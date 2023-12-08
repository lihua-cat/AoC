function read_stack!(s::String, stack::Vector{Vector{Char}})
    for i in 2:4:length(s)
        if s[i] == ' '
            continue
        elseif 'A' <= s[i] <= 'Z'
            push!(stack[(i-2)÷4+1], s[i])
        end
    end
end

function read_procedure(s::String)
    s_split = split(s)
    p = parse.(Int, getindex(s_split, [2, 4, 6]))
end

stack = [Char[] for i in 1:9]
procedure = Vector{Int}[]

for l in eachline("./input05")
    if occursin(r"move [0-9]+ from \d to \d", l)
        p = read_procedure(l)
        push!(procedure, p)
    else
        read_stack!(l, stack)
    end
end

function move_one!(stack, i, j)
    item = first(stack[i])
    popfirst!(stack[i])
    prepend!(stack[j], item)
end

function move_stack!(stack, action, one_by_one=true)
    n = action[1]
    i = action[2]
    j = action[3]
    if one_by_one
        for _ in 1:n
            move_one!(stack, i, j)
        end
    else
        item = stack[i][1:n]
        deleteat!(stack[i], 1:n)
        pushfirst!(stack[j], item...)
    end
end

for i in eachindex(procedure)
    action = procedure[i]
    move_stack!(stack, action, false)
end

first.(stack) |> String