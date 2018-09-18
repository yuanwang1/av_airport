function [interval, bin_limits, bin_width] =interval_from_histogram(survey_file)
    nbin = 100;
    short_term_hourly = dlmread(survey_file); %n*1, each row is parking duration in minutes
    figure(100);
    h = histogram(short_term_hourly,nbin);
    interval = distribution_from_histogram(h.BinCounts);
    bin_limits = h.BinLimits;
    bin_width = h.BinWidth;
    
end

%param[in] h: 1*n
function intervals = distribution_from_histogram(h)
    assert(size(h,2)>=1)
    num_bin = size(h, 2);
    intervals = zeros(1, num_bin);
    sum_hist = sum(h);
    intervals(1) = h(1)/sum_hist;
    for i=2:num_bin
        width = h(i)/sum_hist;
        intervals(i) = intervals(i-1) + width;
    end
    assert(abs(intervals(num_bin)-1)<0.001);
end