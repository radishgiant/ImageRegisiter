# ImageRegisiter
1.Matlab实现GF1WFV遥感数据配准，同时也适用于其他类型的图像校正，拼接。

2.本篇原理是基于surf自动特征提取

3.配准效果用标准误差RMSE进行定量化度量。

4.批量配准图像
# 代码说明
registerbatch.m 一个批量配准的例子

RSAFM.m 图像配准函数

%图像配准demo

original=imread(file1);

distorted=imread(file2);

recovered=RSAFM(original,distorted);

# 部分GF1WFV数据
下载地址：
