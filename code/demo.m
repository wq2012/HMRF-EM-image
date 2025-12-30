%% HMRF-EM-image Toolbox Demo
% This script demonstrates the usage of the HMRF-EM-image toolbox for
% 2D image segmentation with edge-prior preservation.
%
%   Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>
%
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

clear; clc; close all;

% --- Setup ---
fprintf('Setting up...\n');
if is_octave
    pkg load image;
    pkg load statistics;
end
% Compile MEX files if they don't exist
if exist('BoundMirrorExpand', 'file') ~= 3
    mex BoundMirrorExpand.cpp;
end
if exist('BoundMirrorShrink', 'file') ~= 3
    mex BoundMirrorShrink.cpp;
end

% --- Load and Pre-process Image ---
fprintf('Loading image...\n');
I = imread('Beijing World Park 8.JPG');
Y = rgb2gray(I);

% Generate edge map for boundary preservation
fprintf('Generating edge map...\n');
Z = edge(Y, 'canny', 0.75);
imwrite(uint8(Z * 255), 'edge.png');

% Apply Gaussian blur to reduce noise influence
Y = double(Y);
Y = gaussianBlur(Y, 3);
imwrite(uint8(Y), 'blurred_image.png');

% --- Configuration ---
k = 2;             % Number of clusters
max_em_iters = 10; % Max EM iterations
max_map_iters = 10;% Max MAP iterations per EM step

% --- Initialization ---
fprintf('Performing initial k-means segmentation...\n');
tic;
[X, mu, sigma] = image_kmeans(Y, k);
imwrite(uint8(X * (255 / k)), 'initial_labels.png');

% --- HMRF-EM Refinement ---
fprintf('Running HMRF-EM algorithm...\n');
[X_final, mu_final, sigma_final] = HMRF_EM(X, Y, Z, mu, sigma, k, max_em_iters, max_map_iters);

fprintf('Final parameters:\n');
for i = 1:k
    fprintf('  Cluster %d: mu = %.2f, sigma = %.2f\n', i, mu_final(i), sigma_final(i));
end

imwrite(uint8(X_final * (255 / k)), 'final_labels.png');
toc;

fprintf('Demo completed. Check initial_labels.png and final_labels.png.\n');