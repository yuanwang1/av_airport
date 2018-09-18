
% Sep. 25, 2015
% Using the parking percent from previous AV_adoptionrate
% Assumption:
% if AV_adoption_rate = 0%, percent_private_parking = 0.196; percent_curbside = 0.363;
% if AV_adoption_rate = 5%, percent_private_parking = 0.196; percent_curbside = 0.363;
% if AV_adoption_rate = 10%, new percents from the output of 5%;

clear;
clc;
%close all;

addpath('utils'); % need some rand related functions

show_figure = true; % whether to show figure in the main_iteration

% initial values from 2009 TPA survey from ACRP report40 (when no AV is
% available)
percent_private_parking = 0.196;
percent_curbside = 0.363;
parking_over_parking_and_curbside_initial = 0.196/(0.196+0.363); %parking percentage over parking&cubside
percent_parking_and_curbside = 0.196+0.363; 

% AV percent out of all vehicals, also called market penetration
AV_adoption_rate = 0:0.05:1;

num_AV_adoption = length(AV_adoption_rate);
percent_private_parking_all = zeros(num_AV_adoption, 1);
percent_curbside_all = zeros(num_AV_adoption, 1);

% parking percentage over parking&cubside
parking_over_parking_and_curbside = parking_over_parking_and_curbside_initial;

% take care of AV_adoption_rate=0
% id = 1;
% [parking_over_parking_curbeside_new, parking_revenue] = main_iteration(parking_over_parking_and_curbside, percent_parking_and_curbside, AV_adoption_rate, id, show_figure);
% percent_private_parking_all(id) = parking_over_parking_and_curbside*percent_parking_and_curbside;
% percent_curbside_all(id) = (1-parking_over_parking_and_curbside)*percent_parking_and_curbside;
% parking_revenue_all(id) = parking_revenue;
parking_over_parking_curbside_last = 0;
for id = 1:num_AV_adoption
% id represents the AV adoption rate index
    if id>=2
        parking_new = percent_private_parking*(1-AV_adoption_rate(id)) + parking_over_parking_curbside_last*percent_parking_and_curbside*AV_adoption_rate(id);
        parking_over_parking_and_curbside = parking_new / percent_parking_and_curbside;
    end
    [parking_over_parking_curbside_new, parking_revenue, percent_private_parking_new_by_mode] = main_iteration(parking_over_parking_and_curbside, percent_parking_and_curbside, AV_adoption_rate, id, show_figure);
    
    percent_private_parking_all(id) = parking_over_parking_curbside_new*percent_parking_and_curbside;
    percent_curbside_all(id) = (1-parking_over_parking_curbside_new)*percent_parking_and_curbside;
    parking_revenue_all(id) = parking_revenue;
    parking_over_parking_curbside_last = parking_over_parking_curbside_new;
    percent_private_parking_new_by_mode_all(id,:) = percent_private_parking_new_by_mode;
end

% following is for displaying
figure(9);
hold on;
plot(AV_adoption_rate, percent_curbside_all,'-*',...
    'Color', [50,205,50]/255,...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor',[50,205,50]/255,...
    'MarkerFaceColor',[50,205,50]/255);
plot(AV_adoption_rate, percent_private_parking_all,'-o',...
    'Color', [250,128,114]/255,...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor',[250,128,114]/255,...
    'MarkerFaceColor',[250,128,114]/255);
legend('Curbside percentage','Private parking percentage');
xlabel('Autonomous vehicle market penetration');
ylabel('Parking/curbside percentage ');
% using '%' in y-axis
ystr=[cellstr(num2str(get(gca,'ytick')'*100))];
pct = char(ones(size(ystr,1),1)*'%');
new_yticks = [char(ystr),pct];
set(gca,'yticklabel',new_yticks)
set(gca,'FontSize',16);
% using % in x-axis
xstr=[cellstr(num2str(get(gca,'xtick')'*100))];
pct = char(ones(size(xstr,1),1)*'%');
new_xticks = [char(xstr),pct];
set(gca,'xticklabel',new_xticks) 
hold off;

figure(10);
plot(AV_adoption_rate, parking_revenue_all,'-^',...
    'Color', [30,144,255]/255,...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor',[30,144,255]/255,...
    'MarkerFaceColor',[30,144,255]/255)
xlabel('Autonomous vehicle market penetration');
ylabel('TPA parking revenue of 2030 (dollars per day)');
set(gca,'FontSize',16);
% using % in x-axis
xstr=[cellstr(num2str(get(gca,'xtick')'*100))];
pct = char(ones(size(xstr,1),1)*'%');
new_xticks = [char(xstr),pct];
set(gca,'xticklabel',new_xticks) 

figure(11);
hold on;
plot(AV_adoption_rate, percent_private_parking_new_by_mode_all(:,1)','-o',...
    'Color', [250,128,114]/255,...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor',[250,128,114]/255,...
    'MarkerFaceColor',[250,128,114]/255);
plot(AV_adoption_rate, percent_private_parking_new_by_mode_all(:,2)','-*',...
    'Color', [50,205,50]/255,...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor',[50,205,50]/255,...
    'MarkerFaceColor',[50,205,50]/255);
plot(AV_adoption_rate, percent_private_parking_new_by_mode_all(:,3)','-^',...
    'Color', [30,144,255]/255,...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor',[30,144,255]/255,...
    'MarkerFaceColor',[30,144,255]/255);
plot(AV_adoption_rate, percent_private_parking_new_by_mode_all(:,4)','-s',...
    'Color', [147,112,219]/255,...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor',[147,112,219]/255,...
    'MarkerFaceColor',[147,112,219]/255);
xlabel('Autonomous vehicle market penetration');
ylabel('Private parking percentage');
set(gca,'FontSize',16);
legend('Short-term hourly parking', 'Short-term daily parking', 'Long-term parking', 'Economic parking');
% using % in x-axis
xstr=[cellstr(num2str(get(gca,'xtick')'*100))];
pct = char(ones(size(xstr,1),1)*'%');
new_xticks = [char(xstr),pct];
set(gca,'xticklabel',new_xticks);
% using '%' in y-axis
ystr=[cellstr(num2str(get(gca,'ytick')'*100))];
pct = char(ones(size(ystr,1),1)*'%');
new_yticks = [char(ystr),pct];
set(gca,'yticklabel',new_yticks)
set(gca,'FontSize',16);











