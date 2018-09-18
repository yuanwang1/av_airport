

[intervals, bin_limits, bin_width] = interval_from_histogram('SFO_long_term.txt');%'SFO_short_term_hourly.txt', 'SFO_short_term_daily.txt'
for i=1:1000
    duration_minute(i) = duration_from_intervals(intervals, bin_limits(1), bin_width);
end
figure;
plot(duration_minute, '*r');
figure
hist(duration_minute,100);

