function [out_timestamps, mean_time] = single_queue(num_users, num_events, mu, lambda_users, event_times_s, epsilon_node)
    %Takes in lambdas (from users and satellite) and mu (servicing times)
    % num_users = 10;
    % num_events = 100;
    %Arrival rates
    % mu = 1;
    % epsilon_node = 0.2;
    % lambda_node = 1;
    % lambda_users = rand(num_users, 1);
    % 
    % %Servicing rate
    % mu_node = 2;

    % inter_event_times_s = poissrnd(lambda_node, num_events, 1);
    % event_times_s = cumsum(inter_event_times_s)';

    event_times_u = zeros(num_users, num_events);

    for i = 1:num_users
        inter_event_times_u = poissrnd(lambda_users(1, i), num_events, 1);
        event_times_u(i, :) = cumsum(inter_event_times_u)';
    end

    %Sort all the events in increasing order of timestamps
    event_times_all = zeros(num_users+1, num_events);
    event_times_all(1:num_users, :) = event_times_u;
    event_times_all(num_users+1, :) = event_times_s;

    arrival_timestamps_all = sort(event_times_all(:));

    %Service times according to exponential distribution
    service_time = exprnd(1/mu, (num_users + 1)*num_events);

    %Server and Departyre timestamps
    server_timestamp = zeros((num_users + 1)*num_events, 1);
    departure_timestamp = zeros((num_users + 1)*num_events, 1);

    server_timestamp(1) = 0;
    departure_timestamp(1) = server_timestamp(1) + service_time(1);

    for i = 2:(num_users+1)*num_events
        if arrival_timestamps_all(i) < departure_timestamp(i-1)
            server_timestamp(i) = departure_timestamp(i-1);
        else
            server_timestamp(i) = arrival_timestamps_all(i);
        end
        departure_timestamp(i) = server_timestamp(i) + service_time(i);
    end

    mean_time = mean(departure_timestamp - arrival_timestamps_all);
%     round(epsilon_node*(num_users+1)*num_events);

    random_indices = randperm((num_users+1)*num_events, round(epsilon_node*(num_users+1)*num_events));
    departure_timestamp(random_indices) = [];
    size(departure_timestamp)
    out_timestamps = departure_timestamp(1:num_events);
    
end

