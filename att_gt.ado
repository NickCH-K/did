*! att_gt v.0.2.0 Run att_gt in R's did package. 14apr2021 by Nick CH-K
prog def att_gt, eclass

	version 14

	syntax varlist(min=3) [if] [in] [iweight], ///
		[clearR panel_no idname(varname) xformla(string) allow_unbalanced_panel control_group(string) ///
		anticipation(integer 0) ALPha(real 0.05) bootstrap_no cband_no biters(integer 1000) ///
		CLUStervars(varlist max=2) est_method(string) pl cores(integer 1)]
	marksample touse
	
	quietly{
	
	* Limit to estimation sample
	preserve
	keep if `touse'
	keep `varlist' `idname' `clustervars' `weight'
	
	* This check nicked from Jonathan Roth's staggered package
	capture findfile rcall.ado
	if _rc != 0 {
	 display as error "rcall package must be installed. Run didsetup."
	 error 198
	}
	
	* did requires version 4.0+
	rcall_check, rversion(4.0)
	
	capture rcall: library(did)
	if _rc != 0{
		display as error "Package (did) is missing. Run didsetup."
		exit
	} 
	
	* For ereturn later
	local N = _N
	
	* Call the helper
	att_gt_helper `varlist' `if' `in' [`iweight'], ///
		`clearR' `panel_no' idname(`idname') xformla(`xformla') `allow_unbalanced_panel' ///
		control_group(`control_group') anticipation(`anticipation') alp(`alpha') `bootstrap_no' ///
		`cband_no' biters(`biters') clustervars(`clustervars') est_method(`est_method') `pl' cores(`cores')
	
	noisily rcall: if(exists('CS_Model')) { print(summary(CS_Model)) } else {print('R failed to produce a model, or rcall failed to return it to Stata.') }
	
	restore	
	
	* Names
	* Check if the table was small enough to restore normally
	cap matrix list r(table)
	if _rc > 0 {
		did_table_returner, name(table) file(temp_table_toobig)
	}
	matrix T = r(table)
	local numgroups = rowsof(T)
	local namevec = ""
	forvalues i = 1(1)`numgroups' {
		local g = T[`i',1]
		local t = T[`i',2]
		local namevec = "`namevec' G`g'_T`t'"
	}
	matrix b = T[1..`numgroups',"ATTgt"]
	matrix b = b'
	matrix colnames b = `namevec'
	matrix se = T[1..`numgroups',"SE"]
	
		
	if "`bootstrap_no'" == "" {
		noisily display as text "The multiplier bootstrap provides only the diagonal of the V/COV matrix."
		noisily display as text "Use analytic standard errors with {opt bootstrap_no} if you want to do a joint test of coefficients."
		forvalues i = 1(1)`numgroups' {
			matrix se[`i',1] = se[`i',1]^2
		}
		matrix V = diag(se)
		matrix colnames V = `namevec'
		matrix rownames V = `namevec'
	}	
	if "`bootstrap_no'" == "bootstrap_no" {
		* It is often too big to bring back by rcall
		* So get it by file
		preserve
		
		* Bring in file
		import delimited "temp_vcv_toobig.csv", clear
		cap drop v1
		* Drop any -Inf etc.
		destring *, replace force
		mkmat *, matrix(V)
		
		restore
		
		matrix colnames V = `namevec'
		matrix rownames V = `namevec'
	}
	
	cap erase "temp_vcv_toobig.csv"
	
	cap ereturn post b V, o(`N') e(`touse')
	if _rc > 0 {
		cap ereturn post b, o(`N') e(`touse')
		if _rc > 0 {
			display as error "Missing values in estimation results; results have not been delivered to e() matrices."
		}
		else {
			display as error "Missing values in V/COV matrix; variance matrix has not been delivered to e(V)."
		}
	}
	}
end
