function revenue = revenue_tnc(simulation_row)
% @brief revenue from tnc
% @param[input]  1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode 7: parking time 8: distance 9: AV 10: revenue
% @param[output] revenue

%when TNC is av, it has not effect on passengers who originallg choose av
%to airport since there are no difference in terms of passenger choices.
%But TNC might become less expensive given that av may reduce the labor
%cost for TNC. On the other hand, TNC could potentially attract more
%passengers who originally use private car to airport to use the service.
%There is another possibility that when more ppl choose to use TNC, airport
%will impose more charges to TNC, eg. temproray parking in this case, TNC
%to airport will not be as cheap as it should be.

CURBSIDE_PER_TRIP_CHARGE_RESIDENT = 3.8; %2018.6
CURBSIDE_PER_TRIP_CHARGE_ROURIST = 3.8; %2018.6
% delta = 30
% area = 0.01;
% Z = norminv(area);
mu = 10; %minutes
sigma = 10;
waiting_time = normrnd(mu, sigma); %normal distribution
temporary_parking_rate = 0; % $ per minute
temporary_parking_charge = temporary_parking_rate*waiting_time;


assert(simulation_row(4)==2); %travel mode has to be tnc

%----------------curbside pickup and dropoff + waiting charge--------------
revenue = 0;
%FIXME: AV doesn't affect TNC for now
if simulation_row(2) == 1 %resident
    revenue = CURBSIDE_PER_TRIP_CHARGE_RESIDENT+temporary_parking_charge;
end

if simulation_row(2) == 2 %tourist
    revenue = CURBSIDE_PER_TRIP_CHARGE_ROURIST+temporary_parking_charge;
end


