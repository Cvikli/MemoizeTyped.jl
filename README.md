# Type safe memoize of function calls

It is a inspiartion of [Memoize.jl](https://github.com/JuliaCollections/Memoize.jl) and [Memoization.jl](https://github.com/marius311/Memoization.jl)

We want the simples UX to memoize a call. 

Literally we spare this code:
```julia
@memoize_tyepd fn(a,b,c)
```
instead of
```julia
CUSTOMPKG.cache = Dict{typeof(a,b,c),typeof(fn(a,b,c)}()

if(a,b,c) in keys(cache) 
  cache[a,b,c]
else
  cache[a,b,c] = fn(a,b,c)
end
```

# Features
- Cache the function calls, those are repetative. 
- Support to disable memoization.
- Support to disable memoization.

# TODO
- Would be great if we would have the "return type deduced" so we don't have to prespecify. (I saw many different solution [#1](https://stackoverflow.com/questions/58328476/is-it-possible-to-get-the-return-type-of-a-julia-function-in-an-unevaluated-cont))
- Setting the cache to Main module score or Pkg scope. 

# USECARE
- data load. (even from file or from external server) 
- postprocessing data.
- 


