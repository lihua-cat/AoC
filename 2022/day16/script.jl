includet("src.jl")

test = false

function part1(test)
    V = parse_input(test)
    D = min_dist(V)
    index_AA = V.index["AA"]
    off = filter(i -> V.flowrate[i] > 0, 1:length(V.id)) |> Tuple
    S = State{1}(off, (index_AA, ), (30, ))
    A = best_action(S, V, D)
    p = release(A, V)
    (A, p)
end

function part2(test)
    V = parse_input(test)
    D = min_dist(V)
    index_AA = V.index["AA"]
    off = filter(i -> V.flowrate[i] > 0, 1:length(V.id)) |> Tuple
    S = State{2}(off, (index_AA, index_AA), (26, 26))
    A = best_action(S, V, D)
    p = release(A, V)
    (A, p)
end

@time part1(test)

@time part2(test)
