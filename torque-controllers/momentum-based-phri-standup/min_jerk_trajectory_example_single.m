clear all;
close all;
clc;

duration = 1.5;
period   = 0.01;

%% Time
time = 0:period:duration;
time = time';

%% Set points
Xi = [-0.1229 -0.08082 0.3602];
Xf = [0 -0.1081 0.3602];

N = length(time);

for i = 1:1:N

    a = (Xf - Xi);
    b(i,:) = (10 * (time(i)/duration).^3 - 15 * (time(i)/duration).^4 + 6 * (time(i)/duration).^5)';

    %% Position
    position(i,:) = Xi + a * b(i,:);

    %% Velocity
    velocity(i,:) = a.*(30 * (time(i)/duration).^2 - 60 * (time(i)/duration).^3 + 30 * (time(i)/duration).^4)';
    
    %% Acceleration
    acceleration(i,:) = a.*(60*(time(i)/duration).^1 - 180*(time(i)/duration).^2 + 120*(time(i)/duration).^3);

    %% Jerk
    jerk(i,:) = a.*(60*(1/duration) - 360*(time(i)/duration).^1 + 360*(time(i)/duration).^2)';
    
end

%% Position plot
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

%% Velocity plot
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

%% Acceleration plot
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

%% Jerk plot
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
