using DelimitedFiles
using Plots

# Read input from file as an array of strings
a = readdlm("input.txt", String)

# Define the regex patterns for p and v
patternp = r"(-?\d+),(-?\d+)"
patternv = r"(-?\d+),(-?\d+)"

# Arrays to store the parsed values
px = Int[]
py = Int[]
vx = Int[]
vy = Int[]

# Iterate over each row (line) in the input
for row in eachrow(a)
    # Apply the regex to match p and v
    match_p = match(patternp, row[1])
    match_v = match(patternv, row[2])

    # If a match for p is found, extract the values
    if match_p !== nothing
        # Extract the matched groups (which will be numbers as strings)
        push!(px, parse(Int, match_p.captures[1]))  # First group: x for p
        push!(py, parse(Int, match_p.captures[2]))  # Second group: y for p
    end
    
    # If a match for v is found, extract the values
    if match_v !== nothing
        # Extract the matched groups (which will be numbers as strings)
        push!(vx, parse(Int, match_v.captures[1]))  # First group: x for v
        push!(vy, parse(Int, match_v.captures[2]))  # Second group: y for v
    end
end

# Display the extracted arrays
#println("px: ", px)
#println("py: ", py)
#println("vx: ", vx)
#println("vy: ", vy)


n = 100;
#nx = 7;
#ny = 11;
nx = 101;
ny = 103;

# +1 for index offset compensation
@. px += 1;
@. py += 1;


map = zeros(nx,ny);

# Static elements
xlims!(0, nx)
ylims!(0, ny)

skipsteps=0;

@. px += skipsteps * vx;
@. py += skipsteps * vy;


for run=skipsteps+1:10000
    map = zeros(nx,ny);
    px .+= vx;
    py .+= vy;

    for i=1:length(px)
        if px[i]>nx
            while px[i]>nx
                px[i] -= nx;
            end
        elseif px[i]<1
            while px[i]<1
                px[i] += nx;
            end
        end
    end

    for i=1:length(py)
        if py[i]>ny
            while py[i]>ny
                py[i] -= ny;
            end
        elseif py[i]<1
            while py[i]<1
                py[i] += ny;
            end
        end
    end

    #println("px: ", px)
    #println("py: ", py)

    for i=1:length(px)
    #    println("px=",px[i],", py=",py[i])
        map[px[i],py[i]] += 1;
    end

    #p1=scatter(px,py, legend=:none, markersize=2)
    #display(p1)
    if maximum(map) == 1
        println("counter: ", run)
        break
    end
    
    
    #sleep(0.1)
end
println("coutner: ", run)
p1=scatter(px,py, legend=:none, markersize=2)
display(p1)

# empty center row/column

map[ceil(Int, nx/2),:] .= 0;
map[:, ceil(Int, ny/2)] .= 0;

mapa = map[1:floor(Int, nx/2), 1:floor(Int, ny/2)];
mapb = map[ceil(Int, nx/2)+1:end, 1:floor(Int, ny/2)];
mapc = map[1:floor(Int, nx/2), ceil(Int, ny/2)+1:end];
mapd = map[ceil(Int, nx/2)+1:end, ceil(Int, ny/2)+1:end];

result = sum(mapa) * sum(mapb) * sum(mapc) * sum(mapd);

println(Int64(result))