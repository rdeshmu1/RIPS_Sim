%%
clear; clc; close all;

%%
%use linear density model

g= 9.81; %10.44; % gravity on Saturn (kg/m2)
z=72000000; %iterations
deltat=.0001; %time step (s)
time_seconds=deltat*z; %time in seconds
time_hours = time_seconds/60/60; %time in hours

%%
%pre/post parachute deployment

ripcord=10; %ripcord length (m)
Torque = 300; %torque of spool (Nm)
R_spool = .3; %radius of spool (m)

Cd_parachute = .85;
A_parachute = 7.848; %m2
v_parachute=zeros([1 ripcord]); %m/s
Fd_parachute=zeros([1 ripcord]);
rho_parachute = zeros([1 ripcord]);

%probe values
x_probe_with_deployment = zeros(1, z); %m
v_probe_with_deployment = zeros(1,z); %m/s
a_probe_with_deployment = zeros(1,z); %m/s
Fd_probe_with_deployment = zeros(1,z);
rho=zeros(1,z);
T_cord = 0; 

%initial values at mission start
v_probe_with_deployment(1) = 27000;
Cd_probe=1.05; %drag coeff of probe
A_probe=.785; %m^2
m_probe = 355; %kg



for i=1:z
    
    %probe iteration
    rho(i)=(3000/60000000)*x_probe_with_deployment(i);
    
    if time_seconds > 3600
        for l=i:i+ripcord
        	rho_parachute(l) = rho(i);
            T_cord = Torque/R_spool;
            Fd_parachute = T_cord;
            v_parachute = sqrt((2*Fd_parachute)/(rho_parachute(l)*Cd_parachute*A_parachute));
        end  
    end
    
    Fd_probe_with_deployment(i) = 1/2*rho(i)*A_probe*Cd_probe*v_probe_with_deployment(i)^2;
    %force due to drag
    
    if v_probe_with_deployment(i) < 0
        Fd_probe_with_deployment(i) = -Fd_probe_with_deployment(i);
    end
    
    %drag vector opposes velocity
    %ie if velocity is positive, drag vector is negative
    
    a_probe_with_deployment(i) = (g-(Fd_probe_with_deployment(i)/m_probe)-(T_cord/m_probe));
    %new accelration
    
    v_probe_with_deployment(i+1)=v_probe_with_deployment(i)+deltat*a_probe_with_deployment(i);
    %assume constant a
    
    x_probe_with_deployment(i+1) = x_probe_with_deployment(i) + v_probe_with_deployment(i)*deltat + (a_probe_with_deployment(i)*deltat^2)/2;
    %current position
    
end

plot(v_probe_with_deployment)
title('Velocity')
xlabel('Iterations')
ylabel('Velocity (m/s)')

figure
plot(x_probe_with_deployment)
title('Position')
xlabel('Iterations')
ylabel('Position (m)')

%%
figure
plot(Fd_probe_with_deployment)
title('Drag')

figure
plot(a_probe_with_deployment)
title('Acceleration')

%%

x_probe=zeros([1 length(z)]); %m
v_probe=zeros([1 length(z)]); %m/s
a_probe=zeros([1 length(z)]); %m/s
Fd_probe=zeros([1 length(z)]);

%initial probe conditions
v_probe(1)= 27000; %m/s
m_probe = 355; %kg

%total mission time, no deployment
% % for i=1:z
% %
% %     rho(i)=(3000/60000000)*x_probe(i);
% %
% %     Fd_probe(i) = 1/2*rho(i)*A_probe*Cd_probe*v_probe(i)^2;
% %     %force due to drag
% %
% %     if v_probe(i) < 0
% %         Fd_probe(i) = -Fd_probe(i);
% %     end
% %
% %     %drag vector opposes velocity
% %     %ie if velocity is positive, drag vector is negative
% %
% %     a_probe(i) = (g-Fd_probe(i)/m);
% %     %new accelration
% %
% %     v_probe(i+1)=v_probe(i)+deltat*a_probe(i);
% %     %assume constant a
% %
% %     x_probe(i+1) = x_probe(i) + v_probe(i)*deltat + (a_probe(i)*deltat^2)/2;
%     %current position
%
% end

