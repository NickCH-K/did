{smcl}
{* *! version 0.1.0  05apr2021}{...}
{vieweralsosee "aggte" "help aggte"}{...}
{vieweralsosee "did" "help did"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects intro" "help teffects intro"}{...}
{viewerjumpto "Syntax" "att_gt##syntax"}{...}
{viewerjumpto "Description" "att_gt##description"}{...}
{viewerjumpto "Author" "att_gt##author"}{...}
{viewerjumpto "References" "att_gt##references"}{...}
{viewerjumpto "Examples" "att_gt##examples"}{...}
{title:att_gt}

{phang}
{bf:att_gt} {hline 2} Run att_gt in R's did package


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:att_gt} {help depvar} tvar gvar {help varlist} [{help if}] [{help in}] [{help iweight}], [{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt depvar}} The dependent variable.{p_end}
{synopt:{opt tvar}} The name of the column containing the time periods. 
			This should be a numeric variable and not a formatted date.{p_end}
{synopt:{opt gvar}} The name of the variable in data that contains the first period when a particular observation 
			is treated. This should be a positive number for all observations in treated groups. 
			It defines which "group" a unit belongs to. It should be 0 for units in the untreated group.{p_end}
{synopt:{opt varlist}} Variables to be included as controls.{p_end}
{synopt:{opt clearR}} Start a new R environment before running {cmd: did::att_gt}.{p_end}
{synopt:{opt panel_no}} By default, estimation assumes the data is a panel, which should be provided 
			in long format – that is, where each row corresponds to a unit observed at a particular point in time. 
			When using a panel dataset, the {opt idname} must be set. With {opt panel_no}, the data is treated 
			as repeated cross sections.{p_end}
{synopt:{opt idname(varname)}} The individual (cross-sectional unit) id name.{p_end}
{synopt:{opt xformla(string)}} By default, all control variables in {opt: varlist} will be included linearly. 
			If you want to include interactions, polynomials, transformations, and so on, specify a formula 
			here as a string {it: in R syntax}, beginning with a "~". So to include A, B, B squared, A*B, 
			the log of C, and D, we could do {cmd:xformla("~A*B+I(B^2)+log(C)+D")}. 
			These variables must all be listed as normal in {opt: varlist}. 
			See {browse "https://www.youtube.com/watch?v=ZKWQR62Ph-c": this video} 
			for a more thorough walkthrough on R regression formula syntax.{p_end}
{synopt:{opt allow_unbalanced_panel}} Whether or not function should "balance" the panel with respect 
			to time and id. Without this option, {cmd:att_gt} will drop all units where data is not observed 
			in all periods. The advantage of this is that the computations are faster 
			(sometimes substantially).{p_end}
{synopt:{opt control_group(string)}} Which units to use the control group. 
			The default is "nevertreated" which sets the control group to be the group of units that 
			never participate in the treatment. This group does not change across groups or time periods. 
			The other option is to set control_group("notyettreated"). In this case, the control group 
			is set to the group of units that have not yet participated in the treatment in that time period. 
			This includes all never treated units, but it includes additional units that eventually participate 
			in the treatment, but have not participated yet.{p_end}
{synopt:{opt anticipation(integer)}} The number of time periods before participating in the treatment 
			where units can anticipate participating in the treatment and therefore it can affect 
			their untreated potential outcomes. By default 0.{p_end}
{synopt:{opt alp(real)}} The significance level, default .05.{p_end}
{synopt:{opt bootstrap_no}} Compute standard errors analytically rather than with multiplier bootstrap. 
			Note the analytic standard errors only allow clustering at the {opt idname} level.{p_end}
{synopt:{opt cband_no}} Do not compute a uniform confidence band that covers all of 
			the group-time average treatment effects with fixed probability 1-{opt alp}. 
			This option does nothing if you have also included {opt bootstrap_no}{p_end}
{synopt:{opt biters(integer)}} The number of bootstrap iterations. 1000 by default. 
			Does nothing if {opt bootstrap_no} is specified.{p_end}
{synopt:{opt clustervars(varlist)}} A list of one or more variables to cluster on. At most, there can be 
			two variables (otherwise will throw an error) and one of these must be the same as 
			{cmd:idname} which allows for clustering at the individual level.{p_end}
{synopt:{opt est_method(string)}} The method to compute group-time average treatment effects. 
			The default is "dr" which uses the doubly robust approach in 
			the {browse "https://cran.r-project.org/web/packages/DRDID/index.html": DRDID R package}. 
			Other built-in methods include "ipw" for inverse probability weighting and 
			"reg" for first step regression estimators. 
			In R this option also allows custom treatment-effect estimation functions, 
			but if you know how to do that you're probably using R and not this wrapper! 
			So that doesn't work here.{p_end}
{synopt:{opt pl}} Whether or not to use parallel processing (not implemented yet).{p_end}
{synopt:{opt cores(integer)}} The number of cores to use for parallel processing, 
			by default 1 (not implemented yet).{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{pstd}
{cmd: att_gt} computes average treatment effects in DID setups where there are more than two periods of data 
and allowing for treatment to occur at different points in time and allowing for treatment effect heterogeneity 
and dynamics. See Callaway and Sant'Anna (2020) for a detailed description.

{pstd}
Note that {it: all variable names must be legitimate variable names in R as well}. 
This isn't generally a problem though.

{pstd}
Value labels will be ignored for all variables. Be careful with factor variables! 
Currently, all numeric variables, {it including variables with labeled values} will
be treated as numeric. If you want an numeric control variable X included
as a factor, use {opt xformla}, and include that variable using "factor(X)". Or just use {cmd: decode} on it before 
running {cmd: att_gt} and include that version instead. 

{pstd}
A full set of results is returned in {cmd: ereturn list} and you can extract any part of the results table from {cmd: r(table)}.
and so results should be compatible with at least some Stata postestimation tools.

{pstd}
Although some caution is warranted before you go doing all sorts of postestimation {it: testing}. 
Default standard errors are from the multiplier bootstrap. This provides only the diagonal. So if you
want to do a joint hypothesis test, you'll want analytical standard errors with {opt bootstrap_no}.
Also, see the paper to figure out the appropriate null distribution. The relevant critical value
(simultaneous by default) is in {cmd: r(critical_value)}.

{marker author}{...}
{title:Author}

Nick Huntington-Klein
nhuntington-klein@seattleu.edu

{marker references}{...}
{title:References}

{phang} Callaway, B., and P. H. C. Sant'Anna (2020). Difference-in-Differences with Multiple Time Periods. 
{it:Journal of Econometrics}. {browse "https://doi.org/10.1016/j.jeconom.2020.12.001":Link}.{p_end}

{marker examples}{...}
{title:Examples}

{phang}{cmd:. mpdta, clear}{p_end}
{phang}{cmd:. att_gt lemp year firsttreat lpop, idname(countyreal)}{p_end}
{phang}{cmd:. matrix list r(table)}{p_end}

