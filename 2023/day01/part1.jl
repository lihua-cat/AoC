function part1(path)
    input = joinpath(@__DIR__, path)
    sum = 0
    for l in eachline(input)
        d1 = l[findfirst(isdigit, l)]
        d2 = l[findlast(isdigit, l)]
        d = parse(Int, d1 * d2)
        sum += d
    end
    sum
end

part1("demo.txt")   # 142

part2("input.txt")  # 54990
