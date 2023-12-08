import ShiftedArrays: circshift as cs

function jets_of_gas(test=true)
    filename = test ? "test" : "input"
    path = joinpath(@__DIR__, filename)
    jets = readlines(path) |> only
    jets = Vector{String}(split(jets, ""))
end

function height(chamber)
    h = 0
    for col in eachindex(chamber)
        ranges = chamber[col]
        isempty(ranges) && continue
        hc = last(ranges).stop
        if hc > h
            h = hc
        end
    end
    return h
end

function ispush(rock, chamber, jet, h_offset)
    if jet == 1
        if !isempty(last(rock))
            return false
        end
    elseif jet == -1
        if !isempty(first(rock))
            return false
        end
    end
    for c in eachindex(rock)
        c + jet in eachindex(rock) || continue
        rr = rock[c]
        rc = chamber[c + jet]
        (isempty(rr) || isempty(rc)) && continue
        for r1 in rr
            r1 = r1 .+ h_offset
            for r2 in Iterators.reverse(rc)
                if !isempty(r1 ∩ r2)
                    return false
                end
                r2.stop < r1.start && break
            end
        end
    end
    return true ## can be pushed
end

function isfallen(rock, chamber, h_offset)
    for c in eachindex(rock)
        rr = rock[c]
        rc = chamber[c]
        isempty(rr) && continue
        isempty(rc) && first(rr).start + h_offset == 1 && return true
        for r1 in rr
            r1 = r1 .+ h_offset
            for r2 in Iterators.reverse(rc)
                if r1.start == r2.stop + 1
                    return true
                end
                r2.stop < r1.start && break
            end
        end
    end
    return false ## still falling
end

function append_chamber!(chamber, rock, h_offset)
    for c in eachindex(rock)
        rr = rock[c]
        rc = chamber[c]
        isempty(rr) && continue
        for r1 in rr
            r1 = r1 .+ h_offset
            if isempty(rc)
                push!(rc, r1)
                continue
            end
            for n in length(rc):-1:1
                r2 = rc[n]
                if r1.start > r2.stop + 1
                    insert!(rc, n+1, r1)
                    break
                elseif r1.start == r2.stop + 1
                    if n < length(rc) && r1.stop + 1 == rc[n+1].start
                        rc[n] = r2.start:rc[n+1].stop
                        deleteat!(rc, n+1)
                        break
                    else
                        rc[n] = r2.start:r1.stop
                        break
                    end
                end
            end
        end
    end
end

function mat_chamber(chamber)
    h = height(chamber)
    cols = length(chamber)
    mat = zeros(Bool, h, cols)
    for c in 1:cols
        for rc in chamber[c]
            mat[rc, c] .= 1
        end
    end
    reverse!(mat, dims=1)
end

function print_chamber(mat)
    for row in eachrow(mat)
        for i in row
            if i == 0
                print(".")
            elseif i == 1
                print("#")
            end
        end
        println()
    end
end

function simulate(n, test=true; cols=7, cycle=false)
    ## import jets and convert into 1 or -1
    jets = jets_of_gas(test)
    jets = replace(jets, ">" => 1, "<" => -1) |> Vector{Int}


    ## get shapes of all rocks
    rocks = [
        [[1:1], [1:1], [1:1], [1:1]],
        [[2:2], [1:3], [2:2]],
        [[1:1], [1:1], [1:3]],
        [[1:4]],
        [[1:2], [1:2]]
    ]
    
    for r in rocks
        append!(r, Ref([]) .* ones(cols - length(r)))
    end

    ## initial chamber
    chamber = [UnitRange{Int}[] for i in 1:cols]


    ## detect cycle ... why it must be cycle ?
    if cycle
        mem = Dict{Tuple{Int, Int}, Tuple{Int, Int}}()
    end

    ## step
    step = 1
    n_rocks = 1
    h = 0
    while n_rocks <= n
        ## rock initial
        i = mod1(n_rocks, length(rocks))
        rock = cs(rocks[i], 2)
        h_offset = h + 3

        while true
            j = mod1(step, length(jets))
            jet = jets[j]

            ## jet push
            step += 1
            if ispush(rock, chamber, jet, h_offset)
                rock = cs(rock, jet)
            end
            if isfallen(rock, chamber, h_offset)
                append_chamber!(chamber, rock, h_offset)
                h = height(chamber)

                if cycle
                    if (i, j) in keys(mem)
                        n_mem, h_mem = mem[(i, j)]
                        N, R = divrem(n - n_rocks, n_rocks - n_mem)
                        if R == 0
                            println("cycle detected: $n_mem, $h_mem -> $n_rocks, $h | $(n_rocks-n_mem) $(h-h_mem)")
                            return h_mem + (N + 1) * (h - h_mem)
                        end
                    else
                        mem[(i, j)] = (n_rocks, h)
                    end
                end

                n_rocks += 1
                break
            else
                h_offset -= 1
            end
            
        end
    end
    if cycle
        return h
    else
        return (chamber, h)
    end
end
