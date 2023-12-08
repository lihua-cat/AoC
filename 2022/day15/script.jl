includet("src.jl")

function part1(test)
    sb_vec = parse_input(test)
    row = test ? 10 : 2000000
    part1 = sum(length, range_at_row(sb_vec, row))
end

function part2(test)
    sb_vec = parse_input(test)
    row_range = test ? (0:20) : (0:4000_000)
    col_range = row_range
    coord = undetect(sb_vec, row_range, col_range)
    row = only(coord)[1]
    col = only(only(coord)[2])
    part2 = col * 4000_000 + row
end

test = false
part1(test)
part2(test)



# using BenchmarkTools
# 
# sb_vec = parse_input(test)
# @btime range_at_row(sb_vec, 2000000)

# @btime undetect(sb_vec, 0:4000_000, 0:4000_000) evals=1
# @profview undetect(sb_vec, 0:4000_000, 0:4000_000)