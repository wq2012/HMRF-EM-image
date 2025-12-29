function test_ind2ij
  printf('Testing ind2ij...\n');
  
  % Test 1: 1x1 image
  [i, j] = ind2ij(1, 1);
  assert(i == 1);
  assert(j == 1);
  
  % Test 2: 2x2 image, index 2 (row 2, col 1)
  [i, j] = ind2ij(2, 2);
  assert(i == 2);
  assert(j == 1);
  
  % Test 3: 2x2 image, index 3 (row 1, col 2)
  [i, j] = ind2ij(3, 2);
  assert(i == 1);
  assert(j == 2);
  
  % Test 4: 2x2 image, index 4 (row 2, col 2)
  [i, j] = ind2ij(4, 2);
  assert(i == 2);
  assert(j == 2);
  
  % Test 5: 3x2 image, index 4 (row 1, col 2)
  [i, j] = ind2ij(4, 3);
  assert(i == 1);
  assert(j == 2);

  printf('ind2ij tests passed!\n');
endfunction
