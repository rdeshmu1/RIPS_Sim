%%
clear; clc;

load Temp_Alt_Fit;

%altitude of mission
depth = [0:5:400]*1000; %m

%pressure range
pressure = [.01:.1236:10]*100000; %Pa

%altitude = [400:-25:0]*1000;
%temperature = [105, 95, 85, 80, 75, 80, 90, 100, 120, 150, 160, 180, 200, 220, 250, 275, 300];

%density model
rho = pressure./((287.*Temp_Alt_Fit(depth))');

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



