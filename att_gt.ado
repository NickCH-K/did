*! att_gt v.1.2.3 Run att_gt in R's did package. 05apr2021 by Nick CH-K
prog def att_gt, rclass

	version 14

	syntax varlist(min=3) [if] [in] [iweight], ///
		[clearR replace no_panel idname(varname) xformla(string) allow_unbalanced_panel control_group(varlist) ///
		anticipation(integer 0) ALPha(real 0.05) no_bootstrap no_cband biters(integer 1000) ///
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
	
	* Convert binary options to their R-appropriate versions
	* Restart the R session if desired
	if "`clearR'" == "clearR" {
		rcall, clear
	}	
	local boot_TF = "TRUE"
	if "`no_bootstrap'" == "no_bootstrap" {
		local boot_TF = "FALSE"
	}
	foreach x in allow_unbalanced_panel pl {
		local `x'_TF = "FALSE"
		if "``x''" == "`x'" {
			local `x'_TF = "TRUE"
		}
	}
	foreach x in panel cband {
		local `x'_TF = "TRUE"
		if "`no_`x''" == "no_`x'" {
			local `x'_TF = "FALSE"
		}
	}
	if "`pl_TF'" == "TRUE" | `cores' != 1 {
		display as error "pl and cores options are not currently functional and will be ignored."
	}
	
	* Defaults
	if !inlist("`control_group'","","nevertreated","notyettreated") {
		display as error "If control_group is specified it must be nevertreated or notyettreated."
		exit 198
	}
	if "`control_group'" == "" {
		local control_group = "nevertreated"
	}
	if !inlist("`est_method'", "", "dr", "ipw", "reg") {
		display as error "If est_method is specified it must be dr, ipw, or reg."
		if "`est_method'" != "" {
			display as error "Custom estimation functions are not supported in this port."
			display as error "If you can write one of those you can just use R."
		}
		exit 198
	}
	if "`est_method'" == "" {
		local est_method = "dr"
	}
	
	* Get variable names
	local yname = trim(word("`varlist'", 1))
	local varlist = trim(stritrim(subinstr("`varlist'","`yname'","",1)))
	local tname = trim(word("`varlist'",1))
	local varlist = trim(stritrim(subinstr("`varlist'","`tname'","",1)))
	local gname = trim(word("`varlist'",1))
	local varlist = trim(stritrim(subinstr("`varlist'","`gname'","",1)))
	* And construct control formula
	if "`xformla'" == "" {
		local xformla = "NULL"
		if length("`varlist'") > 0 {
			local xformla = subinstr("`varlist'"," ","+",.)
			local xformla = "~`varlist'"
		}
	}
	local clusters = "NULL"
	if "`clustervars'" != "" {
		if "`idname'" == "" {
			display as error "idname must be specified to use clustervars."
			exit
		}
		local clus1 = trim(word("`clustervars'",1))
		local clus2 = trim(word("`clustervars'",2))
		if !(trim("`idname'") == "`clus1'") {
			if "`clus2'" != "" & !(trim("`idname'") == "`clus2'"){
				display as error "One of the clustering variables must be the variable specified in idname."
				exit
			}
		}
		if length("`clus2'") == 0 {
			local clusters = "'`clus1''"
		}
		else {
			local clusters = "c('`clus1'','`clus2'')"
		}
	}
	local idname = "'`idname''"
	if "`idname'" == "''" {
		if "`no_panel'" == "" {
			display as error "idname must be specified unless no_panel is selected."
			exit 198
		}
		local idname = "NULL"
	}
	local weight = "'`weight''"
	if "`weight'" == "''" {
		local weight = "NULL"
	}
	
	* Run interactively so other functions can use
	* the model output
	noisily rcall: library(did); ///
		d <- data.frame(st.data()); ///
		m <- matrix(0); ///
		err <- try(CS_Model <- att_gt(yname = '`yname'', ///
							tname = '`tname'', ///
							idname = `idname', ///
							gname = '`gname'', ///
							xformla = `xformla', ///
							data = d, ///
							panel = `panel_TF', ///
							allow_unbalanced_panel = `allow_unbalanced_panel_TF', ///
							control_group = '`control_group'', ///
							anticipation = `anticipation', ///
							weightsname = `weight', ///
							alp = `alp', ///
							bstrap = `boot_TF', ///
							cband = `cband_TF', ///
							biters = `biters', ///
							clustervars = `clusters', ///
							est_method = '`est_method'', ///
							print_details = FALSE, ///
							pl = `pl_TF', cores = `cores' )); ///
		if (inherits(err, 'try-error')) { ///
			error <- err[1] ///
		} else { ///
			cband_type <- ifelse(CS_Model[['DIDparams']][['bstrap']], ///
                         ifelse(CS_Model[['DIDparams']][['cband']], "Simult", "Pointwise"), ///
                         "Pointwise"); ///
			cibot <- paste0(cband_type,'CI',100*(1-CS_Model[['alp']]),'_Bot'); ///
			citop <- paste0(cband_type,'CI',100*(1-CS_Model[['alp']]),'_Top'); ///
  			table <- cbind(CS_Model[['group']], CS_Model[['t']], CS_Model[['att']], CS_Model[['se']], ///
					CS_Model[['att']] - CS_Model[['c']]*CS_Model[['se']], ///
					CS_Model[['att']] + CS_Model[['c']]*CS_Model[['se']]); ///
			colnames(table) <- c('Group','Time','ATTgt','SE', cibot, citop); /// 
			rm(cibot, citop, cband_type); ///
			print(summary(CS_Model)) ///
		}
	
	* turn to wrapped inside ereturn version:
	*https://github.com/jonathandroth/staggered_stata/blob/master/staggered_helper.ado
		
	noisily display "Type return list to see the the names of the results returned to Stata."
	
	return add
	restore
	
	}
end

/*
out1 <- att_gt(yname="lemp",
               tname="year",
               idname="countyreal",
               gname="first.treat",
               xformla=~lpop,
               data=mpdta)
summary(out1)
att_gt lemp year firsttreat lpop, idname(countyreal)
*/
