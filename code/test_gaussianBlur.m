function test_gaussianBlur
%TEST_GAUSSIANBLUR Unit test for the gaussianBlur function.
%   Verifies that the Gaussian blur function produces output of the correct
%   size and effectively blurs an impulse signal.

%   Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>
%
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

  printf('Testing gaussianBlur...\n');
  if is_octave
    pkg load image;
  end
  
  % Test 1: Identity for very small sigma (effectively)
  I = rand(10, 10);
  GI = gaussianBlur(I, 0.1);
  assert(size(GI) == size(I));
  
  % Test 2: Blur an impulse
  I = zeros(11, 11);
  I(6, 6) = 1;
  GI = gaussianBlur(I, 1);
  assert(GI(6, 6) > 0);
  assert(GI(6, 6) < 1);
  assert(abs(sum(GI(:)) - 1) < 0.01); % Sum should be roughly 1
  
  printf('gaussianBlur tests passed!\n');
endfunction
