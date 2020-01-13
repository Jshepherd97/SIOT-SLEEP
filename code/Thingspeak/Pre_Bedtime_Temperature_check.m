data = thingSpeakRead(947162,'Fields',1, 'ReadKey', 'PBOX5613P4RDGDRJ')
s1 = 'value1=';
%% Read Data %%
if data >= 18
    s2 = sprintf('%1.1f',data)
    s3 = strcat(s1,s2)
    response = webwrite('https://maker.ifttt.com/trigger/bedtimehot/with/key/d7XiQIvL7ZEuwiPOIoy1zL',s3)
elseif data <= 16 
    s2 = sprintf('%1.1f',data)
    s3 = strcat(s1,s2)
    response = webwrite('https://maker.ifttt.com/trigger/bedtimecold/with/key/d7XiQIvL7ZEuwiPOIoy1zL',s3)
else
    s2 = sprintf('%1.1f',data)
    s3 = strcat(s1,s2)
    response = webwrite('https://maker.ifttt.com/trigger/bedtimegood/with/key/d7XiQIvL7ZEuwiPOIoy1zL',s3)
end 

