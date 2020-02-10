%%
clear, clc, close all;

g= 10.44;% gravity on Saturn (kg/m2)
z=72000000; %iterations
deltat=.0001; %time step (s)
time_seconds=deltat*z; %time in seconds
time_hours = time_seconds/60/60; %time in hours


x_probe=zeros([1 length(z)]); %m
v_probe=zeros([1 length(z)]); %m/s
a_probe=zeros([1 length(z)]); %m/s
Fd_probe=zeros([1 length(z)]);


%initial probe conditions
v_probe(1)= 27000; %m/s
m_probe = 355; %kg
A_probe=.785; %m^2
Cd_probe=1.05;

%total mission time, no deployment
for i=1:z

    rho(i)=(3000/60000000)*x_probe(i);

    Fd_probe(i) = 1/2*rho(i)*A_probe*Cd_probe*v_probe(i)^2;
    %force due to drag

    if v_probe(i) < 0
        Fd_probe(i) = -Fd_probe(i);
    end

    %drag vector opposes velocity
    %ie if velocity is positive, drag vector is negative

    a_probe(i) = (g-Fd_probe(i)/m_probe);
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

