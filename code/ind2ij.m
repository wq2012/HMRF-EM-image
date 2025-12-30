function [i, j] = ind2ij(ind, m)
%IND2IJ Convert linear index to 2D image coordinates.
%   [I, J] = IND2IJ(IND, M) converts the linear index IND to row coordinate I
%   and column coordinate J for an image with height M.
%
%   Input:
%     ind - Linear index (1-based)
%     m   - Height (number of rows) of the image
%
%   Output:
%     i   - Row coordinate
%     j   - Column coordinate
%
%   Example:
%     [i, j] = ind2ij(4, 3); % Result: i=1, j=2
%
%   See also: IND2SUB

%   Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>
%
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

i = mod(ind - 1, m) + 1;
j = floor((ind - 1) / m) + 1;