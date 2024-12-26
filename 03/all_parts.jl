using DelimitedFiles
a = readdlm("input.txt",Int32)
a[:,1]=sort!(a[:,1]);
a[:,2]=sort!(a[:,2]);

dist = sum([abs(x[1]-x[2]) for x in eachrow(a)])

weights = sum([length(findall(x->x==row[1], a[:,2])) * row[1] for row in eachrow(a)])