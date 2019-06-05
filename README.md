# cell-migration-spatialcoord-onelayer

<a href="https://github.com/tstepien/cell-migration-spatialcoord-onelayer/"><img src="https://img.shields.io/badge/GitHub-cell--migration--spatialcoord--onelayer-blue.svg" /></a> <a href="https://doi.org/10.1101/460774"><img src="https://img.shields.io/badge/bioRxiv-460774-orange.svg" /></a> <a href="https://doi.org/10.5061/dryad.8pj52vk"><img src="https://img.shields.io/badge/Dryad-10.5061%2Fdryad.8pj52vk-purple.svg"></a> <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" /></a>

The code contained in the cell-migration-spatialcoord-onelayer project was developed for work in numerically simulating the collective migration of cells and tissues in 2D using partial differential equations with a moving boundary. It is described in various papers including:
><a href="http://math.arizona.edu/~stepien/">Tracy L. Stepien</a>, [Holley E. Lynch](https://www.stetson.edu/other/faculty/holley-lynch.php), Shirley X. Yancey, Laura Dempsey, and [Lance A. Davidson](http://mechmorpho.org/), Using a continuum model to decipher the mechanics of embryonic tissue spreading from time-lapse image sequences: An approximate Bayesian computation approach, under review in *PLOS ONE*, bioRxiv:[460774](https://doi.org/10.1101/460774).

and is based off of code developed for the work described in the following papers:
>Julia C. Arciero, Qi Mi, Maria F. Branca, David J. Hackam, David Swigon, Continuum model of collective cell migration in wound healing and colony expansion, *Biophysical Journal*, 100 (2011), 535-543, DOI:[10.1016/j.bpj.2010.11.083](https://doi.org/10.1016/j.bpj.2010.11.0834).

>E. Javierre, C. Vuik, F.J. Vermolen, and A. Segal, A level set method for three dimensional vector Stefan problems: Dissolution of stoichiometric particles in multi-component alloys, *J. Comput. Phys.* 224 (2007), 222-240, DOI: [10.1016/j.jcp.2007.01.038](https://doi.org/10.1016/j.jcp.2007.01.038)

>S. Chen, B. Merriman, S. Osher, and P. Smereka, A simple level set method for solving Stefan problems, *J. Comp. Phys.* 135 (1997), 8-29, DOI: [10.1006/jcph.1997.5721](https://doi.org/10.1006/jcph.1997.5721)

>S. Osher, and J.A. Sethian. Fronts propagating with curvature-dependent speed: algorithms based on Hamilton-Jacobi formulations. *J. Comput. Phys.* 79 (1988), 12-49, DOI: [10.1016/0021-9991(88)90002-2](https://doi.org/10.1016/0021-9991(88)90002-2)

## Necessary Items

*Images:* The raw experimental time-lapse images of *Xenopus laevis* embryonic tissue migration and their corresponding MATLAB-processed files can be downloaded from Dryad via the following DOI: [10.5061/dryad.8pj52vk](https://doi.org/10.5061/dryad.8pj52vk)

The MATLAB processed files should be placed in a root-level folder titled 'experimental_data' for all of the code to run.

*Applications:* The code in this package is developed for [MATLAB](https://www.mathworks.com/products/matlab.html). Furthermore, the following MATLAB packages were also used:
+ [GWMCMC](https://github.com/grinsted/gwmcmc)
+ [imagescnan](https://www.mathworks.com/matlabcentral/fileexchange/20516-imagescnan-m-v2-1-aug-2009)
+ [Perceptually improved colormaps (pmkmp)](https://www.mathworks.com/matlabcentral/fileexchange/28982-perceptually-improved-colormaps)
+ [Subaxis - Subplot](https://www.mathworks.com/matlabcentral/fileexchange/3696-subaxis-subplot)

## Description of Folders

+ [emcee_mymod](emcee_mymod): My modification of the [GWMCMC](https://github.com/grinsted/gwmcmc) routine to obtain a posterior distribution of parameter estimates to match the simulations to experimental data
+ [forward_problem](forward_problem): Code to run the forward problem, in other words, to simuate tissue explant migration
+ [inverse_problem](inverse_problem): Code to run parameter estimation
+ [mylib](mylib): Auxiliary files for the numerical method
+ [mylib_par](mylib_par): Auxiliary files for the numerical method where parfor loops are used
+ [post-processing-plot-making](post-processing-plot-making): Code to create figures and movies
+ [results](results): Contains MATLAB data files containing the posterior distribution parameter estimates and code for related figures, as well as code for statistical analysis

## Licensing
Copyright 2012-2019 [Tracy Stepien](http://github.com/tstepien/).  This is free software made available under the MIT License. For details see the LICENSE file.
