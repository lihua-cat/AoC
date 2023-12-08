function read_cmd(cmd::String, signal::Vector{Int}, X::Int)
    if cmd == "noop"
        push!(signal, X)
    elseif startswith(cmd, "addx ")
        V = parse(Int, replace(cmd, "addx " => ""))
        push!(signal, X, X)
        X += V
    end
    X
end

function load_signal(path)
    signal = Int[]
    X = 1
    for cmd in eachline(path)
        X = read_cmd(cmd, signal, X)
    end
    signal
end

signal = load_signal("./input10")

[n * signal[n] for n in 20:40:220] |> sum

function print_crt(signal::Vector{Int})
    for row in 1:6
        for col in 1:40
            n = (row - 1) * 40 + col
            X = signal[n]
            if X-1 <= col-1 <= X+1
                print("#")
            else
                print(" ")
            end
        end
        print("\n")
    end
end

print_crt(signal)