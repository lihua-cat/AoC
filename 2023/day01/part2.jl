function part2(path)
    input = joinpath(@__DIR__, path)

    sum = 0
    for l in eachline(input)
        d = calibration(l)
        sum += d
    end
    sum

end

function calibration(s::String)
    digits = Dict("one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9, "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9)

    first_index = length(s):length(s)
    last_index = 0:0
    for k in keys(digits)
        first_index_k = findfirst(k, s)
        last_index_k = findlast(k, s)
        if !isnothing(first_index_k)
            if first_index_k[1] < first_index[1]
                first_index = first_index_k
            end
        end
        if !isnothing(last_index_k)
            if last_index_k[1] > last_index[1]
                last_index = last_index_k
            end
        end
        # @show k first_index last_index
    end

    d_first = digits[s[first_index]]
    d_last = digits[s[last_index]]

    calibration = d_first * 10 + d_last

end

part2("demo2.txt")  #281

part2("input.txt")  #54473
