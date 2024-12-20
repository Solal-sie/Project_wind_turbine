#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define RHO_AIR 1.814 //  Density of air [km/m^3]
#define Cp 0.35  // Coefficient of power
#define A 0.16 // Area of the blade [m^2]
#define COL 4
#define ROW 6
#define YIELD 0.35  // Yield of the turbine

// Function to calculate the power of the wind turbine
void wind_power(double *speed, double *power, int count) {
    
    for (int i= 0; i < 6; i++){
        power[i] = YIELD * RHO_AIR * Cp * A * pow(speed[i], 3) * 1/2;
    }
    return;
}

// Function to write the power of the wind turbine in a csv file
void power_to_csv(const char *filename, int *x, int *y, double * speed, double * power, int count) {
    wind_power(speed, power, count);

    FILE *speed_and_power = fopen(filename, "w");
    if (speed_and_power == NULL) {
        printf("%s file not found\n", filename);
        return; 
    }

    // Title of the columns
    fprintf(speed_and_power, "coord x, coord y, speed, power\n");

    // Write the coordinate,speed and power of the wind turbine in the csv file
    for (int i = 0; i < ROW; i++) {
        fprintf(speed_and_power, "%d, %d, %lf,%lf\n", x[i], y[i], speed[i], power[i]);
    }
    fclose(speed_and_power); 
}

 
int main() {
    // Open the file with the biggest wind locations
    FILE *big_wind_loc = fopen("../internal/biggest_wind_locations.csv","r");
    if (big_wind_loc == NULL) {
        printf("file not found\n");
        return 1;
    }
    
    // intitialization
    int count = 0; 
    int x[ROW], y[ROW];
    double speed[ROW], power[ROW];

    // Read the file and store the data in the arrays
    while (fscanf(big_wind_loc, "%d,%d,%lf", &y[count], &x[count], &speed[count])){
        count++;
        if (count >=ROW) {
            break;
        }
    }
    fclose(big_wind_loc);

    // Write the power of the wind turbine in a csv file
    power_to_csv("../Results/Power_wind_and_loc.csv", x, y, speed, power, count);
    return 0;
}