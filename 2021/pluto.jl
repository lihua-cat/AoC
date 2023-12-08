### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 37ad870d-4d77-4d90-a2c9-0e8e1d723e37
md"# AoC 2021"

# ╔═╡ 1394b9ee-d51b-4674-93c7-80d2234cd8d6
import PlutoUI

# ╔═╡ 6d25e656-e71a-4f74-a250-15f98c6f7288
PlutoUI.TableOfContents()

# ╔═╡ b58dfe8f-888c-40d9-a979-bb6a657b8c9f
md"## Day 1: Sonar Sweep"

# ╔═╡ d676ae47-e83e-4dae-a340-fbd206a609db
md"### ---- Part One ----"

# ╔═╡ fb2d0bd8-ec7f-463d-a28a-7324ab1676e6
input01_path = "input01.txt"

# ╔═╡ 0d9cfb54-2b21-45cc-bdcd-facb7969f16b
input01 = open(input01_path) do f
	[parse(Int64, s) for s in readlines(f)]
end

# ╔═╡ c32c9a48-0241-4e1f-82e5-0df0e602a798
function countincrease(v)
	d = diff(v)
	return sum(x -> x > 0, d)
end

# ╔═╡ 304efb98-9240-418b-bba8-4a41e657477e
md"### ---- Part Two ----"

# ╔═╡ 15692d31-67d5-4488-8fcd-3c5d0f9fd8c8
function countincrease(v, w)
	l = length(v)
	l >= w || return 0
	v_w = zeros(l - w + 1)
	for i in 1:l - w + 1
		v_w[i] = sum(v[i:i+w-1]) 
	end
	countincrease(v_w)
end

# ╔═╡ 74c21e9e-6e98-42d8-aa17-cb54b0932e98
countincrease(input01)

# ╔═╡ 2dda6b0b-8a03-4eac-a14f-b6a399c4105c
countincrease(input01, 3)

# ╔═╡ 5b360d45-7b22-469b-a872-7085a16e9c18
md"## Day 2: Dive!"

# ╔═╡ f4439061-f41d-4d62-8808-a77c1fd16838
md"### ---- Part One ----"

# ╔═╡ afe88790-85ef-49e8-a878-7baaaac8e211
input02_path = "input02.txt"

# ╔═╡ 55144b3e-02e5-4f51-9bb3-983e6c0812fb
input02 = open(input02_path) do f
	# [parse(Int64, s) for s in readlines(f)]
	readlines(f)
end

# ╔═╡ ea7eaad6-4e2b-4bf6-9ae5-5193a30fe25c
pos = (d = 0, h = 0)

# ╔═╡ 24772ea4-11f8-46eb-8ec9-bb80470f374d
function move1(pos, command::String)
	cs = split(command)
	dir = cs[1]
	num = parse(Int, cs[2])
	(; d, h) = pos
	if dir == "forward"
		h += num
	elseif dir == "up"
		d -= num
	elseif dir == "down"
		d += num
	end
	pos_new = (; d, h)
end

# ╔═╡ 54617336-76ce-49c2-8fb6-b6adc7f084fe
function move(pos, commands, move)
	for c in commands
		pos = move(pos, c)
	end
	return pos
end

# ╔═╡ 63da6778-c561-4649-a9b2-59a17d2b02a4
pos_new = move(pos, input02, move1)

# ╔═╡ 925db49e-a3c0-4eb0-8de5-1dba43df52e4
pos_new.d * pos_new.h

# ╔═╡ e09cfd00-1fc5-4f6f-9a3f-ff594d128d6a
md"### ---- Part Two ----"

# ╔═╡ 5ef9371d-298b-4804-b2f4-d4800a7e9298
function move2(pos, command::String)
	cs = split(command)
	dir = cs[1]
	num = parse(Int, cs[2])
	(; d, h, a) = pos
	if dir == "forward"
		h += num
		d += a * num
	elseif dir == "up"
		a -= num
	elseif dir == "down"
		a += num
	end
	pos_new = (; d, h, a)
end

# ╔═╡ 48fa4fd5-acda-4074-9d1d-9af66fa4075b
pos2 = (d = 0, h = 0, a = 0)

# ╔═╡ 2a068162-ff29-40a7-8aca-0075481d2cad
pos_new2 = move(pos2, input02, move2)

# ╔═╡ 828cec07-32d4-4e12-9012-08add04802cd
pos_new2.d * pos_new2.h

# ╔═╡ 1d19cdde-4cae-4785-a500-8517ed9121c6
md"## Day 3: Binary Diagnostic"

# ╔═╡ a878e37e-dc82-4576-95a5-afb9f0d5ed57
md"### ---- Part One ----"

# ╔═╡ 3365f01c-bc0e-4987-b004-efc40035a8c9
input03_path = "input03.txt"

# ╔═╡ 75aae7f8-c835-498d-adbb-71537eb8fd5c
input03 = open(input03_path) do f
	p(s::AbstractString)::Vector{Bool} = split(s, "") .== "1"
	v = map(p, readlines(f))
	hcat(v...) |> transpose |> BitMatrix
end

# ╔═╡ b118e84a-ab31-4e68-b2bb-5ab695769c04
function bitvec2int(bv::BitVector)
	out = 0
	l = length(bv)
	for (i, v) in enumerate(bv)
		n = l - i
		out += v * 2 ^ n
	end
	out
end

# ╔═╡ bf0a41df-d71e-41b6-949d-269479ef8615
function binarydiag(m)
	vec = similar(m, size(m, 2))
	for i in 1:size(m, 2)
		n = sum(m[:, i] .== 1)
		vec[i] = n > size(m, 1)/2 ? 1 : 0
	end
	γ = bitvec2int(vec)
	vec = .!vec
	ϵ = bitvec2int(vec)
	return (γ, ϵ)
end

# ╔═╡ 28d54574-e95e-4e1b-8bd5-b694ad96314b
out3 = binarydiag(input03)

# ╔═╡ ed8ed80c-5104-4d0c-a53a-823aea73d5a7
out3[1] * out3[2]

# ╔═╡ accf6429-8508-43d0-a08c-a5ab5c4dfc5e
md"### ---- Part Two ----"

# ╔═╡ ac01fd52-e972-4554-adb5-882fed8ac8ae
function _liferate(a, n, bool)
	row1 = a[:, n] .== 1
	if sum(row1) >= size(a, 1) / 2
		if bool
			return a[row1, :]
		else
			return a[.!row1, :]
		end
	else
		if bool
			return a[.!row1, :]
		else
			return a[row1, :]
		end
	end
end

# ╔═╡ d8ac9612-4ee8-4132-9b8a-09ceab5152be
function liferate(a)
	a1 = a
	a2 = a
	oxygen = NaN
	CO2 = NaN
	for i in 1:size(a, 2)
		a1 = _liferate(a1, i, true)
		if size(a1, 1) == 1
			oxygen = bitvec2int(a1[1, :])
		end
	end
	for i in 1:size(a, 2)
		a2 = _liferate(a2, i, false)
		if size(a2, 1) == 1
			CO2 = bitvec2int(a2[1, :])
		end
	end
	return oxygen * CO2
end

# ╔═╡ 0d5a5593-3310-4479-b28c-41933deb928f
liferate(input03)

# ╔═╡ 471f37bc-0385-45f2-8c42-62f76a246ec0
md"## Day 4: Giant Squid"

# ╔═╡ 8c034d7c-89f4-416d-a496-4b0ff00f01d2
md"### ---- Part One ----"

# ╔═╡ c09f1628-46cb-4df3-9cba-531d84bb6c65
input04_path = "input04.txt"

# ╔═╡ db71de08-081a-4367-93ce-b098fcd5c064
input04_1 = open(input04_path) do f
	[parse(Int, s) for s in split(readlines(f)[1], ",")]
end

# ╔═╡ ddfdd669-ee08-4b1d-9e0a-761ab8358229
input04_2 = open(input04_path) do f
	p = readlines(f)[2:end]
	m = Matrix{Int}[]
	l = 1
	while l <= length(p)
		if p[l] == ""
			mm = [[parse(Int, s) for s in split(ll)] for ll in p[l+1:l+5]]
			push!(m, hcat(mm...))
			l += 5
		end
		l += 1
	end
	m
end

# ╔═╡ fc62149d-1cde-49a5-b0f9-12472731b6a3
function bingo(a::BitMatrix)::Bool
	for col in eachcol(a)
		all(col) && return true
	end
	for row in eachrow(a)
		all(row) && return true
	end
	return false
end

# ╔═╡ 194173b4-5868-4609-8874-ed29814a7bed
function bingo2(input1, input2)
	bingo_mat = [m .== NaN for m in input2]
	for num in input1
		for i in 1:length(input2)
			mat = input2[i]
			bingo_mat[i] = bingo_mat[i] .|| (mat .== num)
			if bingo(bingo_mat[i])
				ss = sum(mat[.!bingo_mat[i]])
				return ss * num
			end
		end
	end
end

# ╔═╡ d0437e4f-8b8d-40ee-9a53-aa9a664b37cf
bingo2(input04_1, input04_2)

# ╔═╡ bfc0a3be-187e-47a1-9a51-4698c8377028
md"### ---- Part Two ----"

# ╔═╡ 61e7222d-213a-48d4-9113-5289f67f2549
function bingo3(input1, input2)
	bingo_mat = [m .== NaN for m in input2]
	out1 = Int[]
	out2 = Int[]
	for num in input1
		for i in 1:length(input2)
			i in out2 && continue
			mat = input2[i]
			bingo_mat[i] = bingo_mat[i] .|| (mat .== num)
			if bingo(bingo_mat[i])
				ss = sum(mat[.!bingo_mat[i]])
				push!(out1, ss * num)
				push!(out2, i)
			end
		end
	end
	return out1
end

# ╔═╡ 0c8f6bc7-1232-45ae-b97f-4f621d76a513
bingo3(input04_1, input04_2)

# ╔═╡ 128451df-2622-4bd0-ac0d-8cfb1afa3a7e
md"## Day 5: Hydrothermal Venture"

# ╔═╡ 6bc2cd23-23cb-47f5-9628-a4ca16a0b749
md"### ---- Part One ----"

# ╔═╡ 9765eb0f-83ed-4f3e-8c65-8e7e9e7bc5e1
input05_path = "input05.txt"

# ╔═╡ 1beff8a4-7128-4050-8561-0bb299280b55
input05 = open(input05_path) do f
	process(line) = [Tuple(parse.(Int, split(s, ","))) for s in split(line, "->")]
	[process(l) for l in readlines(f)]
end

# ╔═╡ 68657f10-c66e-44a3-8039-a91479399c95
input05f = let
	m = similar(input05, 0)
	for l in input05
		if l[1][1] == l[2][1] || l[1][2] == l[2][2]
			push!(m, l)
		end
	end
	m
end

# ╔═╡ 0737820b-d563-435b-a79f-2673090b41e5
function maxsize(v)
	xmax1 = [max(l[1][1], l[2][1]) for l in v]
	ymax1 = [max(l[1][2], l[2][2]) for l in v]
	return(maximum(xmax1), maximum(ymax1))
end

# ╔═╡ 110b1d6f-6d09-4250-855b-597203ea35bc
function ventmap(input)
	map = zeros(maxsize(input))
	_range(l1, l2) = l1 <= l2 ? range(l1, l2) : range(l1, l2, step = -1)
	for l in input
		if l[1][1] == l[2][1]
			for j in _range(l[1][2], l[2][2])
				map[l[1][1], j] += 1
			end
		elseif l[1][2] == l[2][2]
			for i in _range(l[1][1], l[2][1])
				map[i, l[1][2]] += 1
			end
		elseif abs(l[1][1] - l[2][1]) == abs(l[1][2] - l[2][2])
			xr = _range(l[1][1], l[2][1])
			yr = _range(l[1][2], l[2][2])
			for n in 1:abs(l[1][1] - l[2][1])+1
				map[xr[n], yr[n]] += 1
			end
		end
	end
	map
end

# ╔═╡ ad944c61-84f7-459f-8f87-532ad625af74
sum(ventmap(input05f) .>= 2)

# ╔═╡ 23e919e1-a9f8-40bf-9e97-a62d698039fe
md"### ---- Part Two ----"

# ╔═╡ db1f75d5-78f4-4ca3-82db-b50098e002b5
sum(ventmap(input05) .>= 2)

# ╔═╡ a90e3a08-4b6e-4584-be4d-4f58865b68de
md"## Day 6: Lanternfish"

# ╔═╡ 11785d6b-1c6d-4690-a60c-38f8c77bb22a
md"### ---- Part One ----"

# ╔═╡ 5baebb4b-52bb-4b42-8522-ab323d95ee35
input06_path = "input06.txt"

# ╔═╡ a828d933-8573-42fe-9dae-15401186722a
input06 = open(input06_path) do f
	[parse(Int, s) for s in split(readlines(f)[], ",")]
end

# ╔═╡ e8445863-0ac4-411f-a097-0a733c13ab3d
function _fish(v)
	if v == 0
		v = 6
	else
		v -= 1
	end
end

# ╔═╡ 7731ad76-4bb3-455d-9f6e-bf8dfdacbea4
function fish!(v)
	new = sum(iszero, v)
	Threads.@threads for i in 1:length(v)
		v[i] = _fish(v[i])
	end
	push!(v, fill(8, new)...)
end

# ╔═╡ 0c098ce2-0b55-4ca2-bc20-3c53dafbc91f
function fish(input, n)
	v = copy(input)
	for _ in 1:n
		fish!(v)
	end
	return v
end

# ╔═╡ b8e55033-2698-4d71-a261-379c8fc2fd88
fish80 = fish(input06, 80)

# ╔═╡ c7245aed-c72c-43f0-ad6e-1b33e20a1ab4
length(fish80)

# ╔═╡ 50ff2a9b-73eb-4746-bdbc-375e30828d9f
md"### ---- Part Two ----"

# ╔═╡ 78116f86-278f-43d2-9f4f-fa57db0452af
function initial_fish(input)
	age = zeros(Int, 9)
	for f in input
		age[f+1] += 1
	end
	age
end

# ╔═╡ eb424f48-5aed-48b1-9d66-f42dde830ee6
age0 = initial_fish(input06)

# ╔═╡ e1bf9bd1-15a9-4e8e-bd30-80c9c5221cdd
function fish_spawn!(age)
	age_copy = copy(age)
	circshift!(age, age_copy, -1)
	age[7] += age[9]
	age
end

# ╔═╡ a4f2a881-8b6b-4fd0-afa0-0396d89ba9fc
function fish_spawn(age0, n)
	age = copy(age0)
	for _ in 1:n
		fish_spawn!(age)
	end
	age
end

# ╔═╡ 562961f7-f042-4a2e-8fe6-7c9ba7ee4151
fish_spawn(age0, 256) |> sum

# ╔═╡ 9d680e9f-5ec3-49af-ac6d-84a229587970
md"## Day 7: The Treachery of Whales"

# ╔═╡ d0e62e96-ca23-4324-a97a-c855ddea5c6a
md"### ---- Part One ----"

# ╔═╡ 4b97edb8-3387-4f53-b34f-31bb038a23f0
input07_path = "input07.txt"

# ╔═╡ 8a864189-8190-475f-ad4b-c2afd3cd9699
input07 = open(input07_path) do f
	[parse(Int, s) for s in split(readchomp(f), ",")]
end

# ╔═╡ bea4c00b-b37d-4292-b44e-5d42d1993717
function minpos(input)
	fuel(input, x) = sum(abs, input .- x)
	xr = minimum(input):maximum(input)
	minpos = xr[1]
	minfuel = fuel(input, xr[1])
	for x in xr[2:end]
		f = fuel(input, x)
		if f < minfuel
			minpos = x
			minfuel = f
		end
	end
	return (minpos, minfuel)
end

# ╔═╡ be0dbfef-0d01-4adb-9722-1924606b3cb9
minpos(input07)

# ╔═╡ d1c8e704-61ca-43a6-825f-de7590dba603
md"### ---- Part Two ----"

# ╔═╡ b0c71572-f9aa-46d3-969b-d13098e6c08e
function minpos2(input)::Tuple{Int64, BigInt}
	_fuel(x) = (abs(x) + 1) * abs(x) / 2
	fuel(input, x) = sum(_fuel, input .- x)
	xr = minimum(input):maximum(input)
	minpos = xr[1]
	minfuel = fuel(input, xr[1])
	for x in xr[2:end]
		f = fuel(input, x)
		if f < minfuel
			minpos = x
			minfuel = f
		end
	end
	return (minpos, minfuel)
end

# ╔═╡ 8174c483-eb9a-4c75-9c52-3c4f0d1336d9
minpos2(input07)

# ╔═╡ 469f9c7e-b092-4cb9-b7f8-778a41d57931
md"## Day 8: Seven Segment Search"

# ╔═╡ 05ae9276-94fc-4a2f-9e5d-2196a64c95ca
md"### ---- Part One ----"

# ╔═╡ 9d523f38-5a9c-466f-b88e-4b30e06a3ed8
input08_path = "input08.txt"

# ╔═╡ f6b010da-f6c2-4e17-80da-947fe953c2e1
input08 = open(input08_path) do f
	origin = [split(s) for s in readlines(f)]
	pattern = [String.(i[1:10]) for i in origin]
	output = [String.(i[12:15]) for i in origin]
	(; pattern, output)
end

# ╔═╡ 1af590e7-4b78-4d09-a489-122b42f718da
pattern = Dict("0" => Set(["a", "b", "c", "e", "f", "g"]),
	           "1" => Set(["c", "f"]), 
			   "2" => Set(["a", "c", "d", "e", "g"]),
               "3" => Set(["a", "c", "d", "f", "g"]),
               "4" => Set(["b", "c", "d", "f"]),
               "5" => Set(["a", "b", "d", "f", "g"]),
               "6" => Set(["a", "b", "d", "e", "f", "g"]),
               "7" => Set(["a", "c", "f"]),
               "8" => Set(["a", "b", "c", "d", "e", "f", "g"]),
               "9" => Set(["a", "b", "c", "d", "f", "g"]))

# ╔═╡ 605577de-cfb5-48c6-ad1f-bcc6abf3b71a
function pattern_out(pattern_dict::Dict, pattern::String)
	for k in keys(pattern_dict)
		pattern_dict[k] == Set(split(pattern, "")) && return parse(Int, k)
	end
end

# ╔═╡ 179d3cd1-bb2d-4a37-bd47-207f88671923
function findpattern(pattern, n)
	pattern[length.(pattern) .== n]
end

# ╔═╡ 3e85cca3-09ce-4af1-a86a-f929f366ca96
let
	p = hcat(input08.output...)
	pattern1 = findpattern(p, 2)
	pattern4 = findpattern(p, 4)
	pattern7 = findpattern(p, 3)
	pattern8 = findpattern(p, 7)
	sum([length(p) for p in (pattern1, pattern4, pattern7, pattern8)])
end

# ╔═╡ 2693f7ba-dd19-4bb3-b6f6-3742f251558a
md"### ---- Part Two ----"

# ╔═╡ 8361376a-7f2d-447f-969d-157292347d0e
function pattern_resolve(p)
	p_old = Dict("0" => Set(["a", "b", "c", "e", "f", "g"]),
	           "1" => Set(["c", "f"]), 
			   "2" => Set(["a", "c", "d", "e", "g"]),
               "3" => Set(["a", "c", "d", "f", "g"]),
               "4" => Set(["b", "c", "d", "f"]),
               "5" => Set(["a", "b", "d", "f", "g"]),
               "6" => Set(["a", "b", "d", "e", "f", "g"]),
               "7" => Set(["a", "c", "f"]),
               "8" => Set(["a", "b", "c", "d", "e", "f", "g"]),
               "9" => Set(["a", "b", "c", "d", "f", "g"]))
	
	sset(s) = Set(split(s, ""))
	p1 = p[length.(p) .== 2][] |> sset
	p4 = p[length.(p) .== 4][] |> sset
	p7 = p[length.(p) .== 3][] |> sset
	p8 = p[length.(p) .== 7][] |> sset
	p235 = p[length.(p) .== 5] .|> sset
	p069 = p[length.(p) .== 6] .|> sset
	p3 = p235[length.(setdiff.(Ref(p1), p235)) .== 0][]
	p9 = p069[length.(setdiff.(Ref(p4), p069)) .== 0][]
	p06 = p069[length.(setdiff.(Ref(p4), p069)) .!= 0]
	p0 = p06[length.(setdiff.(Ref(p7), p06)) .== 0][]
	p6 = p06[length.(setdiff.(Ref(p7), p06)) .!= 0][]

	p_all = sset("abcdefg")
	p_abcefg = p0
	p_cf = p1
	p_acdfg = p3
	p_bcdf = p4
	p_abdefg = p6
	p_acf = p7
	p_abcdefg = p8
	p_abcdfg = p9
	
	p_a = setdiff(p_acf, p_cf)
	p_b = setdiff(p_abcdfg, p_acdfg)
	p_c = setdiff(p_all, p_abdefg)
	p_d = setdiff(p_all, p_abcefg)
	p_e = setdiff(p_all, p_abcdfg)
	p_f = setdiff(p_cf, p_c)
	p_g = setdiff(p_abcdfg, union(p_bcdf, p_a))

	getset(set) = [s for s in set][]
	
	replace_rule = ("a" => getset(p_a),
			        "b" => getset(p_b),
			        "c" => getset(p_c),
			        "d" => getset(p_d),
			        "e" => getset(p_e),
			        "f" => getset(p_f),
			        "g" => getset(p_g)
				   )

	p_new = Dict()
	for k in keys(p_old)
		old = p_old[k]
		new = replace(old, replace_rule...)
		push!(p_new, k => new)
	end
	p_new
end

# ╔═╡ 0a354e00-0a59-4c40-88f4-c94ae0e989c8
pattern_resolve(input08.pattern[1])

# ╔═╡ 20d00969-207f-4f3d-bf91-54845253201c
function pattern_out2(input)
	function _val(v)
		out = 0
		len = length(v)
		for i in 1:len
			out += v[i] * 10 ^ (len - i)
		end
		return out
	end
	len = length(input.pattern)
	s = 0
	for i in 1:len
		p = input.pattern[i]
		o = input.output[i]
		p_new = pattern_resolve(p)
		oo = pattern_out.(Ref(p_new), o)
		val = _val(oo)
		s += val
	end
	return s
end

# ╔═╡ a128b002-11e4-4922-bad4-8aba167adc16
pattern_out2(input08)

# ╔═╡ 741dc96d-6352-4967-ac64-a8e96221a931
md"## Day 9: Smoke Basin"

# ╔═╡ c81fd037-bbac-4659-bd78-6442de5a0628
input09_path = "input09.txt"

# ╔═╡ 4c1d3a2f-0534-44fd-8185-ce7c478c21fb
input09 = open(input09_path) do f
	hcat([parse.(Int, split(l, "")) for l in readlines(f)]...) |> transpose |> Matrix
end

# ╔═╡ bf468cf1-1d5e-48b1-a064-7ae958ffa4de
md"### ---- Part One ----"

# ╔═╡ c9e72abe-0ffe-49aa-ad40-562482ad61cc
function neighbor(I, M)
	out = CartesianIndex{2}[]
	R = CartesianIndices(M)
	v = CartesianIndex(0, 1)
	h = CartesianIndex(1, 0)
	for In in (v, -v, h, -h)
		if I + In in R
			push!(out, I + In)
		end
	end
	return out
end

# ╔═╡ e030734e-db5d-43ab-89d5-77a19deaae89
function findlower_pos(M::Matrix)
	Ilow = CartesianIndex{2}[]
	for I in CartesianIndices(M)
		v_neighbor = M[neighbor(I, M)]
		v = M[I]
		if v < minimum(v_neighbor)
			push!(Ilow, I)
		end
	end
	return Ilow
end

# ╔═╡ 42f8b845-046d-4b68-8c07-e85148840586
function findlower(M::Matrix)
	out = similar(M, Bool)
	for I in CartesianIndices(M)
		v_neighbor = M[neighbor(I, M)]
		v = M[I]
		if v < minimum(v_neighbor)
			out[I] = true
		else
			out[I] = false
		end
	end
	return out
end

# ╔═╡ e16fd61b-2652-4031-9a26-99d9ecb55fa0
lowpos = findlower(input09)

# ╔═╡ f693b27e-389e-49e8-8728-fb3e27473396
input09[lowpos] .+ 1 |> sum

# ╔═╡ 2eef41e9-586f-4030-bc6d-926553f9c666
md"### ---- Part Two ----"

# ╔═╡ ed55856f-1c4d-4573-90ea-c816f84c7fb5
function low_basin(I, M)
	Ib = [I]
	Iv = copy(Ib)
	while length(Iv) > 0
		Ib_old = copy(Ib)
		for I in Iv
			In = neighbor(I, M)
			for Inn in In
				Inn ∉ CartesianIndices(M) && continue
				M[Inn] == 9 && continue
				Inn ∈ Ib && continue
				push!(Ib, Inn)
			end
		end
		Iv = setdiff(Ib, Ib_old)
	end
	return Ib
end

# ╔═╡ c23f4ccf-090d-4bba-ace5-8d04c6d83a25
basin_size = sort([length(low_basin(I, input09)) for I in findlower_pos(input09)], rev=true)

# ╔═╡ 61208614-0092-4359-a28e-370e866fb1c5
reduce(*, basin_size[1:3])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.24"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "d7fa6237da8004be601e19bd6666083056649918"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "6c9fa3e4880242c666dafa4901a34d8e1cd1b243"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.24"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─37ad870d-4d77-4d90-a2c9-0e8e1d723e37
# ╠═1394b9ee-d51b-4674-93c7-80d2234cd8d6
# ╠═6d25e656-e71a-4f74-a250-15f98c6f7288
# ╟─b58dfe8f-888c-40d9-a979-bb6a657b8c9f
# ╟─d676ae47-e83e-4dae-a340-fbd206a609db
# ╠═fb2d0bd8-ec7f-463d-a28a-7324ab1676e6
# ╠═0d9cfb54-2b21-45cc-bdcd-facb7969f16b
# ╠═c32c9a48-0241-4e1f-82e5-0df0e602a798
# ╠═74c21e9e-6e98-42d8-aa17-cb54b0932e98
# ╟─304efb98-9240-418b-bba8-4a41e657477e
# ╠═15692d31-67d5-4488-8fcd-3c5d0f9fd8c8
# ╠═2dda6b0b-8a03-4eac-a14f-b6a399c4105c
# ╟─5b360d45-7b22-469b-a872-7085a16e9c18
# ╟─f4439061-f41d-4d62-8808-a77c1fd16838
# ╠═afe88790-85ef-49e8-a878-7baaaac8e211
# ╠═55144b3e-02e5-4f51-9bb3-983e6c0812fb
# ╠═ea7eaad6-4e2b-4bf6-9ae5-5193a30fe25c
# ╠═24772ea4-11f8-46eb-8ec9-bb80470f374d
# ╠═54617336-76ce-49c2-8fb6-b6adc7f084fe
# ╠═63da6778-c561-4649-a9b2-59a17d2b02a4
# ╠═925db49e-a3c0-4eb0-8de5-1dba43df52e4
# ╟─e09cfd00-1fc5-4f6f-9a3f-ff594d128d6a
# ╠═5ef9371d-298b-4804-b2f4-d4800a7e9298
# ╠═48fa4fd5-acda-4074-9d1d-9af66fa4075b
# ╠═2a068162-ff29-40a7-8aca-0075481d2cad
# ╠═828cec07-32d4-4e12-9012-08add04802cd
# ╠═1d19cdde-4cae-4785-a500-8517ed9121c6
# ╟─a878e37e-dc82-4576-95a5-afb9f0d5ed57
# ╠═3365f01c-bc0e-4987-b004-efc40035a8c9
# ╠═75aae7f8-c835-498d-adbb-71537eb8fd5c
# ╠═bf0a41df-d71e-41b6-949d-269479ef8615
# ╠═b118e84a-ab31-4e68-b2bb-5ab695769c04
# ╠═28d54574-e95e-4e1b-8bd5-b694ad96314b
# ╠═ed8ed80c-5104-4d0c-a53a-823aea73d5a7
# ╟─accf6429-8508-43d0-a08c-a5ab5c4dfc5e
# ╠═ac01fd52-e972-4554-adb5-882fed8ac8ae
# ╠═d8ac9612-4ee8-4132-9b8a-09ceab5152be
# ╠═0d5a5593-3310-4479-b28c-41933deb928f
# ╟─471f37bc-0385-45f2-8c42-62f76a246ec0
# ╟─8c034d7c-89f4-416d-a496-4b0ff00f01d2
# ╠═c09f1628-46cb-4df3-9cba-531d84bb6c65
# ╠═db71de08-081a-4367-93ce-b098fcd5c064
# ╠═ddfdd669-ee08-4b1d-9e0a-761ab8358229
# ╠═fc62149d-1cde-49a5-b0f9-12472731b6a3
# ╠═194173b4-5868-4609-8874-ed29814a7bed
# ╠═d0437e4f-8b8d-40ee-9a53-aa9a664b37cf
# ╟─bfc0a3be-187e-47a1-9a51-4698c8377028
# ╠═61e7222d-213a-48d4-9113-5289f67f2549
# ╠═0c8f6bc7-1232-45ae-b97f-4f621d76a513
# ╟─128451df-2622-4bd0-ac0d-8cfb1afa3a7e
# ╟─6bc2cd23-23cb-47f5-9628-a4ca16a0b749
# ╠═9765eb0f-83ed-4f3e-8c65-8e7e9e7bc5e1
# ╠═1beff8a4-7128-4050-8561-0bb299280b55
# ╠═68657f10-c66e-44a3-8039-a91479399c95
# ╠═0737820b-d563-435b-a79f-2673090b41e5
# ╠═110b1d6f-6d09-4250-855b-597203ea35bc
# ╠═ad944c61-84f7-459f-8f87-532ad625af74
# ╟─23e919e1-a9f8-40bf-9e97-a62d698039fe
# ╠═db1f75d5-78f4-4ca3-82db-b50098e002b5
# ╠═a90e3a08-4b6e-4584-be4d-4f58865b68de
# ╟─11785d6b-1c6d-4690-a60c-38f8c77bb22a
# ╠═5baebb4b-52bb-4b42-8522-ab323d95ee35
# ╠═a828d933-8573-42fe-9dae-15401186722a
# ╠═e8445863-0ac4-411f-a097-0a733c13ab3d
# ╠═7731ad76-4bb3-455d-9f6e-bf8dfdacbea4
# ╠═0c098ce2-0b55-4ca2-bc20-3c53dafbc91f
# ╠═b8e55033-2698-4d71-a261-379c8fc2fd88
# ╠═c7245aed-c72c-43f0-ad6e-1b33e20a1ab4
# ╠═50ff2a9b-73eb-4746-bdbc-375e30828d9f
# ╠═78116f86-278f-43d2-9f4f-fa57db0452af
# ╠═eb424f48-5aed-48b1-9d66-f42dde830ee6
# ╠═e1bf9bd1-15a9-4e8e-bd30-80c9c5221cdd
# ╠═a4f2a881-8b6b-4fd0-afa0-0396d89ba9fc
# ╠═562961f7-f042-4a2e-8fe6-7c9ba7ee4151
# ╟─9d680e9f-5ec3-49af-ac6d-84a229587970
# ╠═d0e62e96-ca23-4324-a97a-c855ddea5c6a
# ╠═4b97edb8-3387-4f53-b34f-31bb038a23f0
# ╠═8a864189-8190-475f-ad4b-c2afd3cd9699
# ╠═bea4c00b-b37d-4292-b44e-5d42d1993717
# ╠═be0dbfef-0d01-4adb-9722-1924606b3cb9
# ╠═d1c8e704-61ca-43a6-825f-de7590dba603
# ╠═b0c71572-f9aa-46d3-969b-d13098e6c08e
# ╠═8174c483-eb9a-4c75-9c52-3c4f0d1336d9
# ╠═469f9c7e-b092-4cb9-b7f8-778a41d57931
# ╠═05ae9276-94fc-4a2f-9e5d-2196a64c95ca
# ╠═9d523f38-5a9c-466f-b88e-4b30e06a3ed8
# ╠═f6b010da-f6c2-4e17-80da-947fe953c2e1
# ╠═1af590e7-4b78-4d09-a489-122b42f718da
# ╟─605577de-cfb5-48c6-ad1f-bcc6abf3b71a
# ╟─179d3cd1-bb2d-4a37-bd47-207f88671923
# ╠═3e85cca3-09ce-4af1-a86a-f929f366ca96
# ╠═2693f7ba-dd19-4bb3-b6f6-3742f251558a
# ╠═0a354e00-0a59-4c40-88f4-c94ae0e989c8
# ╠═8361376a-7f2d-447f-969d-157292347d0e
# ╠═20d00969-207f-4f3d-bf91-54845253201c
# ╠═a128b002-11e4-4922-bad4-8aba167adc16
# ╠═741dc96d-6352-4967-ac64-a8e96221a931
# ╠═c81fd037-bbac-4659-bd78-6442de5a0628
# ╠═4c1d3a2f-0534-44fd-8185-ce7c478c21fb
# ╠═bf468cf1-1d5e-48b1-a064-7ae958ffa4de
# ╠═c9e72abe-0ffe-49aa-ad40-562482ad61cc
# ╠═e030734e-db5d-43ab-89d5-77a19deaae89
# ╠═42f8b845-046d-4b68-8c07-e85148840586
# ╠═e16fd61b-2652-4031-9a26-99d9ecb55fa0
# ╠═f693b27e-389e-49e8-8728-fb3e27473396
# ╠═2eef41e9-586f-4030-bc6d-926553f9c666
# ╠═ed55856f-1c4d-4573-90ea-c816f84c7fb5
# ╠═c23f4ccf-090d-4bba-ace5-8d04c6d83a25
# ╠═61208614-0092-4359-a28e-370e866fb1c5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
