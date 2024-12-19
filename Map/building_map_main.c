#include <stdio.h>
#include <stdlib.h>
#include <time.h>


void random_building_create(const char * filename,int **list, int x_size, int y_size) {
    // function to create random buildings on the map. 
    // It will create a csv file with the coordinates of the buildings.

    //Initialization of the file 
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("%s file not found\n", filename);
        return; 
    }

    fprintf(file, "start x, start y, end x, end y\n");

    //Initialization of the list to 0
    for (int i = 0; i < x_size; i++) {
        for (int j = 0; j < y_size; j++) {
            list[i][j] = 0;
        }
    }

    // Number of buildings on the map 
    int nb_bat = 30; 

    // Loop to create random sized buildings 
    for (int j = 0; j < nb_bat; j++){

        // Size of the buildings (random size between 1 and 9) 
        int size_in_x = rand() % 8 + 1;
        int size_in_y = rand() % 8 + 1; 
    
        // Starting coordinates of the building (made sure that the building is not on the edges of the map)
        int start_x = rand() % (x_size - 4) + 2; 
        int start_y = rand() % (y_size - 4) + 2;

        // Check if buildings do not go beyond the map
        int if_building_out[9];  
        for (int i=0; i <= 9; i++ ) { 
            if_building_out[i] = x_size-i; 

            if (if_building_out[i] == start_x) {
                start_x = start_x - 9; //bonne taille
                
            } if (if_building_out[i] == start_y) {
                start_y = start_y - 9;
                
            } 
        }
       
        // End coordinates of the building
        int fin_x = start_x + size_in_x;
        int fin_y = start_y + size_in_y;

        // Write the coordinates of the buildings in the CSV file
        fprintf(file, "%d, %d, %d, %d\n", start_x, start_y, fin_x, fin_y);

        // Fill the list with the buildings(1)
        for (int k = 0; k < x_size; k++) {
            for(int l = 0; l < y_size; l++){
                if (k >= start_x && k <= fin_x && l >= start_y && l <= fin_y) {
                    list[k][l] = 1; // building 
                } if (list[k][l] == 1 ) {
                    // already a building
                } 
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
    
    // Seed for random number
    srand(time(NULL)); 

    // Size of the map
    int nx = 51;          
    int ny = 51; 
    
    // Create the malloc of buildings
    int **build = (int **)malloc(nx * sizeof(int *));
    for (int i = 0; i < nx; i++) {
        build[i] = (int *)malloc(ny * sizeof(int));
    }

    // Create the buildings and write the coordinates in a csv file
    random_building_create("../Internal/coordinates_buildings.csv",build, nx, ny); 
    
    // Write the map in a csv file
    map_bat_to_csv(build, "../Internal/map_buildings.csv", nx, ny);

    // Free the malloc
    for (int i = 0; i < nx; i++) {
        free(build[i]);
    }
    free(build);
    return 0;
}