%--------------------------------------------------------------------------
%
% File Name:      random_SO3_test.m
% Date Created:   2018/08/20
% Date Modified:  2019/01/30
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    
%
%--------------------------------------------------------------------------

%% Generate Random Rotation Matrices in SO(3)

figure(100); clf(100);
hold on;
for i = 1:100
   
%    % Naive Random Axis-Angle Method (doesn't work)
%    theta = 2*pi*rand(1,1);
% %    theta = 1/pi*sin(theta-sin(theta));
%    w = 2*rand(3,1)-ones(3,1);
%    R = expMap(w./norm(w)*theta);
   
%    % Random Spherical Coordinates Method (doesn't work)
%    theta = acos(2*rand(1,1)-1);
%    phi = 2*pi*rand(1,1);
%    w = [sin(theta)*cos(phi);
%         sin(theta)*sin(phi);
%         cos(theta)];
%    Theta = 2*pi*rand(1,1);
%    R = expMap(w*Theta);
   
%    % QR Decomposition (doesn't work)
%    [R,~] = qr(randn(3));

%    % Random Axis-Angle Method (Arvo, Fast Random Rotation Matrices)
%    x1 = 1*rand(1,1);
%    x2 = 1*rand(1,1);
%    x3 = 1*rand(1,1);
%    R = rotMat(pi*2*x1,'z');
%    v = [cos(pi*2*x2)*sqrt(x3);
%         sin(pi*2*x2)*sqrt(x3);
%         sqrt(1-x3)];
%    H = eye(3)-2*(v*v');
%    R = -H*R;
   
   % randRot using Arvo method
   R = randRot(3);
   
   % Plot Results
   euler = rot2euler(R);
   plotCoordSys([[0;0;0];euler],'', 50, [0,0,0], 0, 1, 2);
   
end
grid on; axis equal; rotate3d on;
hold off;
title('Random Rotation Matrices');
xlabel('x-axis'); ylabel('y-axis'); zlabel('z-axis');
view([-1,-1.7,1.3]); 


%% Generate Random Noise about R in SO(3)

return;
% Generate Random Rotation Matrix (Arvo, Fast Random Rotation Matrices)
x1 = 1*rand(1,1);
x2 = 1*rand(1,1);
x3 = 1*rand(1,1);
R = rotMat(pi*2*x1,'z');
v = [cos(pi*2*x2)*sqrt(x3);
     sin(pi*2*x2)*sqrt(x3);
     sqrt(1-x3)];
H = eye(3)-2*(v*v');
R = -H*R;

% Noise Term
kappa = 10; % degrees
kappa = deg2rad(kappa);

% Generate Noisy Rotations about R
figure(100); clf(100);
hold on;
euler = rot2euler(R);
plotCoordSys([[0;0;0];euler],'', 50, [0,0,0], 0, 1, 2);
for i = 1:100
   
%    % Random Angle About Existing Axis
%    w = logMap(R);
%    theta = norm(w);
%    theta_noise = normrnd(0.0,kappa);
%    w_hat = w./theta;
%    R_noise = expMap(theta_noise*w_hat);
%    R_ = R_noise*R;
   
   % Random Euler Angles
   euler = kappa*randn(3,1);
   R_noise = euler2rot(euler);
   R_ = R_noise*R;
   
   % Plot Results
   euler = rot2euler(R_);
   plotCoordSys([[0;0;0];euler],'', 50, [0,0,0], 0.5, 0.8, 1);
   
end
grid on; axis equal; rotate3d on;
hold off;
title('Random Rotation Matrices');
xlabel('x-axis'); ylabel('y-axis'); zlabel('z-axis');
view([-1,-1.7,1.3]);

