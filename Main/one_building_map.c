#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Create one builing in the middle of the map and write the coordinates in a csv file
void one_building(const char * filename, int **list, int x_size, int y_size) {
    
    // Creates the file
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("%s file not found\n", filename);
        return; 
    }

    fprintf(file, "start x, start y, end x, end y\n");

    // fill the map with 0
    for (int i = 0; i < x_size; i++) {
        for (int j = 0; j < y_size; j++) {
            list[i][j] = 0;
        }
    }

    // Size of the building
    int b_size = 24 ;

    //  Start coordinates of the building 
    int dep_x = (x_size/2) - 12;
    int dep_y = (y_size/2) - 12;

    // End coordinates of the building
    int end_x = dep_x + b_size;
    int end_y = dep_y + b_size;

    // Fill the file with the coordinate of the building
    fprintf(file, "%d, %d, %d, %d\n", dep_x, dep_y, end_x, end_y);

    // Fill the map with the building
    for (int k = 0; k < x_size; k++) {
        for(int l = 0; l < y_size; l++){
            if (k >= dep_x && k <= end_x && l >= dep_y && l <= end_y) {
                list[k][l] = 1; // building
            } if (list[k][l] == 1 ) {
                // already a building
            } 
        } 
    }
    fclose(file);
}

// Function to write the map in a csv file
void map_bat_to_csv( int **list, const char *filename2, int x_size, int y_size) {
   
    FILE *file = fopen(filename2, "w");
    if (file == NULL) {
        printf("%sfile not found\n", filename2);
        return; 
    }

    // Write the map in the csv file
    for (int i = 0; i < x_size; i++) {
        for (int j = 0; j < y_size; j++) {
            fprintf(file, "%d", list[i][j]);
            if (j < y_size - 1) {
                fprintf(file,",");
            }
        }
        fprintf(file, "\n");
    }
    fclose(file);
}

int main() {
    
    // Size of the map
    int nx = 51;          
    int ny = 51; 
    
    // Create the malloc of buildings
    int **build = (int **)malloc(nx * sizeof(int *));
    for (int i = 0; i < nx; i++) {
        build[i] = (int *)malloc(ny * sizeof(int));
    }

    // Create the buildings and write the coordinates in a csv file
    one_building("../Internal/coordinates_one_building.csv",build, nx, ny); 
    
    // Write the map in a csv file
    map_bat_to_csv(build, "../Internal/map_one_building.csv", nx, ny);

    // Free the malloc
    for (int i = 0; i < nx; i++) {
        free(build[i]);
    }
    free(build);
    return 0;
}