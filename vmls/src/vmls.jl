module vmls
export greet, great_alien

import Random

greet() = print("Hello World!\n")
great_alien() = println("Hello ", Random.randstring(18), "\n")

function g()
end

end # module
