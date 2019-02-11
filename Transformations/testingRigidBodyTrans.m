%--------------------------------------------------------------------------
%
% File Name:      testingRigidBodyTrans.m
% Date Created:   2017/09/19
% Date Modified:  2018/02/03
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Script to test the rigidBodyTrans.m function and
%                 visualize the results. 
%
%--------------------------------------------------------------------------

%% Initialize the Poses
t = [ [5.5313  5.3897  4.9007]',...
      [5.1732  5.3736  5.1442]',...
      [4.6825  4.6149  4.7170]',...
      [5.2592  4.4937  5.1436]',...
      [4.3538  5.1281  5.0945]' ];
R = [ [ 0.9149   -0.3858   -0.1187;
        0.3995    0.8233    0.4031;
       -0.0578   -0.4162    0.9074],...
      [ 0.8130   -0.5549   -0.1764;
        0.2864    0.6450   -0.7085;
        0.5069    0.5255    0.6833],...
      [ 0.9455    0.2999    0.1269;
       -0.2619    0.9319   -0.2509;
       -0.1936    0.2040    0.9597],...
      [ 0.8072    0.3271    0.4913;
       -0.5658    0.6657    0.4865;
       -0.1680   -0.6707    0.7225],...
      [ 0.6263    0.5039    0.5948;
       -0.4199    0.8609   -0.2872;
       -0.6568   -0.0698    0.7508] ];
     
%% Perform Desired Rigid Body Transformation
translation = [0;0;0];
rotation = euler2rot(deg2rad([0;90;0]));
point = [5;5;3];
% point = 0;
% point = 1;
[t_new, R_new] = rigidBodyTrans(t,R,translation,rotation,point);

%% Plot the Results
% Initialize Figure
figure(1); clf(1);
hold on;
box on;
rotate3d on;
% Plot World Reference Frame
h = plotCoordSys([0; 0; 0; 0; 0; 0], 'world', 50, [1,1,1], 0, 1, 2);
% Plot Rotation Point
if size(point,1)==3
  scatter3(point(1),point(2),point(3),100,[0,0,0],'Fill');
  text(point(1)-0.5,point(2)-0.5,point(3)-0.5,...
       'rotation point','HorizontalAlignment','left',...
       'FontSize',12,'Interpreter','LaTex');
end
% Plot Original Rigid Body
d = size(t,1);
n = size(t,2);
cVec = colormap;
cInd = ceil(linspace(11,54,n));
arrowLength = 1;
for i = 1:n
  ind_i = [i*d-2, i*d-1, i*d-0];
  eulerTemp = rot2euler(R(:,ind_i));
  plotCoordSys([t(:,i);eulerTemp], ...
    ['$',num2str(i),'_{old}$'], 50, cVec(cInd(i),:), 0, arrowLength, 2);
end
% Plot Final Rigid Body
gtAlpha = 0.5;
for i = 1:n
  ind_i = [i*d-2, i*d-1, i*d-0];
  eulerTemp = rot2euler(R_new(:,ind_i));
  plotCoordSys([t_new(:,i);eulerTemp], ...
    ['$',num2str(i),'_{new}$'], 50, cVec(cInd(i),:), gtAlpha, arrowLength, 2);
end
% Finished Plotting
hold off;
% Plot Volume
plotVolMin = min(abs(t(:)))-3.0;
plotVolMax = max(abs(t(:)))+3.25;
plotVol = [plotVolMin, plotVolMax, plotVolMin, plotVolMax, plotVolMin, plotVolMax];
axis(plotVol);
% Plot Axes Labels
title('Rigid Body Transformation Results','Interpreter','LaTex');
axesInfo = ancestor(h, 'axes');
xrule = axesInfo.XAxis;
xrule.FontName = 'Times';
yrule = axesInfo.YAxis;
yrule.FontName = 'Times';
zrule = axesInfo.ZAxis;
zrule.FontName = 'Times';
xlabel('x-axis (m)','Interpreter','LaTex');
ylabel('y-axis (m)','Interpreter','LaTex');
zlabel('z-axis (m)','Interpreter','LaTex');
axis equal;
axis(plotVol);
view([-1,-1.7,1.3]); % good angle

