%%
clear; clc;

%%
%use linear density model 

%change iterations for more accuracy 

m=5; % kg
g=9.81; % kg/m2

z=72000000;

Cd=.4; %drag coeff
A_probe=.09; %m^2
d=.3385;
mu = 1.789E-5; %viscosity in Ns/m
%http://www.aerodynamics4students.com/properties-of-the-atmosphere/sea-level-conditions.php

v(1)=27000; %m/s
deltat=.0001;
time=deltat*z;

%%

%pressure range
pressure = [.01:.1236:10]*100000; %Pa

%%
%initial conditions for maximum profile

z=72000000;
x_probe=zeros([1 length(z)]); %m
v_probe=zeros([1 length(z)]); %m/s
a_probe=zeros([1 length(z)]); %m/s
Fd_probe=zeros([1 length(z)]);

%initial probe conditions
v_probe(1)= 27000; %m/s
m_probe = 500; %kg
Cd_probe=1.3;


%% 
for i=1:z
    
    rho(i)=3000/500*x_probe(i);
    
   
    Fd_probe(i) = 1/2*rho(i)*A_probe*Cd_probe*v_probe(i)^2;
    %force due to drag 
    
    if v_probe(i) < 0 
        Fd_probe(i) = -Fd_probe(i);
    end
    
    %drag vector opposes velocity 
    %ie if velocity is positive, drag vector is negative 
    
    a_probe(i) = (g-Fd_probe(i)/m); 
    %new accelration 
     
    v_probe(i+1)=v_probe(i)+deltat*a_probe(i);
    %assume constant a
   
    x_probe(i+1) = x_probe(i) + v_probe(i)*deltat + (a_probe(i)*deltat^2)/2;
    %current position
        
end



%%
%post parachute deployment 

ripcord=1000; %m 
Torque = 30; %Nm 
%this value will change with time 
R_spool = 2; %m

Cd_parachute = 1.4; 
v_parachute=zeros([1 1000]); %m/s
Fd_parachute=zeros([1 1000]);
A_parachute = 10; 

%initial velocity at deployment 

%pd = post deployment 
x_probe_post_deployment = zeros([1 ripcord]); %m
v_probe_post_deployment = zeros([1 ripcord]); %m/s
a_probe_post_deployment = zeros([1 ripcord]); %m/s
Fd_probe_post_deployment = zeros([1 ripcord]);


for l=2:ripcord
    
    T_cord = Torque/R_spool;
   
    Fd_parachute = T_cord;
    v_parachute = sqrt((2*Fd_parachute)/(rho*Cd*A_parachute));
   
    %probe iteration
    Fd_probe_pd(q)= 1/2*Cd_probe*rho(q)*v_probe(q-1)^2*A_probe;
    a_probe_pd(q)= (m_probe*g-Fd_probe_pd(q)-T)/m_probe;
    v_probe_pd(q)=v_probe_pd(q-1)+a_probe_pd(q)*delta_t;
    x_probe_pd(q) = x_probe_pd(q-1) + v_probe_pd(q-1)*delta_t + 1/2*a_probe_pd(q)*delta_t^2;

end
