{smcl}
{* *! version 0.2.0  14apr2021}{...}
{vieweralsosee "att_gt" "help att_gt"}{...}
{vieweralsosee "aggte" "help aggte"}{...}
{vieweralsosee "did" "help did"}{...}
{vieweralsosee "ggdid" "help aggte"}{...}
{vieweralsosee "mpdta" "help mpdta"}{...}
{vieweralsosee "conditional_did_pretest" "help conditional_did_pretest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects intro" "help teffects intro"}{...}
{viewerjumpto "Syntax" "diddsetup##syntax"}{...}
{viewerjumpto "Description" "didsetup##description"}{...}
{viewerjumpto "Author" "didsetup##author"}{...}
{viewerjumpto "References" "didsetup##references"}{...}
{title:didsetup}

{phang}
{bf:didsetup} {hline 2} set up rcall and R package dependencies for did


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:didsetup} [repo], [go]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt repo}} specify a CRAN mirror. Otherwise, defaults to the Cloud mirror.{p_end}
{synopt:{opt go}} skip the text prompts and just say "yes" to everything.{p_end}
{synoptline}
{p2colreset}{...}

{marker description}{...}
{title:Description}

{pstd}
{cmd:didsetup} will install the Stata packages {cmd: github} and {cmd: rcall} referenced in 
{browse "https://journals.sagepub.com/doi/abs/10.1177/1536867X19830891?journalCode=stja":Haghish (2019)}, 
as well as every R package necessary to run the R did package. The Stata packages will be downloaded 
from GitHub and not SSC.

{pstd}
R must be installed first before running {cmd:didsetup}, and R must be callable from the command line. 
You can install R at {browse "https://www.r-project.org/":R-Project.org}. If after installing R, {cmd: rcall} 
is still having trouble finding your R installation, see the 
{browse "http://www.haghish.com/packages/Rcall.php":rcall website} for troubleshooting tips. 
Likely, your R installation is just not where it expects.

{pstd}
Note that running didsetup, or any other function in the did package, 
will often produce lots of bright windows that pop up and disappear. 
If you are sensitive to flashing lights you may want to look away.

{pstd}
If {cmd:rcall} seems to be working fine, but R package installation is giving you problems, 
then open up R and copy/paste the following commands one at a time. 
If one fails, check the error message to see if it's something you can fix (sometimes you 
need to delete the "00LOCK" folder that shows up in your subdirectory of R packages), 
or maybe just try it again before moving on to the next:
      
{phang2}{cmd:install.packages("did", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
{phang2}{cmd:install.packages("rmarkdown", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
{phang2}{cmd:install.packages("plm", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
{phang2}{cmd:install.packages("here", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
{phang2}{cmd:install.packages("knitr", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
{phang2}{cmd:install.packages("BMisc", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
{phang2}{cmd:install.packages("Matrix", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
{phang2}{cmd:install.packages("pbapply", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
{phang2}{cmd:install.packages("ggplot2", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
{phang2}{cmd:install.packages("ggpubr", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
{phang2}{cmd:install.packages("DRDID", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
{phang2}{cmd:install.packages("generics", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
{phang2}{cmd:install.packages("broom", repos = "https://cloud.r-project.org", dependencies = TRUE)}{p_end}
 
{marker author}{...}
{title:Author}

Nick Huntington-Klein
nhuntington-klein@seattleu.edu


{marker seealso}{...}
{title:See also}

{pstd}In this Stata package: {help att_gt}, {help aggte}, {help mpdta}.
In the {browse "https://cran.r-project.org/web/packages/did/did.pdf":original R package}, 
see also {cmd:conditional_did_pretest} (for prior trends tests), 
and the plotting functions {cmd:ggdid}, {cmd:ggdidAGGTEobj}, and {cmd:ggdidMP}.

{pstd}Interface with R: {help rcall}.

{pstd}Official Stata treatment effect estimation commands: {help teffects intro}.


{marker references}{...}
{title:References}

{phang} Haghish, E. F. (2019). Seamless interactive language interfacing between R and Stata. 
{it:The Stata Journal}, 19(1), 61–82. {browse "https://doi.org/10.1177/1536867X19830891":Link}.


