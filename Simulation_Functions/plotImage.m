%--------------------------------------------------------------------------
%
% File Name:      plotImage.m
% Date Created:   2014/11/15
% Date Modified:  2014/11/15
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Plots cartesian coordinate system given position w.r.t a
%                 global coordinate system.
%
% Inputs:         pixelPoints: [4xn] matrix with point coordinates in the
%                              pixel (image) coordinate frame.
%                 imTrackPoints: [4xm] matrix with point coordinates of 
%                                desired trackes points in the pixel
%                                (image) coordinate frame.
%                 plotSize: virtual size of image [0 640 0 480]
%                 pointColor: vector denoting the color of image points
%                 trackPointColor: vector denoting the color of tracked 
%                                  image points.
%
% Outputs:        plot
%
% Example:        plotImage([4xn], [4xm], [], [0,0,1], [1,0,0])
%
%--------------------------------------------------------------------------

function plotImage(pixelPoints, imTrackPoints, plotSize, pointColor, trackPointColor)

% Plot Virtual Image
box on;
plot(pixelPoints(1,:),pixelPoints(2,:),'Color',pointColor,...
     'LineStyle','none','Marker','.');
scatter(imTrackPoints(1,:),imTrackPoints(2,:),20,trackPointColor,'fill');
axis equal;
axis(plotSize);

end

