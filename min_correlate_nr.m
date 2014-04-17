function [u_star,v_star,F] = min_correlate_nr(x,y,u,v,ux0,uy0,vx0,vy0,original,deformed)
% tic;

F0 = [ux0 uy0 vx0 vy0];
% A = [-1 0 0 0;...
%       1 0 0 0;...
%       0 -1 0 0;...
%       0 1 0 0;...
%       0 0 -1 0;...
%       0 0 1 0;...
%       0 0 0 -1;...
%       0 0 0 -1 ];
% b = [-0.5;0.5;-0.5;0.5;-0.5;0.5;-0.5;0.5];
%options = optimset('fmincon','Algorithm','active-set');
[F,fval] = fminsearch(@nr_fun1,F0);%,[],[],[],[],[-0.3 -0.3 -0.3 -0.3],[0.3 0.3 0.3 0.3],[]);
% fval
u_star = u;
v_star = v;


function corr = nr_fun1(e)
        
        tform = maketform('affine',inv([1+e(1) e(2) 0; e(3) 1+e(4) 0; 0 0 1]));
        f = imtransform(deformed,tform);
%         if(~(size(f) < size(deformed)))                 
%             f = imcrop(original,[(size(original)./2 - size(deformed)./2) size(deformed)]);
%         end       
        c = normxcorr2(original,f);
        a = max((c(:)));      
        corr = a;     
end
% toc
end