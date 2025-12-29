function [X, mu, sigma] = image_kmeans(Y, k)
%IMAGE_KMEANS Initial clustering for image segmentation using k-means.
%   [X, MU, SIGMA] = IMAGE_KMEANS(Y, K) segments the 2D image Y into K
%   clusters and returns the label image X, and the estimated cluster 
%   parameters.
%
%   Input:
%     Y     - Input 2D image
%     k     - Number of clusters
%
%   Output:
%     X     - Label image (same size as Y)
%     mu    - Vector of cluster means
%     sigma - Vector of cluster standard deviations
%
%   Example:
%     [X, mu, sigma] = image_kmeans(Y, 3);
%
%   See also: KMEANS

% Reshape for k-means
y = Y(:);
x = kmeans(y, k);
X = reshape(x, size(Y));

mu = zeros(k, 1);
sigma = zeros(k, 1);

% Estimate initial parameters for each cluster
for i = 1:k
    yy = y(x == i);
    if isempty(yy)
        mu(i) = 0; % Or some sensible default
        sigma(i) = 1;
    else
        mu(i) = mean(yy);
        sigma(i) = std(yy);
    end
end