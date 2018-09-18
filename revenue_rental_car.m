function revenue = revenue_rental_car(simulation_row)
% @brief revenue from private car parking
% @param[input]  1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode 7: parking time 8: distance 9: AV 10: revenue
% @param[output] revenue

RENTAL_CAR_ON_AIRPORT = 18; % Average per rental car in may 2017
RENTAL_CAR_OFF_AIRPORT = 18; % Average in may 2017

assert(simulation_row(2)==2 && simulation_row(4)==3); % must be tourist with rental car

revenue = 0;

%-------------------------------no av -------------------------------------
if simulation_row(9)==0 %if not av
    if simulation_row(5)==4
       revenue = RENTAL_CAR_ON_AIRPORT;
    end
    if simulation_row(5)==5
       revenue = RENTAL_CAR_OFF_AIRPORT;
    end
end
%------------------------------- av ---------------------------------------
if simulation_row(9)==1 %if av
     if simulation_row(5)==4
       revenue = 0;
    end
    if simulation_row(5)==5
       revenue = 0;
    end
end