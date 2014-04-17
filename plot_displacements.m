function plot_displacements(displ_data,plot_x,plot_y,plot_magnitude)

load(displ_data);

[Xq,Yq] = meshgrid(2:0.1:x_max,2:0.1:y_max);
if(plot_y==1)
    Vq_smooth = interp2(Vq,Xq,Yq,'bilinear');
    %figure, surf(Vq,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
    figure('units','normalized','outerposition',[0 0 1 1]), surf(Vq_smooth),shading('interp'),view(2),axis ij, axis equal tight,axis off,title('displacement in Y-direction');
    colorbar;
end

if(plot_x==1)
    Uq_smooth = interp2(Uq,Xq,Yq,'bilinear');
    %figure, surf(Vq,'EdgeColor','none','LineStyle','none','FaceLighting','phong');
    figure('units','normalized','outerposition',[0 0 1 1]), surf(Uq_smooth);shading('interp'),view(2),axis equal tight,axis ij,axis off,title('displacement in X-direction');
    colorbar;
end

if(plot_magnitude==1)
    Vq_smooth = interp2(Vq,Xq,Yq,'bilinear');
    Uq_smooth = interp2(Uq,Xq,Yq,'bilinear');
    figure('units','normalized','outerposition',[0 0 1 1]), surf(sqrt(Uq_smooth.^2+Vq_smooth.^2)),view(2),shading('interp'),axis ij,axis equal tight,axis off,title('magnitude of displacement');
    colorbar;
end

end