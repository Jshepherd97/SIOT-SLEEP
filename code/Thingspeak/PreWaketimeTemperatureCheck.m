data = thingSpeakRead(947162,'Fields',1, 'ReadKey', 'PBOX5613P4RDGDRJ')
s1 = 'value1=';
%% Read Data %%
if data <= 20
    s2 = sprintf('%1.1f',data)
    s3 = strcat(s1,s2)
    response = webwrite('https://maker.ifttt.com/trigger/waketimecold/with/key/d7XiQIvL7ZEuwiPOIoy1zL',s3)
else 
    s2 = sprintf('%1.1f',data)
    s3 = strcat(s1,s2)
    response = webwrite('https://maker.ifttt.com/trigger/waketimegood/with/key/d7XiQIvL7ZEuwiPOIoy1zL',s3)
end
