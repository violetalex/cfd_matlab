clc;clear;close all;
filepath = 'C:\Users\dew\Documents\Tencent Files\56213760\FileRecv\teamwork\';%����·��
filetype = '000.txt';%��������
filename = strcat(filepath,filetype);
data = textread(filename,'','headerlines',4);
zj=data(:,[2,3]);
data(:,1:3)=[];
P0=mean(zj(:,1));
P1=mean(zj(:,2));
P2=P0-P1;
Cpi=(data-P1)./P2;
Cpi(:,469:510)=[];

Cpi_m=mean(Cpi);  %ƽ����ѹϵ��
Cpi_p_m=std(data-P1)./P2;  %ƽ��������ѹϵ��

[filename2, pathname2] = uigetfile('xyz.txt','C:\Users\dew\Documents\Tencent Files\56213760\FileRecv\teamwork\');%��ȡʵ�������ļ�·��(xyz.txt)
filename = strcat(pathname2,filename2);
p_loc= load(filename);
x=p_loc(:,1);
y=p_loc(:,2);
z=p_loc(:,3);





%*********1 ���Ʒ�ѹϵ����ͼ***
%A���ѹϵ����ͼ
[yq,zq]=meshgrid(linspace(min(y(1:117)),max(y(1:117)),201),linspace(min(z(1:117)),max(z(1:117)),201));  %�γɻ�ͼ����
% vq=griddata(y(1:117),z(1:117),Cpi_m(1:117),yq,zq);  %��ֵ�������ֵ
F=scatteredInterpolant(y(1:117),z(1:117),Cpi_m(1:117)');  %��ֵ�������ֵ
vq=F(yq,zq);
figure();
subplot(1,4,1);  contour(yq,zq,vq,'fill','on');   %��ͼ
grid on;
colorbar;
xlabel('Y');
ylabel('Z');
title('ӭ����-A��');

%B���ѹϵ����ͼ
[xq,zq]=meshgrid(linspace(min(x(118:234)),max(x(118:234)),201),linspace(min(z(118:234)),max(z(118:234)),201));
% vq=griddata(x(118:234),z(118:234),Cpi_m(118:234),xq,zq);
F=scatteredInterpolant(x(118:234),z(118:234),Cpi_m(118:234)');
vq=F(xq,zq);
subplot(1,4,2);  contour(xq,zq,vq,'fill','on');
grid on;
colorbar;
xlabel('X');
ylabel('Z');
title('�Ҳ�����-B��');



%C���ѹϵ����ͼ
[yq,zq]=meshgrid(linspace(min(y(235:351)),max(y(235:351)),201),linspace(min(z(235:351)),max(z(235:351)),201));
% vq=griddata(y(235:351),z(235:351),Cpi_m(235:351),yq,zq);
F=scatteredInterpolant(y(235:351),z(235:351),Cpi_m(235:351)');
vq=F(yq,zq);
subplot(1,4,3);  contour(yq,zq,vq,'fill','on');
grid on;
colorbar;
xlabel('Y');
ylabel('Z');
title('����-C��');


%D���ѹϵ����ͼ
[xq,zq]=meshgrid(linspace(min(x(352:468)),max(x(352:468)),201),linspace(min(z(352:468)),max(z(352:468)),201));
% vq=griddata(x(352:468),z(352:468),Cpi_m(352:468),xq,zq);
F=scatteredInterpolant(x(352:468),z(352:468),Cpi_m(352:468)');
vq=F(xq,zq);
subplot(1,4,4);  contour(xq,zq,vq,'fill','on');
grid on;
colorbar;
xlabel('X');
ylabel('Z');
title('�������-D��');






%%*********2 ������߶ȴ�����ϵ��***
%A��
az=mean(reshape(z(1:117),9,13));  %ÿ�ε�ƽ���߶ȣ�9����һ��
us_az=mean(reshape(Cpi_m(1:117),9,13)); %ÿ�ε�ƽ��ֵ

%B��
bz=mean(reshape(z(118:234),9,13));
us_bz=mean(reshape(Cpi_m(118:234),9,13));

%C��
cz=mean(reshape(z(235:351),9,13));
us_cz=mean(reshape(Cpi_m(235:351),9,13));

%D��
dz=mean(reshape(z(352:468),9,13));
us_dz=mean(reshape(Cpi_m(352:468),9,13));

figure();
subplot(2,1,1); plot(us_az,az,us_bz,bz,us_cz,cz,us_dz,dz); grid on; xlim([-2 1]); ylim([0 1]); legend(gca,'A','B','C','D','Location','northwest'); xlabel('����ϵ�� {\mu_s}'); ylabel('Z');
subplot(4,2,5); plot(us_az,az); grid on; xlim([0 .8]); ylim([0 1]); legend(gca,'A','Location','northwest'); xlabel('����ϵ�� {\mu_s}'); ylabel('Z');
subplot(4,2,6); plot(us_bz,bz); grid on; xlim([-1.5 -0.5]); ylim([0 1]); legend(gca,'B','Location','northwest'); xlabel('����ϵ�� {\mu_s}'); ylabel('Z');
subplot(4,2,7); plot(us_cz,cz); grid on; xlim([-1.5 -0.5]); ylim([0 1]); legend(gca,'C','Location','northwest'); xlabel('����ϵ�� {\mu_s}'); ylabel('Z');
subplot(4,2,8); plot(us_dz,dz); grid on; xlim([-1.5 -0.5]); ylim([0 1]); legend(gca,'D','Location','northwest'); xlabel('����ϵ�� {\mu_s}'); ylabel('Z');

u_H=min(2.91,50^0.3);  %500m����ѹ�߶ȱ仯ϵ��
z_r=(0.05:0.1:0.95);  %�߶�ϵ��z/H��10�Σ�ȡÿ���е�λ��
H=z_r*500;    %��Ӧԭ�ͽṹ�ĸ߶�

us_a=pchip(az,us_az,z_r);  %��ֵ��A������ϵ��
us_c=pchip(cz,us_cz,z_r);  %��ֵ��C������ϵ��

us_H=us_a-us_c;     

w0=0.6;
A=50*60;

P=u_H*w0*us_H*A;   %��������
F=sum(P);         %���׼���
M=sum(P.*H);     %�������
