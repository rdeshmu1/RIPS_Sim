%%
clear; clc; close all;

%%
%use linear density model

g= 10.44; %10.44; % gravity on Saturn (kg/m2)
z=72000000; %iterations
deltat=.0001; %time step (s)
time_seconds=deltat*z; %time in seconds
time_hours = time_seconds/60/60; %time in hours

%%
%pre/post parachute deployment

%tensile strength 7000 MPa
Torque = 300; %torque of spool (Nm)
r_new_spool = zeros(1,z); %radius of spool (m)
cord=zeros(1,z);
r_total_spool=.5;
w_spool=1;
r_cord=.01;

%R_spool = .3 * ones([1, z])

Cd_parachute = .85;
A_parachute = 7.848; %m2
v_parachute=zeros(1, z); %m/s
Fd_parachute=zeros(1, z);
x_parachute = zeros(1, z);
rho_parachute = zeros(1, z);
deployment_time = zeros(1, z);


%probe values
x_probe = zeros(1, z); %m
v_probe = zeros(1,z); %m/s
a_probe = zeros(1,z); %m/s
Fd_probe = zeros(1,z);
rho=zeros(1,z);
T_cord = 0;

%initial values at mission start
v_probe(1) = 27000;
Cd_probe=1.05; %drag coeff of probe
A_probe=.785; %m^2
m_probe = 355; %kg

check = zeros(1,z);
time = 0:deltat:deltat*z;
n=0;


for i=1:z
    
    current_time = deltat*i;
    
    %probe iteration
    rho(i)=(3000/60000000)*x_probe(i);

    %parachute
    if time(i) < 3600
        x_parachute(i) = x_probe(i); %only while parachute is inside
        v_parachute(i) = v_probe(i); %only while parachute is inside

    else
%         if r_new_spool < .3
%             r_new_spool(i) = .3;
%         else
            cord(i)=(x_parachute(i)-x_probe(i));
            %finds length of cord deployed 
            r_new_spool(i) = sqrt(((pi*r_total_spool^2*w_spool)-(pi*r_cord^2*cord(i)))/(pi*w_spool));
            %at point of deployment
            T_cord = Torque/r_new_spool(i);
            %r_spool varies with time, torque depends on cord material
            Fd_parachute = T_cord;
            v_parachute(i+1) = sqrt((2*Fd_parachute)/(rho(i)*Cd_parachute*A_parachute));
            x_parachute(i+1) = x_parachute(i) + v_parachute(i)*deltat;
            %assume an accelration of 0
            A_probe = 300;
%         end
    end
    
    Fd_probe(i) = 1/2*rho(i)*A_probe*Cd_probe*v_probe(i)^2;
    %force due to drag
    
    if v_probe(i) < 0
        Fd_probe(i) = -Fd_probe(i);
    end
    
    %drag vector opposes velocity
    %ie if velocity is positive, drag vector is negative
    
    a_probe(i) = (g-(Fd_probe(i)/m_probe)-(T_cord/m_probe));
    %new accelration
    
    v_probe(i+1)=v_probe(i)+deltat*a_probe(i);
    %assume constant a
    
    x_probe(i+1) = x_probe(i) + v_probe(i)*deltat + (a_probe(i)*deltat^2)/2;
    %current position
    
%     check(i+1) = 0;
    
    %     if time(i) > 3600
    %         A_probe = 300;
    %         check(i+1) = -1000;
    %     end
end

figure
plot(time, v_probe)
xlabel('Time (s)')
ylabel('Probe Velocity (m/s)')

figure
plot(time, x_probe)
xlabel('Time (s)')
ylabel('Probe Position (m)')

figure
plot(v_parachute)
xlabel('Ripcord length (m/s)')
ylabel('Parachute Velocity (m)')

%%
% figure
% plot(Fd_probe_with_deployment)
% title('Drag')
%
% figure
% plot(a_probe_with_deployment)
% title('Acceleration')
%
% figure
% plot(check)
% title('Check')

