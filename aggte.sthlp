{smcl}
{* *! version 0.1.0  05apr2021}{...}
{vieweralsosee "agg_gt" "help agg_gt"}{...}
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
{bf:aggte} {hline 2} A postestimation command for {cmd: agg_gt} to combine effects into a smaller number of parameters


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:aggte}, [{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt type(string)}} Which type of aggregated treatment effect parameter to compute. 
			One option is "simple" (this just computes a weighted average of all group-time average treatment effects 
			with weights proportional to group size). Other options are "dynamic" (this computes average effects across 
			different lengths of exposure to the treatment and is similar to an "event study"; here the overall effect 
			averages the effect of the treatment across all positive lengths of exposure); 
			"group" (this is the default option and computes average treatment effects across different groups; 
			here the overall effect averages the effect across different groups); 
			and "calendar" (this computes average treatment effects across different time periods; 
			here the overall effect averages the effect across each time period).{p_end}
{synopt:{opt balance_e(integer)}}If set (and if one computes dynamic effects), it balances the sample with respect to 
			event time. For example, if set to {opt balance_e(2)}, {cmd: aggte} will drop groups that are not exposed to 
			treatment for at least three periods. (the initial period when {opt e=0} as well as the next two periods when 
			{opt e=1} and {opt e=2}). This ensures that the composition of groups does not change when event time changes.{p_end}
{synopt:{opt min_e(integer)}} For event studies, this is the smallest event time to compute dynamic effects for. 
			By default, all lengths of exposure are computed.{p_end}
{synopt:{opt max_e(integer)}} For event studies, this is the largest event time to compute dynamic effects for. 
			By default, all lengths of exposure are computed.{p_end}
{synopt:{opt na_rm}} Remove missing values from analysis.{p_end}
{synopt:{opt alp(real)}} The significance level. The default is whatever value was set in the {cmd: att_gt} call.{p_end}
{synopt:{opt bootstrap}} If {cmd: att_gt} was estimated using {opt bootstrap_no}, but you {it: do} want bootstrap in {cmd: aggte}, 
			specify this option.{p_end}
{synopt:{opt bootstrap_no}} If {cmd: att_gt} was estimated {it: without} using {opt bootstrap_no}, but you {it: don't} want bootstrap in {cmd: aggte}, 
			specify this option.{p_end}
{synopt:{opt cband}} If {cmd: att_gt} was estimated using {opt cband_no}, but you {it: do} want uniform confidence bands in {cmd: aggte}, 
			specify this option.{p_end}
{synopt:{opt cband_no}} If {cmd: att_gt} was estimated {it: without} using {opt cband_no}, but you {it: don't} want uniform confidence bands in {cmd: aggte}, 
			specify this option.{p_end}
{synopt:{opt biters(integer)}} The number of bootstrap iterations.  The default is whatever value was set in the {cmd: att_gt} call.{p_end}
{synopt:{opt clustervars(varlist)}} A list of one or more variables to cluster on. At most, there can be 
			two variables (otherwise will throw an error) and one of these must be the same as the
			{opt idname} specified in {cmd:att_gt} which allows for clustering at the individual level.  The default is whatever value was set in the {cmd: att_gt} call.{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{pstd}
{cmd: aggte} is a postestimation function for {cmd:att_gt}. Once you have the group-time treatment effects from {cmd: att_gt},
then {cmd: aggte} can aggregate them for you into time-specific treatment effects and overall treatment effects.
See Callaway and Sant'Anna (2020) for a detailed description.

{pstd}
When {cmd:aggte} is run, it will look for the R model object created by {cmd:att_gt}. So be sure not to clear the R session between
running {cmd: att_gt} and running {cmd:aggte}. {cmd:aggte} does not rely on the {cmd:att_gt} output returned to Stata.
Importantly, because {cmd: aggte} does not rely on the Stata output, it doesn't know whether you're running it immediately
after {cmd: att_gt} or later. So it has no way to access {cmd: e(sample)} or {cmd: r(N)} information. You may want to 
save these in data before running {cmd: aggte} if you want them.

{pstd}
A full set of results is returned in {cmd: ereturn list} and you can extract any part of the results table from {cmd: r(table)}.
and so results should be compatible with at least some Stata postestimation tools.

{pstd}
Be aware that the variance matrix returned by {cmd: aggte} is diagonal, whether or not the bootstrap is used. Output is not suitable
for joint hypothesis tests of coefficients.

{pstd}
After {cmd: aggte} completes, the estimated R model object can be accessed through {cmd: rcall}. It is named TE, 
and is an AGGTEobj object as created by the R {cmd:did} package. See the 
{browse "https://cran.r-project.org/web/packages/did/did.pdf": documentation for the AGGTEobj function} to see
what else you might be able to extract from the object. For example, if you wanted the influence function from estimation,
you could get it with {cmd: rcall: TE[['inf.function']]} (note that {cmd: rcall: TE$inf.function} would be ill-advised;
despite being valid R code, the $ confuses Stata since that's the marker for globals.). Or perhaps
{cmd: rcall: write.csv(TE[['inf.function']], 'inffunction.csv') } to save it to CSV. See the {cmd: rcall} documentation
for more information on passing things directly back to Stata. 

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
{phang}{cmd:. aggte}{p_end}

