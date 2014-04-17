function plot_strains(strain_data,plot_uxx,plot_uxy,plot_uyx,plot_uyy,plot_displ_direction)

load(strain_data);

if(plot_uxx==1)    
    figure('units','normalized','outerposition',[0 0 1 1]), surf(x_axis,y_axis,Uxx);view(2);shading('interp'),axis ij,axis equal tight;axis off;title('e_x_x');
    colorbar;
end

if(plot_uxy==1)
    figure('units','normalized','outerposition',[0 0 1 1]), surf(x_axis,y_axis,Uxy);view(2);shading('interp'),axis ij,axis equal tight;axis off;title('e_x_y');
    colorbar;
end

if(plot_uyx==1)
    figure('units','normalized','outerposition',[0 0 1 1]), surf(x_axis,y_axis,Uyx);view(2);shading('interp'),axis ij,axis equal tight;axis off;title('e_y_x');
    colorbar;
end

if(plot_uyy==1)
    figure('units','normalized','outerposition',[0 0 1 1]), surf(x_axis,y_axis,Uyy);view(2);shading('interp'),axis ij,axis equal tight;axis off;title('e_y_y');
    colorbar;
end

if(plot_displ_direction==1)
    figure('units','normalized','outerposition',[0 0 1 1]), contour(x_axis,y_axis,z), hold on, quiver(x_axis,y_axis,Ux(2:y_max,2:x_max),Uy(2:y_max,2:x_max)), hold off,axis ij,axis equal;axis off;title('displacement');    
end

end