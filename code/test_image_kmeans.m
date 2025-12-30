function test_image_kmeans
%TEST_IMAGE_KMEANS Unit test for the image_kmeans function.
%   Verifies that the initial k-means initialization separates distinct 
%   intensities correctly and returns parameters of optimal size.

%   Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>
%
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

  printf('Testing image_kmeans...\n');
  if is_octave
    pkg load statistics;
  end
  
  % Create a simple image with two distinct intensities
  Y = [zeros(10, 10), ones(10, 10)];
  k = 2;
  
  [X, mu, sigma] = image_kmeans(Y, k);
  
  % Verify output sizes
  assert(all(size(X) == size(Y)));
  assert(length(mu) == k);
  assert(length(sigma) == k);
  
  % Verify that it separated the intensities
  % (Either mu(1) ~ 0 and mu(2) ~ 1 or vice versa)
  assert((abs(mu(1)) < 0.1 && abs(mu(2) - 1) < 0.1) || ...
         (abs(mu(2)) < 0.1 && abs(mu(1) - 1) < 0.1));
  
  printf('image_kmeans tests passed!\n');
endfunction
