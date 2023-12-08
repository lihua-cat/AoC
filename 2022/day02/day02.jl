const dict_1 = Dict("A" => "Rock", "B" => "Paper", "C" => "Scissor")
const dict_2 = Dict("X" => "Rock", "Y" => "Paper", "Z" => "Scissor")

const dict_w = Dict("Scissor" => "Rock", "Rock" => "Paper", "Paper" => "Scissor")
const dict_l = Dict("Scissor" => "Paper", "Rock" => "Scissor", "Paper" => "Rock")

function score_shape(s)
    if s == "Rock"
        return 1
    elseif s == "Paper"
        return 2
    elseif s == "Scissor"
        return 3
    else
        error("$s")
    end
end

function score_round(s_1, s_2)
    if s_1 == s_2
        return 3
    elseif s_2 == dict_w[s_1]
        return 6
    else
        return 0
    end
end

function countscore(c_1, c_2)
    s_1, s_2 = dict_1[c_1], dict_2[c_2]
    score_round(s_1, s_2) + score_shape(s_2)
end

score = 0
for l in eachline("./input02")
    c_1, c_2 = split(l, " ")
    global score += countscore(c_1, c_2)
end
score


dict_3 = Dict("X" => 0, "Y" => 3, "Z" => 6)

function shape_get(s_1, score)
    if score == 3
        return s_1
    elseif score == 6
        s_2 = dict_w[s_1]
    else
        s_2 = dict_l[s_1]
    end
end

score_new = 0

for l in eachline("./input02")
    c_1, c_2 = split(l, " ")
    s_1, score_d = dict_1[c_1], dict_3[c_2]
    s_2 = shape_get(s_1, score_d)
    global score_new += (score_d + score_shape(s_2))
end

score_new