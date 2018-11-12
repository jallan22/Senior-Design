% ML_tutotial.m
%
% DESCRIPTION: Documentation of common useful features of Matlab
%
% EDC Systems - ECE 4805: Senior Design
%
% Origional Version [11/09/2018], Peyton McClintock

clear,clc

%% Tip 

% It is useful to put 'clear' and/or 'clc' at the beginning of every
% program. Clear will clear the workspace while clc clears the command
% window

%% Comments 

% '%' makes everything after is a comment

% '%%' starts a large section, and can be made collapsable in
% home/preferances/EditorDebugger/CodeFolding

% To turn multiple lines of code into a comment, select the lines with the
% cursor and press CTRL+R, try it on the lines below

warning('COMMENT OUT THIS LINE TO CONTINUE!')
warning('COMMENT OUT THIS LINE TO CONTINUE!')

% To undo comments, select the lines and press CTRL+T, try on the lines
% below

% disp('Uncomment this line...')
% disp('Congrats!')

%% Debugging 

% Debugging is a powerful tool. Simply, the dubugger can be used to stop a
% program on a certian line. This is done by left clicking on the "-" next
% to an executible line of code. Once in the debugger, you have additional
% controls on the top pannel, such as "continue" and "step". Continue will
% coontinue the program and step will move to the next line. Also, you can
% see what function you are in by usnig the stack. Try debugging on the
% lines below.

x = 1;
x = 2;
x = 3;

% Another useful debugging technique is executing only certian lines of
% code at a time, rather that the whole script. This is done by selecting
% the code you wish to run and pressing F9. Try is on the code below, ==
% without commenting it out!

% disp('I Pressed F9!')

% Finally, it is possible to be sent directly into the debugger as soon as
% an error occurs. This can be done by tying the following line of code...

dbstop if error

% y=undefinedVar;

% Now, you will enter the debugger on the line of code that produces an
% aeeor, rather then going back and debugging it iself. To stop this, type
% the following code.

dbclear if error

% y=undefinedVar;

%% Indexing

m = [1 2 3; 4 5 6; 7 8 9].' -1;

% The most important thing to know about indexing in Matlab is that
% indexing is ones based. This means that the first indicie of a vector is
% vector(1), NOT vector(0). This holds true for all dimesnions.

% Another useful tool of indexing is selecting certian dimensions

%% Defining Arrays 

% Arrays are defined using [row,col] notation. where row is dimension 1,
% col is dimension, and any other dimensions are 3 and beyond. Here are a
% few useful ways of defining arrays. Use F9 to quickly see how they work.

% 1. Defining a vector of known points

vector1 = [1 2 3];

    % Dimensions can be changed or altered using the following commands...
    % .'
    % '
    % flipud
    % fliplr
    % reshape
    % repmat

% 2. Defining a vector of equally spaced points

vector2 = 1:9;
vector3 = 1:0.5:10;

% 3. Matrix Definition

matrix1 = [1 4 7;
           2 5 9;
           3 6 9;];
       % Grab indicies by...
       % matrix1(2)
       % matrix1(2,1)
       % matrix1(2,:)
       % matrix1(:,2)
       
% 4. Combining Matricies

matrix2 = reshape(vector2,[3,3]); % == matrix1
matrix3 = [matrix1 matrix2];

% 5. Non-numerical arrays

% Arrays that arent limited to numbers are cell arrays and structures. They
% both have many uses while coding.

% Cell arrays are defined as follows, as you can see, they hold many data
% types.
cell1 = {'string', 1, @sin};
% To grab cell indicies, you have two options. To grab the cell, simply use
% the folloowing.
cell1_idx1_cell = cell1(1);
% To grab the information a specific cell index holds, use the following.
cell1_idx1_data = cell1{1};

%% Structures

%% Plotting and Figures 
