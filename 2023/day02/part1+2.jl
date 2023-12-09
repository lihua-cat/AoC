struct Record
    id::Int
    r::Int
    g::Int
    b::Int
end

function parse_record(path)
    input = joinpath(@__DIR__, path)

    rec_all = Vector{Record}()
    for l in eachline(input)
        (; id, sets) = parse_line(l)
        r_max, g_max, b_max = 0, 0, 0
        for set in sets
            (; r, g, b) = parse_set(set)
            (r > r_max) && (r_max = r)
            (g > g_max) && (g_max = g)
            (b > b_max) && (b_max = b)
        end
        rec = Record(id, r_max, g_max, b_max)
        push!(rec_all, rec)
    end
    rec_all
end

function parse_line(str_line::String)
    index = findfirst(':', str_line)
    part_id = str_line[1:index-1]
    part_rec = str_line[index+1:end]
    id = parse(Int, split(part_id, ' ')[2])
    sets = split(part_rec, ';')
    return (; id, sets)
end

function parse_set(set)
    r, g, b = 0, 0, 0
    s = split(set, ',')
    for ss in s
        sss = ss[2:end]
        i = findfirst(' ', sss)
        c = sss[i+1:end]
        n = parse(Int, sss[1:i-1])
        if c == "red"
            r = n
        elseif c == "green"
            g = n
        elseif c == "blue"
            b = n
        else
            error("color parse error: $c")
        end
    end
    return (; r, g, b)
end

function part1(path, r, g, b)
    rec_all = parse_record(path)
    sum = 0
    for rec in rec_all
        if rec.r <= r && rec.g <= g && rec.b <= b
            sum += rec.id
        end
    end
    sum
end

function part2(path)
    rec_all = parse_record(path)
    sum = 0
    for rec in rec_all
        sum += rec.r * rec.g * rec.b
    end
    sum
end

part1("demo.txt", 12, 13, 14)   #8
part1("part1.txt", 12, 13, 14)  #2795

part2("demo.txt")   #2286
part2("part1.txt")   #75561
