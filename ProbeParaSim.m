%%
clear; clc; close all;

%%

%preliminary simulation parameters 
%use linear density model
g= 10.44;% gravity on Saturn (kg/m2)
z=72000000; %iterations
deltat=.0001; %time step (s)
time_seconds=deltat*z; %time in seconds
time_hours = time_seconds/60/60; %time in hours

%%

%Spool/Torque 
r_total_spool=.2; %m
%total diamater of cord on spool pre deployment 
r_cord=3.175/1000; %m 
%radius of Dyneema SK99 
A_cord = pi*r_cord^2;
%area of cord 
P = 4.1E9; 
%Dyneema SK99 Tensile Strength: 4.1 GPa
Torque = P*A_cord*r_total_spool; %Nm
%torque of spool 
r_new_spool = zeros(1,z); %m
%radius of spool 
w_spool=.5;
%width of spool (m)
v_total_spool = pi*r_total_spool^2*w_spool;
%total volume of cord spool m^3 

%parachute values
Cd_parachute = .85;
%Cd parachute 
A_parachute = 7.848; %m2
%area parachute 
v_parachute=zeros(1, z); %m/s
%velocity parachute
Fd_parachute=zeros(1, z);
%drag force on parachute
x_parachute = zeros(1, z);
%distance of parachute travel 
rho_parachute = zeros(1, z);
%rho of parachute position 
cord=zeros(1,z);


%probe values
x_probe = zeros(1, z); %m
%distance of probe travel 
v_probe = zeros(1,z); %m/s
%velocity of probe travel 
a_probe = zeros(1,z); %m/s^2
%accelration of probe 
Fd_probe = zeros(1,z);
%drag force of probe 
rho=zeros(1,z);
%rho 
T_cord = zeros(1, z);
%tension of cord 


%initial values at mission start
v_probe(1) = 27000;
Cd_probe=1.05; 
%drag coeff of probe
A_probe=.785; %m^2
%area of probe 
m_probe = 355; %kg
%mass of probe 

check = zeros(1,z);
time = 0:deltat:deltat*z;
%time vector
n=0;

%%
for i=1:z
    
    current_time = deltat*i;
    %current time 
    
    %probe iteration
    
    rho(i)=(3000/60000000)*x_probe(i);
    %current value of rho based on probe position 
    
    %parachute
    if time(i) <= 3600 %(s)
        %arbitrary moment of deployment 
        x_parachute(i+1) = x_probe(i); %only while parachute is inside
        v_parachute(i+1) = v_probe(i); %only while parachute is inside
        
    else
        cord(i+1)= abs((x_parachute(i)-x_probe(i)));
        %current length of cord unspooled 
        
        if cord(i+1) >= 1000
            check(i+1) = 1;
            %check: not pertinent to actual dynamics of code 
        else
            check(i+1) = 0;
   
            r_new_spool(i) = sqrt((v_total_spool)-(pi*r_cord^2*cord(i+1)))/(pi*w_spool);
            %finds new radius of spool based on volume of cord deployed 
            T_cord(i) = Torque/r_new_spool(i);
            %finds changing T_cord 
            Fd_parachute(i) = T_cord(i);
            %new Fd parachute 
            v_parachute(i+1) = sqrt((2*Fd_parachute(i))/(rho(i)*Cd_parachute*A_parachute));
            %new velocity of parachute 
            x_parachute(i+1) = x_parachute(i) + v_parachute(i)*deltat;
            %new position of parachute 
            %assume an acceleration of 0
            
        end
    end
    
    Fd_probe(i) = 1/2*rho(i)*A_probe*Cd_probe*v_probe(i)^2;
    %force due to drag
    
    if v_probe(i) < 0
        Fd_probe(i) = -Fd_probe(i);
    end
    %drag vector opposes velocity
    %ie if velocity is positive, drag vector is negative
    
    a_probe(i) = (g-(Fd_probe(i)/m_probe)-(T_cord(i)/m_probe));
    %new accelration
    
    v_probe(i+1)=v_probe(i)+deltat*a_probe(i);
    %assume constant a
    
    x_probe(i+1) = x_probe(i) + v_probe(i)*deltat + (a_probe(i)*deltat^2)/2;
    %current position
    
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
ylabel('Parachute Velocity (m/s)')

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

