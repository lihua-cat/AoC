struct Position
    r::Int
    c::Int
end

struct SensorBeacon
    s::Position
    b::Position
    m::Int
end

function parse_input(test=true)
    data = test ? "test" : "input"
    path = joinpath(@__DIR__, data)
    sb_vec = SensorBeacon[]
    for l in eachline(path)
        regex = r"^Sensor at x=(-?\d+), y=(-?\d+)\: closest beacon is at x=(-?\d+), y=(-?\d+)$"
        m2 = parse.(Int, match(regex, l).captures)
        s = Position(m2[2], m2[1])
        b = Position(m2[4], m2[3])
        push!(sb_vec, SensorBeacon(s, b, manhattan(s, b)))
    end
    sb_vec
end

manhattan(x1::Int, y1::Int, x2::Int, y2::Int) = abs(x1 - x2) + abs(y1 - y2)
manhattan(p1::Position, p2::Position) = manhattan(p1.r, p1.c, p2.r, p2.c)
manhattan(sb::SensorBeacon) = manhattan(sb.s, sb.b)

Base.issubset(sb1::SensorBeacon, sb2::SensorBeacon) = sb1.m + manhattan(sb1.s, sb2.s) <= sb2.m

function remove_sub!(v)
    flag = fill(false, length(v))
    for i in eachindex(v)
        for j in eachindex(v)
            i == j && continue
            if v[i] ⊆ v[j]
                flag[i] = true
                break
            end
        end
    end
    deleteat!(v, flag)
end

function union_range!(rv::Vector{UnitRange{Int64}})
    remove_sub!(rv)
    length(rv) == 1 && return rv
    sort!(rv)
    i = 2
    while i <= length(rv)
        r1 = rv[i-1]
        r2 = rv[i]
        a, b = r1.start, r1.stop
        c, d = r2.start, r2.stop
        if c <= b + 1
            rv[i-1] = a:d
            deleteat!(rv, i)
        else
            i += 1
        end
    end
    return rv
end

function range_at_row(sb::SensorBeacon, row::Int, include_beacon::Bool=false)
    d = abs(row - sb.s.r)
    if d > sb.m
        return 1:0
    else
        dd = sb.m - d
        c1, c2 = sb.s.c - dd, sb.s.c + dd
        if include_beacon
            return c1:c2
        else
            if sb.b.r == row
                if sb.b.c == c1
                    return c1+1:c2
                else
                    return c1:c2-1
                end
            else
                return c1:c2
            end
        end
    end
end

function range_at_row(sb_vec::Vector{SensorBeacon}, row::Int, include_beacon::Bool=false)
    out = UnitRange{Int}[]
    for sb in sb_vec
        range_col = range_at_row(sb, row, include_beacon)
        push!(out, range_col)
    end
    union_range!(out)
    out
end

# function setdiff_range(r1::UnitRange{Int}, r2::UnitRange{Int})
#     a, b = r1.start, r1.stop
#     a > b && return UnitRange{Int}[]
#     c, d = r2.start, r2.stop
#     c > d && return r1
#     if b < c || d < a
#         return [r1]
#     end
#     if a > c - 1
#         if d + 1 > b
#             return UnitRange{Int}[]
#         else
#             return [d+1:b]
#         end
#     else
#         if d + 1 > b
#             return [a:c-1]
#         else
#             return [a:c-1, d+1:b]
#         end
#     end
# end

# function setdiff_range!(r1::Vector{UnitRange{Int}}, r2::Vector{UnitRange{Int}})
#     for r in r2
#         setdiff_range!(r1, r)
#     end
#     r1
# end

function setdiff_range!(r1::Vector{UnitRange{Int}}, r2::UnitRange{Int})
    isempty(r2) && return r1
    n = 1
    while n <= length(r1)
        if isempty(r1[n])
            deleteat!(r1, n)
            continue
        end
        a, b = r1[n].start, r1[n].stop
        c, d = r2.start, r2.stop
        if a > b || (a > c - 1 && d + 1 > b)
            deleteat!(r1, n)
        elseif c > d || b < c || d < a
            n += 1
        elseif a > c - 1
            r1[n] = d+1:b
            n += 1
        else
            if d + 1 > b
                r1[n] = a:c-1
                n += 1
            else
                r1[n] = a:c-1
                insert!(r1, n+1, d+1:b)
                n += 2
            end
        end
    end
    r1
end

# function undetect_at_row(sb_vec::Vector{SensorBeacon}, row::Int, col_range::UnitRange{Int})
#     undetect = [col_range]
#     for sb in sb_vec
#         range_col = range_at_row(sb, row, true)
#         setdiff_range!(undetect, range_col)
#         isempty(undetect) && break
#     end
#     undetect
# end

function undetect_at_row!(sb_vec::Vector{SensorBeacon}, row::Int, col_range::UnitRange{Int}, undetect = [col_range])
    for sb in sb_vec
        range_col = range_at_row(sb, row, true)
        setdiff_range!(undetect, range_col)
        isempty(undetect) && break
    end
    undetect
end

function undetect(sb_vec::Vector{SensorBeacon}, row_range::UnitRange{Int}, col_range::UnitRange{Int})
    coord = Tuple{Int, UnitRange{Int}}[]
    undetect = [col_range]
    for row in row_range
        undetect_at_row!(sb_vec, row, col_range, undetect)
        for c in undetect
            push!(coord, (row, c))
        end
        empty!(undetect)
        push!(undetect, col_range)
    end
    coord
end
