%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /**
%  * @author: Yeshasvi Tirupachuri
%  * This is the matlab code for replicating results in the paper titled
%  * "Trajectory Deformations from Physical Human-Robot Interaction" by
%  * Dylan P. Losey and Marcia K. O'Malley
%  * https://arxiv.org/pdf/1710.09871.pdf
%  */
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % close all;
% % clear all;
% % clc;

%% User parameters

%% Sampling periods
T     = 1e-3; %Impedance controller sampling time
delta = 1e-2; %Deformation sampling time

tau   = 5; %Deformation duration
N     = (tau/delta) + 1; %Number of waypoints
time  = [0:delta:tau]';

mu     = 1; %Arbiration parameter

%% Matrices

%% Constraint Matrix B = R^(4 X N)
B          = zeros(4, N);
B(1,1)     = 1;
B(2,2)     = 1;
B(N-1,N-1) = 1;
B(N,N)     = 1;

%% Difference Matrix A = R^((N+3) X N)
ordered_row_matrix = [-1, 3, -3, 1];
A = zeros(N+3,N);

A(1,1) = 1;
A(2,1) = -3;
A(2,2) = 1;
A(3,1) = 3;
A(3,2) = -3;
A(3,3) = 1;

column_index = 0;
for row = 4:size(A,1)-3
    for colummn = 1:size(ordered_row_matrix,2)
        A(row,colummn+column_index) = ordered_row_matrix(1,colummn);
    end
    column_index = column_index+1;
end

A(size(A,1)-2,size(A,2)-2) = -1;
A(size(A,1)-2,size(A,2)-1) = 3;
A(size(A,1)-2,size(A,2))   = -3;

A(size(A,1)-1,size(A,2)-1) = -1;
A(size(A,1)-1,size(A,2))   = 3;

A(size(A,1),size(A,2))     = -1;

R = A'*A;

G  = (eye(N,N) - pinv(R)*B'*pinv(B*pinv(R)*B')*B)*pinv(R)*ones(N,1); %Using psuedo inverse
alpha = mu*delta*(sqrt(N)/norm(G));

%% Optimal Variation H
H = (sqrt(N)/norm(G))*G;

figure(1);
plot(time,H); hold on;
title('Optimal Variation H');
ylabel('Magnitude');
xlabel('Element Number');

%% Original 1DoF desired trajectory
xdstar =  -0.75*sin(time);

figure;
plot(time,xdstar); hold on;
title('Desired Trajectory');
ylabel('Position [M]');
xlabel('Time [S]');


%% External force
force = zeros(N,1);
square_shape_percent = 0.15;

tau_i_index = ceil(N/2 - (square_shape_percent*N));
tau_i =  time(ceil(N/2 -(square_shape_percent*N)));

tau_f_index = ceil(N/2 + (square_shape_percent*N));
tau_f = time(ceil(N/2 +(square_shape_percent*N)));

for n = tau_i_index:tau_f_index
    force(n,1) = 1;
end

figure;
plot(time,force);
title('Input Force');
ylabel('Force [N]');
xlabel('Time [S]');

% % %% Deformed Trajectory
% % xdnew = xdstar + mu*delta*H.*force;
% % 
% % figure;
% % plot(time,xdstar); hold on;
% % title('Deformed Trajectory');
% % ylabel('Position [M]');
% % xlabel('Time [S]');
