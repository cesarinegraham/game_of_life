
%{ 
RULES OF CONWAYS GAME OF LIFE
1. Any live cell with fewer than two live neighbors dies, as if caused by under-population.
2. Any live cell with two or three live neighbors lives on to the next generation.
3. Any live cell with more than three live neighbors dies, as if by overcrowding.
4. Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.

%}

clc
clear

%redefining variables that are defined in other functions to fix scope issues
dataLog = "";
cellDeathCounter = 0;
cellBirthCounter = 0;

fprintf("<strong>Start Time</strong> : %s \n", string(datetime('now','Timezone', 'local', 'Format', 'd-MMM-y HH:mm:ss:SS')));
dataLog = dataLog + "\nStart Time : " + timeStamping();

%skipping the menu option
message = "Would you like to skip the intro to this game?";
optionsZero = ["Yes" "No"];
choicezero = menu(message, optionsZero);
    if (choicezero == 2)
        %Informing the User
        waitfor(msgbox("Welcome! This program will be running Conway's Game of Life. Please hit OK to learn about the Game of Life."));
        waitfor(msgbox("Conway's Game of Life is a very simple simulation. There are four rules that are applied to a grid of randomly placed pixels."));
        waitfor(msgbox(["Here are the four rules of the Game of Life: " ; "1. Any live cell with fewer than two live neighbours dies, as if caused by under-population." ; "2. Any live cell with two or three live neighbours lives on to the next generation." ; "3. Any live cell with more than three live neighbours dies, as if by overcrowding." ; "4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction."]));
        waitfor(msgbox(["There are three different kinds of civilizations that can be produces from simulation: " ; "1. Still lifes" ; "2. Oscillators" ; "3. Spaceships"]));
       (msgbox("Your inputs for the game layout will determine the production of the different civilizations. Keep in mind that the game is a simulation based upon pixels, therefore, the larger the grid size you set, the longer the simulation will run."));
        
    elseif (choicezero == 1)
        fprintf ("You chose to skip the intro.")
    end

% The Grid Size Choice Menu
message = "What size grid would you like to run the game on?";
optionsFirst = ["150 x 150" "100 x 100" "50 x 50"];
choiceFirst = menu(message,optionsFirst);
    if (choiceFirst == 1) 
        lengthX = 150;
        lengthY = 150;
    elseif (choiceFirst == 2) 
        lengthX = 100;
        lengthY = 100;
    elseif (choiceFirst == 3)  
        lengthX = 50;
        lengthY = 50;
    end

%color of the grid menu option
message = "What color grid would you like to run the game on?";
optionsSecond = ["Winter" "Summer" "Spring" "Autumn" "Parula" "Copper" "Bone"];
choiceSecond = menu(message,optionsSecond);
    if (choiceSecond == 1)  
        color = colormap(flipud(winter));
    elseif (choiceSecond == 2)  
        color = colormap(flipud(summer));
    elseif (choiceSecond == 3)  
        color = colormap(flipud(spring));
    elseif (choiceSecond == 4) 
        color = colormap(flipud(autumn));
    elseif (choiceSecond == 5)  
        color = colormap(flipud(parula));
    elseif (choiceSecond == 6) 
        color = colormap(flipud(copper));
    elseif (choiceSecond == 7) 
        color = colormap(flipud(bone));
    end

%the speed of the simulation menu
message = "What speed would you like the game to run at?";
optionsThird = ["Slow" "Medium" "Fast (Recommended)"];
choiceThird = menu(message,optionsThird);
    if (choiceThird == 1) 
        setSpeed = 2;
    elseif (choiceThird == 2) 
        setSpeed = 0.5;
    elseif (choiceThird == 3)  
        setSpeed = 0.001;
    end

% Initial Cell for Random Pattern
cells = zeros(lengthX, lengthY);

%setting up the extinction button
c = uicontrol;
c.String = 'EXTINCTION';
c.Value = 1;
c.Callback = "c.Value =0;"; %Callback can actually run lines of code.

%setting up the subplots for the figure and the image
RGB = imread('GOL_Civilizations.jpg');
subplot(1,2,1)

% Generate random life cells
nInitial = numel(cells) / 10;
initialCells = randperm(numel(cells), nInitial);   
cells(initialCells) = 1;
showCells(cells,color,setSpeed);

%subplotting the reference image next to the game so the user can view
%both of them at the same time
subplot(1,2,2)
imshow(RGB);
hold on; %this is so the image is not overwritten

% Set up of the While Loop to enable Continuous Animation
while (c.Value)
subplot(1,2,1)   %stating this again so it will only update the figure on the left
    % Creation of the next generation
    [cellsNew, dataLog, cellDeathCounter, cellBirthCounter] = findNeighbor(cells, dataLog, cellDeathCounter, cellBirthCounter);        
    % Update as per the Rules
    cells = cellsNew;
    % Visualization of the Cells
    showCells(cells,color,setSpeed); 
end

close all   % close the figure. 

%file I/O for the time logging
dataLog= sprintf(dataLog);  
fprintf("\n<strong>Start Time of the Program</strong> : %s", dataLog);
stringDateTime = timeStamping();
%for the user to see the end time right away
fprintf("\n<strong>End Time of the Program : </strong>%s", stringDateTime);

%adding data to the time logging sheet text file
dataLog = dataLog + "\n\nTotal Cell Deaths : " + cellDeathCounter;
dataLog = dataLog + "\nTotal Cell Births : " + cellBirthCounter;
dataLog = dataLog + "\n\nEnd Time of the Program : " + stringDateTime +"\n\n _____________________________ \n";
dataLog = sprintf(dataLog);  
fileId = fopen("GOL_Log.txt", 'a'); 
fprintf(fileId, "%s\n",dataLog);
fclose(fileId);

%telling the user how many cell died and how many were birthed
fprintf("\n<strong>Total Cell Deaths</strong> : %d", cellDeathCounter);
fprintf("\n<strong>Total Cell Births</strong> : %d", cellBirthCounter);

%telling the user that the data is in the text file
fprintf("\n\n<strong>The data has been compiled into GOL_Log.txt</strong>\n");

%this is for the time-stamping done within the program
function stringDateTime = timeStamping()
timeStamp = datetime('now','Timezone', 'local', 'Format', 'd-MMM-y HH:mm:ss:SS');
stringDateTime = string(timeStamp);
end

%this is to implement the rules of the game into the code
function [cellsNew, dataLog, cellDeathCounter, cellBirthCounter] = findNeighbor(cells, dataLog, cellDeathCounter, cellBirthCounter)  
%Creating variables for the cell counters
    cellDeathCounter = 0;
    cellBirthCounter = 0;

% creating the periodic boundary conditions for the four corners
    cellsNextGen(1, 1) = cells(end, end);
    cellsNextGen(1, end) = cells(end, 1);
    cellsNextGen(end, 1) = cells(1, end);
    cellsNextGen(end, end) = cells(1, 1);
    [x, y] = size(cells);

% creating the periodic boundary conditions for the grid
    cellsNextGen = zeros(size(cells)+2);
    cellsNextGen(2:end-1, 2:end-1) = cells;
    cellsNextGen(1, 2:end-1) = cells(end, :);
    cellsNextGen(end, 2:end-1) = cells(1, :);
    cellsNextGen(2:end-1, 1) = cells(:, end);
    cellsNextGen(2:end-1, end) = cells(:, 1);

%creating the first grid
    cellsNew = zeros(size(cells));
    initialCells = 0;

%creating the conditions for the four rules of the game
for y_0 = 2:y+1 
    
    for x_0 = 2:x+1 
        initialCells = initialCells + 1; 
        gridCount = sum(sum(cellsNextGen(x_0-1:x_0+1, y_0-1:y_0+1))) - cells(initialCells); 
        
        % Rule 1: Any live cell with fewer than two live neighbors dies
        if (cells(initialCells) == 1) && (gridCount < 2)
            cellsNew(initialCells) = 0; 
            %adding to the data log when the cell dies
            stringDateTime = timeStamping();
            dataLog = dataLog + "\nCell Death : " + stringDateTime;
            cellDeathCounter = cellDeathCounter + 1; 
        end
        
        % Rule 2: Any live cell with two or three neighbors lives
        if (cells(initialCells) == 1) && ((gridCount == 2) || (gridCount == 3)) 
            cellsNew(initialCells) = 1; 
        end
        
        % Rule 3: Any live cell with more than three live neighbors dies
        if (cells(initialCells) == 1) && (gridCount > 3)
            cellsNew(initialCells) = 0;  
            %adding to the data log when the cell dies
            stringDateTime = timeStamping();
            dataLog = dataLog + "\nCell Death : " + stringDateTime;
            cellDeathCounter = cellDeathCounter + 1; 
        end
        
        % Rule 4: Any dead cell with three live neighbors becomes alive
        if (cells(initialCells) == 0) && (gridCount == 3) 
            cellsNew(initialCells) = 1;
            %adding to the data log when a cell is birthed
            stringDateTime = timeStamping();
            dataLog = dataLog + "\nCell Birth : " + stringDateTime;
            cellBirthCounter = cellBirthCounter + 1; 
        end
    end
    
end
end

%This is for the display of the game
function showCells(cells,color,setSpeed)
imagesc(cells); 
colormap(flipud(color)); axis equal; axis off; drawnow 
pause(setSpeed); %for the speed of the game
end

