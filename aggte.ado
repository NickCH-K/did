*! aggte v.0.1.0 Following att_gt, run aggte in R's did package. 05apr2021 by Nick CH-K
prog def aggte, eclass

	version 14
	
	syntax, ///
		[type(string) balance_e(integer -99) min_e(integer -99) max_e(integer -99) na_rm ALPha(real -99) bootstrap bootstrap_no ///
		cband cband_no biters(integer -99) CLUStervars(varlist max=2)]
		
	* This check nicked from Jonathan Roth's staggered package
	capture findfile rcall.ado
	if _rc != 0 {
	 display as error "rcall package must be installed. Run didsetup."
	 error 198
	}
	
	if "`bootstrap'" == "bootstrap" & "`bootstrap_no'" == "bootstrap_no" {
		display as error "bootstrap and bootstrap_no cannot be specified together."
		exit 198
	}
	if "`cband'" == "cband" & "`cband_no'" == "cband_no" {
		display as error "cband and cband_no cannot be specified together."
		exit 198
	}
	
	* Check if agg_gt object can be found
	* If it can, we passed the other R checks so don't need them
	rcall: if (!exists('CS_Model')) stop("att_gt output not found in R. Run att_gt first, and don't clear R afterwards.")
	
	quietly{
		
	* Call the helper
	aggte_helper, ///
		type(`type') balance_e(`balance_e') min_e(`min_e') max_e(`max_e') `na_rm' alp(`alpha') `bootstrap_no' ///
		`bootstrap' `cband' `cband_no' biters(`biters') clustervars(`clustervars')
	
	noisily rcall: if(exists('TE')) { print(summary(TE)) } else {print('R failed to produce estimates, or rcall failed to return it to Stata.') }
	
	
	* ereturn pulls straight from the table
	matrix T = r(table)
	local numgroups = rowsof(T)
	matrix b = T[1..`numgroups',"ATT"]
	matrix b = b'
	matrix se = T[1..`numgroups',"SE"]
	matrix V = diag(se)
	
	noisily display as text "The returned variance matrix is diagonal and cannot be used for joint tests."
	
	ereturn post b V
	}
end
