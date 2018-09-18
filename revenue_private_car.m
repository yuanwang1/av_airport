function revenue = revenue_private_car(simulation_row)
% @brief revenue from private car parking
% @param[input]  1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode 7: parking time 8: distance 9: AV 10: revenue
% @param[output] revenue
%
CURB_PER_TRIP_CHARGE = 0; % current no charge
off_airport_parking_shuttle_per_trip = 3.8; % current $3.8
off_airport_parking_rate = 15/24; %$15 per day average near SFO airport,parking time simulated in minutes
off_airport_concession = 0; % POSSIBLE MODULE

assert(simulation_row(2)==1 && simulation_row(4)==1); % must be resident and private car

revenue = 0;
cost = 0;
cost_fuel = 0;
cost_at_airport = 0;
cost_off_airport = 0;
cost_curbside = 0;
%IF NOT AV
if  simulation_row(9)==0 % if not AV
%---------------------------park off airport-------------------------------
    if simulation_row(5)==2
        revenue = off_airport_parking_shuttle_per_trip;
    end

%---------------------------curbside---------------------------------------
    if simulation_row(5)==3
        revenue = CURB_PER_TRIP_CHARGE;
    end
%---------------------------park at airport--------------------------------
    if simulation_row(5)==1
        revenue = revenue_private_car_at_airport(simulation_row);
    end
end

% IF AV
if  simulation_row(9)==1 % if is AV
%---------------------------park at airport--------------------------------
    if simulation_row(5) == 1 %originally park at airport
        cost_at_airport = revenue_private_car_at_airport(simulation_row);
        cost_off_airport = off_airport_parking_rate * simulation_row(7); 
        [cost_fuel,~]  = cost_round_trip(simulation_row);
        cost_curbside = CURB_PER_TRIP_CHARGE + cost_fuel; %fuel
        %minumum cost and corresponding activity
        [~,idx] = min([cost_at_airport cost_off_airport cost_curbside]);
        if idx ==1 %still park at air port
            revenue = revenue_private_car_at_airport(simulation_row);
        elseif idx == 2
            %park at airport=>part off airport
            revenue = off_airport_parking_shuttle_per_trip + off_airport_concession;
        else
            %park at airport => curbside
            revenue = CURB_PER_TRIP_CHARGE;
        end
    end
%---------------------------park off airport-------------------------------
    if simulation_row(5) == 2 %originally park off airport
        cost_off_airport = off_airport_parking_rate * simulation_row(7);
        [cost_fuel,~]  = cost_round_trip(simulation_row);
        cost_curbside = CURB_PER_TRIP_CHARGE + cost_fuel; %fuel
        if cost_off_airport >= cost_curbside
            %still park off airpot, nothting change
            revenue = off_airport_parking_shuttle_per_trip + off_airport_concession;
        else
            %change from park off airport to curbside
            revenue = CURB_PER_TRIP_CHARGE;
        end
    end
    
%---------------------------curbside---------------------------------------
      if simulation_row(5) == 3 %originally use the curbside
          [cost_fuel,~]  = cost_round_trip(simulation_row);
          cost_curbside = CURB_PER_TRIP_CHARGE + cost_fuel; %fuel
          revenue = CURB_PER_TRIP_CHARGE;
     end       
end        
