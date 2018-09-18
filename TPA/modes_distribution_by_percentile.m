function distribution = modes_distribution_by_percentile(num, percent_mode)
%generate a random distribution of modes (choices) based on the given percentiles
%any number of modes are supported
%choices are digitized as 1, 2, .. length(percent_mode). Their meanings depend on their columns in
%simulation_all
%input: num: total number 
%          percent_mode: percentage of different modes

if( abs(sum(percent_mode)-1)>0.000001 )%sum(percent_mode)~=1 very wierd 
    error('Input percentiles are not valid. They do not sum up to 1. Please check!\n');
end

distribution = zeros(num,1);

len = length(percent_mode);

num_mode = floor(num*percent_mode+0.5);
num_mode(len) = num-sum( num_mode(1:len-1));
accumulation = zeros(1, len); %the number of random IDs in 1-to-i modes
count = 0;
for j=1:len
    accumulation(j) = count + num_mode(j);
    count = accumulation(j);
end

 random_permulation = randperm(num);
 for i=1:num
     ID = random_permulation(i);
     for j=1:len
         if i<=accumulation(j)
             distribution(ID) = j;
             break;
         end
         if j==len && distribution(ID)==0
             error('shouldnt come here\n');
         end
     end
 end
 
 
% for i=1:num_mode(1)
%     ID = random_permulation(i);
%     distribution(ID) = 1;
% end
% for i=num_mode(1)+1:num_mode(1)+num_mode(2)
%     ID = random_permulation(i);
%     distribution(ID) = 2;
% end
% for i=num_mode(1)+num_mode(2)+1:num
%     ID = random_permulation(i);
%     distribution(ID) = 3;
% end


