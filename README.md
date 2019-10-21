## README (impulse-2-lti)

[![GitHub release](https://img.shields.io/github/release/danielrherber/impulse-2-lti.svg)](https://github.com/danielrherber/impulse-2-lti/releases/latest)
[![license](https://img.shields.io/github/license/danielrherber/impulse-2-lti.svg)](https://github.com/danielrherber/impulse-2-lti/blob/master/License)

[![](https://img.shields.io/badge/language-matlab-EF963C.svg)](https://www.mathworks.com/products/matlab.html)
[![](https://img.shields.io/github/issues-raw/danielrherber/impulse-2-lti.svg)](https://github.com/danielrherber/impulse-2-lti/issues)
[![GitHub contributors](https://img.shields.io/github/contributors/danielrherber/impulse-2-lti.svg)](https://github.com/danielrherber/impulse-2-lti/graphs/contributors)
[![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.svg)](https://gitter.im/impulse-2-lti/community)

This project is concerned with finding the linear time-invariant state-space (LTISS) system that best approximates a given impulse response function (IRF). Please see this [link](http://systemdesign.illinois.edu/publications/Herber209c.pdf) for a description of the theory and methods used.

![readme_image.svg](optional/readme_image.svg)

---
### Install
* Download [impulse2LTI](https://github.com/danielrherber/impulse-2-lti/archive/master.zip)
* Run [INSTALL_impulse2LTI.m](INSTALL_impulse2LTI.m) to automatically add the project files to your MATLAB path, download the required files, and open some examples
```matlab
INSTALL_impulse2LTI
```
* See [impulse2LTI_opts.m](src/impulse2LTI_opts.m) for the function options
```matlab
open impulse2LTI_opts
```
* See [impulse2LTI_ex_viscoelastic2.m](examples/impulse2LTI_ex_viscoelastic2.m) and [impulse2LTI_ex_steplike.m](examples/impulse2LTI_ex_steplike.m) for some of the examples
```matlab
open impulse2LTI_ex_viscoelastic2
open impulse2LTI_ex_steplike
```

### Citation
Please cite the following if you use this project.

- DR Herber, JT Allison. **Approximating Arbitrary Impulse Response Functions with Prony Basis Functions**. Technical report, Engineering System Design Lab, UIUC-ESDL-2019-01, Urbana, IL, USA, Oct. 2019. [[PDF]](http://systemdesign.illinois.edu/publications/Herber2019c.pdf)
	- *Abstract: In this report, we are concerned with approximating the input-to-output behavior of a type of scalar convolution integral given its so-called impulse response function by constructing an appropriate linear time-invariant state-space model. Such integrals frequently appear in the modeling of hydrodynamic forces, viscoelastic materials, among other applications. First, linear systems theory is reviewed. Next, Prony basis functions, which are exponentially decaying cosine waves with phase delay and variable amplitude, are described as potential objects to be used to approximate a given impulse response function. Then it is shown how a superposition of Prony basis functions can be directly mapped back to an equivalent linear state-space model. Also, it is directly shown that both the Golla-Hughes-McTavish model and Prony series (generalized Maxwell model) are special cases of the considered Prony basis function. Several nonlinear optimization (fitting) problems are then described to determine the value of the model parameters that result in the desired approximation. Finally, a few numerical examples are presented to demonstrate that Prony basis functions can approximation a diverse set of impulse response behaviors.*

### External Includes
See [INSTALL_impulse2LTI.m](INSTALL_impulse2LTI.m) for more information.

- MATLAB File Exchange submission IDs (**40397, 52552**)

- MATLAB toolboxes (some functionality may be possible if some toolboxes are unavailable)
   - [Optimization Toolbox](https://www.mathworks.com/products/optimization.html)
   - [Global Optimization Toolbox](https://www.mathworks.com/products/global-optimization.html)
   - [Parallel Computing Toolbox](https://www.mathworks.com/products/parallel-computing.html)
   - [Image Processing Toolbox](https://www.mathworks.com/products/image.html)

---
### General Information

#### Contributors
- [Daniel R. Herber](https://github.com/danielrherber) (primary)
- [James T. Allison](https://github.com/jamestallison)

#### Project Links
- [https://github.com/danielrherber/impulse-2-lti](https://github.com/danielrherber/impulse-2-lti)
<!-- - [https://www.mathworks.com/matlabcentral/fileexchange/XXXXX](https://www.mathworks.com/matlabcentral/fileexchange/XXXXX) -->

<!-- [[URL]](http://hdl.handle.net/XXXX/XXXXX) -->