%% Eric Cristofalo
% 2014/04/07
% Sorting and Removing Duplicate Matches from OpenCV Matching Algorithm
%
% INPUTS: matches - point match structure given from OpenCV match
%
% OUTPUTS: matchesFinal - sorted and unique match indices
%
% EXAMPLE: matches = matcher.match(queryDescriptors, trainDescriptors); 
%          matchesFinal = matchRefine(matches) % refined matches
%          % Save Final Match Points in Array
%          points1 = zeros(length(matchesFinal),2);
%          points2 = zeros(length(matchesFinal),2);
%          for i = 1:length(matchesFinal);
%             points1(i,:) = keypoints1(matchesFinal(i,1)+1).pt;
%             points2(i,:) = keypoints2(matchesFinal(i,2)+1).pt;
%          end
%          % RANSAC: Determine Homography
%          srcPoints = reshape(points1,[1,length(points1),2]);
%          dstPoints = reshape(points2,[1,length(points2),2]);
%          [H12, mask] = cv.findHomography(srcPoints, dstPoints,'Method','Ransac');

%% Function
function [matchesFinal] = matchRefine(matches)

%%% Obtain Match Array

matchesGood = zeros(length(matches),4);
for i = 1:length(matches);
   matchesGood(i,1) = matches(i).queryIdx;
   matchesGood(i,2) = matches(i).trainIdx;
   matchesGood(i,3) = matches(i).imgIdx;
   matchesGood(i,4) = matches(i).distance;
end

%%% Remove Duplicate Matches

[trainSort,indSort] = sort(matchesGood(:,2));
matchesFinal = zeros(length(unique(matchesGood(:,2))),4);
iFinal = 1; % final matrix index
check = [0,0,0]; % temporary check matrix [trainIdx,distance,checkSize]

for i = 1:length(matches)
   
   if i~=length(matches) && trainSort(i)==trainSort(i+1) % there is a duplicate
      check(check(end,3)+1,:) = [indSort(i),...
         matchesGood(indSort(i),4),check(end,3)+1]; % save distance data
   elseif i~=length(matches) && trainSort(i)~=trainSort(i+1) % end of the duplicates
      
      if sum(check)~=0 % finish check matrix
         check(check(end,3)+1,:) = [indSort(i),...
            matchesGood(indSort(i),4),check(end,3)+1]; % save distance data
         [smallest,indSmallest] = min(check(:,2)); % choose best duplicate
         matchesFinal(iFinal,:) = [matchesGood(check(indSmallest),1),...
            trainSort(i),matchesGood(check(indSmallest),3),...
            matchesGood(check(indSmallest),4)]; % add to final matrix
         iFinal = iFinal+1; % raise final matrix index
         check = [0,0,0]; % reset check matrix
      else % simply add to final matrix
         matchesFinal(iFinal,:) = [matchesGood(indSort(i),1),...
            trainSort(i),matchesGood(indSort(i),3),...
            matchesGood(indSort(i),4)]; % add to final matrix
         iFinal = iFinal+1; % raise final matrix index
      end
      
   else
      matchesFinal(iFinal,:) = [matchesGood(indSort(i),1),...
         trainSort(i),matchesGood(indSort(i),3),...
         matchesGood(indSort(i),4)]; % add to final matrix
   end
   
end

end