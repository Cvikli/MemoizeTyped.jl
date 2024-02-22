module MemoizeTyped

export @memoize_typed

macro memoize_typed(out_type,funccall)
	funcname = funccall.args[1]
	args_tsafe = tuple(funccall.args[2:end]...)
	cache_funcname = Symbol("$(funcname)_cached")
	esc(quote
			!@isdefined($cache_funcname) && ($cache_funcname=Dict{typeof($args_tsafe),$out_type}())
			if $args_tsafe in keys($cache_funcname) 
					$cache_funcname[$args_tsafe]
			else
					$cache_funcname[$args_tsafe] = $funccall
			end
	end)
end

end # module MemoizeTyped
