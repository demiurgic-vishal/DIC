function displacement_hd()
grid_generator();
tic;
original = imread('undeformed.gif');
deformed = imread('deformed1.2.gif');sn=7;
% original = imread('PIC00300.Tif');
% deformed = imread('PIC00310.Tif');sn=21;
% original = imread('final-000_0.tif');
% deformed = imread('final-010_0.tif');sn=5;

sd=size(deformed);
original(sd(1)+10,sd(2)+10)=0;
deformed(sd(1)+10,sd(2)+10)=0;

if exist('grid_x')==0
    load('grid_x.dat')              % file with x position, created by grid_generator.m
end
if exist('grid_y')==0
    load('grid_y.dat')              % file with y position, created by grid_generator.m
end

valid_x=grid_x;
valid_y=grid_y;

u0=0;v0=0;

u=zeros(size(original));
v=zeros(size(original));
ux=zeros(size(original));
uy=zeros(size(original));
vx=zeros(size(original));
vy=zeros(size(original));
h=waitbar(0,sprintf('Processing images'));
a=0;
n=10;
i=2;j=2;
p=size(grid_x,1);

grid_side_y=grid_y(2)-grid_y(1);

y_max=(grid_y(p)-grid_y(1))/grid_side_y + 1
x_max=p/y_max

grid_side_x=(grid_x(x_max)-grid_x(1))/y_max;

[u(i,j),v(i,j),ux(i,j),uy(i,j),vx(i,j),vy(i,j)]=samll_disp_normal_corr(grid_x(y_max+2),grid_y(y_max+2),u0,v0,0,0,0,0,original,deformed,n,sn);
t=toc;
k=y_max;
for i=2:x_max
    k=k+1;
    for j=2:y_max   
        k=k+1;
        u0=(u(i-1,j)+u(i,j-1))/((i~=2 || (i==2 && j==2))+(j~=2));
        v0=(v(i-1,j)+v(i,j-1))/((i~=2 || (i==2 && j==2))+(j~=2));
        ux0=(ux(i-1,j)+ux(i,j-1))/2;
        vx0=(vx(i-1,j)+vx(i,j-1))/2;
        uy0=(uy(i-1,j)+uy(i,j-1))/2;
        vy0=(vy(i-1,j)+vy(i,j-1))/2;
        grid_x(k);
        [u(i,j),v(i,j),ux(i,j),uy(i,j),vx(i,j),vy(i,j)]=samll_disp_normal_corr(grid_x(k),grid_y(j),u0,v0,ux0,uy0,vx0,vy0,original,deformed,n,sn);
        valid_x(k)=grid_x(k)+u(i,j);
        valid_y(k)=grid_y(k)+v(i,j);
        e=toc-t;
        a=k;
        h=waitbar(a/(x_max)/(y_max),h,sprintf('Processing images %d sec remaining...',int32(((e/a)*((x_max)*(y_max)-a)))));
    end
end
k
p
%(e/a)*x_max*y_max;
close(h);

figure(14);
    imshow(deformed)
    hold on
    %plot(grid_x,grid_y,'g+')                                % plot start position of raster
    Uq = reshape(valid_x,y_max,x_max);
    Vq = reshape(valid_y,y_max,x_max);
    plot(Uq(2:y_max,2:x_max),Vq(2:y_max,2:x_max),'r+')        % plot actual postition of raster
    hold off
    drawnow
    figure(15);
    imshow(original)
    hold on
    Uq = reshape(grid_x,y_max,x_max);
    Vq = reshape(grid_y,y_max,x_max);
    plot(Uq(2:y_max,2:x_max),Vq(2:y_max,2:x_max),'g+')                 % plot start position of raster        
    hold off
    drawnow

input_correl(:,:) = cpcorr([valid_x valid_y],[grid_x grid_y],...
                          deformed(:,:,1),original(:,:,1));
    input_correl_x=input_correl(:,1);                                       % the results we get from cpcorr for the x-direction
    input_correl_y=input_correl(:,2); 
    figure(10);
    imshow(deformed)
    hold on
    %plot(grid_x,grid_y,'g+')                                % plot start position of raster
    Uq = reshape(input_correl_x,y_max,x_max);
    Vq = reshape(input_correl_y,y_max,x_max);
    plot(Uq(2:y_max,2:x_max),Vq(2:y_max,2:x_max),'r+')        % plot actual postition of raster
    hold off
    drawnow
    figure(11);
    imshow(original)
    hold on
    Uq = reshape(grid_x,y_max,x_max);
    Vq = reshape(grid_y,y_max,x_max);
    plot(Uq(2:y_max,2:x_max),Vq(2:y_max,2:x_max),'g+')                 % plot start position of raster        
    hold off
    drawnow


Uq = reshape(input_correl_x-grid_x,y_max,x_max);
Vq = reshape(input_correl_y-grid_y,y_max,x_max);

strain(Uq(2:y_max,2:x_max),Vq(2:y_max,2:x_max),2:x_max,2:y_max,grid_side_x,grid_side_y,x_max,y_max);

[Xq,Yq] = meshgrid(2:0.1:x_max,2:0.1:y_max);
Vq = interp2(Vq,Xq,Yq,'bilinear');
figure, surf(Vq,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
figure, pcolor(Vq);shading('interp');

Uq = interp2(Uq,Xq,Yq,'bilinear');
figure, surf(Vq,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
figure, pcolor(Uq);shading('interp');
figure, pcolor(Uq.^2+Vq.^2);shading('interp');
% figure(1);
% [Xq,Yq] = meshgrid(2:0.1:x_max,2:0.1:y_max);
% Vq = interp2(v,Xq,Yq,'linear');
% plot3(grid_x,grid_y,valid_y-grid_y);%'EdgeColor','none','LineStyle','none','FaceLighting','phong');
% Uq = interp2(v,Xq,Yq,'linear');
% figure(2);
% plot3(grid_x,grid_y,valid_x-grid_x);%,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
% figure(3);
% surf((Vq.^2+Uq.^2).^0.5,'EdgeColor','none','LineStyle','none','FaceLighting','phong');

%save('deformed1.2_results','s1');
toc
