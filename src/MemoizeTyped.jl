module MemoizeTyped

export @memoize_typed, @clean_cache
macro memoize_typed(out_type,funccall)
	cache(true, out_type,funccall)
end
macro memoize_typed(is_cache_enabled, out_type,funccall)
	cache(is_cache_enabled, out_type,funccall)	
end
cache(is_cache_enabled, out_type,funccall) = begin
	funcname = funccall.args[1]
	args_tsafe = tuple(funccall.args[2:end]...)
	cache_funcname = Symbol("$(funcname)_cached")
	esc(quote
			!@isdefined($cache_funcname) && ($cache_funcname=Dict{typeof($args_tsafe),$out_type}())
			if $is_cache_enabled && $args_tsafe in keys($cache_funcname) 
					$cache_funcname[$args_tsafe]
			else
					$cache_funcname[$args_tsafe] = $funccall
			end
	end)
end

macro clean_cache(funccall)
	cache_funcname = Symbol("$(funcname)_cached")
	quote
		!@isdefined($cache_funcname) && empty!($(esc(cache_funcname)))
	end
end


end # module MemoizeTyped
