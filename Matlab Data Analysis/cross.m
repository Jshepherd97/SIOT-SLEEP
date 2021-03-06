function [actnorm,hrnorm,tempnorm] = cross(x) 
    s1 = 'Roomdata';
    s2 = 'Sleepdata';
    s3 = '.xlsx';
    s5 = strcat(s1,x,s3);
    s6 = strcat(s2,x,s3);
    S = readtable(s6);
    M = readtable(s5);
    TimeSleep = S{:,1};
    Activity = S{:,2};
    TimeHR = S{:,3};
    HR = S{:,4};
    TimeRoom = M{:,2};
    Temp = M{:,3};
    TA = table(TimeSleep,Activity);
    THR = table(TimeHR,HR);
    TR = table(TimeRoom,Temp);
    TAT = table2timetable(TA);
    THT = table2timetable(THR);
    TRT = table2timetable(TR);
    THT2 = rmmissing(THT);
    TT = synchronize(TRT,TAT,THT2);
    TTT = retime(TT, 'minutely','linear');
    Values = TTT.Variables;
    temp = Values(:,1);
    tempnorm = normalize(temp);
    act = Values(:,2);
    actnorm = normalize(act);
    hr = Values(:,3);
    hrnorm = normalize(hr);
end