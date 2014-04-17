function [K theta_recovered] = feature_matching(original,distorted)
%% feature_matching
tic;
ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);
%Extract feature descriptors.

[featuresIn   validPtsIn]  = extractFeatures(original,  ptsOriginal);
[featuresOut validPtsOut]  = extractFeatures(distorted, ptsDistorted);
%Match features by using their descriptors.

index_pairs = matchFeatures(featuresIn, featuresOut);
%Retrieve locations of corresponding points for each image.

matchedOriginal  = validPtsIn(index_pairs(:,1));
matchedDistorted = validPtsOut(index_pairs(:,2));
%Show putative point matches.

% cvexShowMatches(original,distorted,matchedOriginal,matchedDistorted);
% title('Putatively matched points (including outliers)');

gte = vision.GeometricTransformEstimator; % defaults to RANSAC
gte.Transform = 'affine';
gte.NumRandomSamplingsMethod = 'Desired confidence';
gte.MaximumRandomSamples = 1000;
gte.DesiredConfidence = 99.8;

% Compute the transformation from the distorted to the original image.
[tform_matrix inlierIdx] = step(gte, matchedDistorted.Location, ...
    matchedOriginal.Location);
%Display matching point pairs used in the computation of the transformation matrix.

% cvexShowMatches(original,distorted,matchedOriginal(inlierIdx),...
%     matchedDistorted(inlierIdx),'ptsOriginal','ptsDistorted');
% title('Matching points (inliers only)');

tform_matrix = cat(2,tform_matrix,[0 0 1]'); % pad the matrix
tinv  = inv(tform_matrix);

ss = tinv(2,1);
sc = tinv(1,1);
scale_recovered = sqrt(ss*ss + sc*sc);
[ss sc];
theta_recovered = atan2(ss,sc)*180/pi;

%% image_recovery

% original_xy = double(matchedOriginal(inlierIdx).Location);
% distorted_xy = double(matchedDistorted(inlierIdx).Location);
% size(original_xy)
% mean(original_xy(1:size(original_xy,1)/3,:))
% o_xy=[mean(original_xy(1:size(original_xy,1)/3,:));...
%         mean(original_xy(size(original_xy,1)/3+1:size(original_xy,1)*2/3,:));...
%         mean(original_xy(size(original_xy,1)*2/3+1:size(original_xy,1),:))];
% 
% d_xy=[mean(distorted_xy(1:size(distorted_xy,1)/3,:));...
%             mean(distorted_xy(size(distorted_xy,1)/3+1:size(distorted_xy,1)*2/3,:));...
%             mean(distorted_xy(size(distorted_xy,1)*2/3+1:size(distorted_xy,1),:))];
% 
% 
% 
% tform = maketform('affine',d_xy,o_xy);
% J = imtransform(distorted,tform);
% figure(1);
% imshow(original), figure(2), imshow(J);

K=imrotate(distorted, -double(theta_recovered), 'bicubic', 'crop');
figure(23), imshowpair(original,K);

toc
end