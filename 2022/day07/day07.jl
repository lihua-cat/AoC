abstract type FsNode end
name(fs::FsNode) = last(fs.path)


struct File <: FsNode
    path::Vector{String}
    size::Int
end
size_fs(f::File) = f.size
subdirectory(f::File) = []

struct Directory <: FsNode
    path::Vector{String}
    sub::Vector{FsNode}
end
size_fs(d::Directory) = sum(size_fs.(d.sub))
subdirectory(d::Directory) = d.sub

blank_dir(dirname::String, path=[]) = Directory([path..., dirname], [])
add_sub!(d::Directory, d_sub::FsNode) = push!(d.sub, d_sub)
add_sub!(d::Directory, dirname::String) = add_sub!(d, blank_dir(dirname, d.path))
add_sub!(d::Directory, filename::String, filesize::Int) = add_sub!(d, File([d.path..., filename], filesize))


function (d::Directory)(s::String)
    for f in d.sub
        if s == name(f)
            return f
        end
    end
    error("no such file or directory: $s in $(d.path)")
end

function (d::Directory)(path::Vector{String})
    @assert d.path[1] == path[1]
    for s in path[2:end]
        d = d(s)
    end
    return d
end

first!(v::AbstractVector) = length(v) < 2 ? v : deleteat!(v, 2:length(v))

function cmd_resolve!(cmd::String, pwd::Vector{String}, d_root::Directory)
    if cmd == "\$ cd /"
        first!(pwd)
        return nothing
    elseif cmd == "\$ ls"
        return nothing
    elseif cmd == "\$ cd .."
        pop!(pwd)
        return nothing
    elseif startswith(cmd, "\$ cd ")
        dirname = replace(cmd, "\$ cd " => "")
        push!(pwd, dirname)
        return nothing
    elseif startswith(cmd, "dir ")
        dirname = replace(cmd, "dir " => "")
        dirname in name.(d_root(pwd).sub) || add_sub!(d_root(pwd), dirname)
        return nothing
    elseif occursin(r"^[0-9]+\s[0-9a-zA-Z]+\.?[0-9a-zA-Z]+$", cmd)
        filesize, filename = split(cmd)
        filesize = parse(Int, filesize)
        filename = String(filename)
        filename in name.(d_root(pwd).sub) || add_sub!(d_root(pwd), filename, filesize)
        return nothing
    end
end

function cmd_resolve(path)
    d_root = Directory(["/"], [])
    pwd = copy(d_root.path)
    for cmd in eachline(path)
        cmd_resolve!(cmd, pwd, d_root)
    end
    return d_root
end

d_root = cmd_resolve("./input07")

# using AbstractTrees
# AbstractTrees.children(fs::FsNode) = subdirectory(fs)
# AbstractTrees.nodevalue(fs::FsNode) = name(fs)

# print_tree(d_root, maxdepth=3)

function total_size_of_dir(d::Directory)
    sum = 0
    dc = [d]
    while length(dc) > 0
        for ds in dc
            s = size_fs(ds)
            if s <= 100000
                sum += s
            end
        end
        dc = reduce(vcat, filter.(ds -> ds isa Directory, subdirectory.(dc)))
    end
    sum
end

size_fs(d_root)
total_size_of_dir(d_root)

function find_samllest_dir(d::Directory, max_space=40000000)
    null_space = size_fs(d) - max_space
    d_min = d
    dc = [d]
    while length(dc) > 0
        for ds in dc
            s = size_fs(ds)
            if s >= null_space && s < size_fs(d_min)
                d_min = ds
            end
        end
        dc = reduce(vcat, filter.(ds -> ds isa Directory, subdirectory.(dc)))
    end
    (size_fs(d_min), d_min.path)
end

find_samllest_dir(d_root)