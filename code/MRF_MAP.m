function [X, sum_U] = MRF_MAP(X, Y, Z, mu, sigma, k, MAP_iter, show_plot)
%MRF_MAP Maximum A Posteriori (MAP) estimation for Markov Random Field.
%   [X, SUM_U] = MRF_MAP(X, Y, Z, MU, SIGMA, K, MAX_ITER, SHOW_PLOT) updates
%   the label image X using MAP estimation given the observed image Y and
%   current Gaussian parameters MU and SIGMA.
%
%   Input:
%     X         - Initial 2D label image
%     Y         - Input 2D image (double)
%     Z         - 2D edge constraint map (0: no edge, 1: edge)
%     mu        - Vector of cluster means
%     sigma     - Vector of cluster standard deviations
%     k         - Number of clusters
%     MAP_iter  - Maximum number of MAP iterations
%     show_plot - 1 to plot energy, 0 otherwise
%
%   Output:
%     X         - Updated 2D label image
%     sum_U     - Final total energy
%
%   See also: HMRF_EM

%   Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>
%
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

[m, n] = size(Y);
y = Y(:);
U = zeros(m * n, k); % Accumulating energy matrix
sum_U_MAP = zeros(1, MAP_iter);

% Pre-calculate likelihood term to avoid redundant computation inside iterations
% Note: The original code added this term in EVERY iteration to the accumulating U
L = zeros(m * n, k);
for l = 1:k
    yi = y - mu(l);
    L(:, l) = (yi.^2) / (2 * sigma(l)^2) + log(sigma(l));
end

for it = 1:MAP_iter
    fprintf('  Inner iteration: %d\n', it);
    
    % U1 inherits previous total energy and adds current likelihood
    % This matches original: U1 = U; U1(:,l) = U1(:,l) + temp1;
    U1 = U + L;
    
    % Prior energy (U2) is always recalculated from current labels
    % This matches original: U2 = U; U2(ind,l) = u2; (U2 is fully overwritten)
    U2 = zeros(m * n, k);
    no_edge = (Z == 0);
    for l = 1:k
        X_diff = (X ~= l) / 2;
        
        u2 = zeros(m, n);
        % Neighboring penalties (Top, Bottom, Left, Right)
        u2(2:end, :) = u2(2:end, :) + X_diff(1:end-1, :) .* no_edge(1:end-1, :);
        u2(1:end-1, :) = u2(1:end-1, :) + X_diff(2:end, :) .* no_edge(2:end, :);
        u2(:, 2:end) = u2(:, 2:end) + X_diff(:, 1:end-1) .* no_edge(:, 1:end-1);
        u2(:, 1:end-1) = u2(:, 1:end-1) + X_diff(:, 2:end) .* no_edge(:, 2:end);
        
        U2(:, l) = u2(:);
    end
    
    % Update total state U
    U = U1 + U2;
    
    % MAP label assignment (minimizing energy)
    [temp, x] = min(U, [], 2);
    sum_U_MAP(it) = sum(temp(:));
    X = reshape(x, [m, n]);
    
    % Convergence check
    if it >= 3 && std(sum_U_MAP(it-2:it)) / sum_U_MAP(it) < 0.0001
        break;
    end
end

% The final energy is calculated from the final labels using the last state of U
sum_U = 0;
for ind = 1:m*n
    sum_U = sum_U + U(ind, x(ind));
end

if show_plot == 1
    figure;
    plot(1:it, sum_U_MAP(1:it), 'r', 'LineWidth', 2);
    title('Convergence of MAP Energy');
    xlabel('Iteration');
    ylabel('Total Energy (U)');
    grid on;
    drawnow;
end
