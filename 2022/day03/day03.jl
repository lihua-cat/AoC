function common_type(content::String)
    len = length(content)
    @assert iseven(len)
    type_1 = content[1:len÷2]
    type_2 = content[len÷2+1:end]
    type_common = Set(type_1) ∩ Set(type_2)
    @assert length(type_common) == 1
    only(type_common)
end

item_type = [l for l in eachline("./input03")]
item_type_common = [common_type(i) for i in item_type]

function type_priority(c::Char)
    @assert 'a' <= c <= 'z' || 'A' <= c <= 'Z'
    if 'a' <= c <= 'z'
        return c - 'a' + 1
    else 'A' <= c <= 'Z'
        return c - 'A' + 27
    end
end

item_priority = type_priority.(item_type_common)
sum_priority = sum(item_priority)

item_group = [item_type[i:i+2] for i in 1:3:length(item_type)]

function common_type_group(g::Vector{String})
    gs = Set.(g)
    type_common = intersect(gs...)
    @assert length(type_common) == 1
    only(type_common)
end

badge = [common_type_group(i) for i in item_group]
badge_priority = type_priority.(badge)
sum_badge_priority = sum(badge_priority)