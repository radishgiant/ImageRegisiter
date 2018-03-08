
clear all;
file1='20160519cut.jp2';
path='F:\遥感数据--张美玲\多时相\高分1宽幅\裁剪form张';
list=dir(fullfile([path '\*.jp2']));
filenum=length(list);
if isempty(dir([pwd,'\GF1WFV.mat']))
GF1WFV=struct();
ori_n=1;
ori_date=['20160519cut.jp2'];
else
    load GF1WFV.mat
    ori_n=length(GF1WFV);
    ori_date=vertcat(GF1WFV.date);
end
j=1;
for i=1:filenum
    file2=list(i).name;
    if  ismember(file2(1:8),ori_date,'rows')||isequal(file2,file1)
        %check if image have been registered
        continue;
    else
[original,recovered]=register([path,'\',file1],[path,'\',file2]);
figure, imshowpair(original(:,:,1:3),recovered(:,:,1:3),'ColorChannels','red-cyan')
title([file2(1:8) ,'  Adjusted in linear']);
GF1WFV(j+ori_n).date=file2(1:8);
GF1WFV(j+ori_n).data=recovered;
imwrite(GF1WFV(j+ori_n).data(:,:,[3,2,1]),['F:\遥感数据--张美玲\多时相\高分1宽幅\配准\',GF1WFV(j+ori_n).date,'.png'],'bitdepth',16);
j=j+1;
    end
end
GF1WFV(1).data=original;GF1WFV(1).date=file1(1:8);%save reference image
save GF1WFV GF1WFV -v7.3
%% 按日期调整GF1WFV存储顺序
tmp1=GF1WFV(1);
tmp2=GF1WFV(2:13);
tmp3=GF1WFV(14:19);
tmp2(13).date=tmp1.date;tmp2(13).data=tmp1.data;
for i=1:6
tmp2(i+13).date=tmp3(i).date;tmp2(i+13).data=tmp3(i).data;
end
GF1WFV=tmp2;
clear tmp*