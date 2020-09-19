%--------------------------------------------------------------------------
%
% File Name:      starup.m
% Date Created:   2013/09/03
% Date Modified:  2018/04/05
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    My MATLAB's default start program
%
% Inputs:         
%
% Outputs:        
%
%--------------------------------------------------------------------------

% warning on backtrace
% warning on

%% Add Paths

% Add My Own MATLAB Functions
directory = '/home/ericcristofalo/Documents/matlab_functions/matlab_functions';
folders = dir(directory);
init = 0;
pathToAdd = [directory,':'];
for i = 1:length(folders)
   if ( ~strcmp(folders(i).name(1),'.') )
%       if (init==0)
%          pathToAdd = genpath([folders(i).folder,'/',folders(i).name]);
%          init = 1;
%       else
      if ( folders(i).isdir==1 )
         pathToAdd = [pathToAdd,genpath([folders(i).folder,'/',folders(i).name])];
      end
   end
end
addpath(pathToAdd);

% Mexopencv
% addpath(genpath('/Users/ericcristofalo/Dropbox/PhD/Research/Open_Source/mexopencv'));

% % CVX
% cvx_path = '/Users/ericcristofalo/Dropbox/PhD/Research/Open_Source/cvx';
% addpath(genpath(cvx_path));
% rmpath([cvx_path,'/lib/narginchk_:']); % to fix interference with Matlab's legend function

% addpath(genpath('/Users/ericcristofalo/Dropbox/PhD/Research/Open_Source/pdfcrop_v0.4b'));

% For Issues with Paths
% restoredefaultpath
% savepath


%% Set Default Current Working Directory

cd /home/ericcristofalo/Documents


%% Set MATLAB Variables

% userpath = '/Users/ericcristofalo/Dropbox/PhD/Research/Functions/matlab_functions/MATLAB';


%% Friendly Welcome Message

clc;

% Current Time
curTime = clock; %[year month day hour minute seconds]

% Months
months = {'January','February','March','April','May','June',...
          'July','August','September','October','November','December'};
monthStr = months{curTime(2)};

% Days
if curTime(3)==11 || curTime(3)==12 || curTime(3)==13
    % special cases
    ending = 'th';
elseif rem((curTime(3)-1),10)==0
    % first
    ending = 'st';
elseif rem((curTime(3)-2),10)==0
    % second
    ending = 'nd';
elseif rem((curTime(3)-3),10)==0
    % third
    ending = 'rd';
else
    % zeroth and fourth through nineth
    ending = 'th';
end

% Hours
if curTime(4)>=0 && curTime(4)<=11
    hour = 'am';
    if curTime(4)==0
        curTime(4) = 12;
    end 
else
    if curTime(4)==12
    else
        curTime(4) = curTime(4)-12;
    end
    hour = 'pm';
end
if curTime(4)<10
    h = '0';
else
    h = '';
end 

% Minutes
if curTime(5)<10
    min = '0';
else
    min = '';
end

% Seconds
if curTime(6)<10
    sec = '0';
else
    sec = '';
end

% Display Message
disp('Welcome back, Eric!')
disp(['Current Date is: ',monthStr,' ',num2str(curTime(3)),ending,...
   ', ',num2str(curTime(1))])
disp(['Current Time is: ',h,num2str(curTime(4)),':',...
   min,num2str(curTime(5)),':',sec,num2str(ceil(curTime(6))),' ',hour])

disp(' ');disp(' ');disp(' ');

% Special Events
% Evenings
if curTime(4)>=21
    pause(1.5)
    disp(' ');disp('It is a little late for MATLAB...')
    pause(2)
    disp(' ');disp('GO TO SLEEP!')
    disp(' ');disp(' ');disp(' ');
end
% Birthday:
if curTime(2)==7 && curTime(3)==3
    pause(1.5)
    disp(' ');disp('Happy Birthday Eric!!!')
    pause(2)
    disp(' ');disp('GET OFF MATLAB AND GO OUTSIDE!')
    disp(' ');disp(' ');disp(' ');
end
% Christmas
if curTime(2)==12 && curTime(3)==25
    pause(1.5)
    disp(' ');disp('Merry Christmas Eric!!!')
    pause(2)
    disp(' ');disp('GET OFF MATLAB AND GO OUTSIDE!')
    disp(' ');disp(' ');disp(' ');
end
% New Years
if curTime(2)==12 && curTime(3)==31
    pause(1.5)
    disp(' ');disp('Happy New Years Eve Eric!!!')
    pause(2)
    disp(' ');disp('GET OFF MATLAB AND GO OUTSIDE!')
    disp(' ');disp(' ');disp(' ');
end

clear

% tbxmanager restorepath
