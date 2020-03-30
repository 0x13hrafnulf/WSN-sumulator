function [labels, centroids] = get_spectral_result(input_matrix, n)
    
    %dist_temp = pdist(input_matrix(:,1:2));
    %dist = squareform(dist_temp);
    %S = exp(-dist.^2);  
    tic 
    labels = spectralcluster(input_matrix(:,1:2),n);
    %labels = spectralcluster(S,n,'Distance','precomputed','LaplacianNormalization','symmetric');
    %labels = spectralcluster(input_matrix(:,1:2),n,'NumNeighbors',size(input_matrix,1),'LaplacianNormalization','symmetric');
    %labels = spectralcluster(input_matrix(:,1:2),n,'SimilarityGraph','epsilon','Radius',2);
    toc
    distances = zeros(n,1);
    centroids = zeros(n,2);
    for i = 1:n
        centroids(i,1) = mean(input_matrix(labels == i,1)); 
        centroids(i,2) = mean(input_matrix(labels == i,2)); 
    end
    disp(input_matrix);
    disp(labels);
    disp(centroids);
    %%required for drawing circles in simulator
    for i = 1:n
        temp = pdist2(centroids(i,1:2), input_matrix(labels == i,1:2));
        distances(i) = max(temp);
    end
    centroids = [centroids, distances];
     
end