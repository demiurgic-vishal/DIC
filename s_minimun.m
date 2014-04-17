function [u_star,v_star,ux_star,uy_star,vx_star,vy_star]=s_minimun(x,y,u0,v0,ux0,uy0,vx0,vy0,original,deformed,n)

%correlate(x,y,u,v,ux,uy,vx,vy,f,g,subsize)
a_prev=100000;
u_star=u0;
v_star=v0;
%% correlation for finding displacement

% for u=-1:0.2:1
%     for v=-1:0.2:1
%             a=correlate(x,y,u+u0,v+v0,ux0,uy0,vx0,vy0,original,deformed,n);
%             if(a_prev>a) 
%                 a_prev=a;
%                 u_star=u+u0;
%                 v_star=v+v0;
%                 ux_star=ux0;
%                 vy_star=vy0;
%                 uy_star=uy0;
%                 vx_star=vx0;
%             end
%     end
% end

%% correlation for finding e_xx and e_yy

for ux=-0.5:0.1:0.5
    for vy=-0.5:0.1:0.5
        tform = maketform('affine',[1+ux 0 0; 0 1+vy 0; 0 0 1]);
        f = imtransform(original,tform);
        c = normxcorr2(f,deformed);
        a = max(abs(c(:)));
        %a=correlate(x,y,u_star,v_star,ux+ux0,uy0,vx0,vy+vy0,original,deformed,n);
        if(a_prev>a) 
            a_prev=a;
            ux_star=ux+ux0;
            vy_star=vy+vy0;
            uy_star=uy0;
            vx_star=vx0;  
        end
    end
end

%% correlation for finding e_xy and e_yx

% for uy=-0.5:0.1:0.5
%     vx=uy;        
%     
%     a=correlate(x,y,u_star,v_star,ux_star,uy+uy0,vx+vx0,vy_star,original,g,n);
%     if(a_prev>a) 
%         a_prev=a;         
%         uy_star=uy+uy0;
%         vx_star=vx+vx0;            
%     end
% end
% a_prev
% u_star
% v_star
% ux_star
% uy_star
% vx_star
% vy_star
end