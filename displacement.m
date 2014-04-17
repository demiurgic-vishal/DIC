function displacement()

original = imread('undeformed.gif');
deformed = imread('deformed1.2.gif');

% [deformed, theta] = rigid_rotation(original,deformed);
[optimizer, metric] = imregconfig('monomodal');
optimizer.MaximumIterations = 300;
optimizer.MinimumStepLength = 5e-4;
deformed1= imregister(deformed,original,'affine',optimizer,metric);
imshow(deformed1);

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
i=9;j=10;
[u(i,j),v(i,j),ux(i,j),uy(i,j),vx(i,j),vy(i,j)]=samll_disp_normal_corr(i*4,j*4,u0,v0,0,0,0,0,original,deformed,n);
t=cputime;
for i=40/4:100/4
    for j=40/4:100/4        
        u0=(u(i-1,j)+u(i,j-1))/((i~=10 || (i==10 && j==10))+(j~=10));
        v0=(v(i-1,j)+v(i,j-1))/((i~=10 || (i==10 && j==10))+(j~=10));
        ux0=(ux(i-1,j)+ux(i,j-1))/2;
        vx0=(vx(i-1,j)+vx(i,j-1))/2;
        uy0=(uy(i-1,j)+uy(i,j-1))/2;
        vy0=(vy(i-1,j)+vy(i,j-1))/2;
        [u(i,j),v(i,j),ux(i,j),uy(i,j),vx(i,j),vy(i,j)]=samll_disp_normal_corr(i*4,j*4,u0,v0,ux0,uy0,vx0,vy0,original,deformed,n);
        e=cputime-t;
        a=a+1;        
        h=waitbar(a/441,h,sprintf('Processing images %d sec remaining...',int32(((e/a)*(441-a)))));
    end
end
(e/a)*256
close(h);
figure(1);
[Xq,Yq] = meshgrid(10:0.1:30);
Vq = interp2(v,Xq,Yq,'linear');
surf(Vq);
[Xq,Yq] = meshgrid(10:0.1:30);
Uq = interp2(u,Xq,Yq,'linear');
figure(2);
surf(Uq);
figure(3);
surf((Vq.^2+Uq.^2).^0.5);
figure(4);
s1=[Vq Uq];
save('deformed1.2_results','s1');

