%calculate parking cost using data in simulation_all

cost_parking_fuel=zeros(num_all_IDs,5);%1. ID,  2. parking cost, 3. round-trip fuel cost of AV 4. choice (0 parking, 1 AV), 5. lost parking fee 

%cost fee from TPA master plan 2011
max_per_day_short = 20;
max_per_day_long = 16;
max_per_day_econ = 9;

fee_per_20min_short = 2;
fee_per_20min_long=2;
fee_per_20min_econ=1;

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
            cost_parking_fuel(i,2) = (fee_days+fee_hours)/(time/24);
        end   
        
        if simulation_all(i,4)==3 && time > 1 % long term
            fee_days = days*max_per_day_long;
            num_20mins = ceil(hours*3);
            fee_hours = num_20mins*fee_per_20min_long;
            if  fee_hours > max_per_day_long
                fee_hours = max_per_day_long;
            end
            cost_parking_fuel(i,2) = (fee_days+fee_hours)/(time/24);
        end
        
        if simulation_all(i,4)==4                      % economic parking
            fee_days = days*max_per_day_econ;
            num_20mins = ceil(hours*3);
            fee_hours = num_20mins*fee_per_20min_econ;
            if  fee_hours > max_per_day_econ
                fee_hours = max_per_day_econ;
            end
            cost_parking_fuel(i,2) = (fee_days+fee_hours)/(time/24);
        end
    end
end

%calculating round-trip cost
for i=1:num_all_IDs
    distance_cal = simulation_all(i,6);
    fuel_per_gallon = 2.8;
    MPG = 20;
    gallon_per_meter = 1/MPG/1609.34;
    cost_parking_fuel(i,3) = distance_cal*fuel_per_gallon*gallon_per_meter*2;
end

%choice (0 parking, 1 AV)
count_AV = 0;
count_parking = [0;0;0;0];
for i=1:num_all_IDs
    if cost_parking_fuel(i,2) > 0
        if simulation_all(i,3)==1 && simulation_all(i,7)==1 && (cost_parking_fuel(i,2)>=cost_parking_fuel(i,3))
            cost_parking_fuel(i,4) = 1;
            cost_parking_fuel(i,5) = cost_parking_fuel(i,2); % parking lost
            count_AV = count_AV + 1;
        else
            cost_parking_fuel(i,4) = 0;
            cost_parking_fuel(i,5) = 0; % no parking lost
            count_parking(simulation_all(i,4)) = count_parking(simulation_all(i,4)) + 1;
        end
    end
end
parking_fee_lost = sum(cost_parking_fuel(:,5));
parking_revenue = sum(cost_parking_fuel(:,2)) - parking_fee_lost;
% fprintf('%d people will choose AV\n', count_AV);
% fprintf('%d people will choose private parking\n', count_parking);
% fprintf('%f percent of people will choose AV\n', count_AV/(count_AV+count_parking));
% fprintf('The airport will lose %f incomes from parking due to AV\n', parking_fee_lost);



