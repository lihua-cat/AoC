carlories = Int[]
c_sum = 0
for l in eachline("./input01")
    if length(l) != 0
        c_n = parse(Int, l)
        c_sum += c_n
    else
        push!(carlories, c_sum)
        c_sum = 0
    end
end

findmax(carlories)

function find3max(data)
    max_1, index_1 = findmax(data)
    deleteat!(data, index_1)
    max_2, index_2 = findmax(data)
    deleteat!(data, index_2)
    max_3, index_3 = findmax(data)
    max_1 + max_2 + max_3
end

find3max(carlories)