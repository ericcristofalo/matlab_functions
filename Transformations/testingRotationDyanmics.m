dt = 0.1;
tEnd = 1;
tspan = 0.0:dt:tEnd;
steps = size(tspan,2);
% R = euler2rot([0;0;pi/2]);
R = euler2rot([0;0;pi/2]);
x = zeros(3,steps);
x(:,1) = logMap(R);
omega = [0.5;0;0]; % rad/sec
% dynamics = 'rotation_matrix';
dynamics = 'axis_angle';
% control_frame = 'body';
control_frame = 'world';

% Initial Plot
figure(1); clf(1);
subplot(1,2,1); hold on;
% Plot World Frame
plotCoordSys([0; 0; 0; 0; 0; 0], 'world', 50, [0,0,0], 0, 1, 2);
% Plot Local Body Frame
plotCoordSys([1;1;1;rot2euler(expMap(x(:,1)))], ...
   'local', 50, [0,0,0], 0, 1, 2);
hold off;
title('Initial');
box on;
rotate3d on;
view([-1,-1.8,1.3]);
axis equal;
axis([0,2,0,2,0,2]);

for t = 2:steps
   
   if strcmp(dynamics,'rotation_matrix')
      
      if strcmp(control_frame,'body')
         R = R*expMap(omega*dt);
         x(:,t) = logMap(R);
      elseif strcmp(control_frame,'world')
         R = expMap(omega*dt)*R;
         x(:,t) = logMap(R);
      else
         error('Error: incorrect control frame');
      end
      
   elseif strcmp(dynamics,'axis_angle')
      
      x_t = x(:,t-1);
      theta = norm(x_t);
      beta = 0;
      x_t_ = zeros(3,1);
      if (theta~=0)
         x_t_ = x_t./theta;
         beta = 1 - 0.25*(theta*sin(theta)/(sin(0.5*theta)^2));
      end
      x_exp = skewSymMat(x_t_);
      L_x = eye(3) + 0.5*theta*x_exp + beta*x_exp*x_exp;
      
      if strcmp(control_frame,'body')
         x(:,t) = x_t + dt*(L_x*omega);
      elseif strcmp(control_frame,'world')
         x(:,t) = x_t + dt*(L_x'*omega);
      else
         error('Error: incorrect control frame');
      end
      
   else
      error('Error: incorrect dynamics');
   end
   
   % Final
   subplot(1,2,2); hold on;
   % Plot World Frame
   plotCoordSys([0; 0; 0; 0; 0; 0], 'world', 50, [0,0,0], 0, 1, 2);
   % Plot Local Body Frame
   plotCoordSys([1;1;1;rot2euler(expMap(x(:,t-1)))], ...
      '', 50, [0,0,0], 0.75, 1, 1);
   hold off;
   title('Final');
   box on;
   rotate3d on;
   view([-1,-1.8,1.3]);
   axis equal;
   axis([0,2,0,2,0,2]);
   pause(0.01);
   
end

% Final
subplot(1,2,2); hold on;
% Plot World Frame
plotCoordSys([0; 0; 0; 0; 0; 0], 'world', 50, [0,0,0], 0, 1, 2);
% Plot Local Body Frame
plotCoordSys([1;1;1;rot2euler(expMap(x(:,t)))], ...
   'local', 50, [0,0,0], 0, 1, 2);
hold off;
title('Final');
box on;
rotate3d on;
view([-1,-1.8,1.3]);
axis equal;
axis([0,2,0,2,0,2]);
pause(0.01);


