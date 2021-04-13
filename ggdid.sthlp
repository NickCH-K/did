{smcl}
{* *! version 0.1.0  05apr2021}{...}
{vieweralsosee "att_gt" "help att_gt"}{...}
{vieweralsosee "aggte" "help aggte"}{...}
{vieweralsosee "did" "help did"}{...}
{vieweralsosee "didsetup" "help didsetup"}{...}
{vieweralsosee "mpdta" "help mpdta"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects intro" "help teffects intro"}{...}
{viewerjumpto "Syntax" "att_gt##syntax"}{...}
{viewerjumpto "Description" "att_gt##description"}{...}
{viewerjumpto "Author" "att_gt##author"}{...}
{viewerjumpto "References" "att_gt##references"}{...}
{viewerjumpto "Examples" "att_gt##examples"}{...}
{title:att_gt}

{phang}
{bf:aggte} {hline 2} A postestimation command for {cmd: att_gt} or {cmd: aggte} to plot the results.


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:ggdid}, [{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt type(string)}} This can either be "att_gt", the default, to plot the results from a {cmd: att_gt} command,
			or "aggte" to plot the results from a {cmd: aggte} command.{p_end}
{synopt:{opt file(string)}} This is the filename that the resulting graph will be saved to. Do not include file extensions (e.g. .pdf, .png) here. Default is didplot.{p_end}
{synopt:{opt format(string)}} This is the filetype that will be produced. Options include "pdf" (the default), "eps", "ps", "tex" (pictex), "jpeg", "tiff", "png", "bmp", "svg" or "wmf" (windows only).{p_end}
{synopt:{opt ylim(string)}} Specify as two real numbers (bottom limit, then top), separated by a space. Sets the y-axis limits for the graphs
			for all groups to be the same.{p_end}
{synopt:{opt xlab(string)}} The x-axis label.{p_end}
{synopt:{opt ylab(string)}} The y-axis label.{p_end}
{synopt:{opt title(string)}} The plot title.{p_end}
{synopt:{opt xgap(integer)}} The gap between the labels on the x-axis. For example, {opt xgap=3} indicates that the labels should show up for every third value on the x-axis. The default is 1.{p_end}
{synopt:{opt ncol(integer)}} Only relevant for {opt type(att_gt)}. The number of columns to include in the resulting plot. The default is 1.{p_end}
{synopt:{opt legend_no}} Omit the legend (which will indicate color of pre- and post-treatment estimates).{p_end}
{synopt:{opt ggcode(string)}} A string of {browse "https://ggplot2.tidyverse.org/": ggplot2 code}, presumably starting with a "+", that will modify the ggplot object produced by {cmd: ggdid}. For example, {opt ggcode(+ggpubr::theme_pubr())} to use the pubr theme, or {opt ggcode(+theme(panel.grid = element_blank()))} to get rid of the panel gridlines in the background. This won't be checked for accuracy, and error messages won't always be effectively communicated back, so proceed at your own risk. Also note that as of R package did version 2.0, this won't work for {cmd: att_gt} graphs, only {cmd: aggte} graphs.{p_end}
{synopt:{opt width(real)}} Width of the output image, in {opt units} units. Set by ggplot2 in R if not specified.{p_end}
{synopt:{opt height(real)}} Height of the output image. Set by ggplot2 in R if not specified.{p_end}
{synopt:{opt units(string)}} Units that {opt width} and {opt height} are in, if those are specified. "in", "cm", or "mm", inches by default.{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{pstd}
{cmd: ggdid} is a postestimation function for {cmd:att_gt} and {cmd: aggte} that plots the estimated effects. 
using the {browse "https://ggplot2.tidyverse.org/": ggplot2 graphics package}. 

{pstd}
Instead of being opened up in a graph viewer, the result will be saved to file based on {opt file} and {opt format}.

{pstd}
After {cmd: ggdid} is run, the resulting ggplot object is saved in R as didplot. If you want even more control over 
the image export beyond {opt width}, {opt height}, {opt units}, {opt format}, and filetype, you can use {cmd: rcall} with the {browse "https://www.rdocumentation.org/packages/ggplot2/versions/3.3.3/topics/ggsave": ggsave()}
function, referring to the plot as didplot.

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
{phang}{cmd:. ggdid}{p_end}
{phang}{cmd:. aggte}{p_end}
{phang}{cmd:. ggdid, type(aggte)}{p_end}

