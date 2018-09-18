function revenue = revenue_comfortable_economic(simulation_row)
% @brief revenue from tnc
% @param[input]  1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode 7: parking time 8: distance 9: AV 10: revenue
% @param[output] revenue

COMFORTABLE_GROUND_TRANSPORTATION = 3.6; %average
ECONOMIC_GROUND_TRANSPORTATION = 0; %no charge currently

assert(simulation_row(4)==4 || simulation_row(4)==5); %travel mode has to be tnc

revenue = 0;
if  simulation_row(9)==0 % if not AV
    if simulation_row(2) == 4
        revenue = COMFORTABLE_GROUND_TRANSPORTATION;
    end

    if simulation_row(2) == 5
        revenue = ECONOMIC_GROUND_TRANSPORTATION;
    end
end
