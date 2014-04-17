function [movingRegistered, theta_recovered] = rigid_rotation(fixed,moving);

imshowpair(fixed, moving,'Scaling','joint');
[optimizer, metric] = imregconfig('monomodal');
optimizer.MaximumIterations = 300;
optimizer.MinimumStepLength = 5e-4;
[movingRegistered , tform]= dic_imregister(moving,fixed,'rigid',optimizer,metric);

T=tform.tdata.T';
figure
imshowpair(fixed, movingRegistered,'Scaling','joint');

ss = T.tdata.Tinv(2,1);
sc = T.tdata.Tinv(1,1);
theta_recovered = atan2(ss,sc)*180/pi;

end