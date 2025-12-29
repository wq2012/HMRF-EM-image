function run_all_tests
  try
    test_ind2ij;
    test_gaussianBlur;
    test_image_kmeans;
    test_MRF_MAP;
    test_HMRF_EM;
    printf('All tests passed successfully!\n');
    exit(0);
  catch err
    printf('Test failed: %s\n', err.message);
    exit(1);
  end_try_catch
endfunction
