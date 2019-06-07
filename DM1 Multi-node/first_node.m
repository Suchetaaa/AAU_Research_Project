num_users = 10; 
num_events = 1000;
num_events_considered = 0.4*num_users*num_events;

offset_start = (1-0).*rand(num_users, 1) + 0;
arrival_periods = (4-1).*rand(num_users, 1) + 1;
num_events_matrix = 1:num_events;

arrival_timestamps_unsorted =  offset_start + arrival_periods*num_events_matrix ;

arrival_timestamps = sort(arrival_timestamps_unsorted(:));
arrival_timestamps = arrival_timestamps(1:num_events_considered);
offset = min(arrival_timestamps);






