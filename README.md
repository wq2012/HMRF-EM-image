# HMRF-EM-image [![MATLAB](https://img.shields.io/badge/Language-MATLAB-blue.svg)](https://www.mathworks.com/products/matlab.html) [![arxiv](https://img.shields.io/badge/PDF-arXiv-yellow.svg)](https://arxiv.org/pdf/1207.3510.pdf)

## Overview

In this project, we study the hidden Markov random field (HMRF) model and its expectation-maximization (EM) algorithm. We implement a MATLAB toolbox named `HMRF-EM-image` for 2D image segmentation using the HMRF-EM framework. This toolbox also implements edge-prior-preserving image segmentation, and can be easily reconfigured for other problems, such as [3D image segmentation](https://github.com/wq2012/GMM-HMRF).

Document: https://arxiv.org/pdf/1207.3510.pdf

This library is also available at:
* https://www.mathworks.com/matlabcentral/fileexchange/37530-hmrf-em-image

![pic](resources/HMRF_EM.png)

## Citations

If you use this library, please cite:

```
@article{wang2012hmrf,
  title={HMRF-EM-image: implementation of the hidden markov random field model and its expectation-maximization algorithm},
  author={Wang, Quan},
  journal={arXiv preprint arXiv:1207.3510},
  year={2012}
}
```