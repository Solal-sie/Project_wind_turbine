# Computational Methods and Tools - Project : Urban Wind Simulation

## Project Description 

This program simulates how wind field evolve in area. The code creates a map simulating the wind field in urban area. It evaluates where are the biggest wind, more accurately it determines the norm of the velocity vector projected in u and v direction in cartesian coordinates and calculates the the the power resulting  from this biggest wind locations.

The program will:
1. Compute randomly a map representing a random city and the coordinates of the buildings ("*building_map_main.c*", located in "*Main/*").
2. Compute The Navier-Stokes solver which creates a wind map according to the map we created before and compute 6 locations where the norm of the wind is the biggest("*Navier_Stokes_Solver_main.m*", located in "*Main/*"). 
3. From the wind map one last program use the 6 best locations to add a wind turbine and then calculates the power generated ("*turbine_power_main.c*", located in "*Main/*"). 
4. Compute a specific map representing one building and its coordinates ("*one_building_map.c*", located in "*Main/*").
5. Compute The Navier-Stokes solver for one building which creates a wind map according to the map we created before ("*Navier_Stokes_one_building.m*", located in "*Main/*"). 

## Project structure

- "*Data/*" contains all files that will be created and required for the simulation.  
- "*Main/*" contains all the C and Matlab files for the creation of the map, the propagation of the winds through the map and the power resulting from the biggest wind.
- "*Results/*" contains all the results as .csv and .png file. 

### Inputs and Outputs

Inputs:
- "*Data/Wind_Data_Lausanne.csv*" is a semicolon-delimited file.

Internal files:
- "*Internal/map_buildings.csv*" is a semicolon-delimited file.
- "*Internal/coordinates_buildings.csv*" is a semicolon-delimited file.
- "*Internal/biggest_wind_locations.csv*" is a semicolon-delimited file.

Outputs:
- "*Results/*" contains all the results: "*Map.png*", "*Power_wind_and_loc.csv*" and "*Map_one_building.png*".

## Implementation details

**Overview:**
- C creates and send .csv files which contains a map and some specific coordinates.
- The simulation is handled by Matlab. it uses the inputs, directly outputs the result of computation and visualizes it into a PNG file.
- C also handle another output.

**Structure:** In the directory "*Project_wind_turbine*" are located:

- "*Main/*" folder:
    - "*Run_All*"
        - This programm compiles and then runs all files. 
    - "*building_map_main.c*"
        - Generate a map of defined size with random sized and located buildings.
        - Compute start and end coordinates in cartesian coordinates: 
        - Export the map and coordinates of each buildings in a separated CSV located in "*Internal*".
    - "*Navier_Stokes_solver_main.m*" 
        - Reads "*Wind_Data_Lausanne.csv*" from "*Data*" folder and computes it to have the mean speed over the year.
        - Reads "*map_buildings.csv*" and "*coordinates_buildings.csv*" located in "*Internal*".
        - Computes, using "*map_buildings.csv*", the Navier-Stokes Equation and simulate on a map the wind field. 
        - Add rectangles representing buildings using "*coordinates_buildings.csv*"
        - Export the map in PNG format in the folder "*Results*".
        - Evaluates the locations of biggest wind on the map and export them in a CSV in "*Internal/*" folder. 
    - "*turbines_power_main.c*"
        - Reads "*biggest_wind_locations.csv*" and compute the velocities to find the power.
        - Writes a csv file and exports it to "*Results*" folder as "*Power_wind_and_loc.csv*".
    - "*one_building_map.c*"
        - Generate a map of defined size with one sized and located building.
        - Compute start and end coordinates in cartesian coordinates: 
        - Export the map and coordinates of each buildings in a separated CSV located in "*Internal/*".
    - "*Navier_Stokes_one_building.m*" 
        - Reads "*Wind_Data_Lausanne.csv*" from "*Data/*" folder and computes it to have the mean speed over the year.
        - Reads "*map_one_building.csv*" and "*coordinates_one_building.csv*" located in "*Internal/*".
        - Computes, using "*map_one_building.csv*", the Navier-Stokes Equation and simulate on a map the wind field. 
        - Add rectangles representing the building using "*coordinates_one_buildings.csv*"
        - Export the map in PNG format in the folder "*Results/*" as name "*Map_one_building.png*".
    

## Instructions

To reproduce results in the report, you will need to follow these steps: 

Before touching everything Run the "*Run_All*" program to compile and run all files.
    - Close the window the shows the map before reruning the program. 

- If you want to see the map from the report you have to change line 30 in "*Navier_Stokes_solver_main.m*. In the brakets of readmatrix copy/paste this: '../Internal/map_from_the_report.csv' 
If you want to go back to random buildings copy/paste this: '../Internal/map_building.csv'

1. Find "*building_map_main.c*"("*one_building_map_main.c*") in the "*Main/*" folder. Run the program.

2. Go in the "*Main/*" folder and run the "*Navier_Stokes_solver_main.m*" code. 
It may be possible that the map empties itself before the end of the iteration. 
If so, you have two choices:
                - In "*Navier_Stokes_solver_main.m*" follow comments in line 63.
                - Go back to step 1. and rerun "*building_map_main.c*".  

3. In the "*Main/*" folder run "*turbines_power_main.c**".

4. All the results except the Navier-Stokes plot will be in the "*Result/*".  

## Trouble shooting

There may be some troubles with "*Navier_Stokes_solver_main.m*":
- If the map empties itself befor the stepcount is at 100, see Instruction 2. The problem is that the viscosity of the fluid is not high enough.

"*Navier_Stokes_solver_main.m*" and "*Navier_Stokes_one_building.m*" program are quite long this is like so, because the Wind_direction function, Placing_the_building function and Best_location_for_wind_turbines are directly inside the code. Actually this is because the functions created with MATLAB function script doesn't work on others environment than the one who created it. 


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

The data files "*Wind_Data_Lausanne.csv*" comes from Prof. Satoshi Takahama personal data. 

Constants used in "*turbines_powwer_main.c*" and in "*Navier_Stokes_solver.m*" relies on the [Engineers EGDE](https://www.engineersedge.com/physics/viscosity_of_air_dynamic_and_kinematic_14483.htm).

### Formulae

The function converting the "*biggest_wind_location.csv*" into power comes from [Discover The Greentech](https://www.discoverthegreentech.com/enr/energie-eolienne/puissance/)

The resolution of the Naviers-Stokes equation relies on Prof. Lorena Barba courses on Computational Fuild Dynamic. [BarbaGroup](https://github.com/barbagroup/CFDPython)
Helped by videos Doctor Manuel Ramsaier. [Dr -ing Manuel Ramsaier](https://www.youtube.com/watch?v=rXiKiy25jGY&list=PLE4jpqcRJiBoJMMJlnWLudgBf_iQNjTz8)
