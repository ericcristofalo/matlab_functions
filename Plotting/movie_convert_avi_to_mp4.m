% Demo to extract frames and get frame means from a movie and save individual frames to separate image files.
% Then rebuilds a new movie by recalling the saved images from disk.
% Also computes the mean gray value of the color channels
% And detects the difference between a frame and the previous frame.
% Illustrates the use of the VideoReader and VideoWriter classes.
% A Mathworks demo (different than mine) is located here http://www.mathworks.com/help/matlab/examples/convert-between-image-sequences-and-video.html

clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
% clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 22;

% Open the rhino.avi demo movie that ships with MATLAB.
% First get the folder that it lives in.
% folder = fileparts(which('rhinos.avi')); % Determine where demo folder is (works with all versions).
% Pick one of the two demo movies shipped with the Image Processing Toolbox.
% Comment out the other one.
% movieFullFileName = fullfile(folder, 'rhinos.avi');
% movieFullFileName = fullfile(folder, 'traffic.avi');
% Check to see that it exists.
if ~exist(movieFullFileName, 'file')
	strErrorMessage = sprintf('File not found:\n%s\nYou can choose a new one, or cancel', movieFullFileName);
	response = questdlg(strErrorMessage, 'File not found', 'OK - choose a new movie.', 'Cancel', 'OK - choose a new movie.');
	if strcmpi(response, 'OK - choose a new movie.')
		[baseFileName, folderName, FilterIndex] = uigetfile('*.avi');
		if ~isequal(baseFileName, 0)
			movieFullFileName = fullfile(folderName, baseFileName);
		else
			return;
		end
	else
		return;
	end
end

try
	videoObject = VideoReader(movieFullFileName)
	% Determine how many frames there are.
	numberOfFrames = videoObject.NumberOfFrames;
	vidHeight = videoObject.Height;
	vidWidth = videoObject.Width;
	
	numberOfFramesWritten = 0;
	% Prepare a figure to show the images in the upper half of the screen.
	figure;
	% 	screenSize = get(0, 'ScreenSize');
	% Enlarge figure to full screen.
	set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
	
	% Create a VideoWriter object to write the video out to a new, different file.
	outputFolder = pwd; % Current folder.
	outputFileName = fullfile(outputFolder, 'NewRhinos.mp4');
	writerObj = VideoWriter(outputFileName, 'MPEG-4');
	open(writerObj);
	
	% Read the frames back in from disk, and convert them to a movie.
	% Preallocate recalledMovie, which will be an array of structures.
	% First get a cell array with all the frames.
	allTheFrames = cell(numberOfFrames,1);
	allTheFrames(:) = {zeros(vidHeight, vidWidth, 3, 'uint8')};
	% Next get a cell array with all the colormaps.
	allTheColorMaps = cell(numberOfFrames,1);
	allTheColorMaps(:) = {zeros(256, 3)};
	% Now combine these to make the array of structures.
	newMovie = struct('cdata', allTheFrames, 'colormap', allTheColorMaps)

	% Loop through the movie, writing all frames out.
	% Each frame will be in a separate file with unique name.
	for frame = 1 : numberOfFrames
		% Extract the frame from the movie structure.
		thisFrame = read(videoObject, frame);
		
		% Display it
		image(thisFrame);
		caption = sprintf('Frame %4d of %d.', frame, numberOfFrames);
		title(caption, 'FontSize', fontSize);
		drawnow; % Force it to refresh the window.
		
		% Convert the image into a "movie frame" structure.
		newMovie(frame) = im2frame(thisFrame);
		% Write this frame out to a new video file.
		writeVideo(writerObj, thisFrame);
		% Increment frame count (should eventually = numberOfFrames
		% unless an error happens).
		numberOfFramesWritten = numberOfFramesWritten + 1;		
	end
	caption = sprintf('Done!  It processed %d frames.', numberOfFramesWritten);
	title(caption, 'FontSize', fontSize);

	close(writerObj);
	
	% Alert user that we're done.
	finishedMessage = sprintf('Done!  It processed %d frames of\n"%s"\nand created MP4 movie\n%s\n\nClick OK to view it.', numberOfFramesWritten, movieFullFileName, outputFileName);
	disp(finishedMessage); % Write to command window.
	uiwait(msgbox(finishedMessage, 'modal')); % Also pop up a message box.

	% Play the movie in the Windows Media Player.
	winopen(outputFileName);
	
	% Create new axes for our movie.
% 	title('Newly Created Movie', 'FontSize', fontSize);
	% Play the movie in the axes.
% 	movie(newMovie);

		
catch ME
	% Some error happened if you get here.
	strErrorMessage = sprintf('Error extracting movie frames from:\n\n%s\n\nError: %s\n\n)', movieFullFileName, ME.message);
	uiwait(msgbox(strErrorMessage));
end

