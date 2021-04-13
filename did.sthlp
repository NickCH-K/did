{smcl}
{* *! version 0.1.0  05apr2021}{...}
{vieweralsosee "att_gt" "help att_gt"}{...}
{vieweralsosee "aggte" "help aggte"}{...}
{vieweralsosee "ggdid" "help aggte"}{...}
{vieweralsosee "didsetup" "help didsetup"}{...}
{vieweralsosee "mpdta" "help mpdta"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects intro" "help teffects intro"}{...}
{viewerjumpto "Syntax" "did##syntax"}{...}
{viewerjumpto "Description" "did##description"}{...}
{viewerjumpto "Author" "did##author"}{...}
{viewerjumpto "References" "did##references"}{...}
{title:did}

{phang}
{bf:did} {hline 2} Overview of the did package


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
This package is a wrapper for the R package {cmd:did}, by Callaway and Sant'Anna (2020), 
which uses the {help rcall} package by Haghish (2019) to invoke {cmd:did} in R. 
Because it is only a wrapper for an existing R package, you will need 
to {browse "https://www.r-project.org/": have R installed} and accessible by command line before using it.

{pstd}
Note that {cmd: rcall} is in beta and can sometimes be temperamental. Two troubleshooting tips to point out:
(1) If it looks like your code is running fine but the results aren't showing up in Stata, it may be that 
your results are too big. {cmd: rcall} will sometimes refuse to return big matrices to Stata. If this happens,
use {cmd: rcall: write.csv(object, 'filename.csv')} to write the big matrix (filling in "object" with whatever the 
matrix's name is) to write the results to file so you can load them some other way.
(2) Sometimes errors in {cmd: rcall} can be "sticky." That is, once you get an error in your session, {cmd: rcall}
may continue reporting that error with subsequent uses, even if those subsequent uses are error-free. If this happens,
you can try {cmd: rcall, clear} to restart the R session. If that still doesn't work, you'll need to restart Stata.

{pstd}
Once you have R installed, you can get set up with the appropriate R packages, 
and the Stata packages for calling R, by running the {cmd:didsetup} command.

{pstd}
Then, the command names are the same as those listed in the 
{browse "https://cran.r-project.org/web/packages/did/index.html":documentation for the R package}.

{pstd}
Some of the primary commands you will want to examine will be 
{help att_gt}, which calculates group-time average treatment on the treated, 
{help aggte}, which calculates treatment effects from that model, 
and {help mpdta}, which provides an example data set.

{pstd}
Other commands in the package are {cmd: conditional_did_pretest} (for prior trends tests), 
and the plotting functions {cmd:ggdid}, {cmd:ggdidAGGTEobj}, and {cmd:ggdidMP}.

{pstd}
There are other functions in the did package, but they are intended largely for intermediate use, 
i.e. not by the end user, and so are not included in this Stata package. 
However, if you {it: do} want to use one of the non-included functions, let me know by email or as a GitHub issue.

{pstd}
Note that running any function in the did package will often produce lots of bright windows calling R 
that pop up and disappear. If you are sensitive to flashing lights you may want to look away.
 
 
{marker author}{...}
{title:Author}

Nick Huntington-Klein
nhuntington-klein@seattleu.edu


{marker seealso}{...}
{title:See also}

{pstd}In this Stata package: {help att_gt}, {help aggte}, {help mpdta}.
In the {browse "https://cran.r-project.org/web/packages/did/did.pdf":original R package}, 
see also {cmd:conditional_did_pretest} (for prior trends tests), 
and the plotting function {cmd:ggdid}.

{pstd}Interface with R: {help rcall}.

{pstd}Official Stata treatment effect estimation commands: {help teffects intro}.


{marker references}{...}
{title:References}

{phang} Callaway, B., and P. H. C. Sant'Anna (2020). did: Treatment Effects with Multiple Periods and Groups. 
CRAN. {browse "https://cran.r-project.org/web/packages/did/index.html":Link}.

{phang} Haghish, E. F. (2019). Seamless interactive language interfacing between R and Stata. 
{it:The Stata Journal}, 19(1), 61–82. {browse "https://doi.org/10.1177/1536867X19830891":Link}.


