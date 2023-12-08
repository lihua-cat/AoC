function section_pair(path)
    s = Tuple{UnitRange{Int}, UnitRange{Int}}[]
    for l in eachline(path)
        p = parse.(Int, split(l, ('-', ',')))
        push!(s, (p[1]:p[2], p[3]:p[4]))
    end
    s
end

sp = section_pair("./input04")

sum([intersect(sp_i...) in sp_i for sp_i in sp])

sum([length(intersect(sp_i...)) > 0 for sp_i in sp])