function [labels, centroids] =  get_hierarchical_result(input_matrix, n)
    
    tic
    labels = clusterdata(input_matrix(:,1:2), 'Linkage', 'centroid', 'MaxClust', n);
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
