function [u_star,v_star,ux_star,uy_star,vx_star,vy_star]=samll_disp_normal_corr(x,y,u0,v0,ux0,uy0,vx0,vy0,original,deformed,n,sn)
    
    [sub_original,rect_original] = imcrop(original,[x-sn y-sn 2*sn+1 2*sn+1]); % choose the pepper below the onion
    [sub_deformed,rect_deformed] = imcrop(deformed,[x+u0-2*sn y+v0-2*sn 4*sn+1 4*sn+1]); % choose the whole onion

    if(size(sub_original)<size(sub_deformed))
        
%         figure(11);
%         imshowpair(sub_original,sub_deformed);title([x,y;u0,v0]);
        c = normxcorr2(sub_original(:,:,1),sub_deformed(:,:,1));
%         size(c)
%         waitforbuttonpress;
        
        % centrally weighing the matrix c
%         Rweight_offset=0.4;
        s_c=size(c);
%         w = linspace(1-weight_offset,1+weight_offset,s_c(1));       
%         w=w.*fliplr(w);
%         h = linspace(1-weight_offset,1+weight_offset,s_c(2));     
%         h=h.*fliplr(h);
        w=[linspace(0.8,1,ceil(s_c(1)/2)) linspace(1,0.8,floor(s_c(1)/2))];
        h=[linspace(0.8,1,ceil(s_c(2)/2)) linspace(1,0.8,floor(s_c(2)/2))];
        c = c.*(w'*h);
%          figure(100), surf(c), shading flat
        
        % offset found by correlation
%         [max_c, imax] = max(abs(c(:)));
%         [ypeak, xpeak] = ind2sub(size(c),imax(1));
        p = peakfit2d(c);
        ypeak  = p(1);xpeak = p(2);        
        
        corr_offset = [(xpeak-size(sub_original,2))
                       (ypeak-size(sub_original,1))];
                   
        % relative offset of position of subimages
        rect_offset = [(rect_deformed(1)-rect_original(1))
                       (rect_deformed(2)-rect_original(2))];

        % total offset
        offset = double(corr_offset + rect_offset);
                   
        xoffset = offset(1);
        yoffset = offset(2);

        u_star = xoffset;
        v_star = yoffset;
        ux_star = ux0;
        uy_star = uy0;
        vx_star = vx0;
        vy_star = vy0;

%         [~,~,F]=min_correlate_nr(size(sub_original)/2+1,(sub_deformed)/2+1,corr_offset(1),corr_offset(1)...
%                                                             ,ux0,uy0,vx0,vy0,sub_original,sub_deformed);
%         ux_star = F(1);
%         uy_star = F(2);
%         vx_star = F(3);
%         vy_star = F(4);         
        
%         if(offset(1)> x/5+5 || offset(1)<0)
%             x
%             y
%             u0
%             v0
%             
%                 offset
%                 figure(21);
%                 surf(c);
%                 figure(9);
%                 imshow(deformed)                     % update image
%                 hold on
%                 plot(x,y,'g+')                                % plot start position of raster                
%                 plot(x+u0,y+v0,'r+');        % plot actual postition of raster
%                 plot(x+offset(1),y+offset(2),'b+');        % plot actual postition of raster
%                 hold off
%                 drawnow
%                 waitforbuttonpress;
%         end
        
        
    else
        u_star = u0;
        v_star = v0;
        ux_star = ux0;
        uy_star = uy0;
        vx_star = vx0;
        vy_star = vy0;
    end
%      [u_star,v_star,ux_star,uy_star,vx_star,vy_star]=s_minimun(x,y,xoffset,yoffset,ux0,uy0,vx0,vy0,original,deformed,n);
%     t1=cputime-t0
end
