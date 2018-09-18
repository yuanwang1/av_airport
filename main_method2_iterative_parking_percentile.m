
%given the initial percentage of parking / (parking+curbside), and
%calculate new parking / (parking+curbside) due to AV emerging with a
%certain adoption rate, and then do iteration within the same adoption rate
%param[in]: id is the (id)th AV_adoption_rate  

clear;
clc;
close all;

addpath('utils');

show_figure = false; % whether to show figure in the main_iteration

percent_private_parking = 0.196;
percent_curbside = 0.363;
parking_over_parking_curbside_initial = 0.196/(0.196+0.363); %parking percentage over parking&cubside
percent_parking_and_curbside = 0.196+0.363;

AV_adoption_rate = 0:0.05:1;
id = 1; %choose which AV adoption rate to calculate

num_AV_adoption = length(AV_adoption_rate);
num_iteration = 5;  % set how many iterations are needed
percent_private_parking_all = zeros(num_AV_adoption, num_iteration);
percent_curbside_all = zeros(num_AV_adoption, num_iteration);

%set rows as all adoption rate from 0% to 100%
for id=1:num_AV_adoption
    percent_private_parking_all(id,1) = percent_private_parking;
    percent_curbside_all(id,1) = percent_curbside;
end

%do iteration to each adoption rate
for id = 1:num_AV_adoption
    parking_over_parking_curbside = parking_over_parking_curbside_initial;
    for i=1:num_iteration
        parking_over_parking_curbeside_new = main_iteration(parking_over_parking_curbside, percent_parking_and_curbside, AV_adoption_rate, id, show_figure);
        parking_over_parking_curbside = parking_over_parking_curbeside_new;
        
        percent_private_parking(i+1) = parking_over_parking_curbside*percent_parking_and_curbside
        percent_curbside(i+1) = (1-parking_over_parking_curbside)*percent_parking_and_curbside;
        
        percent_private_parking_all(id, i+1) = percent_private_parking(i+1);
        percent_curbside_all(id, i+1) = percent_curbside(i+1);
    end
end

figure(9);
hold on;
for i=1:num_iteration
    plot(AV_adoption_rate, percent_private_parking_all(:,i+1), '-or');
    plot(AV_adoption_rate, percent_curbside_all(:,i+1), '-*g');
end
hold off;










