struct Valves
    id::Vector{String}  ## 1~N
    index::Dict{String, Int}
    flowrate::Vector{Int}
    to::Vector{Vector{UInt8}}
end

struct Dist
    dist::Matrix{Int}
    path::Matrix{Vector{UInt8}}
end

function parse_input(test=true)
    data = test ? "test" : "input"
    path = joinpath(@__DIR__, data)
    r = r"Valve (\w{2}) has flow rate=(\d+); tunnels? leads? to valves? ((?:\w{2},?\s?)+)"
    id = String[]
    flowrate = Int[]
    to_str = Vector{String}[]
    for l in eachline(path)
        c = match(r, l).captures
        push!(id, c[1])
        push!(flowrate, parse(Int, c[2]))
        push!(to_str, split(c[3], ", "))
    end
    N = length(id)
    index = Dict([s => i for (s, i) in zip(id, 1:N)])
    to = [Vector{Int}() for _ in 1:N]
    for i in 1:N
        for s in to_str[i]
            push!(to[i], index[s])
        end
    end
    Valves(id, index, flowrate, to)
end

function min_dist(V::Valves) ## Floyd–Warshall algorithm
    n = length(V.id)
   
    dist = fill(Inf, n, n)
    next = zeros(Int, n, n)
    
    @inbounds for u in 1:n
        dist[u, u] = oneunit(eltype(dist))
        next[u, u] = u

        for v in V.to[u]
            dist[u, v] = 1
            next[u, v] = v
        end
    end
    
    @inbounds for k in 1:n
        for v in 1:n
            d = dist[k, v]
            isinf(d) && continue
            for u in 1:n
                dd = d + dist[u, k]
                if dist[u, v] > dd
                    dist[u, v] = dd
                    next[u, v] = next[u, k]
                end
            end
        end
    end
    path = Matrix{Vector{Int}}(undef, n, n)
    for I in CartesianIndices(path)
        i, j = I.I
        if iszero(next[I])
            path[I] = Int[]
        elseif i == j
            if dist[i, j] == 0
                path[I] = [i]
            elseif dist[i, j] == 1
                path[I] = [i, j]
            end
        else
            path[I] = [i]
            while i != j
                i = next[i, j]
                push!(path[I], i)
            end
        end
    end
    @assert all(length.(path) .- 1 .== dist) 
    return Dist(dist, path)
end

struct State{N}
    off::Tuple{Vararg{UInt8}}
    id::NTuple{N, UInt8}
    time::NTuple{N, Int}
end

# Base.hash(S::State, h::UInt) = hash(S.off, hash(S.id, hash(S.time, h)))

const Action{N} = Vector{State{N}} where N

function best_action(S::State{N}, V::Valves, D::Dist, mem::Dict{State{N}, Action{N}} = Dict{State{N}, Action{N}}()) where N
    if haskey(mem, S)
        return mem[S]
    end

    if isempty(S.off) ## all valves have been turned on
        mem[S] = Action{N}()
        return mem[S]
    end
    
    id_next = Tuple([collect(UInt8, S.off) for _ in 1:N])
    for i in 1:N
        id_c = S.id[i]
        if iszero(id_c)
            empty!(id_next[i])
        else
            time = S.time[i]
            filter!(id_n->D.dist[id_c, id_n]+2<=time, id_next[i])
        end
        push!(id_next[i], 0)## nothing to do
    end

    all_next_state = next_state(S, id_next, D)

    if isempty(all_next_state)
        mem[S] = Action{N}()
        return mem[S]
    else
        p_max = 0
        a_max = Action{N}()
        for s in all_next_state
            a = vcat([s], best_action(s, V, D, mem))
            p = release(a, V)
            if p > p_max
                p_max = p
                a_max = a
            end
        end
        mem[S] = a_max
        return mem[S]
    end
end

function next_off_time(S::State{N}, id_n, D) where N
    v = filter(!iszero, id_n)
    if allunique(v) && !isempty(v)
        n = Vector{Int}(undef, length(v))
        for i in eachindex(v)
            n[i] = findfirst(x->x==v[i], S.off)
        end
        off_n = S.off[1:end .∉ (n,)]
        time_n = map(id_n, S.time, S.id) do id, time, id_c
            if !iszero(id)
                d = D.dist[id_c, id]
                return time - d - 1
            else
                return 0
            end         
        end
        return off_n, time_n
    else
        return nothing
    end
end

function next_state(S::State{N}, id_next::NTuple{N, Vector{UInt8}}, D::Dist) where N
    out = State{N}[]
    for id_n in Iterators.product(id_next...)
        next_ot = next_off_time(S, id_n, D)
        if !isnothing(next_ot)
            off_n, time_n = next_ot
            S_new = State(off_n, id_n, time_n)
            push!(out, S_new)
        end
    end
    out
end

function release(A::Action, V::Valves)
    p = 0
    for S in A
        for (id, time) in zip(S.id, S.time)
            iszero(id) && continue
            flowrate = V.flowrate[id]
            p += flowrate * time
        end
    end
    p
end
