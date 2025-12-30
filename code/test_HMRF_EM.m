function test_HMRF_EM
%TEST_HMRF_EM Unit test for the HMRF_EM function.
%   Verifies that the EM algorithm converges and produces reasonable parameters
%   for a synthetic test case.

%   Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>
%
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

  printf('Testing HMRF_EM...\n');
  
  % Create a small test case
  m = 10; n = 10;
  Y = [zeros(m, n/2), ones(m, n/2)];
  Y = Y + 0.05 * randn(size(Y)); % Add some noise
  
  % Initial clustering
  k = 2;
  [X, mu, sigma] = image_kmeans(Y, k);
  
  Z = zeros(m, n); % No constraints
  EM_iter = 5;
  MAP_iter = 5;
  
  % HMRF_EM opens a figure, so we might want to close it after
  [X_final, mu_final, sigma_final] = HMRF_EM(X, Y, Z, mu, sigma, k, EM_iter, MAP_iter);
  close all;
  
  % Verify output sizes
  assert(all(size(X_final) == [m, n]));
  assert(length(mu_final) == k);
  assert(length(sigma_final) == k);
  
  % Verify parameters have converged to something reasonable
  assert(min(mu_final) < 0.2);
  assert(max(mu_final) > 0.8);
  
  printf('HMRF_EM tests passed!\n');
endfunction
