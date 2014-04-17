function resize()

    original = imread('example.gif');
    %imshow(original);
    scale = 0.7;
    distorted = imresize(original,scale); % Try varying the scale factor.

    theta = 30;
    distorted = imrotate(distorted,theta); % Try varying the angle, theta.
    %figure, imshow(distorted)
    input_points = [151.52  164.79; 131.40 79.04];
    base_points = [135.26  200.15; 170.30 79.30];
    cpselect(distorted,original,input_points,base_points);
    t = cp2tform(input_points,base_points,'affine');
    ss = t.tdata.Tinv(2,1);
    sc = t.tdata.Tinv(1,1);
    scale_recovered = sqrt(ss*ss + sc*sc)
    theta_recovered = atan2(ss,sc)*180/pi
end