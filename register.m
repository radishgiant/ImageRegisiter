function [original,recovered]=register(file1,file2);
%file1 is reference
%file2 is warp image
data1=imread(file1);
data2=imread(file2);
original=data1.*16;
distorted=data2.*16;
recovered=RSAFM(original,distorted);

 