image=imread('C:\Users\DN\Desktop\US\IMG_20200516_1_1.jpg');%读入图像
im0=rgb2gray(image);%转化为灰度图
%im0=image;
figure
subplot(221),imshow(im0),title('\fontsize{16}灰度图')
%% 阈值分割对比
% 基于Otsu方法的全局图像阈值分割
im1=imbinarize(im0,'global');%通过阈值化将二维灰度图像二值化
%局部自适应图像阈值分割
im2=imbinarize(im0,'adaptive');
% 基于轮廓像素分割
Eidx=edge(im0,'Sobel');%使用Sobel获取边缘
E1=im0(Eidx);%获取边缘像素
E1=E1(E1>0);
im3=imbinarize(im0,graythresh(E1));
subplot(222),imshow(im1),title('\fontsize{16}全局分割')
subplot(223),imshow(im2),title('\fontsize{16}局部自适应分割')
subplot(224),imshow(im3),title('\fontsize{16}基于轮廓像素分割')
%% 去除床板衣物等干扰，提取人体部分
% 计算连通分量
[label,num]=bwlabel(im1);
% 计算最大连通分量
MAX = 0;
for k = 1:num
    maxtmp = sum(find(label==k));
    if maxtmp>MAX
        IDX = k;
        MAX = maxtmp;
    end
end
im4 = label==IDX;
figure
subplot(221),imshow(im4),title('\fontsize{16}胸腔')
%% 提取疑似肺质
im5 = imfill(im4,'hole'); % 填充
subplot(222),imshow(im5),title('\fontsize{16}填充')
im6 = im5-im4;
subplot(223),imshow(im6),title('\fontsize{16}相减')
%去除气管等
P = 2000;
im7 = bwareaopen(im6,P,4);  % 删除面积小于P的4连通分量
subplot(224),imshow(im7),title('\fontsize{16}去除气管')
%% 形态学处理
SE1=strel('disk',2);%定义结构元素的形状，圆形-半径2
SE2=strel('disk',4);
im8=imdilate(imerode(im7,SE1),SE2);%闭运算，先膨胀再腐蚀
figure
subplot(221),imshow(im8),title('\fontsize{16}闭运算')
%% 获得掩膜
im9 = imfill(im8,'hole'); %填充
figure
subplot(222),imshow(im9),title('\fontsize{16}掩膜')
%% 提取肺实质
im10=immultiply(im0,im9);%相乘
figure
imshow(im10)
imshow(image)
figure
imshow(im10)