function [u_star,v_star,ux_star,uy_star,vx_star,vy_star]=very_samll_disp_normal_corr(x,y,u0,v0,ux0,uy0,vx0,vy0,original,deformed,n)
    
    p=0;q=0;r=0;s=0;
    
    [sub_original,rect_original] = imcrop(original,[x-6 y-6 13 13]); % choose the pepper below the onion
    [sub_deformed,rect_deformed] = imcrop(deformed,[x+u0-10 y+v0-10 21 21]); % choose the whole onion
    
    [Xq,Yq] = meshgrid(x-6:1:x+7,y-6:1:y+7);
    Vq = interp2(double(sub_original),Xq,Yq,'cubic');
    % display sub images
%     figure, imshow(sub_original)
%     figure, imshow(sub_deformed)
%     t0=cputime;
    c = normxcorr2(Vq(:,:),sub_deformed(:,:,1));
%     figure, surf(c), shading flat
    
    % offset found by correlation
    [max_c, imax] = max(abs(c(:)));
    [ypeak, xpeak] = ind2sub(size(c),imax(1));
    corr_offset = [(xpeak-size(sub_original,2))
                   (ypeak-size(sub_original,1))];

    % relative offset of position of subimages
    rect_offset = [(rect_deformed(1)-rect_original(1))
                   (rect_deformed(2)-rect_original(2))];

    % total offset
    offset = corr_offset + rect_offset;
%     if(offset(1)> x/5+5)
%         x
%         y
%         u0
%         v0
%         waitforbuttonpress;
%     end
    xoffset = offset(1);
    yoffset = offset(2);
    
    u_star = xoffset;
    v_star = yoffset;
    ux_star = p;
    uy_star = q;
    vx_star = r;
    vy_star = s;
    
    %[u_star,v_star,ux_star,uy_star,vx_star,vy_star]=s_minimun(x,y,xoffset,yoffset,ux0,uy0,vx0,vy0,original,deformed,n);
%     t1=cputime-t0
end
