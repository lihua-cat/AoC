stream = readline("./input06")

function find_1st_marker(s::String, n=4)
    for i in n:length(s)
        buffer = s[i-n+1:i]
        if unique(buffer) == collect(buffer)
            return (i, buffer)
        else
            continue
        end
    end
end

find_1st_marker(stream)

find_1st_marker(stream, 14)