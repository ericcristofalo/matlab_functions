%--------------------------------------------------------------------------
%
% File Name:      matrix2textfile.m
% Date Created:   2017/02/27
% Date Modified:  2017/02/27
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Exports matrix to text file using desired write
%                 convention
%
% Inputs:         
%
% Outputs:        
%
%--------------------------------------------------------------------------

clean('Figures',0);

%% Export Matrix to Textfile

% Desired Matrix
mat = flipud(round(255*jet(256)));

% Output File Location
outputFolderPath = '/Users/ericcristofalo/Desktop/matrix.txt';

% Save Transformations to a Text File
fileID = fopen(outputFolderPath,'w');
for i = 1:size(mat,1)
   for j = 1:size(mat,2)
      fprintf(fileID,'%4.0f',mat(i,j));
      fprintf(fileID,', ');
   end
%    fprintf(fileID,';');
   fprintf(fileID,'\n');
end
fclose(fileID);
