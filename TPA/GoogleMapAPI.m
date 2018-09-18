%calcuate the distance from the origin to the TPA given their longtitude
%and latitude
%https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.6905615%2C-73.9976592%7C40.659569%2C-73.933783%7C40.729029%2C-73.851524%7C40.6860072%2C-73.6334271%7C40.598566%2C-73.7527626%7C40.659569%2C-73.933783%7C40.729029%2C-73.851524%7C40.6860072%2C-73.6334271%7C40.598566%2C-73.7527626&key=YOUR_API_KEY

TPA_coord = '27.9756,-82.5333';
SFO_coord = '37.6213,-122.3790'; 
mode='driving';

file_name = 'OriginCoordinates.txt';
orig_coord_all = dlmread(file_name);
num = size(orig_coord_all,1);
distance_all = zeros(num,1)-1;
for i = 1:num
    coord = orig_coord_all(i,1:2);
    orig_coord = [num2str(coord(1)) ',' num2str(coord(2))];
    disp(orig_coord);
    url = ['https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=(orig_coord)&destinations=(TPA_coord)&mode=driving&key=AIzaSyDN1Sy8sdzp4nwAClwSjq3gSBoeqO_Nxz0 '];
    str = urlread(url);
    %find the value of distance in str
    pos = findstr(str, 'value');
    if size(pos,1) == 0
        fprintf('Warning! Google API said: the %d origin coordinate does not have valid route to TPA.\n', i);
        continue;
    end
    pos_first = pos(1)+9;
    ch = str(pos_first);
    pos_last = pos_first-1;
    while (ch >= '0') && (ch <= '9')
        pos_last = pos_last + 1;
        ch = str(pos_last+1);
    end
    str_value = str(pos_first:pos_last);
    value = str2num(str_value);
    distance_all(i) = value;
end
distance_all


