# Computational Methods and Tools - Project : Urban Wind Simulation

## Project Description 

This program simulates how wind field evolve in area. The code creates a map simulating the wind field in urban area. It evaluates where are the biggest wind, more accurately it determines the norm of the velocity vector projected in u and v direction in cartesian coordinates and calculates the the the power resulting  from this biggest wind locations.

The program will:
1. Compute randomly a map representing a random city and the coordinates of the buildings ("*building_map_main.c*", located in "*Map*").
2. Compute The Navier-Stokes solver which creates a wind map accoring to the map we created before and compute 6 locations where the norm of the wind is the biggest("*Navier_Stokes_Solver_main.m*", located in "*Main*"). 
3. From the wind map one last program use the 6 best locations to add a wind turbine and then calculates the power generated ("*turbine_power_main.c*", located in "*Power*"). 

## Project structure

- "* Data*" contains allthe files that will be created and required for the simulation.  
- "*Map*" contains the map program code that creates map.
- "*Main*" runs the propagation of the winds through the map.
- "*Power*" contains the power calculating program
- "*Results*" contains all the results as .csv and .png file. 

### Inputs and Outputs

Inputs:
- "*Data/Wind_Data_Lausanne.csv*" is a semicolon-delimited file.

Internal files:
- "*Internal/map_buildings.csv*" is a semicolon-delimited file.
- "*Internal/coordinates_buildings.csv*" is a semicolon-delimited file.
- "*Internal/biggest_wind_locations.csv*" is a semicolon-delimited file.

Outputs:
- "*Results*" contains all the results: "*Map.png* and "*Power_wind_and_loc*".

## Implementation details

**Overview:**
- C creates and send .csv files which contains a map and some specific coordinates.
- The simulation is handled by Matlab. it uses the inputs, directly outputs the result of computation and visualizes it into a PNG file.
- C also handle another output.

**Structure:** In the directory "*Project_main/*" are located:
- "*Map/*" folder:
    - "*building_map_main.c*"
        - Generate a map of defined size with random sized and located buildings.
        - Compute start and end coordinates in cartesian coordinates: 
        - Export the map and coordinates of each buildings in a separated CSV located in "*Internal*".
- "*Main/*" folder:
    - "*Navier_Stokes_solver_main.m*" 
        - Reads "*Wind_Data_Lausanne.csv*" from "*Data/*" folder and compute it to have the mean speed over the year.
        - Reads "*map_buildings.csv*" and "*coordinates_buildings.csv*" located in "*Internal*".
        - Compute, using "*map_buildings.csv*", the Navier-Stokes Equation and simulate on a map the wind field. 
        - Add squares representing buildings using "*coordinates_buildings.csv*"
        - Export the map in PNG format in the folder "*Results/*".
        - Evaluates the locations of biggest wind on the map and export them in a CSV in    "*Internals/*" folder. 
- "*Power/*" folder:
    - "*turbines_power_main.c*"
        - Reads "*biggest_wind_locations.csv*" and compute the velocities to find to power.
        - Write a csv file and exports it to "*Results/*" folder as "*Power_wind_and_loc.csv*".

## Instructions

To reproduce results in the report, you will need to follow these steps:


- If you want to generate a one building map, first make some changes in "*Navier_Stokes_solver_main.m*":
    - Go to line 29 and comments it, then see line 31 and decomments it.
    - Go to line 37 and comments it, then see line 39 and decomments it.
Do the same instructions, but use the program in brakets. 

- If you want to see the map on the report you to change line 31 in "*Navier_Stokes_solver_main.m*. in the brakets of readmatrix copy/paste this: '../Internal/map_from_the_report.csv' 
If you want to go back to random buildings copy/paste this: '../Internal/map_building.csv'

1. Find "*building_map_main.c*"("*one_building_map_main.c*") in the "*Map/*" folder. Run the programme.

2. Go in the "*Main/*" folder and run the "*Navier_Stokes_solver_main.m*" code. 
It may be possible the map empties itself before the end of the iteration. 
If so, you have two choises:
                - In "*Navier_Stokes_solver_main.m*" follow comments in line 68.
                - Go back to step 1. and rerun "*building_map_main.c*".  

3. Find the "*Power/*" folder and run "*turbines_power_main**". 



## Requirememnts

Version of MATLAB used is as follow.
```
MATLAB Version: 24.2.0.2712019 (R2024b)$

```
Version of C used is as follow.
```
gcc.exe (Rev3, Built by MSYS2 project) 14.1.0

```
No specific libraries are required for the program to work

### Data

The data files "*Wind_Data_Lausanne.csv*" comes from ????????????????

Constants used in "*turbines_powwer_main.c*" and in "*Navier_Stokes_solver.m*" relies on the [Engineers EGDE](https://www.engineersedge.com/physics/viscosity_of_air_dynamic_and_kinematic_14483.htm).

### Formulae

The function converting the "*biggest_wind_location.csv*" into power comes from [Discover The Greentech](https://www.discoverthegreentech.com/enr/energie-eolienne/puissance/)

The resolution of the Naviers-Stokes equation relies on Prof. Lorena Barba courses on Computational Fuild Dynamic. [BarbaGroup](https://github.com/barbagroup/CFDPython)
Helped by videos Doctor Manuel Ramsaier. [Dr -ing Manuel Ramsaier](https://www.youtube.com/watch?v=rXiKiy25jGY&list=PLE4jpqcRJiBoJMMJlnWLudgBf_iQNjTz8)
