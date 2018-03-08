function recovered=RSAFM(original,distorted)

%show image
figure, imshowpair(original(:,:,3:-1:1), distorted(:,:,3:-1:1), 'montage')
title('Unregistered')
figure, imshowpair(original(:,:,3:-1:1), distorted(:,:,3:-1:1),'ColorChannels','red-cyan')
title('Unregistered')
inlier_n=1;
MetricThreshold=5500;
while((inlier_n<20)&&(MetricThreshold>0))
%Detect features in both images.
MetricThreshold=MetricThreshold-500;
ptsOriginal  = detectSURFFeatures(original(:,:,1),'MetricThreshold',MetricThreshold);
ptsDistorted = detectSURFFeatures(distorted(:,:,1),'MetricThreshold',MetricThreshold);
%Extract feature descriptors.
[featuresOriginal,   validPtsOriginal]  = extractFeatures(original(:,:,1),ptsOriginal );
[featuresDistorted, validPtsDistorted]  = extractFeatures(distorted(:,:,1),ptsDistorted );
%Match features by using their descriptors.
indexPairs = matchFeatures(featuresOriginal, featuresDistorted);
%Retrieve locations of corresponding points for each image.
matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));
figure;
showMatchedFeatures(original(:,:,3:-1:1),distorted(:,:,3:-1:1),matchedOriginal,matchedDistorted);
title('Putatively matched points (including outliers)');
% Transform estimate
[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(matchedDistorted, matchedOriginal, 'affine');
inlier_n=size(inlierDistorted,1);
end
% calulate RMSE
error=calerror(inlierDistorted,inlierOriginal,tform);
fprintf('matchfeature number =%d  RMSE is %0.4f\n',inlierDistorted.Count,error)
%Display matching point pairs used in the computation of the transformation matrix.
figure;
showMatchedFeatures(original(:,:,3:-1:1),distorted(:,:,3:-1:1), inlierOriginal, inlierDistorted);
title('Matching points (inliers only)');
% legend('ptsOriginal','ptsDistorted');
% Compute the inverse transformation matrix.
Tinv  = tform.T
ss = Tinv(2,1);
sc = Tinv(1,1);
scale_recovered = sqrt(ss*ss + sc*sc)
theta_recovered = atan2(ss,sc)*180/pi
%Recover the original image by transforming the distorted image.
outputView = imref2d(size(original));
recovered  = imwarp(distorted,tform,'linear','OutputView',outputView);
%Compare recovered to original by looking at them side-by-side in a montage.
% figure, imshowpair(original(:,:,1:3),recovered(:,:,1:3),'ColorChannels','red-cyan')
% title('Adjusted in linear')
end
function error=calerror(inlierDistorted,inlierOriginal,tform)
squaresum=[0;0];
    T=zeros(3);
    T(1:2,1:2)=tform.T(1:2,1:2);
    T(:,3)=tform.T(3,:)';
    T(3,:)=[0,0,1];
for i=1:inlierDistorted.Count
    xy=[inlierDistorted.Location(i,:),1]';
    mn=[inlierOriginal.Location(i,:),1]';
    uv(:,i)=T*xy;
squaresum=squaresum+(uv(1:2,i)-mn(1:2)).^2;
end
error=sqrt(double(sum(squaresum)))/inlierDistorted.Count;
end
