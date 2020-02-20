module Clustering
export kmean


using Statistics, Test
using LinearAlgebra

Jclust(x, reps, assignement) =
    mean(norm(x[i] - reps[assignement[i]])^2 for i = 1:length(x))

x = [ [0,1], [1,0], [-1,1] ];
reps = [ [1,1], [0,0] ];
assignment = [1,2,1];

Jclust(x, reps, assignment)

function kmean(x, k; maxiters = 100, tol = 1e-5)
    N = length(x)
    n = length(x[1])
    distances = zeros(N)
    reps = [zeros(n) for j = 1:k]
    assignment = [rand(1:k) for i = 1:N]
    Jprev = Inf
    for iter = 1:maxiters

        # cluster representative is an average in the group
        for j = 1:k
            group = [i for i=1:N if assignment[i] == j]
            reps[j] = sum(x[group]) ./ length(group)
        end

        # distance to the nearest representative
        for i = 1:N
            distances[i], assignment[i] =
                findmin([norm(x[i]-reps[j]) for j = 1:k])
        end

        J = norm(distances)^2 / N

        println("Iteration ", iter, ": Jclust = ", J, ".")

        if iter > 1 && abs(J-Jprev) < tol*J
            return assignment, reps
        end
        Jprev = J
    end
end

X = vcat( [ 0.3*randn(2) for i = 1:100 ],
    [ [1,1] + 0.3*randn(2) for i = 1:100 ],
    [ [1,-1] + 0.3*randn(2) for i = 1:100 ] );
k = 3
assignment, reprs = kmean(X,k, maxiters=100)

using Makie
N = length(X)
scatter([x[1] for x in X], [x[2] for x in X])
grps  = [[X[i] for i=1:N if assignment[i] == j] for j=1:k];
scatter([c[1] for c in grps[1]], [c[2] for c in grps[1]], color = :green)
scatter!([c[1] for c in grps[2]], [c[2] for c in grps[2]], color = :blue)
scatter!([c[1] for c in grps[3]], [c[2] for c in grps[3]], color = :brown)


import VMLS

article, dictionary, titles = VMLS.wikipedia_data()
N = length(article)
k = 9
assigment, reps = kmean(article, k)

d = [norm(article[i]-reps[assigment[i]]) for i = 1:N]
for j = 1:k
    group = [i for i = 1:N if assigment[i] == j]
    println()
    println("Cluster ", j, " (", length(group), " articles)")
    I = sortperm(reps[j], rev=true)
    println("Top words: \n    ", dictionary[I[1:5]]);
    println("Documents closest to representative: ")
    I = sortperm(d[group])
    for i= 1:5
        println("    ", titles[group[I[i]]])
    end
end

end
