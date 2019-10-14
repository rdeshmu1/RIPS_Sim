%%
clear; clc;

%%
rad = [60000 50000 40000 0];
den = [0 500 1000 3500];

%%

load Linear_density
%altitude of mission
depth = [0:5:400]*100; %m
rho = Linear_density(depth);

%pressure range
pressure = [.01:.1236:10]*100000; %Pa
% 
% altitude = [400:-25:0]*100;
% temperature = [105, 95, 85, 80, 75, 80, 90, 100, 120, 150, 160, 180, 200, 220, 250, 275, 300];
% 
% %density model
%rho = pressure./((287.*Temp_Alt(depth))');

%%
%initial conditions for maximum profile

%tension
T = 0;
%gravity
g = 10.4; % m/s2

x_probe=zeros([1 length(depth)]); %m
v_probe=zeros([1 length(depth)]); %m/s
a_probe=zeros([1 length(depth)]); %m/s
Fd_probe=zeros([1 length(depth)]);
delta_t = 100;

%initial probe conditions
v_probe(1)= 13166.667; %m/s
m_probe = 500; %kg
Cd_probe=1.3;


%% 
for q=2:length(depth)
    
    if depth(q) > 200000
        rho(q) = .73;
    end
    
    if pressure(q) > 100000
        A_probe = 50; % m2
    else 
        A_probe = .78;
    end
    
    %probe iteration
    Fd_probe(q)= 1/2*Cd_probe*rho(q)*v_probe(q-1)^2*A_probe;
    a_probe(q)= (m_probe*g-Fd_probe(q))/m_probe;
    v_probe(q)=v_probe(q-1)+a_probe(q)*delta_t;
    x_probe(q) = x_probe(q-1) + v_probe(q-1)*delta_t + 1/2*a_probe(q)*delta_t^2;

end

%%
%post parachute deployment 

ripcord=1000;
Torque = 78;
R_spool = 2;


v_parachute=zeros([1 1000]); %m/s
Fd_parachute=zeros([1 1000]);


%initial velocity at deployment 

%pd = post deployment 
x_probe_pd=zeros([1 ripcord]); %m
v_probe_pd=zeros([1 ripcord]); %m/s
a_probe_pd=zeros([1 ripcord]); %m/s
Fd_probe_pd=zeros([1 ripcord]);


for l=2:ripcord
    
    T_cord = Torque/R_spool;
   
    v_parachute = sqrt((2*Fd_parachute)/(rho*Cd*A_parachute));
   
  
    %probe iteration
    Fd_probe_pd(q)= 1/2*Cd_probe*rho(q)*v_probe(q-1)^2*A_probe;
    a_probe_pd(q)= (m_probe*g-Fd_probe_pd(q)-T)/m_probe;
    v_probe_pd(q)=v_probe_pd(q-1)+a_probe_pd(q)*delta_t;
    x_probe_pd(q) = x_probe_pd(q-1) + v_probe_pd(q-1)*delta_t + 1/2*a_probe_pd(q)*delta_t^2;

end
