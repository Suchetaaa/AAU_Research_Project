function [arrival_timestamps_all, departure_timestamps_out, ground_indices, largest_time_out] = other_node(departure_timestamps, num_users, lambda_users, mu_node, epsilon_node, largest_time)
%     num_users = 10;
%     lambda_users = abs(randn(1, num_users));
%     mu_node = 1;
%     epsilon_node = 0.6;
    done = 0;
    j = 0;

    while done == 0
        j = j+1
        event_times_users = zeros(num_users, j);
        for i = 1:num_users
            inter_event_times(i, j) = 1/lambda_users(1, i)*log(1./rand(1,1));
            event_times_users(i, :) = cumsum(inter_event_times(i, :));
        end
        
        if (min(event_times_users(:, j)) > largest_time)
            done = 1;
        end
%         event_times_users;
    end
    
    arrival_timestamps_all = sort(event_times_users(:));
    arrival_timestamps_all = arrival_timestamps_all';
    new = [departure_timestamps arrival_timestamps_all];
    arrival_timestamps_all = sort(new(:));
    
    a = arrival_timestamps_all <= largest_time;
    num_useful = numel(a(a>0));
    arrival_timestamps_all = arrival_timestamps_all(1:num_useful, 1)';
    
    [~, m] = size(departure_timestamps);
    ground_indices = zeros(1, m);
    
    for k = 1 : m
        ground_indices(1, k) = find(arrival_timestamps_all == departure_timestamps(1, k));
    end
     
    server_timestamps = zeros(1, num_useful);
    departure_timestamps_out = zeros(1, num_useful);
    
    inter_service_times = 1/mu_node*log(1./rand(1,num_useful));
    
    server_timestamps(1) = 0;
    departure_timestamps_out(1) = server_timestamps(1) + inter_service_times(1);
    
    for i = 2:num_useful
        if arrival_timestamps_all(i) < departure_timestamps_out(i-1)
            server_timestamps(i) = departure_timestamps_out(i-1);
        else
            server_timestamps(i) = arrival_timestamps_all(i);
        end   
       departure_timestamps_out(i) = server_timestamps(i) + inter_service_times(i);   
    end
    
    random_indices = randperm(num_useful, round((1-epsilon_node)*num_useful));
    departure_timestamps_out(random_indices) = [];
   
    l = 0;
    for k = 1 : m
        
%         ground_indices(1, k)
        a = find(random_indices == ground_indices(1, k)); 
        if (a ~= 0)
            l = l + 1;
            unwanted_indices(1, l) = k;
        end
    end
    
    ground_indices(unwanted_indices) = [];
    
    largest_time_out = max(departure_timestamps_out); 
end
    