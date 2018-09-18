function revenue = revenue_private_car_at_airport(simulation_row)
% @brief revenue from private car parking
% @param[input]  1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode 7: parking time 8: distance 9: AV 10: revenue
% @param[output] revenue

%cost fee from SFO
max_per_day_short = 36; % max fee per day for short term parking 2014 22
max_per_day_long = 25;  % max fee per day for long term parking       18
max_per_day_econ = 20;   % max fee per day for econ parking            10

fee_per_20min_short = 2/15*20; % 2011 1fee per every 20 min 2014  2
fee_per_20min_long= 2/15*20;    %      1                           2
fee_per_20min_econ=0;    %      1                           1


assert(simulation_row(2)==1 && simulation_row(4)==1 && simulation_row(5)==1); % must be resident and private car

%calculating parking cost
time_min = simulation_row(7)/60; 
days = floor(time_min/24);
hours = mod(time_min, 24);
parking_fee = 0;
if  simulation_row(9)==0 % if not AV
    if (simulation_row(6)==1||simulation_row(6)==2) && time_min>0 %short term and not AV
        fee_days = days*max_per_day_short;
        num_20mins = ceil(hours*24*3);  %hours*3
        fee_hours = num_20mins*fee_per_20min_short;
        if  fee_hours > max_per_day_short
            fee_hours = max_per_day_short;
        end
        parking_fee = fee_days+fee_hours;
    end   

    if simulation_row(6)==3 && time_min > 0%long term and not AV
        fee_days = days*max_per_day_long;
        num_20mins = ceil(hours*24*3);    %hours*3
        fee_hours = num_20mins*fee_per_20min_long;
        if  fee_hours > max_per_day_long
            fee_hours = max_per_day_long;
        end
        parking_fee = fee_days+fee_hours;
    end

    if simulation_row(6)==4 %economic parking and not AV
        fee_days = days*max_per_day_econ;
        num_20mins = ceil(hours*24*3);    %hours*3
        fee_hours = num_20mins*fee_per_20min_econ;
        if  fee_hours > max_per_day_econ
            fee_hours = max_per_day_econ;
        end
        parking_fee = fee_days+fee_hours;
    end
end

revenue = parking_fee;

