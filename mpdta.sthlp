{smcl}
{* *! version 0.2.0  14apr2021}{...}
{vieweralsosee "att_gt" "help att_gt"}{...}
{vieweralsosee "aggte" "help aggte"}{...}
{vieweralsosee "did" "help did"}{...}
{vieweralsosee "ggdid" "help aggte"}{...}
{vieweralsosee "didsetup" "help didsetup"}{...}
{vieweralsosee "conditional_did_pretest" "help conditional_did_pretest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects intro" "help teffects intro"}{...}
{viewerjumpto "Syntax" "mpdta##syntax"}{...}
{viewerjumpto "Description" "mpdta##description"}{...}
{viewerjumpto "Author" "mpdta##author"}{...}
{viewerjumpto "References" "mpdta##references"}{...}
{title:mpdta}

{phang}
{bf:mpdta} {hline 2} Load example data mpdta from the did package


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:mpdta}, [clear]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt clear}} replace existing data with the mpdta data. 
I would make this the default but that feels un-Stata-like.{p_end}
{synoptline}
{p2colreset}{...}

{marker description}{...}
{title:Description}

{pstd}
{cmd:mpdta} will load the example data from the R did package called mpdta. 
This data can be used to try out different did commands.

{pstd}
This dataset contains (the log of) teen employment in 500 counties in the U.S. from 2004 to 2007. 
This is a subset of the dataset used in Callaway and Sant'Anna (2020). See that paper for additional descriptions.

{marker author}{...}
{title:Author}

Nick Huntington-Klein
nhuntington-klein@seattleu.edu

{marker references}{...}
{title:References}

{phang} Callaway, B., and P. H. C. Sant'Anna (2020). Difference-in-Differences with Multiple Time Periods. 
{it:Journal of Econometrics}. {browse "https://doi.org/10.1016/j.jeconom.2020.12.001":Link}.

