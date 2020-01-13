function autoplot(x) 
    s2 = 'Roomdata';
    s3 = '.xlsx';
    s6 = strcat(s2,x,s3);
    M = readtable(s6);
    Time = M{:,2};
    Temperature = M{:,3};
    T = table(Time,Temperature);
    MM = table2timetable(T);
    MMM = retime(MM, 'minutely','linear');
    MMMM = retime(MMM, 'hourly','mean');
    figure
    stackedplot(MMMM);
    temp2 = MMMM.Variables;
    figure
    autocorr(temp2,'NumLags',168);
    xlabel('Lag (hours)')
    ylabel('Autocorrelation')
    tempnorm = temp2-mean(temp2)
    fs = 24;
    [autocor,lags] = xcorr(tempnorm,2*7*24,'coeff');
    figure;
    plot(lags/fs,autocor)
    xlabel('Lag (days)')
    ylabel('Autocorrelation')
    axis([-14 14 -0.4 1.1])
    [pksh,lcsh] = findpeaks(autocor);
    short = mean(diff(lcsh))/fs
    [pklg,lclg] = findpeaks(autocor, ...
        'MinPeakDistance',ceil(short)*fs,'MinPeakheight',0.3);
    long = mean(diff(lclg))/fs
    hold on
    pks = plot(lags(lcsh)/fs,pksh,'or', ...
        lags(lclg)/fs,pklg+0.05,'vk');
    hold off
    legend(pks,[repmat('Period: ',[2 1]) num2str([short;long],0)])
    axis([-14 14 -0.4 1.1])
end