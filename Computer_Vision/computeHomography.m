%--------------------------------------------------------------------------
%
% File Name:      computeHomography.m
% Date Created:   2016/04/28
% Date Modified:  2016/05/02
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Compute Homography between two images
%
% Inputs:         descriptorType: string of descriptor type
%                    BRISK
%                    ORB
%                    KAZE
%                    AKAZE
%                    SIFT
%                    SURF
%                    FREAK
%                    BriefDescriptorExtractor
%                    LUCID
%                    LATCH
%                    DAISY
%                 matchType: string of cv.DescriptorMatcher type
%                    BruteForce
%                    BruteForce-SL2
%                    BruteForce-L1
%                    BruteForce-Hamming
%                    BruteForce-HammingLUT'
%                    BruteForce-Hamming(2)
%                    FlannBased
%                 im1: first image
%                 im2: second image
%                 options: cell of options strings
%                    Fundamental:   Computes Fundamental matrix instead of homography
%                    numKeypoints:  SIFT ONLY: [2x1] array of desired keypoints for image 1 and image 2 respectively. 0 indicates no preference.
%                    im1Warped
%                    imKeypoints1
%                    imKeypoints2
%                    imMatches
%                    imHomography
%
% Outputs:        H_12: Homography H_12 (object to scene) or (1 to 2)
%                 outputs: struct of outputs corresponding to input options
%
% Example:        matchType = 'Bruteforce';
%                 descriptorType = 'SIFT';
%                 options = {'im1Warped','imKeypoints1','imKeypoints2','imMatches','imHomography'};
%                 [H_12,ouputs] = computeHomography(matchType, descriptorType, im1, im2, options)
%
%
%--------------------------------------------------------------------------


function [H_12,outputs] = computeHomography(matchType, descriptorType, im1, im2, options)

% Initialization
totalOptions = {'Fundamental',...
                'im1Warped',...
                'imKeypoints1',...
                'imKeypoints2',...
                'imMatches',...
                'imHomography'};
outputs = struct;
matcher = cv.DescriptorMatcher(matchType);
% detector = cv.FeatureDetector(descriptorType);
extractor = cv.DescriptorExtractor(descriptorType);

% Extract Keypoints and Descriptors
% keypoints1 = detector.detect(im1);
% keypoints2 = detector.detect(im2);
% keypoints1 = cv.SIFT(im1,'NFeatures',500);
% keypoints2 = cv.SIFT(im2,'NFeatures',500);
keypoints1 = cv.SURF(im1);
keypoints2 = cv.SURF(im2);
descriptors1 = extractor.compute(im1, keypoints1);
descriptors2 = extractor.compute(im2, keypoints2);

% Match Descriptors: (local, remote) or (object, scene)
queryDescriptors = descriptors1;
trainDescriptors = descriptors2;
matches = matcher.match(queryDescriptors, trainDescriptors);
matchesFinal = matchRefine(matches);
if length(matchesFinal) > 30
   
    % Transform the features for the homography computation
    points1 = ones(length(matchesFinal),3);
    points2 = ones(length(matchesFinal),3);
    for i = 1:length(matchesFinal);
        points1(i,1:2) = keypoints1(matchesFinal(i,1)+1).pt;
        points2(i,1:2) = keypoints2(matchesFinal(i,2)+1).pt;
    end
    
    % Delete homogeneous coordinate
    points1(:,3) = []; points2(:,3) = [];
    
    % RANSAC: Compute Homography: (object, scene) or Homography_12
    srcPoints = reshape(points1,[1,length(points1),2]);
    dstPoints = reshape(points2,[1,length(points2),2]);
    
    % Compute Transformation
    cond = strcmp(totalOptions{1},options);
    if any(cond)
       computeFundamental = 1;
    else
       computeFundamental = 0;
    end
    if computeFundamental~=1
      [H_12,mask] = cv.findHomography(srcPoints,dstPoints,'Method','Ransac','RansacReprojThreshold',2.5);
    else
      [H_12, mask] = cv.findFundamentalMat(srcPoints,dstPoints,'Method','Ransac');
%       output.S = cv.stereoRectify(cameraMatrix1, distCoeffs1, cameraMatrix2, distCoeffs2, imageSize, R, T)
    end
    
    % Finding Inliers
    maskInd = find(mask~=0);
    matchesInliers = zeros(length(maskInd),4);
    for k = 1:length(maskInd)
        ind = maskInd(k);
        matchesInliers(k,:) = matchesFinal(ind,:);
    end
    
    % Other Options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Plot im1Warped Option
    cond = strcmp(totalOptions{2},options);
    if any(cond)
       outputs.im1Warped = cv.warpPerspective(im1, H_12);
    end
    
    % Plot imKeypoints1 Option
    cond = strcmp(totalOptions{3},options);
    if any(cond)
       outputs.imKeypoints1 = cv.drawKeypoints(im1, keypoints1);
    end
    
    % Plot imKeypoints2 Option
    cond = strcmp(totalOptions{4},options);
    if any(cond)
       outputs.imKeypoints2 = cv.drawKeypoints(im2, keypoints2);
    end
    
    % Plot imMatches Option
    cond = strcmp(totalOptions{5},options);
    if any(cond)
       matchesPlotting = struct;
       for i = 1:size(matchesInliers,1)
          matchesPlotting(i).queryIdx = matchesInliers(i,1);
          matchesPlotting(i).trainIdx = matchesInliers(i,2);
          matchesPlotting(i).imgIdx =   matchesInliers(i,3);
          matchesPlotting(i).distance = matchesInliers(i,4);
       end
       outputs.imMatches = cv.drawMatches(im1, keypoints1, im2, keypoints2, matchesPlotting);
%        % Plot Matches By Hand
%         for i=1:length(matchesInliers)
%             p1 = kp1(matchesInliers(i,1)+1).pt;
%             p2 = kp2(matchesInliers(i,2)+1).pt;
%             Image = cv.line(Image, [p1(1)+translation(1), p1(2)+translation(2)], ...
%                 [p2(1)+translation(3), p2(2)+translation(4)], 'Color', [255,150,0], 'Thickness',2);
%             Image=cv.circle(Image, [p1(1)+translation(1), p1(2)+translation(2)], 5, 'Color', [0.0,255,0], 'Thickness',-1);
%             Image=cv.circle(Image, [p2(1)+translation(3), p2(2)+translation(4)], 5, 'Color', [0.0,200,255], 'Thickness',-1);
%             
%         end
    end
    
    % Plot imHomography Option
    cond = strcmp(totalOptions{6},options);
    if any(cond)
       points(1,:,1) = [0,size(im1,2),size(im1,2),0,0];
       points(1,:,2) = [0,0,size(im1,1),size(im1,1),0];
%        points = {[0,0],[size(im1,2),0],[size(im1,2),size(im1,1)],[0,size(im1,1)],[0,0]};
       points = cv.perspectiveTransform(points,H_12);
       outputs.imHomography = uint8(zeros(max(size(im1,1),size(im2,1)),(size(im1,2)+size(im2,2)),3));
       points(1,:,1) = points(1,:,1)+size(im1,2);
       outputs.imHomography(1:size(im1,1),1:size(im1,2),:) = im1;
       outputs.imHomography(1:size(im2,1),size(im1,2)+1:end,:) = im2;
       for i = 1:4
          pt1 = [points(1,i,1),points(1,i,2)];
          pt2 = [points(1,i+1,1),points(1,i+1,2)];
          outputs.imHomography = cv.line(outputs.imHomography, pt1, pt2,'Color',[255,0,0],'Thickness',3);
       end
    end
   
else % not enough matches
   
   error(['Error: Number of matches is less than threshold: ',...
      num2str(length(matchesFinal)),' < 30']);
   
end % if enough matches

end % end function

