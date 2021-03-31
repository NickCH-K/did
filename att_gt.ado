cap prog drop att_gt
prog def att_gt
	syntax varlist [if] [in], [clearR] [replace] [no_panel] [idname(varname)] [allow_unbalanced_panel] [control_group(string "nevertreated")] [anticipation(integer 0)] [alp(real 0.05)] [no_bootstrap] [no_cband] [biters(integer 1000)] [clustervars(varlist)] [est_method(string "dr")] [pl] [cores(integer 1)]
end
