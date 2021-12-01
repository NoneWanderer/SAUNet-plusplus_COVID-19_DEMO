nii1=load_nii('brain_img001.nii');%导入三维数据
slice=nii1.img;%nii图像文件有img和head二个部分，其中img部分是图像数据
save image.mat slice %将数据变成mat格式
load('image.mat') %加载
nii2=load_nii('P0567050_1.2.156.112605.14038007944937.20210109091312.3.204.33__0_.nii');%导入三维数据
mask=nii2.img;%nii图像文件有img和head二个部分，其中img部分是图像数据
save image.mat mask %将数据变成mat格式
load('image.mat') %加载
[n1,n2,n3]=size(mask); %得到图像尺寸
for i=1:1:n3
    mask1=mask(:,:,i);
    mask2=mat2gray(mask1,[0.1,0.11]);%设置合适的窗宽窗位
    if(length(find(mask2==1))>100)
        mask3=imrotate(mask2,90);%逆时针旋转90度
        mask4=fliplr(mask3);%水平翻转
        imwrite(mask4,['E:\brainblood\mask\mask001_',num2str(i),'.png'])
        slice1=slice(:,:,i);
        slice2=imrotate(slice1,90);%逆时针旋转90度
        slice3=fliplr(slice2);%水平翻转
        slice4=mat2gray(slice3,[0,100]);%设置合适的窗宽窗位
        imwrite(slice4,['E:\brainblood\brain\slice001_',num2str(i),'.png'])
    end
end
