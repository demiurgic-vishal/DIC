function strain_new(Ux,Uy,x_axis,y_axis,grid_side_x,grid_side_y,x_max,y_max,a)        
%% smoothing to get Ux,Uy at every pixcel

    [Xq,Yq] = meshgrid(1:1/grid_side_x:x_max-1,1:1/grid_side_y:y_max-1);
    Ux(y_max,x_max)
    Ux_smooth = interp2(Ux(2:y_max,2:x_max),Xq,Yq,'bilinear');
    Uy_smooth = interp2(Uy(2:y_max,2:x_max),Xq,Yq,'bilinear');
    
    z_smooth=sqrt(Ux_smooth.^2+Uy_smooth.^2);
    [px_smooth py_smooth] = gradient(z_smooth);
% %     Ux
% %     grid_side_x
% %     grid_side_y
    [Uxx_smooth Uxy_smooth] = gradient(Ux_smooth);
    [Uyx_smooth Uyy_smooth] = gradient(Uy_smooth);


%% moving average
    
%     z = imresize(z_smooth,[y_max/a x_max/a],'bilinear');
%     px = imresize(px_smooth,[y_max/a x_max/a],'bilinear');
%     py = imresize(py_smooth,[y_max/a x_max/a],'bilinear');
    Uxy = imresize(Uxy_smooth,[y_max/a x_max/a],'bilinear');
    Uxx = imresize(Uxx_smooth,[y_max/a x_max/a],'bilinear');
    Uyx = imresize(Uyx_smooth,[y_max/a x_max/a],'bilinear');
    Uyy = imresize(Uyy_smooth,[y_max/a x_max/a],'bilinear');

%     size(Uxx)
%     size(Uyy)
%     size(x_axis)

%% zoom out
    z = imresize(z_smooth,[y_max-1 x_max-1],'bilinear');
    px = imresize(px_smooth,[y_max-1 x_max-1],'bilinear');
    py = imresize(py_smooth,[y_max-1 x_max-1],'bilinear');
    Uxy = imresize(Uxy,[y_max-1 x_max-1],'bilinear');
    Uxx = imresize(Uxx,[y_max-1 x_max-1],'bilinear');
    Uyx = imresize(Uyx,[y_max-1 x_max-1],'bilinear');
    Uyy = imresize(Uyy,[y_max-1 x_max-1],'bilinear');

%% plots

%     figure, contour(x_axis,y_axis,z), hold on, quiver(x_axis,y_axis,Ux(2:y_max,2:x_max),Uy(2:y_max,2:x_max)), hold off,axis ij,axis equal;axis off;title('displacement');    
%     figure, pcolor(x_axis,y_axis,Uxx);shading('interp'),axis ij,axis equal;axis off;title('e_x_x');
%     figure, pcolor(x_axis,y_axis,Uxy);shading('interp'),axis ij,axis equal;axis off;title('e_x_y');
%     figure, pcolor(x_axis,y_axis,Uyx);shading('interp'),axis ij,axis equal;axis off;title('e_y_x');
%     figure, pcolor(x_axis,y_axis,Uyy);shading('interp'),axis ij,axis equal;axis off;title('e_y_y');
%     figure, surf(Uxx);shading('interp');axis equal;
%     figure, surf(Uxx);shading('interp');axis equal;
%     Uxx_mean = mean(mean(Uxx))
%     Uxy_mean = mean(mean(Uxy))
%     Uyx_mean = mean(mean(Uyx))
%     Uyy_mean = mean(mean(Uyy))
    
%% save data
    
save('strain-gradient_data','Uxx', 'Uxy', 'Uyx', 'Uyy','Ux','Uy','x_max','y_max','z','x_axis','y_axis');
% plot_strains('strain-gradient_data',1,1,1,1,1);
end