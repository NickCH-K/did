# did
A Stata package that acts as a wrapper for Callaway and Sant'Anna's R did package. This makes heavy use of the [rcall](http://github.com/haghish/rcall) package by Haghish.

This package is fully functional, although it is also relatively untested and there may remain some bugs. Thankfully, since all the calculation is done in the R package, those bugs are more likely to give you no results than to give you wrong ones.

Functions included in this package:

- `did` which does nothing but remind you to read the help file
- `didsetup` to set up the appropriate packages so you can run the **did** R package
- `mpdta` to load the `mpdta` example data from the **did** package
- `att_gt` to estimate group-time treatment effects
- `aggte` to estimate treatment effects aggregated to the group and/or time level
- `ggdid` to produce graphs of either `att_gt` or `aggte` output
- `conditional_did_pretest` to perform an integrated moments test of the conditional parallel trends assumption

You can install **did** with `net install did, from("https://raw.githubusercontent.com/NickCH-K/did/master/")`. Make sure the [R language](R-project.org) is installed on your computer. Then run `didsetup` in Stata.

## Citation

If you use this package, some citations are in order! BibTeX entries at at the bottom of this readme.

You should definitely cite the Callaway and Sant'Anna paper that describes the estimator used in this package:

Callaway, Brantly and Pedro H.C. Sant'Anna.  "Difference-in-Differences with Multiple Time Periods." Forthcoming at the Journal of Econometrics, 2020. 

The published version of the paper can be found [here](https://doi.org/10.1016/j.jeconom.2020.12.001), and the ungated working paper is [here](https://arxiv.org/abs/1803.09015).

You may also want to cite the Callaway and Sant'Anna R package that performs the estimation:

Callaway, Brantly and Pedro H.C. Sant'Anna. "did: Difference in Differences." R package version 2.0.0. [https://bcallaway11.github.io/did/](https://bcallaway11.github.io/did/).

Finally, should you also cite this package, which acts purely as a Stata wrapper for their R package which actually does all the work? I don't know! There's not really a citation standard for this sort of thing. I certainly wouldn't mind it though. A few more years until tenure review, just sayin'.

Huntington-Klein, Nick. "'did': Use the Callaway and Sant'anna R package 'did' in Stata." Stata package version 0.2.0. [https://github.com/NickCH-K/did](https://github.com/NickCH-K/did).

BibTeX entries for citations:

```
@article{callaway2020difference,
  title={Difference-in-differences with Multiple Time Periods},
  author={Callaway, Brantly and Sant'Anna, Pedro H.C.},
  journal={Journal of Econometrics},
  year={2020},
  publisher={Elsevier}
}

@Misc{,
    title = {did: Difference in Differences},
    author = {Callaway, Brantly and Sant'Anna, Pedro H.C.},
    year = {2020},
    note = {R package version 2.0.0},
    url = {https://bcallaway11.github.io/did/},
 }
  
@Misc{,
    title = {'did': Use the Callaway and Sant'anna R package 'did' in Stata},
    author = {Huntington-Klein, Nick},
    year = {2021},
    note = {Stata package version 0.2.0},
    url = {https://github.com/NickCH-K/did},
} 
```
