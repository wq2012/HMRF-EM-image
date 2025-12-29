function GI = gaussianBlur(I, s)
%GAUSSIANBLUR Perform Gaussian blur on an image.
%   GI = GAUSSIANBLUR(I, S) applies a Gaussian low-pass filter to image I 
%   with standard deviation S.
%
%   Input:
%     I  - Input image (2D matrix)
%     s  - Standard deviation (sigma) of the Gaussian kernel
%
%   Output:
%     GI - Blurred image
%
%   Example:
%     I = imread('image.png');
%     GI = gaussianBlur(double(I), 2);
%
%   See also: FSPECIAL, IMFILTER

% Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>

% Kernel size usually 3*sigma on each side
h_size = ceil(s) * 3 + 1;
h = fspecial('gaussian', h_size, s);

% Apply filter with replication padding to handle boundaries
GI = imfilter(I, h, 'replicate');
