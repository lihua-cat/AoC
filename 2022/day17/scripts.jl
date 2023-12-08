includet("src.jl")

part1(test=true) = simulate(2022, test)[2]
part2(test=true) = simulate(1000_000_000_000, test, cycle=true)

@time part1(false)
@time part2(true) # 1514285714288
# @profview part1(2022)