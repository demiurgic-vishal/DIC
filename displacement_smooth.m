function displacement_smooth(fr,U_filename,D_filename,pathname,rigid)
[grid_x,grid_y]= grid_generator(U_filename,pathname);
cd(pathname);
tic;
% fr=1;
% original = imread('undeformed.gif');
% deformed = imread('deformed1.2.gif');sn=6*fr;
% [Xq,Yq] = meshgrid(1:1/fr:size(original,1),1:1/fr:size(original,1));
% original = interp2(double(original),Xq,Yq,'bicubic');
% [Xq,Yq] = meshgrid(1:1/fr:size(deformed,1),1:1/fr:size(deformed,1));
% deformed = interp2(double(deformed),Xq,Yq,'bicubic');
% original = imread('PIC00300.Tif');
% deformed = imread('PIC00310.Tif');sn=21*fr;
% original = imread('impdic_00.tiff');
% deformed = imread('impdic_01.tiff');sn=5*fr;

% original = imread('pcbend1-000_0.tif');
% deformed = imread('pcbend1-030_0.tif');sn=15*fr;

original = imread(U_filename);
deformed = imread(D_filename);

prompt = {'Enter Max deformation in pixels co-ordinates :'};
dlg_title = 'Input for initial check region';
num_lines= 1;
def     = {'15'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
sn = str2double(cell2mat(answer(1,1)));

sn = sn*fr;

%% Rigid_Rotation
if(rigid==1)
    [deformedRegistered theta_recovered] = feature_matching(original,deformed);
    theta_recovered
    if(theta_recovered>2||theta_recovered<-2)
        theta_recovered
        deformed = deformedRegistered;
    end
end

%% Image Smooting/Interpolation
if(fr~=1)
    original=imresize(original,fr,'bicubic');
    deformed=imresize(deformed,fr,'bicubic');
end

sd=size(deformed);
original(sd(1)+10,sd(2)+10)=0;
deformed(sd(1)+10,sd(2)+10)=0;

%% Load Grid Data
% if exist('grid_x')==0
%     load('grid_x.dat')              % file with x position, created by grid_generator.m
% end
% if exist('grid_y')==0
%     load('grid_y.dat')              % file with y position, created by grid_generator.m
% end

grid_x=grid_x.*fr;
grid_y=grid_y.*fr;
valid_x=grid_x;
valid_y=grid_y;

%% Initializing variables and extract data

n=10;
i=2;j=2;
p=size(grid_x,1);

grid_side_y=grid_y(2)-grid_y(1);

y_max=(grid_y(p)-grid_y(1))/grid_side_y + 1
x_max=p/y_max

grid_side_x=(grid_x(y_max+1)-grid_x(1));

u0=0;v0=0;

u=zeros(x_max,y_max);
v=zeros(x_max,y_max);
ux=zeros(x_max,y_max);
uy=zeros(x_max,y_max);
vx=zeros(x_max,y_max);
vy=zeros(x_max,y_max);
h=waitbar(0,sprintf('Processing images'));
a=0;

%% Normaxcorr method for finding displacements

[u(i,j),v(i,j),ux(i,j),uy(i,j),vx(i,j),vy(i,j)]=samll_disp_normal_corr(grid_x(y_max+2),grid_y(y_max+2),u0,v0,0,0,0,0,original,deformed,n,2*sn);
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

%% Control point corrilation method for fine tuning the displacements

input_correl(:,:) = cpcorr([valid_x valid_y],[grid_x grid_y],...
                          deformed(:,:,1),original(:,:,1));
    input_correl_x=input_correl(:,1);                                       % the results we get from cpcorr for the x-direction
    input_correl_y=input_correl(:,2); 
    figure('units','normalized','outerposition',[0 0 1 1]);
    imshow(deformed)
    hold on
    %plot(grid_x,grid_y,'g+')                                % plot start position of raster
    Uq = reshape(input_correl_x,y_max,x_max);
    Vq = reshape(input_correl_y,y_max,x_max);
    plot(Uq(2:y_max,2:x_max),Vq(2:y_max,2:x_max),'r+')        % plot actual postition of raster
    hold off
    drawnow
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    imshow(original)
    hold on
    Uq = reshape(grid_x,y_max,x_max);
    Vq = reshape(grid_y,y_max,x_max);
    plot(Uq(2:y_max,2:x_max),Vq(2:y_max,2:x_max),'g+')                 % plot start position of raster        
    hold off
    drawnow
    
%% Plots of displacements, strains along x,y directions

Uq = reshape(input_correl_x-grid_x,y_max,x_max);
Vq = reshape(input_correl_y-grid_y,y_max,x_max);

save('displ_data','Uq','Vq','x_max','y_max');

% [Xq,Yq] = meshgrid(2:0.1:x_max,2:0.1:y_max);
% Vq_smooth = interp2(Vq,Xq,Yq,'bilinear');
% %figure, surf(Vq,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
% figure, pcolor(Vq_smooth),shading('interp'),axis ij, axis equal,axis off,title('displacement in Y-direction');
% 
% Uq_smooth = interp2(Uq,Xq,Yq,'bilinear');
% %figure, surf(Vq,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
% figure, pcolor(Uq_smooth);shading('interp'),axis equal,axis ij,axis off,title('displacement in X-direction');
% figure, pcolor(sqrt(Uq_smooth.^2+Vq_smooth.^2)),shading('interp'),axis ij,axis equal,axis off,title('magnitude of displacement');

%% Calculate strain

 strain_new(Uq,Vq,2:x_max,2:y_max,grid_side_x,grid_side_y,x_max,y_max,6);
% strain(Uq(2:y_max,2:x_max),Vq(2:y_max,2:x_max),2:x_max,2:y_max,grid_side_x,grid_side_y,x_max,y_max);

toc

%% GUI at the end
end_gui
end