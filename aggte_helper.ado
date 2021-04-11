*! aggte_helper v.0.1.0 F in R's did package. 05apr2021 by Nick CH-K
cap prog drop aggte_helper
prog def aggte_helper, rclass

	version 14
	
	syntax, ///
		[type(string) balance_e(integer -99) min_e(integer -99) max_e(integer -99) na_rm ALPha(real -99) bootstrap bootstrap_no ///
		cband cband_no biters(integer -99) CLUStervars(varlist max=2)]
	
	quietly{
	
	* Make sure to get rid of old results lest we error here and refer back to them!
	rcall: suppressWarnings(try(rm(TE)))
	return clear
	
	* Convert to R call options
	
	local boot_TF = "NULL"
	if "`bootstrap_no'" == "bootstrap_no" {
		local boot_TF = "FALSE"
	}
	if "`bootstrap'" == "bootstrap" {
		local boot_TF = "TRUE"
	}
	local cband_TF = "NULL"
	if "`cband_no'" == "cband_no" {
		local cband_TF = "FALSE"
	}
	if "`cband'" == "cband" {
		local cband_TF = "TRUE"
	}
	local narm_TF = "FALSE"
	if "`na_rm'" == "na_rm" {
		local narm_TF = "TRUE"
	}
	foreach x in "balance_e" "biters" "alpha" {
		local opt_`x' = "NULL"
		if ``x'' != -99 {
			local opt_`x' = "``x''"
		}
	}
	
	local opt_min_e = "-Inf"
	local opt_max_e = "Inf"
	foreach x in "min_e" "max_e" {
		if ``x'' != -99 {
			local opt_`x' = "``x''"
		}
	}
	
	if !inlist("`type'","","simple","dynamic","group","calendar") {
		display as error "If {opt type} is specified it must be simple, dynamic, group, or calendar."
		exit 198
	}
	if "`type'" == "" {
		local type = "group"
	}
	
	local clusters = "NULL"
	if "`clustervars'" != "" {
		display as error "At least one of the cluster variables must be {opt idname} from {cmd: att_gt}."
		display as error "This is not checked for correctness in {cmd: aggte} but if you get an error, that may be why."
		local clus1 = trim(word("`clustervars'",1))
		local clus2 = trim(word("`clustervars'",2))
		if length("`clus2'") == 0 {
			local clusters = "'`clus1''"
		}
		else {
			local clusters = "c('`clus1'','`clus2'')"
			
			if "`boot_TF'" == "FALSE" {
				display as error "Multiple clustering variables not allowed with analytic SEs."
				exit 198
			}
		}
	}
	
	* Run interactively so other functions can use
	* the model output
	* "dotter" turns R NA's into Stata NA's
	noisily rcall: library(did); ///
		dotter <- function(M) {; ///
			if (sum(is.na(M)) > 0) M[is.na(M)] <- '.'; ///
			return(M) ; ///
		}; ///
		err <- try(TE <- aggte(CS_Model, ///
							type = "`type'", ///
							balance_e = `opt_balance_e', ///
							min_e = `opt_min_e', ///
							max_e = `opt_max_e', ///
							na.rm = `narm_TF', ///
							bstrap = `boot_TF', ///
							biters = `opt_biters', ///
							cband = `cband_TF', ///
							alp = `opt_alpha', ///
							clustervars = `clusters')); ///
		if (inherits(err, 'try-error')) { ///
			error <- err[1]; ///
		} else { ///
			overall_effect <- TE[['overall.att']]; ///
			overall_se <- TE[['overall.se']]; ///
			overall_crit_value <- qnorm(1-TE[['DIDparams']][['alp']]/2); ///
			overall_cband_upper <- TE[['overall.att']] + overall_crit_value*TE[['overall.se']]; ///
			overall_cband_lower <- TE[['overall.att']] - overall_crit_value*TE[['overall.se']]; ///
			table <- cbind.data.frame(TE[['overall.att']], TE[['overall.se']], overall_cband_lower, overall_cband_upper); ///
			if (TE[['type']] != 'simple') {; ///
				cband_lower <- TE[['att.egt']] - TE[['crit.val.egt']]*TE[['se.egt']]; ///
				cband_upper <- TE[['att.egt']] + TE[['crit.val.egt']]*TE[['se.egt']]; ///
				table[2:(length(TE[['egt']])+1),] <- cbind.data.frame(TE[['att.egt']], TE[['se.egt']], cband_lower, cband_upper); ///
			}; ///
			cband_text1a <- paste0(100*(1-TE[['DIDparams']][['alp']]),"%"); ///
			colnames(table) <- c("ATT","SE", ///
								 paste0('CI',cband_text1a,'_Bot'),  ///
								 paste0('CI',cband_text1a,'_Top')); ///
			rownames(table) <- c('Overall', TE[['egt']]); ///
			table <- dotter(as.matrix(table)); ///
			rm(overall_cband_lower, overall_cband_upper, cband_upper, cband_lower, cband_text1a); ///
		}
	
	return add
	
	}
end
