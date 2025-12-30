function [X, mu, sigma] = HMRF_EM(X, Y, Z, mu, sigma, k, EM_iter, MAP_iter)
%HMRF_EM Expectation-Maximization algorithm for Hidden Markov Random Field.
%   [X, MU, SIGMA] = HMRF_EM(X, Y, Z, MU, SIGMA, K, EM_ITER, MAP_ITER)
%   performs image segmentation by iteratively updating labels using MAP 
%   estimation and updating parameters using the EM framework.
%
%   Input:
%     X        - Initial 2D label image
%     Y        - Input 2D image (double)
%     Z        - 2D edge constraint map (0: no edge, 1: edge)
%     mu       - Initial vector of cluster means
%     sigma    - Initial vector of cluster standard deviations
%     k        - Number of clusters
%     EM_iter  - Maximum number of EM iterations
%     MAP_iter - Maximum number of MAP iterations per EM step
%
%   Output:
%     X        - Final 2D label image
%     mu       - Final estimated cluster means
%     sigma    - Final estimated cluster standard deviations
%
%   See also: MRF_MAP, IMAGE_KMEANS

%   Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>
%
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

[m, n] = size(Y);
y = Y(:);
P_lyi = zeros(k, m * n);
sum_U = zeros(1, EM_iter);

for it = 1:EM_iter
    fprintf('EM Iteration: %d\n', it);
    
    % --- E-Step ---
    % Update labels using MAP estimation
    [X, sum_U(it)] = MRF_MAP(X, Y, Z, mu, sigma, k, MAP_iter, 0);
    
    % Calculate posterior probability P(l|y, neighbors)
    for l = 1:k
        % Likelihood part: P(y|l)
        likelihood = 1 / sqrt(2 * pi * sigma(l)^2) * exp(-(y - mu(l)).^2 / (2 * sigma(l)^2));
        
        % Prior part from neighbors (vectorized)
        X_diff = (X ~= l) / 2;
        no_edge = (Z == 0);
        u = zeros(m, n);
        u(2:end, :) = u(2:end, :) + X_diff(1:end-1, :) .* no_edge(1:end-1, :);
        u(1:end-1, :) = u(1:end-1, :) + X_diff(2:end, :) .* no_edge(2:end, :);
        u(:, 2:end) = u(:, 2:end) + X_diff(:, 1:end-1) .* no_edge(:, 1:end-1);
        u(:, 1:end-1) = u(:, 1:end-1) + X_diff(:, 2:end) .* no_edge(:, 2:end);
        
        prior_energy = u(:);
        P_lyi(l, :) = (likelihood .* exp(-prior_energy))';
    end
    
    % Normalize posteriors
    sum_P = sum(P_lyi, 1);
    P_lyi = bsxfun(@rdivide, P_lyi, sum_P);
    
    % --- M-Step ---
    % Update means and standard deviations
    for l = 1:k
        W = P_lyi(l, :);
        mu(l) = (W * y) / sum(W);
        sigma(l) = sqrt((W * (y - mu(l)).^2) / sum(W));
    end
    
    % Convergence check
    if it >= 3 && std(sum_U(it-2:it)) / sum_U(it) < 0.0001
        break;
    end
end

% Plot energy convergence
figure;
plot(1:it, sum_U(1:it), 'b-o', 'LineWidth', 2);
title('EM Algorithm Energy Convergence');
xlabel('EM Iteration');
ylabel('Total Energy (U)');
grid on;
drawnow;