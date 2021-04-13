*! ggdid v.0.1.0 Following att_gt or aggte, run ggdid in R's did package. 05apr2021 by Nick CH-K
prog def ggdid

	version 14
		syntax, ///
		[type(string) format(string) file(string) ylim(string) xlab(string) ylab(string) title(string) ///
		xgap(integer 1) ncol(integer 1) legend_no ggcode(string) width(real -99) height(real -99) units(string)]
		
	* This check nicked from Jonathan Roth's staggered package
	capture findfile rcall.ado
	if _rc != 0 {
	 display as error "rcall package must be installed. Run didsetup."
	 error 198
	}
	
	* Defaults
	local obj = "CS_Model"
	if !inlist("`type'","","att_gt","aggte") {
		display as error "If specified, {opt type} must be att_gt or aggte."
		exit 198
	}
	if "`type'" == "aggte" {
		local obj = "TE"
	}
	if "`type'" == "" {
		local type = "att_gt"
	}
	
	* Check if relevant object can be found
	* If it can, we passed the other R checks so don't need them
	if "`type'" == "att_gt" {
		rcall: if (!exists('CS_Model')) stop("att_gt output not found in R. Run att_gt first, and don't clear R afterwards.")
	}
	if "`type'" == "aggte" {
		rcall: if (!exists('TE')) stop("aggte output not found in R. Run aggte first, and don't clear R afterwards.")
	}
	

	if !inlist("`format'","","pdf","eps", "ps", "tex", "jpeg") & !inlist("`format'", "tiff", "png", "bmp", "svg", "wmf") {
		display as error "Any R image device should work, but you have entered a {opt format} not confirmed to work."
		display as error "This might be fine but may lead to error."
	}
	if "`format'" == "" {
		local format = "pdf"
	}
	
	local units = lower("`units'")
	if !inlist("`units'", "", "in", "mm", "cm") {
		display as error "If specified, {opt units} must be in, mm, or cm."
		exit 198
	}
	if "`units'" == "" {
		local units = "in"
	}
	
	local sizespec = ""
	if `width' != -99 {
		local sizespec = "`sizespec', width = `width'"
	}
	if `height' != -99 {
		local sizespec = "`sizespec', height = `height'"
	}
	if `width' != -99 | `height' != -99 {
		local sizespec = "`sizespec', units = '`units''"
	}

	* Defaults
	foreach x in ylim xlab ylab {
		if "``x''" == "" {
			local `x' = "NULL"
		}
	}
	if "`file'" == "" {
		local file = "didplot"
	}
	if "`format'" == "" {
		local format = "pdf"
	}
	
	
	* Process ylim
	if ("`ylim'" != "NULL") {
		if word("`ylim'",2) == "" {
			display as error "If ylim is specified, it must contain two values."
			exit 198
		}
		ylim = "c(" word("`ylim'",1) ", " word("`ylim'", 2) ")"
	}
	* Process the titles, allowing NULL for xlab and ylab
	foreach x in xlab ylab {
		if "``x''" != "NULL" {
			local `x' = "'``x'''"
		}
	}
	if ("`title'" == "" & "`type'" == "att_gt") {
		local title = "Group"
	}
	
	local legend_TF = "TRUE"
	if "`legend_no'" == "legend_no" {
		local legend_TF = "FALSE"
	}
	
	* Rcall!
	noisily rcall: library(did); ///
		library(ggplot2); ///
		err1 <- try(didplot <- ggdid(`obj', ///
						ylim = `ylim', ///
						xlab = `xlab', ///
						ylab = `ylab', ///
						title = "`title'", ///
						xgap = `xgap', ///
						ncol = `ncol', ///
						legend = `legend_TF') `ggcode'); ///
		if (inherits(err1, 'try-error')) { ///
			error <- err1[1] ///
		} else { ///
			err2 <- try(ggplot2::ggsave('`file'.`format'', plot = didplot, device = '`format''`sizespec')); ///
			if (inherits(err2, 'try-error')) { ///
				save_error <- err2[1] ///
			} ///
		}
	
	
	display as text "The result should be available as `file'.`format' in the working directory."
	display as text "If you cannot find it, try looking at r(error) for graph-creation errors,"
	display as text "or r(save_error) for graph-saving errors."
end
