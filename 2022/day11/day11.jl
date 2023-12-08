struct Monkey
    n::Int
    item::Vector{Int}
    op::Function
    d::Int
    to_true::Int
    to_false::Int
end
whichmonkey(m::Monkey) = m.n

function load_monkey(path)
    args = []
    mc = Monkey[]
    for l in eachline(path)
        if l == ""
            empty!(args)
        else
            if startswith(l, "Monkey ")
                n = parse(Int, replace(l, "Monkey " => "", ":" => ""))
                push!(args, n)
            elseif startswith(l, "  Starting items: ")
                s = replace(l, "  Starting items: " => "")
                item = parse.(Int, split(s, ", "))
                push!(args, item)
            elseif startswith(l, "  Operation: ")
                fn = "f" * String(gensym())[3:end]
                s = replace(l, "  Operation: " => "", "new" => "$fn(old)")
                push!(args, eval(Meta.parse(s)))
            elseif startswith(l, "  Test: divisible by ")
                d = parse(Int, replace(l, "  Test: divisible by " => ""))
                push!(args, d)
            elseif startswith(l, "    If true: throw to monkey ")
                to = parse(Int, replace(l, "    If true: throw to monkey " => ""))
                push!(args, to)
            elseif startswith(l, "    If false: throw to monkey ")
                to = parse(Int, replace(l, "    If false: throw to monkey " => ""))
                push!(args, to)
                push!(mc, Monkey(args...))
            end
        end
    end
    sort!(mc, by = x -> whichmonkey(x))
end

function inspect!(mc::Vector{Monkey}, times::Vector{Int})
    for n in 1:length(mc)
        m = mc[n]
        for it in m.item
            it_new = m.op(it) ÷ 3
            if it_new % m.d == 0
                push!(mc[m.to_true+1].item, it_new)
            else
                push!(mc[m.to_false+1].item, it_new)
            end
            times[n] += 1
        end
        empty!(m.item)
    end
    return nothing
end

function inspect2!(mc::Vector{Monkey}, times::Vector{Int})
    divprod = prod([m.d for m in mc])
    for n in 1:length(mc)
        m = mc[n]
        for it in m.item
            it_new = m.op(it)
            it_new = it_new % divprod
            if it_new % m.d == 0
                push!(mc[m.to_true+1].item, it_new)
            else
                push!(mc[m.to_false+1].item, it_new)
            end
            times[n] += 1
        end
        empty!(m.item)
    end
    return nothing
end

function find2max(data)
    max_1, index_1 = findmax(data)
    deleteat!(data, index_1)
    max_2, index_2 = findmax(data)
    [(max_1, index_1), (max_2, index_2)]
end


mc = load_monkey("./input11")
times = zeros(Int, length(mc))

for _ in 1:10000
    inspect2!(mc, times)
end

times
max2 = find2max(times)
business = max2[1][1] * max2[2][1] 

