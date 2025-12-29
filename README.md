# HMRF-EM-image

[![View HMRF-EM-image on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/37530-hmrf-em-image)
[![arxiv](https://img.shields.io/badge/PDF-arXiv-yellow.svg)](https://arxiv.org/pdf/1207.3510.pdf)
[![Octave application](https://github.com/wq2012/HMRF-EM-image/actions/workflows/octave.yml/badge.svg)](https://github.com/wq2012/HMRF-EM-image/actions/workflows/octave.yml)

## Overview

`HMRF-EM-image` is a MATLAB/Octave toolbox for 2D image segmentation using the **Hidden Markov Random Field (HMRF)** model and its **Expectation-Maximization (EM)** algorithm. This framework is particularly effective for segmenting images corrupted by noise or with spatial dependencies between pixels.

This toolbox also implements **edge-prior-preserving** image segmentation, which uses the edge information (e.g., from a Canny edge detector) to constrain the spatial context, preventing over-smoothing across boundaries.

![pic](resources/HMRF_EM.png)

## Key Features

- **HMRF Model**: Captures spatial dependencies between neighboring pixels using a Markov Random Field.
- **EM Algorithm**: Automatically estimates the parameters (means and standard deviations) of the image classes.
- **MAP Estimation**: Uses Maximum A Posteriori estimation for label assignment.
- **Edge-Prior Preservation**: Incorporates edge information to protect boundaries during segmentation.
- **Octave Compatible**: Fully functional in both MATLAB and GNU Octave.

---

## Getting Started

### Prerequisites

- **MATLAB** or **GNU Octave**
- **Image Processing Toolbox/Package**: Required for `fspecial`, `imfilter`, and `edge` functions.
- **Statistics and Machine Learning Toolbox/Package**: Required for `kmeans` and `std`.

In Octave, you can load these packages using:
```matlab
pkg load image;
pkg load statistics;
```

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/wq2012/HMRF-EM-image.git
   cd HMRF-EM-image/code
   ```
2. Compile the MEX files (required for boundary handling):
   ```matlab
   mex BoundMirrorExpand.cpp;
   mex BoundMirrorShrink.cpp;
   ```

---

## Usage Example

The following example (from `demo.m`) shows how to perform segmentation on a gray-scale image.

```matlab
% Load image and convert to grayscale
I = imread('Beijing World Park 8.JPG');
Y = rgb2gray(I);

% Generate edge map (for edge-prior preservation)
Z = edge(Y, 'canny', 0.75);

% Pre-process: Gaussian blur
Y = double(Y);
Y = gaussianBlur(Y, 3);

% Parameters
k = 2; % Number of labels
EM_iter = 10; % Max EM iterations
MAP_iter = 10; % Max MAP iterations per EM step

% Step 1: Initial segmentation using k-means
[X, mu, sigma] = image_kmeans(Y, k);

% Step 2: HMRF-EM algorithm
[X_final, mu_final, sigma_final] = HMRF_EM(X, Y, Z, mu, sigma, k, EM_iter, MAP_iter);

% Display or save result
imshow(uint8(X_final * (255/k)));
```

---

## Algorithm Explanation

### 1. Hidden Markov Random Field (HMRF)
The HMRF model assumes that the "true" labels of the pixels (hidden) follow a Markov Random Field, where the label of a pixel depends on the labels of its neighbors. The observed pixel intensities are then realizations from a distribution (usually Gaussian) conditioned on these hidden labels.

### 2. Expectation-Maximization (EM)
Since the true labels are hidden, we use the EM algorithm to iteratively estimate the model parameters ($\mu$ and $\sigma$ for each class).
- **E-Step**: Estimate the posterior distribution of the labels given the current parameters.
- **M-Step**: Update the parameters to maximize the expected log-likelihood.

### 3. Maximum A Posteriori (MAP)
In each EM iteration, the MAP estimation finds the label configuration $X$ that maximizes the posterior probability $P(X|Y, \theta)$. This is equivalent to minimizing an energy function defined by the MRF potential.

---

## Function Reference

### `HMRF_EM(X, Y, Z, mu, sigma, k, EM_iter, MAP_iter)`
Performs the core EM algorithm.
- **Inputs**:
    - `X`: Initial 2D label image.
    - `Y`: Input grayscale image (double).
    - `Z`: 2D edge constraint map (0 for no edge, 1 for edge).
    - `mu`, `sigma`: Initial guess for Gaussian parameters.
    - `k`: Number of classes.
- **Outputs**:
    - `X`: Final segment labels.
    - `mu`, `sigma`: Final estimated Gaussian parameters.

### `MRF_MAP(X, Y, Z, mu, sigma, k, MAP_iter, show_plot)`
Performs Maximum A Posteriori estimation of labels.

### `image_kmeans(Y, k)`
Provides an initial clustering using standard k-means for the EM algorithm.

---

## Unit Tests

A suite of unit tests is included to verify the library's functionality. To run the tests:

```matlab
cd code
run_all_tests
```

This will run tests for `ind2ij`, `gaussianBlur`, `image_kmeans`, `MRF_MAP`, and `HMRF_EM`.

---

## Citations

If you use this library in your research, please cite the following paper:

```
@article{wang2012hmrf,
  title={HMRF-EM-image: implementation of the hidden markov random field model and its expectation-maximization algorithm},
  author={Wang, Quan},
  journal={arXiv preprint arXiv:1207.3510},
  year={2012}
}
```

Full document available at [arXiv:1207.3510](https://arxiv.org/pdf/1207.3510.pdf).