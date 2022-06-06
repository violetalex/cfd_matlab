clc;clear;close all;
filepath = 'C:\Users\dew\Documents\Tencent Files\56213760\FileRecv\teamwork\';%数据路径
filetype = '000.txt';%数据名称
filename = strcat(filepath,filetype);
data = textread(filename,'','headerlines',4);
zj=data(:,[2,3]);
data(:,1:3)=[];
P0=mean(zj(:,1));
P1=mean(zj(:,2));
P2=P0-P1;
Cpi=(data-P1)./P2;
Cpi(:,469:510)=[];

Cpi_m=mean(Cpi);  %平均风压系数
Cpi_p_m=std(data-P1)./P2;  %平均脉动风压系数

[filename2, pathname2] = uigetfile('xyz.txt','C:\Users\dew\Documents\Tencent Files\56213760\FileRecv\teamwork\');%获取实验数据文件路径(xyz.txt)
filename = strcat(pathname2,filename2);
p_loc= load(filename);
x=p_loc(:,1);
y=p_loc(:,2);
z=p_loc(:,3);





%*********1 绘制风压系数云图***
%A面风压系数云图
[yq,zq]=meshgrid(linspace(min(y(1:117)),max(y(1:117)),201),linspace(min(z(1:117)),max(z(1:117)),201));  %形成绘图网格
% vq=griddata(y(1:117),z(1:117),Cpi_m(1:117),yq,zq);  %插值求得网格值
F=scatteredInterpolant(y(1:117),z(1:117),Cpi_m(1:117)');  %插值求得网格值
vq=F(yq,zq);
figure();
subplot(1,4,1);  contour(yq,zq,vq,'fill','on');   %绘图
grid on;
colorbar;
xlabel('Y');
ylabel('Z');
title('迎风面-A面');

%B面风压系数云图
[xq,zq]=meshgrid(linspace(min(x(118:234)),max(x(118:234)),201),linspace(min(z(118:234)),max(z(118:234)),201));
% vq=griddata(x(118:234),z(118:234),Cpi_m(118:234),xq,zq);
F=scatteredInterpolant(x(118:234),z(118:234),Cpi_m(118:234)');
vq=F(xq,zq);
subplot(1,4,2);  contour(xq,zq,vq,'fill','on');
grid on;
colorbar;
xlabel('X');
ylabel('Z');
title('右侧立面-B面');



%C面风压系数云图
[yq,zq]=meshgrid(linspace(min(y(235:351)),max(y(235:351)),201),linspace(min(z(235:351)),max(z(235:351)),201));
% vq=griddata(y(235:351),z(235:351),Cpi_m(235:351),yq,zq);
F=scatteredInterpolant(y(235:351),z(235:351),Cpi_m(235:351)');
vq=F(yq,zq);
subplot(1,4,3);  contour(yq,zq,vq,'fill','on');
grid on;
colorbar;
xlabel('Y');
ylabel('Z');
title('背面-C面');


%D面风压系数云图
[xq,zq]=meshgrid(linspace(min(x(352:468)),max(x(352:468)),201),linspace(min(z(352:468)),max(z(352:468)),201));
% vq=griddata(x(352:468),z(352:468),Cpi_m(352:468),xq,zq);
F=scatteredInterpolant(x(352:468),z(352:468),Cpi_m(352:468)');
vq=F(xq,zq);
subplot(1,4,4);  contour(xq,zq,vq,'fill','on');
grid on;
colorbar;
xlabel('X');
ylabel('Z');
title('左侧立面-D面');






%%*********2 计算各高度处体型系数***
%A面
az=mean(reshape(z(1:117),9,13));  %每段的平均高度，9个点一段
us_az=mean(reshape(Cpi_m(1:117),9,13)); %每段的平均值

%B面
bz=mean(reshape(z(118:234),9,13));
us_bz=mean(reshape(Cpi_m(118:234),9,13));

%C面
cz=mean(reshape(z(235:351),9,13));
us_cz=mean(reshape(Cpi_m(235:351),9,13));

%D面
dz=mean(reshape(z(352:468),9,13));
us_dz=mean(reshape(Cpi_m(352:468),9,13));

figure();
subplot(2,1,1); plot(us_az,az,us_bz,bz,us_cz,cz,us_dz,dz); grid on; xlim([-2 1]); ylim([0 1]); legend(gca,'A','B','C','D','Location','northwest'); xlabel('体型系数 {\mu_s}'); ylabel('Z');
subplot(4,2,5); plot(us_az,az); grid on; xlim([0 .8]); ylim([0 1]); legend(gca,'A','Location','northwest'); xlabel('体型系数 {\mu_s}'); ylabel('Z');
subplot(4,2,6); plot(us_bz,bz); grid on; xlim([-1.5 -0.5]); ylim([0 1]); legend(gca,'B','Location','northwest'); xlabel('体型系数 {\mu_s}'); ylabel('Z');
subplot(4,2,7); plot(us_cz,cz); grid on; xlim([-1.5 -0.5]); ylim([0 1]); legend(gca,'C','Location','northwest'); xlabel('体型系数 {\mu_s}'); ylabel('Z');
subplot(4,2,8); plot(us_dz,dz); grid on; xlim([-1.5 -0.5]); ylim([0 1]); legend(gca,'D','Location','northwest'); xlabel('体型系数 {\mu_s}'); ylabel('Z');

u_H=min(2.91,50^0.3);  %500m处风压高度变化系数
z_r=(0.05:0.1:0.95);  %高度系数z/H，10段，取每段中点位置
H=z_r*500;    %对应原型结构的高度

us_a=pchip(az,us_az,z_r);  %插值求A面体型系数
us_c=pchip(cz,us_cz,z_r);  %插值求C面体型系数

us_H=us_a-us_c;     

w0=0.6;
A=50*60;

P=u_H*w0*us_H*A;   %各层风荷载
F=sum(P);         %基底剪力
M=sum(P.*H);     %基底弯矩
