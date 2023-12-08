const Position = Vector{Int}

function update_head!(head_pos::Position, mv::String)
    if mv == "L"
        head_pos[1] -= 1
    elseif mv == "R"
        head_pos[1] += 1
    elseif mv == "U"
        head_pos[2] += 1
    elseif mv == "D"
        head_pos[2] -= 1
    end
    head_pos
end

function update_tail!(tail_pos::Position, head_pos::Position)
    if all(abs.(tail_pos - head_pos) .<= 1)
        nothing
    else
        d = head_pos - tail_pos
        tail_pos .+= sign.(d)
    end
    tail_pos
end


trajectory = Position[]
origin = [0, 0]
head_pos = copy(origin)
tail_pos = copy(origin)

for l in eachline("./input09")
    mv, step = split(l)
    mv = String(mv)
    step = parse(Int, step)
    for _ in 1:step
        update_head!(head_pos, mv)
        update_tail!(tail_pos, head_pos)
        if !(tail_pos in trajectory)
            push!(trajectory, copy(tail_pos))
        end
    end
end

trajectory

## 
origin = [0, 0]
knots = [copy(origin) for _ in 1:10]
trajectory = Position[]

for l in eachline("./input09")
    mv, step = split(l)
    mv = String(mv)
    step = parse(Int, step)
    for _ in 1:step
        for n in 1:10
            if n == 1
                update_head!(knots[1], mv) 
            else
                update_tail!(knots[n], knots[n-1])
            end
        end
        if !(knots[10] in trajectory)
            push!(trajectory, copy(knots[10]))
        end
    end
end

trajectory