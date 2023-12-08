using OffsetArrays

function load_rock(path)
    rock = Vector{CartesianIndex{2}}[]
    for l in eachline(path)
        v_cart = CartesianIndex{2}[]
        v_substr = split(l, " -> ")
        for substr in v_substr
            v_int = parse.(Int, split(substr, ","))
            push!(v_cart, CartesianIndex(v_int...))
        end
        push!(rock, v_cart)
    end
    rock
end

function bound(rock, part=1)
    first = minimum([minimum(r) for r in rock])
    last = maximum([maximum(r) for r in rock])
    first = CartesianIndex(first.I[1], 0)
    if part == 2
        first -= CartesianIndex(2, 0)
        last += CartesianIndex(2, 2)
    end
    first:last
end

function cave(rock, part=1)
    bd = bound(rock, part)
    m = zeros(Int, size(bd)...)
    mo = OffsetArray(m, bd)
    for r in rock
        for i in 1:length(r)-1
            mo[r[i]:r[i+1]] .= 1
            mo[r[i+1]:r[i]] .= 1
        end
    end
    if part == 2
        mo[:, end] .= 1
    end
    mo
end

function extend(ca, d)
    bd = CartesianIndices(ca)
    bd_new = min(bd..., d):max(bd..., d)
    m = zeros(Int, size(bd_new)...)
    mo = OffsetArray(m, bd_new)
    mo[bd] .= ca
    mo[:, end] .= 1
    mo
end

function fall(sand, ca, part=1)
    down = CartesianIndex(0, 1)
    downleft = CartesianIndex(-1, 1)
    downright = CartesianIndex(1, 1)
    for mv in [down, downleft, downright]
        dest = sand + mv
        if part == 2 && dest ∉ CartesianIndices(ca)
            ca = extend(ca, dest)
        end
        if dest ∈ CartesianIndices(ca)
            if ca[dest] == 0
                if part == 2
                    return dest, ca
                else
                    return dest
                end
            end
        else
            if part == 2
                return dest, ca
            else
                return dest ## out
            end
        end
    end
    if part == 2
        return sand, ca
    else
        return sand
    end
end

function fall_to_out!(ca, part=1, source = CartesianIndex(500, 0))
    bd = CartesianIndices(ca)
    sand_old = source
    while true
        if part == 2
            sand_new, ca = fall(sand_old, ca, part)
        else
            sand_new = fall(sand_old, ca, part)
        end
        if (sand_new ∈ bd && part == 1) || (ca[source] == 0 && part == 2)
            if sand_new == sand_old
                ca[sand_new] = 2
                sand_old = source
            else
                sand_old = sand_new
            end
        else
            break
        end
    end
    ca
end

function print_cave(ca)
    for i in axes(ca, 2)
        n_str = lpad("$i ", 5)
        print(n_str)
        for c in ca[:, i]
            if c == 0
                print(".")
            elseif c == 1
                print("#")
            elseif c == 2
                print("o")
            end
        end
        println()
    end
end


part = 2
rock = load_rock("input14")
ca = cave(rock, part)
ca = fall_to_out!(ca, part)
sum(x->x==2, ca)



print_cave(ca)

using GLMakie
heatmap(OffsetArrays.no_offset_view(ca), axis = (aspect = DataAspect(), yreversed=true))