function read_mat(path)
    m = Vector{Int}[]
    for l in eachline(path)
        s = split(l, "") .|> String
        s = parse.(Int, s)
        push!(m, s)
    end
    m
    reduce(hcat, m) |> transpose |> Matrix
end

function isvisible(m::Matrix, i::Int, j::Int)
    s = size(m)
    h = m[i, j]
    if i in (1, s[1]) || j in (1, s[2])
        return true
    else
        left = @views m[1:i-1, j]
        top = @views m[i, 1:j-1]
        right = @views m[i+1:end, j]
        bottom = @views m[i, j+1:end]
        if all(h .> left) ||all(h .> top) ||all(h .> right) ||all(h .> bottom)
            return true
        else
            return false
        end
    end
end

function isvisible(m::Matrix)
    out = similar(m, Bool)
    s = size(m)
    for i in 1:s[1], j in 1:s[2]
        out[i, j] = isvisible(m, i, j)
    end
    out
end

function scenic_score(m::Matrix, i::Int, j::Int)
    s = size(m)
    h = m[i, j]
    if i in (1, s[1]) || j in (1, s[2])
        return 0
    else
        left = @views m[1:i-1, j]
        top = @views m[i, 1:j-1]
        right = @views m[i+1:end, j]
        bottom = @views m[i, j+1:end]
        s_l = any(h .<= left) ? i - findlast(h .<= left) : i - 1
        s_t = any(h .<= top) ? j - findlast(h .<= top) : j - 1
        s_r = any(h .<= right) ? findfirst(h .<= right) : s[1] - i
        s_b = any(h .<= bottom) ? findfirst(h .<= bottom) : s[2] - j
        return s_l * s_t * s_r * s_b
    end
end

function scenic_score(m::Matrix)
    out = similar(m, Int)
    s = size(m)
    for i in 1:s[1], j in 1:s[2]
        out[i, j] = scenic_score(m, i, j)
    end
    out
end


treemap = read_mat("./input08")
isvisible(treemap) |> sum
scenic_score(treemap) |> maximum