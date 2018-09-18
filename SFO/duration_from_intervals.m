function duration_minitue = duration_from_intervals(intervals, min_value, bin_width)
%generate a random value that follow the distribution defined by the
%intervals
    val = rand();
    id = search_interval(val, intervals);
    assert(id>=1)
    duration_minitue = min_value+id*bin_width;
    
end

function id = search_interval(val, intervals)

    num_bin = size(intervals, 2);
    low = 1;
    high = num_bin;
    id = -1;
    while low<high-1
        mid = floor((low+high)/2);
        if val==intervals(mid)
            id = mid;
            return;
        elseif val < intervals(mid)
            high = mid;
        else
            low = mid;
        end
    end
    if low==high-1
        id = high;
    end
end