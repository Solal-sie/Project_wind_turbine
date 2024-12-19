% Executes the first C program 
status = system('../Map/building_map_main.exe');
if status ~= 0
    error('Erreur lors de l''exécution du programme C');
end

% Executes the MATLAB program
try
    Navier_Stokes_solver_main;
catch
    error('Erreur lors de l''exécution du programme MATLAB');
end

% Executes the second C program

status = system('../Power/turbines_power_main.exe');
if status ~= 0
    error('Erreur lors de l''exécution du deuxième programme C');
end

disp('Tous les programmes ont été exécutés avec succès')