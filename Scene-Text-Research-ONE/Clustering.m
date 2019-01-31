function [class_array] = Clustering(data_array,no_of_clusters)

  class_array = kmeans(data_array,no_of_clusters);

end