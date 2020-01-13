function Graphday(x)
    s1 = 'Sleepdata';
    s2 = 'Roomdata';
    s3 = '.xlsx';
    s5 = strcat(s1,x,s3);
    s6 = strcat(s2,x,s3);
    A = readtable(s5);
    M = readtable(s6);
    figure; 
    x = A{:,1};
    y = A{:,2};
    Y = normalize(y);
    plot(x,Y);
    hold on
    x1 = A{:,3};
    y1 = A{:,4};
    Y1 = normalize(y1);
    plot(x1,Y1);
    hold on
    x2 = M{:,2};
    y2 = M{:,3};
    Y2 = normalize(y2);
    plot(x2,Y2);
    title('Temperature, Heart rate and Sleep activity')
end