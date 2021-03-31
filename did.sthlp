{smcl}
{* *! version 1.2.2  15may2018}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Author" "examplehelpfile##author"}{...}
{viewerjumpto "References" "examplehelpfile##references"}{...}
{title:didsetup}

{phang}
{bf:didsetupz} {hline 2} Overview of the did package


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:did}

{synoptline}
{p2colreset}{...}

{marker description}{...}
{title:Description}

{pstd}
{cmd:did} is just a program reminding you to look at this help file, where the real information is!

{pstd}
This package is a wrapper for the R package did, by Callaway and Sant'anna, using the rcall package by Haghish (2019). Because it is only a wrapper for an existing R package, you will need to {browse "https://www.r-project.org/": have R installed} and accessible by command line before using it.

Once you have R installed, you can get set up with the appropriate R packages, and the Stata packages for calling R, by running the {cmd:didsetup} command.

Then, the function names are the same as those listed in the {browse "https://cran.r-project.org/web/packages/did/index.html":documentation for the R package}.

Some of the primary functions you will want to examine will be {cmd:att_gt}, which calculates group-time average treatment on the treated, {cmd:aggte}, which calculates treatment effects from that model, or {mpdta}, which provides an example data set.

The full list of functions in this package are: {cmd: att_gt}, {cmd: aggte}, {cmd:mpdta}, {cmd: conditional_did_pretest} (for prior trends tests), and the plotting functions {cmd:ggdid}, {cmd:ggdidAGGTEobj}, and {ggdidMP}.

There are other functions in the did package, but they are intended largely for intermediate use, i.e. not by the end user, and so are not included in this Stata package. However, if you {it: do} want to use one of the non-included functions, let me know by email or as a GitHub issue.

Note that running any function in the did package will often produce lots of bright windows that pop up and disappear. If you are sensitive to flashing lights you may want to look away.
 
{marker author}{...}
{title:Author}

Nick Huntington-Klein
nhuntington-klein@seattleu.edu

{marker references}{...}
{title:References}

{phang} Callaway, B., and P. H. C. Sant'Anna (2020). did: Treatment Effects with Multiple Periods and Groups. CRAN. {browse "https://cran.r-project.org/web/packages/did/index.html":Link}.

{phang} Haghish, E. F. (2019). Seamless interactive language interfacing between R and Stata. The Stata Journal, 19(1), 61–82. {browse "https://doi.org/10.1177/1536867X19830891":Link}.


