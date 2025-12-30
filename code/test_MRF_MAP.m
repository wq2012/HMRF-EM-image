function test_MRF_MAP
%TEST_MRF_MAP Unit test for the MRF_MAP function.
%   Verifies that the MAP estimation produces labels within the valid range
%   and that the energy minimization output is consistent.

%   Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>
%
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

  printf('Testing MRF_MAP...\n');
  
  % Create a small test case
  m = 10; n = 10;
  Y = [zeros(m, n/2), ones(m, n/2)];
  X = ones(m, n); % Initial labels (all 1)
  Z = zeros(m, n); % No constraints
  mu = [0; 1];
  sigma = [0.1; 0.1];
  k = 2;
  MAP_iter = 10;
  
  [X_new, sum_U] = MRF_MAP(X, Y, Z, mu, sigma, k, MAP_iter, 0);
  
  % Verify output sizes
  assert(all(size(X_new) == [m, n]));
  
  % Verify labels are in [1, k]
  assert(all(X_new(:) >= 1 & X_new(:) <= k));
  
  % For this simple case, it should recover the two halves
  % One half should be mostly 1, the other mostly 2 (or vice versa depending on mu)
  % Given mu = [0; 1], Y=0 should favor label 1, Y=1 should favor label 2
  assert(mean(X_new(:, 1:n/2)(:)) == 1);
  assert(mean(X_new(:, n/2+1:end)(:)) == 2);
  
  printf('MRF_MAP tests passed!\n');
endfunction
