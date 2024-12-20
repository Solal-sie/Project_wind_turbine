% Code for the automation of the project

%Name of the C source file and the compiled program
sourceFile1 = 'building_map_main.c';
compiledProgram1 = 'building_map_main.out';

[status, cmdout1] = system(sprintf('gcc %s -lm -o %s', sourceFile1, compiledProgram1));
assert(status == 0, 'Error during C code compilation:\n%s', cmdout1);
 
%Run the C program
cmd1 = sprintf('%s',compiledProgram1);

[status, cmdout1] = system(cmd1);
if status ~= 0
    error('Erreur lors de l''exécution du  programme C');
end

% Executes the MATLAB program
try
    Navier_Stokes_solver_main;
catch
    
end


%Name of the C source file and the compiled program
sourceFile2 = 'turbines_power_main.c';
compiledProgram2 = 'turbines_power_main.out';

[status, cmdout2] = system(sprintf('gcc %s -lm -o %s', sourceFile2, compiledProgram2));
assert(status == 0, 'Error during the second C code compilation:\n%s', cmdout2);


%Run the C program
cmd2 = sprintf('%s', compiledProgram2);
[status, cmdout2] = system(cmd2);

if status ~= 0
    error('Erreur lors de l''exécution du deuxieme programme C');
end


%% runs the second code for one building
%Name of the C source file and the compiled program
sourceFile3 = 'one_building_map.c';
compiledProgram3 = 'one_building_map.out';

[status, cmdout3] = system(sprintf('gcc %s -lm -o %s', sourceFile3, compiledProgram3));
assert(status == 0, 'Error during C code compilation:\n%s', cmdout3);
 
%Run the C program
cmd3 = sprintf('%s',compiledProgram3 );

[status, cdmout3] = system(cmd3);

if status ~= 0
    error('Erreur lors de l''exécution du  programme C');
end

% Executes the MATLAB program
try
    Navier_Stokes_one_building;
catch
    error('Erreur lors de l''exécution du programme MATLAB');
end