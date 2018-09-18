%random distribution given percentile
clear;
enplanements = dlmread('Enplanements_2011.txt'); %numbers must be positive or 0
idx = enplanements < 0 ;
if sum(idx)>=1
    error('Error! Negtive enplanement number detected! Please check the excel file\n');
end

num_all_IDs = sum(enplanements);

%contains all information for each ID
simulation_all = zeros(num_all_IDs, 7);% 1: IDs, 2: Zip codes, 3: travel modes 4. parking modes 5. parking time 6.distance 7. private car that has AV or not

%step1 generating IDs
simulation_all(:,1) = 1:num_all_IDs;

%step2 generating zip codes
zipcodes = dlmread('ZipCodes.txt');
zipcode_by_id = generate_zip_codes(zipcodes, enplanements);
simulation_all(:,2) = zipcode_by_id;

%distance by zip code
distance = zeros(472,2); %1. zipcode, 2. google-map distance
distance = dlmread('Distance.txt');

for i=1:num_all_IDs
    zipcode = simulation_all(i,2);
    for j = 1:size(distance,1)
        if zipcode == distance(j,1)
            simulation_all(i, 6) = distance (j,2);
            break;
        end
    end
    if j == size(distance,1) && simulation_all(i, 6) ~= distance (j,2)
        fprintf('Invalid zipcode: %d\n', zipcode);
        error('The above zipcode does not have a value from "Distance.txt. Please check" ');
    end
end

%step3 generating travel modes
percent_travel_mode = [0.196 0.363 0.036 0.369 0.036 ];  %1. private parking, 2. curbside, 3. commercial vehicle resident, 4. rental car,  5. commercial vehicle tourist
distribution = modes_distribution_by_percentile(num_all_IDs, percent_travel_mode);
simulation_all(:,3) = distribution;

%verifying the correctness of travel modes
idx_travel1 = (simulation_all(:,3)==1);
idx_travel2 = (simulation_all(:,3)==2);
num_travel1 = sum(idx_travel1);
num_travel2 = sum(idx_travel2);
percentage_travel1= num_travel1/num_all_IDs
percentage_travel2 = num_travel2/num_all_IDs

%step4 generating parking modes
percent_parking_mode = [0.1243, 0.1744, 0.4559, 0.2454]; %1. short-term hourly parking, 2. short-term daily parking  3. long-term parking, 4. economic parking, 0. non-private parking
distribution_private_parking = modes_distribution_by_percentile(num_travel1, percent_parking_mode);
distribution = zeros(num_all_IDs,1);
j=1;
for i=1:num_all_IDs
    if simulation_all(i,3)==1
        distribution(i) = distribution_private_parking(j);
        j = j+1;
    end
end
%distribution(idx_travel1) = distribution_private_parking;
simulation_all(:,4) = distribution;
%verifying the correctness of parking modes
idx_parking_mode1 = (simulation_all(:,4)==1);
idx_parking_mode2 = (simulation_all(:,4)==2);
idx_parking_mode3 = (simulation_all(:,4)==3);
idx_parking_mode4 = (simulation_all(:,4)==4);
num_parking_mode1 = sum(idx_parking_mode1);
num_parking_mode2 = sum(idx_parking_mode2);
num_parking_mode3 = sum(idx_parking_mode3);
num_parking_mode4 = sum(idx_parking_mode4);
percentage_parking_mode1= num_parking_mode1/num_travel1
percentage_parking_mode2 = num_parking_mode2/num_travel1
percentage_parking_mode3 = num_parking_mode3/num_travel1
percentage_parking_mode4 = num_parking_mode4/num_travel1

%step5 parking time
%step5.1 parking time--short term hourly
X = 6;
area = 0.87;
Z = norminv(area);
mu1 = 54/60;
sigma1 = (X-mu1)/Z;

histogram1 = zeros(num_parking_mode1,1);
k1 = 1;
for i=1:num_all_IDs
    if( simulation_all(i,4) ==1)
        while 1
            time = normrnd(mu1, sigma1);
            if(time>0)
                simulation_all(i,5) = time;
                histogram1(k1) = time;
                k1 = k1+1;
                break;
            end
        end
    end
end
val = simulation_all(:,5);
idx = val>0;
figure(1);
hist(histogram1);



%step5.2 parking time--short term daily
X = 8;
area = 0.01;
Z = norminv(area);
mu2 = 2.5*24;
sigma2 = (X-mu2)/Z;

histogram2 = zeros(num_parking_mode2,1);
k2 = 1;
for i=1:num_all_IDs
    if( simulation_all(i,4) ==2)
        while 1
            time = normrnd(mu2, sigma2);
            if(time>0)
                simulation_all(i,5) = time;
                histogram2(k2) = time;
                k2 = k2+1;
                break;
            end
        end
    end
end
val = simulation_all(:,5);
idx = val>0;
figure(2);
hist(histogram2);

%step5.3 parking time -- long term
X=6;
area = 0.13;
Z = norminv(area);
mu3 = 3.5*24;
sigma3 = (X-mu3)/Z;

mu4 = 5.2*24;
sigma4 = (6-mu4)/norminv(0.05);
histogram3 = zeros(num_parking_mode3,1);
histogram4 = zeros(num_parking_mode4,1);
k3 = 1; 
k4 = 1;
for i=1:num_all_IDs
    if( simulation_all(i,4) ==3 )
        while 1
            time = normrnd(mu3, sigma3);
            if(time>0)
                simulation_all(i,5) = time;
                histogram3(k3) = time;
                k3 = k3+1;
                break;
            end
        end
    end
    if( simulation_all(i,4) ==4 )
        while 1
            time = normrnd(mu4, sigma4);
            if(time>0)
                simulation_all(i,5) = time;
                histogram4(k4) = time;
                k4 = k4 +1;
                break;
            end
        end
    end
end
val = simulation_all(:,5);
idx = val>0;
figure(3);
hist(histogram3);
figure(4);
hist(histogram4);

%step7 private car that is AV or not

AV_adoption_rate = 0:0.05:1;
num = length(AV_adoption_rate);
for n=1:num
    %randomly assigns private cars to be AV or not based on the adoption rate 
    for k = 1:num_all_IDs
        if (simulation_all(k,3)==1 || simulation_all(k,3)==2 || simulation_all(k,3)==3)%private parking
            random_number = rand();
            if random_number <= AV_adoption_rate(n)
                simulation_all(k,7) = 1; % this car is AV
            else
                simulation_all(k,7) = 0; % this car is not AV
            end
        end
    end
    
    parking_cost_calculation;
    
    count_AV_all(n) = count_AV;
    count_parking_all(n) = sum(count_parking);
    percent_AV_all(n) = count_AV/(count_AV+sum(count_parking));
    parking_fee_lost_all(n) = parking_fee_lost;
    parking_revenue_all(n) = parking_revenue;
end

figure(5);
plot(AV_adoption_rate, count_AV_all, 'o-b');
legend('Number of people chooing AV');

figure(6);
plot(AV_adoption_rate, percent_AV_all, 'o-g');
legend('Percentile of people chooing AV among all private parking');

figure(7);
plot(AV_adoption_rate, parking_fee_lost_all, 'o-c');
legend('TPA Parking-fee-income lost per day in 2030 due to AV');

figure(8);
xlabel('Autonomous vehicle market penetration');
ylabel('TPA parking revenue of 2030 (dollars per day)');
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


    
    





        




