clear all;
close all;
clc;

%% Time
time = 0:0.01:10;

%% Set points
Xi = [0 0 0];
Xf = [10 10 10];

d = time(end);
N = length(time);

a = repmat((Xf - Xi), N, 1);
b = repmat((10 * (time/d).^3 - 15 * (time/d).^4 + 6 * (time/d).^5)', 1, 3);

%% Position
position = repmat(Xi, N, 1) + a .* b;

figure(1)
subplot(3,1,1);
plot(time, position(:,1));
xlabel('time');
ylabel('x');
title('Position'); hold on;

subplot(3,1,2);
plot(time, position(:,2));
xlabel('time');
ylabel('y');

subplot(3,1,3);
plot(time, position(:,3));
xlabel('time');
ylabel('z');

%% Velocity
velocity = a.*repmat((30 * (time/d).^2 - 60 * (time/d).^3 + 30 * (time/d).^4)', 1, 3);

figure(2)
subplot(3,1,1);
plot(time, velocity(:,1));
xlabel('time');
ylabel('x');
title('Velocity'); hold on;

subplot(3,1,2);
plot(time, velocity(:,2));
xlabel('time');
ylabel('y');

subplot(3,1,3);
plot(time, velocity(:,3));
xlabel('time');
ylabel('z');

%% Acceleration
acceleration = a.*repmat((60*(time/d).^1 - 180*(time/d).^2 + 120*(time/d).^3)', 1, 3);

figure(3)
subplot(3,1,1);
plot(time, acceleration(:,1));
xlabel('time');
ylabel('x');
title('Acceleration'); hold on;

subplot(3,1,2);
plot(time, acceleration(:,2));
xlabel('time');
ylabel('y');

subplot(3,1,3);
plot(time, acceleration(:,3));
xlabel('time');
ylabel('z');

%% Jerk
jerk = a.*repmat((60*(1/d) - 360*(time/d).^1 + 360*(time/d).^2)', 1, 3);

figure(4)
subplot(3,1,1);
plot(time, jerk(:,1));
xlabel('time');
ylabel('x');
title('Jerk'); hold on;

subplot(3,1,2);
plot(time, jerk(:,2));
xlabel('time');
ylabel('y');

subplot(3,1,3);
plot(time, jerk(:,3));
xlabel('time');
ylabel('z');