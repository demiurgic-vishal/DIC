function strain(Ux,Uy,x_axis,y_axis,grid_side_x,grid_side_y,x_max,y_max)        
%% smoothing to get Ux,Uy at every pixcel
%     grid_side_x,grid_side_y
    x_axis,y_axis
    [Xq,Yq] = meshgrid(1:1/grid_side_x:x_max-1,1:1/grid_side_y:y_max-1);
    Ux(y_max,x_max)
    Ux_smooth = interp2(Ux(2:y_max,2:x_max),Xq,Yq,'bilinear')
    Uy_smooth = interp2(Uy(2:y_max,2:x_max),Xq,Yq,'bilinear');
    figure, surf(Ux_smooth);
    figure, surf(Uy_smooth);
    z_smooth=sqrt(Ux_smooth.^2+Uy_smooth.^2);
    [px_smooth py_smooth] = gradient(z_smooth);
% %     Ux
% %     grid_side_x
% %     grid_side_y
    [Uxx_smooth Uxy_smooth] = gradient(Ux_smooth);
    [Uyx_smooth Uyy_smooth] = gradient(Uy_smooth);


%% moving average
    z = imresize(z_smooth,[y_max-1 x_max-1],'bilinear');
    px = imresize(px_smooth,[y_max-1 x_max-1],'bilinear');
    py = imresize(py_smooth,[y_max-1 x_max-1],'bilinear');
    Uxy = imresize(Uxy_smooth,[y_max-1 x_max-1],'bilinear');
    Uxx = imresize(Uxx_smooth,[y_max-1 x_max-1],'bilinear');
    Uyx = imresize(Uyx_smooth,[y_max-1 x_max-1],'bilinear');
    Uyy = imresize(Uyy_smooth,[y_max-1 x_max-1],'bilinear');

%     size(Uxx)
%     size(Uyy)
%     size(x_axis)

%% plots

    figure, contour(x_axis,y_axis,z), hold on, quiver(x_axis,y_axis,px,py), hold off;axis equal;title('displacement');    
    figure, pcolor(Uxx);shading('interp');axis equal;axis off;title('e_x_x');
    figure, pcolor(Uxy);shading('interp');axis equal;axis off;title('e_x_y');
    figure, pcolor(Uyx);shading('interp');axis equal;axis off;title('e_y_x');
    figure, pcolor(Uyy);shading('interp');axis equal;axis off;title('e_y_y');
%     figure, surf(Uxx);shading('interp');axis equal;
%     figure, surf(Uxx);shading('interp');axis equal;
    Uxx_mean = mean(mean(Uxx))
    Uxy_mean = mean(mean(Uxy))
    Uyx_mean = mean(mean(Uyx))
    Uyy_mean = mean(mean(Uyy))
    

%% moving average
    z = imresize(z_smooth,[y_max/a x_max/a],'bilinear');
    px = imresize(px_smooth,[y_max/a x_max/a],'bilinear');
    py = imresize(py_smooth,[y_max/a x_max/a],'bilinear');
    Uxy = imresize(Uxy_smooth,[y_max/a x_max/a],'bilinear');
    Uxx = imresize(Uxx_smooth,[y_max/a x_max/a],'bilinear');
    Uyx = imresize(Uyx_smooth,[y_max/a x_max/a],'bilinear');
    Uyy = imresize(Uyy_smooth,[y_max/a x_max/a],'bilinear');

%     size(Uxx)
%     size(Uyy)
%     size(x_axis)

%% plots

    figure, contour(x_axis,y_axis,z), hold on, quiver(x_axis,y_axis,px,py), hold off;axis equal;title('displacement');    
    figure, pcolor(Uxx);shading('interp');axis equal;axis off;title('e_x_x');
    figure, pcolor(Uxy);shading('interp');axis equal;axis off;title('e_x_y');
    figure, pcolor(Uyx);shading('interp');axis equal;axis off;title('e_y_x');
    figure, pcolor(Uyy);shading('interp');axis equal;axis off;title('e_y_y');
%     figure, surf(Uxx);shading('interp');axis equal;
%     figure, surf(Uxx);shading('interp');axis equal;
    Uxx_mean = mean(mean(Uxx))
    Uxy_mean = mean(mean(Uxy))
    Uyx_mean = mean(mean(Uyx))
    Uyy_mean = mean(mean(Uyy))
%     save('Ux','Ux');
end