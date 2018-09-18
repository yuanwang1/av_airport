function cost = cost_tnc(simulation_row)
% @brief revenue from tnc
% @param[input]  1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode 7: parking time 8: distance 9: AV 10: revenue
% @param[output] revenue

TNC_per_meter_charge_resident = 0.97/1609.34; %0.97 per mile
TNC_per_meter_charge_tourist = 0.97/1609.34; %2017

assert(simulation_row(4)==2); %travel mode has to be tnc

cost = 0;
if  simulation_row(9)==0 % if not AV
    if simulation_row(2) == 1
        cost = simulation_row(8)*TNC_per_meter_charge_resident+8+3.8;
    end

    if simulation_row(2) == 2
        cost = simulation_row(8)*TNC_per_meter_charge_tourist+8+3.8;
    end
end