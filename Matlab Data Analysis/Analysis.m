Graphday('27');
Graphday('28');
Graphday('30');
Graphday('1');
Graphday('2');
Graphday('3');
Graphday('4'); 
Autoplot('ALLTEMP');
[actnorm1,hrnorm1,tempnorm1] = cross('28');
[actnorm2,hrnorm2,tempnorm2] = cross('2');
[actnorm3,hrnorm3,tempnorm3] = cross('4');
figure
subplot(1,3,1);
crosscorr(actnorm1,hrnorm1,'NumLags',30,'NumSTD',3)
title('28th December')
xlabel('Lag (minutes)')
ylabel('Correlation')
subplot(1,3,2)
crosscorr(actnorm2,hrnorm2,'NumLags',30,'NumSTD',3)
title('2nd January')
xlabel('Lag (minutes)')
ylabel('Correlation')
subplot(1,3,3)
crosscorr(actnorm3,hrnorm3,'NumLags',30,'NumSTD',3)
title('4th January')
xlabel('Lag (minutes)')
ylabel('Correlation')

figure
subplot(1,3,1);
crosscorr(tempnorm1,actnorm1,'NumLags',30,'NumSTD',3)
title('28th December')
xlabel('Lag (minutes)')
ylabel('Correlation')
subplot(1,3,2);
crosscorr(tempnorm2,actnorm2,'NumLags',30,'NumSTD',3)
title('2nd January')
xlabel('Lag (minutes)')
ylabel('Correlation')
subplot(1,3,3);
crosscorr(tempnorm3,actnorm3,'NumLags',30,'NumSTD',3)
title('4th January')
xlabel('Lag (minutes)')
ylabel('Correlation')

figure
subplot(1,3,1);
crosscorr(tempnorm1,hrnorm1,'NumLags',30,'NumSTD',3)
title('28th December')
xlabel('Lag (minutes)')
ylabel('Correlation')
subplot(1,3,2);
crosscorr(tempnorm2,hrnorm2,'NumLags',30,'NumSTD',3)
title('2nd January')
xlabel('Lag (minutes)')
ylabel('Correlation')
subplot(1,3,3);
crosscorr(tempnorm3,hrnorm3,'NumLags',30,'NumSTD',3)
title('4th January')
xlabel('Lag (minutes)')
ylabel('Correlation')

