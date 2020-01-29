function [labels, centroids] = get_k_means_result(input_matrix, n)
    
    tic
    [labels, centroids] = kmeans(input_matrix(:,1:2), n);
    toc
    distances = zeros(n,1);
    %%required for drawing circles in simulator
    for i = 1:n
        temp = pdist2(centroids(i,1:2), input_matrix(labels == i,1:2));
        distances(i) = max(temp);
    end
    centroids = [centroids, distances];
end