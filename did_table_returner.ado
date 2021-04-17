*! did_table_returner v.0.2.0 Run att_gt in R's did package. 14apr2021 by Nick CH-K
prog def did_table_returner, rclass
	syntax, name(string) file(string)
	
	preserve
	
	* Bring in file
	import delimited "`file'.csv", clear case(preserve)

	cap drop v1
	* Drop any -Inf etc.
	destring *, replace force
	
	mkmat *, matrix(tab)
	
	return matrix `name' = tab
	
	return add
	
	restore
	
end
