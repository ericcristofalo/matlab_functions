%--------------------------------------------------------------------------
%
% File Name:      generateCalibrationBoard.m
% Date Created:   2018/12/13
% Date Modified:  2018/12/13
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    
%
%--------------------------------------------------------------------------

%% Inputs

board_size = [6,8];
square_size = 0.06; % meters
border_size = 0.06; % in pixels
dpi = 200;

plot_optitrack_circles = true;
plot_optitrack_crosshairs = true;
plot_chessboard_type_string = true;
save_image = false;

square_size_pixels = ceil(square_size*39.3701*dpi); % in pixels
border_size_pixels = ceil(border_size*39.3701*dpi); % in pixels
resolution = square_size_pixels*board_size + 2*border_size_pixels;


%% Generate Calibration Pattern

% Generate Chessboard
image = ones(resolution)*255;
chess_pixel_width = (0:board_size(1,2))*square_size_pixels + border_size_pixels;
chess_pixel_height = (0:board_size(1,1))*square_size_pixels + border_size_pixels;
square_ind_rows = 0;
square_ind = 0;
figure(1); clf(1); imshow(image); hold on;
for i = 1:board_size(1,2)
   
   % Flip Color of Top Row
   if ( square_ind_rows )
      square_ind_rows = 0;
      square_ind = 1;
   else
      square_ind_rows = 1;
      square_ind = 0;
   end
   
   % Generate Color Square
   for j = 1:board_size(1,1)
      if ( square_ind )
         % OpenCV Method
%          image(...
%             chess_pixel_height(j):chess_pixel_height(j+1)-1, ...
%             chess_pixel_width(i):chess_pixel_width(i+1)-1   ) = 0;
         % MATLAB Method
         rectangle('Position',...
            [chess_pixel_width(i),chess_pixel_height(j) square_size_pixels square_size_pixels],...
            'FaceColor',[0,0,0],'EdgeColor','none')
         square_ind = 0;
      else
         square_ind = 1;
      end
   end

end

% Add Optitrack Marker Positions
corner_poses = [1,1,0;
                1,board_size(1,2)+1,0
                board_size(1,1)+1,1,0;
                board_size(1,1)+1,board_size(1,2)+1,0];
for i = 1:size(corner_poses,1)
   % Find Center
   ind_h = corner_poses(i,1);
   ind_w = corner_poses(i,2);
   center = [chess_pixel_width(ind_w),...
             chess_pixel_height(ind_h)];
   % Plot Circle
   radius = square_size_pixels/3;
   thickness = 20;
   if (plot_optitrack_circles)
%       % OpenCV Method
%       image = cv.circle(image, center, radius, ...
%                         'Color',[255,255,255]*corner_poses(i,3), ...
%                         'Thickness',thickness);
      % MATLAB Method
      theta = 0:pi/100:2*pi;
      x_circle = radius*cos(theta) + center(1,1);
      y_circle = radius*sin(theta) + center(1,2);
      plot(x_circle, y_circle,...
         'Color',[1,1,1]*corner_poses(i,3),...
         'LineWidth',3);
   end
   % Plot Crosshairs
   if (plot_optitrack_crosshairs)
      length = radius + square_size_pixels/4;
      dir_small = [+1,0;0,+1];
      dir_large = [-1,0;0,-1];
      for j = 1:2
%          % OpenCV Method
%          image = cv.line(image, ...
%                          center+dir_small(j,:)*length, center+dir_large(j,:)*length,...
%                          'Color',[255,255,255]*corner_poses(i,3),...
%                          'Thickness',thickness/2);
         % MATLAB Method
         plot_line = [center+dir_small(j,:)*length; center+dir_large(j,:)*length];
         plot(plot_line(:,1), plot_line(:,2),...
            'Color',[1,1,1]*corner_poses(i,3),'LineWidth',1.5)
      end
   end
end

% Plot Text on Image of Chessboard Type
if (plot_chessboard_type_string)
   string_text = ['Camera Calibration Pattern: ',num2str(board_size(1,1)),' x '...
                  num2str(board_size(1,2)),'. Square Size: ', ...
                  num2str(square_size),' meters.'];
   height_offset = 80;
% 	% OpenCV Method
%    bottom_left_pixel = [chess_pixel_width(1,1),chess_pixel_height(1,end)+100];
%    image = cv.putText(image, string_text, bottom_left_pixel,...
%                       'FontFace','HersheyDuplex',...
%                       'FontScale',3,...
%                       'Thickness',3,...
%                       'BottomLeftOrigin',false);
   % MATLAB Method
   mid_left_pixel = [chess_pixel_width(1,1)+180,chess_pixel_height(1,end)+height_offset];
   text(mid_left_pixel(1,1),mid_left_pixel(1,2),string_text,'FontName','Helvetica Neue')
   % MSL Text
   string_text = ['Multi-robot Systems Laboratory at Stanford University'];
   mid_left_pixel = [2630,chess_pixel_height(1,end)+height_offset];
   text(mid_left_pixel(1,1),mid_left_pixel(1,2),string_text,'FontName','Helvetica Neue')
end

% Plot Image
hold off;

% Save Image
if ( save_image )
   saveFigures('FigureRange',1,'Names',{'chessboard'},'Extension','pdf');
end

