function s=correlate(x,y,u,v,ux,uy,vx,vy,f,g,subsize)

num=0.0;denf=0.0;deng=0.0;
n=floor(subsize/2);



for i=-n:n
    for j=-n:n     
        x1=x+i;
        y1=y+j;
        x2=(x1+u+ux*i+uy*j);
        y2=(y1+v+vx*i+vy*j);
        
        %check for index exceeding of f or g
        %let x2,y2 be double and interpolate the data.
%         ff=double(f(x1,y1));
%         gg=double(g(x2,y2));
%         X=x1;
%         Y=y1;
%         if(floor(X)==X && floor(Y)==Y)
             ff=double(f(x1,y1));
%         else
%             ff=double(f(floor(X),floor(Y)))*(ceil(X)-X)*(ceil(Y)-Y)...
%             + double(f(ceil(X),floor(Y))*(X-floor(X)))*(ceil(Y)-Y)...
%             + double(f(floor(X),ceil(Y))*(ceil(X)-X))*(Y-floor(Y))...
%             + double(f(ceil(X),ceil(Y))*(X-floor(X)))*(Y-floor(Y));
%         end
        
        X=x2;
        Y=y2;
        if(floor(X)==X) X=X+0.01;end
        if(floor(Y)==Y) Y=Y+0.01;end
%             gg=double(g(X,Y));
%         else
            gg=double(g(floor(X),floor(Y)))*(ceil(X)-X)*(ceil(Y)-Y)...
            + double(g(ceil(X),floor(Y))*(X-floor(X)))*(ceil(Y)-Y)...
            + double(g(floor(X),ceil(Y))*(ceil(X)-X))*(Y-floor(Y))...
            + double(g(ceil(X),ceil(Y))*(X-floor(X)))*(Y-floor(Y));
%         end
        num = num + ff*gg;
        denf = denf + ff^2;
        deng = deng + gg^2;
    end
end
if(denf==0 && deng==0)  s=0;
else if(denf==0 || deng==0) s=1;
    else
        s = 1-(num/(denf*deng)^0.5);
    end
end

end

