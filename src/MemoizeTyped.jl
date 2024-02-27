module MemoizeTyped

using MacroTools: isexpr


export @memoize_typed, @clean_cache


function _memoize_funccall(funccall)
	funcname = funccall.args[1]
	args, kwargs = [], []
	for arg in funccall.args[2:end]
			if isexpr(arg, :kw)
					push!(kwargs, Expr(:(=), arg.args...))
			elseif isexpr(arg, :parameters)
					push!(kwargs, arg)
			else
					push!(args, arg)
			end
	end
	funcname, args, kwargs
end


macro memoize_typed(out_type,funccall)
	cache(true, out_type,funccall)
end
macro memoize_typed(is_cache_enabled, out_type,funccall)
	cache(is_cache_enabled, out_type,funccall)	
end
cache(is_cache_enabled, out_type,funccall) = begin
	funcname, args, kwargs = _memoize_funccall(funccall)
	cache_funcname = Symbol("$(funcname)_cached")
	esc(quote
			key = (($(args...),),($(kwargs...),))
			!@isdefined($cache_funcname) && ($cache_funcname=Dict{typeof(key),$out_type}())
			if $is_cache_enabled && key in keys($cache_funcname) 
					$cache_funcname[key]
			else
					$cache_funcname[key] = $funccall
			end
	end)
end

macro clean_cache(funccall)
	funcname = funccall.args[1]
	cache_funcname = Symbol("$(funcname)_cached")
	quote
		!@isdefined($cache_funcname) && empty!($(esc(cache_funcname)))
	end
end


end # module MemoizeTyped
