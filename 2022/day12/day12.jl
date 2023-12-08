function load_map(path)
    m = Vector{Char}[]
    for l in eachline(path)
        s = split(l, "") .|> only
        push!(m, s)
    end
    m
    reduce(hcat, m) |> Matrix
end

function adjacent(I, R)
    T = typeof(I)
    N = length(I)
    out = T[]
    for i in 1:N
        v = zeros(Int, N)
        v[i] = 1
        S = T(v...)
        I_next = [I + S, I - S]
        for In in I_next
            if In in R
                push!(out, In)
            end
        end
    end
    out
end

elevation(c::Char) = c == 'S' ? 'a' : c == 'E' ? 'z' : c

function gogo(I, R, map, step)
    In = adjacent(I, R)
    current_elevation = elevation(map[I])
    filter(x -> elevation(map[x]) <= current_elevation + 1 && step[x] == -1, In)
end
gogo(I::Vector, R, map, step) = reduce(vcat, [gogo(In, R, map, step) for In in I]) |> unique

function count_step(map, start)
    step = fill(-1, size(map))
    R = CartesianIndices(map)
    I_next = start
    n = 0
    while !isempty(I_next)
        for In in I_next
            step[In] = n
        end
        n += 1
        I_next = gogo(I_next, R, map, step)
    end
    step
end

map = load_map("./input12")

start = findall(x -> x == 'S', map)
dest = findall(x -> x == 'E', map)

step = count_step(map, start)
step[dest]

function find_nearest_start(map)
    dest = findall(x -> x == 'E', map) |> only
    start = findall(x -> x == 'S' || x == 'a', map)
    step = 0
    for s in start
        st = count_step(map, [s])[dest]
        if step == 0 || 0 < st < step
            step = st
        end 
    end
    step
end

find_nearest_start(map)