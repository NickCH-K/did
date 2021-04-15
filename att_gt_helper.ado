*! att_gt_helper v.0.2.0 Run att_gt in R's did package. 14apr2021 by Nick CH-K
prog def att_gt_helper, rclass

	version 14

	syntax varlist(min=3) [if] [in] [iweight], ///
		[clearR replace panel_no idname(varname) xformla(string) allow_unbalanced_panel control_group(string) ///
		anticipation(integer 0) alp(real 0.05) bootstrap_no cband_no biters(integer 1000) ///
		clustervars(varlist max=2) est_method(string) pl cores(integer 1)]
	
	quietly{
	
	* Convert binary options to their R-appropriate versions
	* Restart the R session if desired
	if "`clearR'" == "clearR" {
		rcall, clear
	}	
	
	* Make sure to get rid of old results lest we error here and refer back to them!
	rcall: suppressWarnings(try(rm(CS_Model)))
	return clear
	
	local boot_TF = "TRUE"
	if "`bootstrap_no'" == "bootstrap_no" {
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
		if "``x'_no'" == "`x'_no" {
			local `x'_TF = "FALSE"
		}
	}
	if "`pl_TF'" == "TRUE" | `cores' != 1 {
		display as error "{opt pl} and {opt cores} options are not currently functional and will be ignored."
	}
	
	* Defaults
	if !inlist("`control_group'","","nevertreated","notyettreated") {
		display as error "If {opt control_group} is specified it must be nevertreated or notyettreated."
		exit 198
	}
	if "`control_group'" == "" {
		local control_group = "nevertreated"
	}
	if !inlist("`est_method'", "", "dr", "ipw", "reg") {
		display as error "If {opt est_method} is specified it must be dr, ipw, or reg."
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
	if length("`xformla'") == 0 {
		local xformla = "NULL"
		if length("`varlist'") > 0 {
			local xformla = subinstr("`varlist'"," ","+",.)
			local xformla = "~`xformla'"
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
			
			if "`boot_TF'" == "FALSE" {
				display as error "Multiple clustering variables not allowed with {opt bootstrap_no}."
				exit 198
			}
		}
	}
	* Deal with labels and variable conversion
	foreach var in `yname' `tname' `gname' `clustervars' `idname' `weight' {
		label values `var'
	}
	* Labeled controls 
	foreach var in  `varlist' {
		local has_label = ("`: value label `var''" != "")
		if `has_label' == 1 {
			tempvar temp1
			tempvar temp2
			decode `var', g(`temp1')
			tostring `var', g(`temp2')
			replace `temp1' = `temp2' if missing(`temp1')
			drop `var'
			rename `temp1' `var'
			
			* Check if there was a problem
			levelsof `var', l(lvls)
			local nlevs = 0
			foreach l in `lvls' {
				local nlevs = `nlevs' + 1
			}
			if `nlevs' == 1 {
				display as error "Variable `var' only has one value. There is probably something wrong with its value label."
				exit
			}
			if `nlevs' > 100 {
				display as error "Variable `var' has more than 100 values. Is it perhaps a continuous variable with a value label?"
				exit 134
			}
		}
	}
	
	
	* More variable names
	local idname = "'`idname''"
	if "`idname'" == "''" {
		if "`panel_no'" == "" {
			display as error "idname must be specified unless panel_no is selected."
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
	* "dotter" turns R NA's into Stata NA's
	noisily rcall: library(did); ///
		d <- data.frame(st.data()); ///
		dotter <- function(M) {; ///
			if (sum(is.na(M)) > 0) M[is.na(M)] <- '.'; ///
			return(M) ; ///
		}; ///
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
  			table <- dotter(cbind(CS_Model[['group']], CS_Model[['t']], CS_Model[['att']], CS_Model[['se']], ///
					CS_Model[['att']] - CS_Model[['c']]*CS_Model[['se']], ///
					CS_Model[['att']] + CS_Model[['c']]*CS_Model[['se']])); ///
			colnames(table) <- c('Group','Time','ATTgt','SE', cibot, citop); /// 
			vcv_analytical <- dotter(as.matrix(CS_Model[['V_analytical']])); ///
			critical_value <- CS_Model[['c']]; ///
			rm(cibot, citop, cband_type) ///
		}
	
	return add
	
	}
end
