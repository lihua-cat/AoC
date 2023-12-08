struct PacketPair
    left::Vector
    right::Vector
end
PacketPair(v::Vector) = length(v) == 2 ? PacketPair(v[1], v[2]) : error("input of length = $(length(v))")

function load_packet_pair(path)
    out = PacketPair[]
    pair = []
    for l in eachline(path)
        if isempty(l)
            push!(out, PacketPair(pair))
            empty!(pair)
        else
            packet = Meta.parse(l) |> eval
            push!(pair, packet)
        end
    end
    push!(out, PacketPair(pair))
    out
end

function checkorder(left::Int, right::Int)
    if left < right
        return true
    elseif left > right
        return false
    else
        return -1
    end
end

function checkorder(left::Vector, right::Vector)
    len_l, len_r = length(left), length(right) 
    for i in 1:len_l
        if i <= len_r
            f = checkorder(left[i], right[i])
            if f isa Bool
                return f
            end
        else
            return false
        end
    end
    if len_l < len_r
        return true
    else
        return 0
    end
end

checkorder(left::Int, right::Vector) = checkorder([left], right)
checkorder(left::Vector, right::Int) = checkorder(left, [right])
checkorder(p::PacketPair) = checkorder(p.left, p.right)

packet_pair = load_packet_pair("./input13")

sum([checkorder(packet_pair[i]) ? i : 0 for i in eachindex(packet_pair)])

packet_all = [reduce(vcat, [[p.left, p.right] for p in packet_pair])..., [[2]], [[6]]]

packet_sort = sort(packet_all, lt=checkorder)

prod(findall(x -> x == [[2]] || x == [[6]], packet_sort))