%% Navier-Stokes equation solver
%this program resolve navier stokes equation in 2D using Wind_Data_Lausanne.csv, 
% and map_buildings.csv. It first, calculates and projects on vertical (v) and
% horizontal (u) the mean velocities comming from south to north pasing by 
% west over a year. 
% Then the resolution of Navier-Stokes begin. We use the channel
% flow case to solve it. 
% We assume the pressure, and the velocites in both x and y directions to 
% be set at zero. This setup  represent a stationary fluid. The boundary 
% conditions are periodic in x for u, v and p at the start and at the end
% of x axis, allowing continuous flow through the horizontal edges. u and v
% are set according to the projection of the mean wind velocities over 
% a year. At y 0 start and end of the map, u and v are et to zero
% maintaining the the flux in the "channel", while the pressure gradient is
% set to zero ensuring consistent pressure across these boundaries.
% Last, the program finds the six location where the wind if the biggest 
% and creats a CSV file filled with locations and speed. 

%% Reading the different CSV files
% import of the different csv file for the code

% file containing direction and velocity of the wind over a year with 
% a timesteps of 10 minutes
wind_data = readmatrix('../Data/Wind_Data_Lausanne.csv');

% file containing a matrix of size (nx=51,ny=51) when there is a building(1) or not(0)

    % Map for 30 buildings
    % to see the map from the report use: '../Internal/map_from_the_report.csv'
map_buildings = readmatrix('../Internal/map_buildings.csv');  
    
% file with the coordinates of each building (start x, start y, end x, 
% end y) according to map_buildings.csv 
    % Coordinates for the 30 buildings 
coordinates_buildings = readmatrix('../Internal/coordinates_buildings.csv');

%% Initialization of variables 

% Size in axis x and axis y of the map according to map_buildings.csv
nx = length(map_buildings); ny = length(map_buildings);

% nit is the number of iteration for the Poisson Equation
nit = 10; 

% Minimum and maximum value of x on the x axis similarely for y on the y
% axis 
xmin = 0; xmax = nx; ymin = 0; ymax = ny; 

% Difference on the x axis respectively for axis y
dx = (xmax - xmin)/(nx - 1); dy = (ymax - ymin)/(ny - 1);

% Linespace for the grid on x and y
x = linspace(0,nx-1,nx); y = linspace(0,ny-1,ny);
[X,Y] = meshgrid(x,y);


% Constants 

% Viscosity of air [kg/m^3]
rho = 1.184; 

% Kinematic viscosity of air [m^2/s] (note: if the plot empties change 
% value to something over 1.1)
nu = 1.608e-5; 

% Driving force (source term)
F=1; 

% Amout of time each timesteps covers (delta t)
dt=0.01; 


% Initialization of the map

% Velocity vector projection on x and y respectively
u=map_buildings; v=map_buildings;

% Pressure field
p=zeros(ny,nx);

% Source term based on velocity field
b=zeros(ny,nx);  


%% Wind_direction Function 

% Uses datas from Wind_Data_Lausanne.csv. It extracts the direction and
% the speed from the file. Then it sort which direction will stay and the
% others are set at 0. the range of direction is from 0 to 45 degres and 
% 225 to 360 degres, because in the CSV file we already know that the wind 
% mostly comes to West and so we make sure to take the all winds going to 
% the West. Then the function reduce the lists erasing all the 0 in 
% variable wind_in and angle. Finally using the direction, the speed is 
% projected over u and v which are on x and y axis respectively.
% mean_wind_u and mean_wind_v are the mean of the projected wind form the 
% CSV file Wind_Data_Lausanne.csv      
 

% Extracts a list of direction and a list of speed form Wind_Data_Lausanne.csv    
speed = wind_data(:,7);
direction = wind_data(:,6);

%length of each column from Wind_Data_Lausanne.csv
len = length(wind_data(:,1));

% Initialize lists full of nan of length of the Wind_Data_Lausanne.csv for 
% the wind speed that will be choosen and the direction of this wind  
wind_in = nan(1, len);
angle = nan(1,len);

% Initialize a count to know the size of the wind list.   
count = 0;

% Loop which selects only wind in a range of 180°([0, 45] U [225, 360]), 
% but mostly oriented west. Speeds that are not in the right direction are 
% set to zero and the coresponding angle is set to -1 because 0 is in 
% the range of directions. It add the selected winds and directions in 
% wind_in and in angle respectively. 
for i=1:len
    if direction(i) < 360 && direction(i) >= 225
        wind_in(i) = speed(i);
        angle(i) = direction(i);
        count= count + 1;
    elseif direction(i) <= 45 && direction(i) >= 0
        wind_in(i) = speed(i); 
        angle(i) = direction(i);
        count = count + 1;
    else
        wind_in(i) = 0; 
        angle(i) = -1;
    end 
end

% Erase from the list the winds equal to 0
wind_in(wind_in == 0) = [];

% Erase from the list the direction equal to -1
angle(angle == -1)= [];

% Projecting wind in x and y axis according to the direction(angle)
% u represents the velocity field in x axis and v the velocity field in y
% axis 
wind_u = cos((angle+45)*pi/180) .* wind_in;
wind_v = sin((angle+45)*pi/180) .* wind_in;

% Mean of the projected winds over the year 
mean_wind_u = sum(wind_u)/count;
mean_wind_v =sum(wind_v)/count;


%% Navier_Stokes_equation
% This part solve and show at each stepcount the wind field u and v. 
% It assumes that the map as buildings on it comming from map_buildings.csv
% which are represented by 1 on the map. At each stepcount, each point 
% u(i,j) and v(i,j) of the velocity field updates itself depending on  
% backward,forward and side difference ((i,j-1);(i+1,j);(i,j+1);(i-1;j)) at the same point 
% one stepcount before.    

stepcount=0;
while stepcount < 100

    % Initializing the speed of the first and last column
    u(1,:) = mean_wind_u; u(nx,:) = mean_wind_u; 

    % Making the wind flow out of the map with a predefined speed
    v(1,:) = mean_wind_v; v(nx,:) = mean_wind_v;

    %% Iterating over the source term b base on velocity field 
    for i=2:(nx-1)
        for j=2:(ny-1)
            b(i,j)=rho*(1/dt*((u(i+1,j) ...
                -u(i-1,j))/(2*dx) ...
                +(v(i,j+1)-v(i,j-1))/(2*dy)) ...
                -((u(i+1,j)-u(i-1,j))/(2*dx))^2 ...
                -2*((u(i,j+1)-u(i,j-1))/(2*dy)*(v(i+1,j)-v(i-1,j))/(2*dx)) ...
                -((v(i,j+1)-v(i,j-1))/(2*dy))^2);
        end
    end

    % Periodic Term for x = 0 

        for j=2:(ny-1)
            b(1,j)=rho*(1/dt*((u(2,j)-u(nx,j))/(2*dx) ...
                +(v(i,j+1)-v(i,j-1))/(2*dy)) ...
                -((u(2,j)-u(nx,j))/(2*dx))^2 ...
                -2*((u(i,j+1)-u(i,j-1))/(2*dy)*(v(2,j)-v(nx,j))/(2*dx)) ...
                -((v(i,j+1)-v(i,j-1))/(2*dy))^2);
        end
        
    % Periodic Term for x = nx

        for j=2:ny-1
            b(nx,j)=rho*(1/dt*((u(1,j)-u(nx-1,j))/(1*dx)+(v(i,j+1) ...
                -v(i,j-1))/(1*dy)) ...
                -((u(1,j)-u(nx-1,j))/(1*dx))^1 ...
                -1*((u(i,j+1)-u(i,j-1))/(1*dy)*(v(1,j)-v(nx-1,j))/(1*dx)) ...
                -((v(i,j+1)-v(i,j-1))/(1*dy))^1);
        end

    %% Pressure Poisson Equation iteratively for pressure p 
    for iit=1:nit+1

        % Copy of p to keep a version of the previous stepcount 
        pn=p;
        for i=2:(nx-1)
            for j=2:(ny-1) 
                p(i,j)=((pn(i+1,j)+pn(i-1,j))*dy^2 ...
                    +(pn(i,j+1)+pn(i,j-1))*dx^2)/(2*(dx^2+dy^2))...
                    -dx^2*dy^2/(2*(dx^2+dy^2))*b(i,j);
            end
        end
        
        % Periodic Terms for x = 0
        
            for j=2:(ny-1) 
                    p(1,j)=((pn(2,j)+pn(nx,j))*dy^2+ ...
                        (pn(1,j+1)+pn(1,j-1))*dx^2)/(2*(dx^2+dy^2))...
                        -dx^2*dy^2/(2*(dx^2+dy^2))*b(i,j);
            end
        
        % Periodic Term for x = 0

            for j=2:(ny-1) 
                    p(nx,j)=((pn(1,j)+pn(nx-1,j))*dy^2 ...
                        +(pn(nx,j+1)+pn(nx,j-1))*dx^2)/(2*(dx^2+dy^2))...
                        -dx^2*dy^2/(2*(dx^2+dy^2))*b(i,j);
            end
        
        p(:,ny) = p(:,ny-1);	    
        p(:,1) = p(:,2);		

    end

    un = u;
    vn = v;

    % Iteration on velocity field (u,v)
    for j=2:nx-1
        for i=2:ny-1 

            
            if map_buildings(i,j) == 1
                u(i,j) = 0;
                v(i,j) = 0;
            else     
                u(i,j) = un(i,j)-un(i,j)*dt/dx*(un(i,j)-un(i-1,j))...
                        -vn(i,j)*dt/dy*(un(i,j)-un(i,j-1))-dt/(2*rho*dx)*(p(i+1,j)-p(i-1,j))...
                        +nu*(dt/dx^2*(un(i+1,j)-2*un(i,j)+un(i-1,j))...
                        +(dt/dy^2*(un(i,j+1)-2*un(i,j)+un(i,j-1))))+F*dt;
            
                v(i,j) = vn(i,j)-un(i,j)*dt/dx*(vn(i,j)-vn(i-1,j))...
                        -vn(i,j)*dt/dy*(vn(i,j)-vn(i,j-1))-dt/(2*rho*dy)*(p(i,j+1)-p(i,j-1))...
                        +nu*(dt/dx^2*(vn(i+1,j)-2*vn(i,j)+vn(i-1,j)) ...
                        +(dt/dy^2*(vn(i,j+1)-2*vn(i,j)+vn(i,j-1))));   
            end
        end     
    end
    
    % Periodic Term for x =0
    
    for j=2:ny-1
        u(2,j) = un(1,j)-un(1,j)*dt/dx*(un(1,j)-un(nx,j))...
                -vn(1,j)*dt/dy*(un(1,j)-un(1,j-1))-dt/(2*rho*dx)*(p(2,j)-p(nx,j))...
                +nu*(dt/dx^2*(un(2,j)-2*un(1,j)+un(nx,j))...
                +(dt/dy^2*(un(1,j+1)-2*un(1,j)+un(1,j-1))))+F*dt;
        v(2,j) = vn(1,j)-un(1,j)*dt/dx*(vn(1,j)-vn(nx,j))...
                 -vn(1,j)*dt/dy*(vn(1,j)-vn(1,j-1))-dt/(2*rho*dy)*(p(1,j+1)-p(1,j-1))...
                +nu*(dt/dx^2*(vn(2,j)-2*vn(1,j)+vn(nx,j))...
                +(dt/dy^2*(vn(1,j+1)-2*vn(1,j)+vn(1,j-1))));
    end
  
    % Periodic Term for x=2

    for j=2:ny-1
        u(nx-1,j) = un(nx,j)-un(nx,j)*dt/dx*(un(nx,j)-un(nx-1,j))...
                -vn(nx,j)*dt/dy*(un(nx,j)-un(nx,j-1))-dt/(2*rho*dx)*(p(1,j)-p(nx-1,j))...
                +nu*(dt/dx^2*(un(1,j)-2*un(nx,j)+un(nx-1,j))...
                +(dt/dy^2*(un(nx,j+1)-2*un(nx,j)+un(nx,j-1))))+F*dt;
        v(nx-1,j) = vn(nx,j)-un(nx,j)*dt/dx*(vn(nx,j)-vn(nx-1,j))...
                -vn(nx,j)*dt/dy*(vn(nx,j)-vn(nx,j-1))-dt/(2*rho*dy)*(p(nx,j+1)...
                -p(nx,j-1))+nu*(dt/dx^2*(vn(1,j)-2*vn(nx,j)+vn(nx-1,j))...
                +(dt/dy^2*(vn(nx,j+1)-2*vn(nx,j)+vn(nx,j-1))));
    end

% Putting walls up and down the map
u(:,ny)=0;
u(:,1)=0;
v(:,1)=0;
v(:,ny)=0;

stepcount = stepcount +1;
disp(stepcount);
quiver(y,x, u.',v.', 1.3)
axis equal
pause(0.01);
end

hold on;
xlabel('axis x [m]')
ylabel('axis y [m]')
title('Wind passing through a city with urban wind turbines')



%% Placing_the_buildings Function

% Displaying the buildings
for B = 1:length(coordinates_buildings)

    rectangle('Position', [coordinates_buildings(B,1), coordinates_buildings(B,2),...
        coordinates_buildings(B,3)-coordinates_buildings(B,1),...
        coordinates_buildings(B,4)-coordinates_buildings(B,2)],...
        'EdgeColor', [0.4,0.4, 0.4] , 'FaceColor', [0.4, 0.4, 0.4]);
end
 
%% Best_location_for_wind _turbines Function
speed_matrix = zeros(nx,ny);

% Speed is calculated at each point with the norm of each u and v vector 
% and added to speed_matrix
for i = 1:nx
    for j = 1:nx
        speed_matrix(i,j) = sqrt(u(i,j)^2 + v(i,j)^2);
    end
end

number_of_turbines = 6;

% Initializing a matrix to put coordinate and speed of each turbine  
wind_speed = zeros(number_of_turbines,3);

% title of each columne
wind_speed(1, :)= "coord y"; "coord x"; "speed";

for h = 1:number_of_turbines
    wind_speed_1 = 0;
    for i = 2:nx
        for j = 2:ny 
            if speed_matrix(i,j) > wind_speed_1
                wind_speed_1 = speed_matrix(i,j);
                wind_speed(h,3) = speed_matrix(i,j);
                wind_speed(h,2) = i;
                wind_speed(h,1) = j;
            end
        end
    end

    % The next line prevents two turbines to be next to one another
    speed_matrix(int16(wind_speed(h,2) - 1) : int16(wind_speed(h,2) + 1),...
        int16(wind_speed(h,1) - 1) : int16(wind_speed(h,1) + 1)) = 0;

    speed_matrix(wind_speed(h,2),wind_speed(h,1)) = NaN;
end

% Displaying the turbines
for T = 1:number_of_turbines
    plot(wind_speed(T,2) - 1, wind_speed(T,1) - 1,...
        'ro', 'MarkerFaceColor','r');
end

h = plot(wind_speed(1,2) - 1, wind_speed(1,1) - 1,...
    'ro','MarkerFaceColor','r');

for i = 1:number_of_turbines
    text(wind_speed(i,2) - 1, wind_speed(i,1) - 1, num2str(i),...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right',...
        'FontSize', 12, 'Color', 'r');
end

legend(h, 'Wind turbines');
hold off;

% Making a csv file for calculating the power generated by each turbines
writematrix(wind_speed, '../Internal/biggest_wind_locations.csv');

% Save the map with the winds in results folder
saveas(gcf, '../Results/Map.png');

