%--------------------------------------------------------------------------
%
% File Name:      squareMap.m
% Date Created:   2014/07/11
% Date Modified:  2014/08/04
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Generates a map of specfied dimensions with random 
%                 colored squares.
%
% Inputs:         sqHeight: height of the squares in pixels
%                 sqWidth: width of the squares in pixels
%                 rows: numbers of squares in vertical direction
%                 columns: numbers of squares in horizontal direction
%                 edgeThickness: thickness of boarder between squares in
%                                pixels
%                 colors: enter desired colors in rgb matrix format
%                         or
%                         enter 0 for random colors
%
% Outputs:        map: final map in MATLAB image format [height,width,3]
%
% Example:        sqHeight = 100;              
%                 sqWidth = 100;
%                 rows = 7;
%                 columns = 7;
%                 edgeThickness = 10;
%                 colors = [1,0,0;0,1,0;0,0,1;1,1,1];
%                 map = squareMap(sqHeight, sqWidth, rows, columns,...
%                       edgeThickness,colors);
%                 imshow(map)
%
%--------------------------------------------------------------------------


%% squareMap

function map = squareMap(sqHeight, sqWidth, rows, columns, edgeThickness,colors)

% Initialize Image
imH = sqHeight*rows+(rows+1)*edgeThickness;
imW = sqWidth*columns+(columns+1)*edgeThickness;
map = zeros(imH,imW,3);

% Calculate Region Positions
indH = zeros(rows*sqHeight,2);
for i = 1:rows
   for k = 1:sqHeight
      ind = (i-1)*sqHeight+k;
      indH(ind,1) = (edgeThickness*i)+sqHeight*(i-1)+k;
      indH(ind,2) = i;
   end
end
indW = zeros(columns*sqWidth,2);
for i = 1:columns
   for k = 1:sqWidth
      ind = (i-1)*sqWidth+k;
      indW(ind,1) = (edgeThickness*i)+sqWidth*(i-1)+k;
      indW(ind,2) = i;
   end
end

% Initialize Random Region Colors
if colors==0
   sqColor = rand(rows,columns*3);
else
   sqColor = zeros(rows,columns*3);
   for i = 1:rows
      for j = 1:columns
         colorInd = ceil(rand(1)*length(colors));
         for k = 1:3
            sqColor(i,3*(j-1)+k) = colors(colorInd,k);
         end
      end
   end
end

% Fill Image
for i = 1:imH
   for j = 1:imW
      checkH = find(indH(:,1)==i);
      checkW = find(indW(:,1)==j);
      if ~isempty(checkH) && ~isempty(checkW)
         indColor = [indH(checkH,2),indW(checkW,2)];
         for k = 1:3
            map(i,j,k) = sqColor(indColor(1),(3*(indColor(2)-1)+k));
         end
      end
   end
end

end


%% Scrap

% Calculate Boarder Position
% edgeNumH = zeros((rows+1)*edgeThickness,1);
% for i = 0:rows
%    for k = 1:edgeThickness
%       edgeNumH((i+1)*edgeThickness+(k-edgeThickness)) = (i*height)+(i*edgeThickness)+k;
%    end
% end
% edgeNumW = zeros((columns+1)*edgeThickness,1);
% for i = 0:columns
%    for k = 1:width
%       edgeNumW((i+1)*edgeThickness+(k-edgeThickness)) = (i*width)+(i*edgeThickness)+k;
%    end
% end
