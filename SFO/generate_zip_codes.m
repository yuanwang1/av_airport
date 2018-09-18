function zipcode_by_id = generate_zip_codes(zipcodes, enplanements)
%generae zip code per id given enplanements
%

num_all_IDs = sum(enplanements);
zipcode_by_id = zeros(num_all_IDs, 1);
j = 1;%current zip code
count = 0; %number of ids in current zip code
i=1;
while i<=num_all_IDs
    if (enplanements(j)<0)
        error('Error! Invalid enplanements number. Please check the excel file\n');
        break;
    end
    if(enplanements(j)==0)
        i=i-1;
    end
    if count < enplanements(j)
        zipcode_by_id(i) = zipcodes(j);
        count = count + 1;
    end
    if (count==enplanements(j))
        j = j+1;
        count = 0;
    end
    i=i+1;
end