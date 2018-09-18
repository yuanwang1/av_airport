% main
% 1. simulate a table, each row is a person, each col represents an
% attribute
% 2. compute revenue for reach person (each row)

clear;
close all;
delta = 0.01;

av_adoption_rates = [0:delta:1; 0:delta:1; 0:delta:1; 0:delta:1; 0:delta:1]';%20*5: each row represent 5 adoption rate respectively for: private car, tnc, rental car, comfortable, economic
num_adoption = size(av_adoption_rates, 1);

revenue_all_private_car = [];
revenue_all_tnc = [];
revenue_all = [];
for i=1:num_adoption
%----------------------step1 generate simulation table---------------------
%1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode, 7: parking time 8: distance 9: AV 10: revenue
    fprintf("iteration: %d/%d\n", i,num_adoption);
    simulation_all = generate_simulation_table(av_adoption_rates(i, :));
    num_rows = size(simulation_all,1);
    
%----------------------step2 compute revenue for each row------------------
    for j = 1:num_rows
        row = simulation_all(j, :);
        revenue = 0;
        if(row(2)==1&&row(4)==1) % resident private car
            revenue = revenue_private_car(row);
        end
        if(row(4)==2) % tnc
            revenue = revenue_tnc(row);
        end
        if(row(4)==3) % rental car
            revenue = revenue_rental_car(row);
        end
        if(row(4)==4 || row(4)==5) % comfortable or economic
            revenue = revenue_comfortable_economic(row);
        end
        simulation_all(j,10) = revenue;
    end
    
    %private car
    idx_private_car = (simulation_all(:,4)==1);
    sum_revenue_private_car = sum(simulation_all(idx_private_car, 10));
    revenue_all_private_car(i, 1) = av_adoption_rates(i, 1);
    revenue_all_private_car(i, 2) = sum_revenue_private_car;
    
    %tnc
    idx_tnc = (simulation_all(:,4)==2);
    sum_revenue_tnc = sum(simulation_all(idx_tnc, 10));
    revenue_all_tnc(i, 1) = av_adoption_rates(i, 2);
    revenue_all_tnc(i, 2) = sum_revenue_tnc;
    
    %rental car
    idx_rental_car = (simulation_all(:,4)==3);
    sum_revenue_rental_car = sum(simulation_all(idx_rental_car, 10));
    revenue_all_rental_car(i, 1) = av_adoption_rates(i, 2);
    revenue_all_rental_car(i, 2) = sum_revenue_rental_car;
    
    %all
    sum_revenue = sum(simulation_all(:,10));
    revenue_all(i, 1) = av_adoption_rates(i, 1);
    revenue_all(i, 2) = sum_revenue;
end

%-----draw graph of revenue with AV emgering with current situatin---------
figure(5);
hold on;
plot(revenue_all(:,1), revenue_all(:,2), '-g*');
plot(revenue_all_private_car(:,1), revenue_all_private_car(:,2), '->r');
plot(revenue_all_tnc(:,1), revenue_all_tnc(:,2), '-bo');
plot(revenue_all_rental_car(:,1), revenue_all_rental_car(:,2), '-c^');
xlabel('AV adoption rate');
ylabel('SFO daily groud access related revenue (US dollar)')
legend('total revenue', 'private car revenue', 'TNC revenue', 'rental car revenue');
set(gca,'FontSize',16);

hold off;



