
using Lazy

fibs = @lazy 0:1:(fibs + tail(fibs));

take(10, fibs)

fibs[100]
