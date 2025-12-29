function test_gaussianBlur
  printf('Testing gaussianBlur...\n');
  pkg load image;
  
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
