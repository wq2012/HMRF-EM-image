function test_image_kmeans
  printf('Testing image_kmeans...\n');
  pkg load statistics;
  
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
