function [labels, centroids] = get_gmm_result(input_matrix, n) 
    
    options = statset('Display','final', 'MaxIter', 200); 
    
    tic
    gm = fitgmdist(input_matrix(:,1:2), n,'Options',options,'CovarianceType','diagonal','SharedCovariance', true);
    labels = cluster(gm,input_matrix(:,1:2));
    toc
    distances = zeros(n,1);
    centroids = zeros(n,2);
    for i = 1:n
        centroids(i,1) = mean(input_matrix(labels == i,1)); 
        centroids(i,2) = mean(input_matrix(labels == i,2)); 
    end
    disp(labels);
    disp(centroids);
    %%required for drawing circles in simulator
    for i = 1:n
        temp = pdist2(centroids(i,1:2), input_matrix(labels == i,1:2));
        distances(i) = max(temp);
    end
    centroids = [centroids, distances];
end