function [cost_fuel,cost_electric]  = cost_round_trip(simulation_row)
% @brief cost for round trip, fuel cost or electric cost
% @param[input]  1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode 7: parking time 8: distance 9: AV 10: revenue
% @param[output] cost_fuel, cost_electric

cost_fuel = 0;
cost_electric = 0;
distance_cal = simulation_row(8);

%-----------------------parameters for fuel and electricity----------------
% fuel
fuel_per_gallon = 3.02; %The Bay Area's gas prices are averaging $3.02
MPG = 20;
mile_in_meter = 1609.34;
gallon_per_meter = 1/MPG/mile_in_meter;

%electric
cost_per_kwh = 0.59; %21 cents per kwh in SF area, but 0.49-0.69 by Blink company, level-2
kwh_per_mile = 0.2257; %range from 18.75kwh/100mile to 26.39kwh/100mile, thus average 22.57
kwh_per_meter = kwh_per_mile/mile_in_meter;

%----------------------calculate the round trip cost-----------------------
cost_fuel = distance_cal*fuel_per_gallon*gallon_per_meter*2;
cost_electric = distance_cal*cost_per_kwh*kwh_per_meter*2;