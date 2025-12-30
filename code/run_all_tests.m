function run_all_tests
%RUN_ALL_TESTS Execute all unit tests for the HMRF-EM-image library.
%   RUN_ALL_TESTS runs the test suite and exits with status 0 on success 
%   or 1 on failure.

%   Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>
%
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

  if is_octave
    pkg load image;
    pkg load statistics;
  end
  try
    test_ind2ij;
    test_gaussianBlur;
    test_image_kmeans;
    test_MRF_MAP;
    test_HMRF_EM;
    printf('All tests passed successfully!\n');
    if is_octave
        exit(0);
    end
  catch err
    printf('Test failed: %s\n', err.message);
    if is_octave
        exit(1);
    end
  end_try_catch
endfunction
