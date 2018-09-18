function [count_AV, count_parking, parking_fee_lost, parking_revenue] = parking_cost_calculation(simulation_all, num_all_IDs)
%param[in] simulation_all 1: IDs, 2: Zip codes, 3: travel modes 4. parking modes 5. parking time 6.distance 7. private car that has AV or not
%param[in] num_all_IDs:      Number of all IDs
%
%calculate parking cost using data in simulation_all

cost_parking_fuel=zeros(num_all_IDs,6);%1. ID,  2. parking cost, 3. round-trip fuel cost of AV 4. choice (0 parking, 1 AV), 5. lost parking fee per day, 6 parking cost per day

%cost fee from TPA master plan 2011
max_per_day_short = 44; % max fee per day for short term parking 2014 22
max_per_day_long = 36;  % max fee per day for long term parking       18
max_per_day_econ = 20;   % max fee per day for econ parking            10

fee_per_20min_short = 4; % 2011 1fee per every 20 min 2014  2
fee_per_20min_long=4;    %      1                           2
fee_per_20min_econ=2;    %      1                           1

fuel_per_gallon = 2.8;
MPG = 20;
mile_in_meter = 1609.34;

fee_parking = zeros(num_all_IDs,2); %1: parking mode 2: fee
for i =1:num_all_IDs
    %--------------------------------------------------------------------------%
    %calculating parking cost
    cost_parking_fuel(i,1) = simulation_all(i,1);
    time = simulation_all(i,5);
    days = floor(time/24);
    hours = mod(time, 24);
    if simulation_all(i,3)==1  % private car parking
        if (simulation_all(i,4)==1||simulation_all(i,4)==2) && time>1 %short term
            fee_days = days*max_per_day_short;
            num_20mins = ceil(hours*3);
            fee_hours = num_20mins*fee_per_20min_short;
            if  fee_hours > max_per_day_short
                fee_hours = max_per_day_short;
            end
            cost_parking_fuel(i,2) = fee_days+fee_hours;
            if time<=24
                cost_parking_fuel(i,6) = fee_days+fee_hours;
            else
                cost_parking_fuel(i,6) = (fee_days+fee_hours);
            end
            fee_parking(i,1) = simulation_all(i,4);
            fee_parking(i,2) = fee_days+fee_hours;
        end   
        
        if simulation_all(i,4)==3 && time > 1 % long term
            fee_days = days*max_per_day_long;
            num_20mins = ceil(hours*3);
            fee_hours = num_20mins*fee_per_20min_long;
            if  fee_hours > max_per_day_long
                fee_hours = max_per_day_long;
            end
            cost_parking_fuel(i,2) = fee_days+fee_hours;
            if time<=24
                cost_parking_fuel(i,6) = fee_days+fee_hours;
            else
                cost_parking_fuel(i,6) = (fee_days+fee_hours);
            end
            fee_parking(i,1) = simulation_all(i,4);
            fee_parking(i,2) = fee_days+fee_hours;
        end
        
        if simulation_all(i,4)==4                      % economic parking
            fee_days = days*max_per_day_econ;
            num_20mins = ceil(hours*3);
            fee_hours = num_20mins*fee_per_20min_econ;
            if  fee_hours > max_per_day_econ
                fee_hours = max_per_day_econ;
            end
            cost_parking_fuel(i,2) = fee_days+fee_hours;
            if time<=24
                cost_parking_fuel(i,6) = fee_days+fee_hours;
            else
                cost_parking_fuel(i,6) = (fee_days+fee_hours);
            end
            fee_parking(i,1) = simulation_all(i,4);
            fee_parking(i,2) = fee_days+fee_hours;
        end
    end
end
% idx1 = fee_parking(:,1)==1;
% fee1 = sum(fee_parking(idx1, 2));
% idx2 = fee_parking(:,1)==2;
% fee2 = sum(fee_parking(idx2, 2));
% idx3 = fee_parking(:,1)==3;
% fee3 = sum(fee_parking(idx3, 2));
% idx4 = fee_parking(:,1)==4;
% fee4 = sum(fee_parking(idx4, 2));
% fprintf('fee1: %f, fee2 %f, fee3: %f, fee4: %f\n', fee1, fee2, fee3, fee4);

%calculating round-trip cost
for i=1:num_all_IDs
    distance_cal = simulation_all(i,6);
    gallon_per_meter = 1/MPG/mile_in_meter;
    cost_parking_fuel(i,3) = distance_cal*fuel_per_gallon*gallon_per_meter*2;
end

%choice (0 parking, 1 AV)
count_AV = 0;
count_parking = [0;0;0;0];
for i=1:num_all_IDs
    if cost_parking_fuel(i,2) > 0
        if simulation_all(i,3)==1 && simulation_all(i,7)==1 && (cost_parking_fuel(i,2)>=cost_parking_fuel(i,3))
            cost_parking_fuel(i,4) = 1;
            cost_parking_fuel(i,5) = cost_parking_fuel(i,6); % parking lost
            count_AV = count_AV + 1;
        else
            cost_parking_fuel(i,4) = 0;
            cost_parking_fuel(i,5) = 0; % no parking lost
            count_parking(simulation_all(i,4)) = count_parking(simulation_all(i,4)) + 1;
        end
    end
end
parking_fee_lost = sum(cost_parking_fuel(:,5));
parking_revenue = sum(cost_parking_fuel(:,6)) - parking_fee_lost;
% fprintf('%d people will choose AV\n', count_AV);
% fprintf('%d people will choose private parking\n', count_parking);
% fprintf('%f percent of people will choose AV\n', count_AV/(count_AV+count_parking));
% fprintf('The airport will lose %f incomes from parking due to AV\n', parking_fee_lost);



