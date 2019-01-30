
% Author: Stefano Balietti and Karsten Donnay, 2012

% Simulate disease spreading on a 2D grid

% Set parameter values
N=100;              % Grid size (NxN)
beta=0.01;          % Infection rate
gamma=0.01;         % Immunity rate

% define grid
x = zeros(N, N);    % The grid x, is coded as:  0=Susceptible, 1=Infected, 2=Removed


% Set the initial grid, x with a circle of infected individuals in the
% center of the grid, and with a radius of 10 cells.
for i=1:N
    for j=1:N
        dx = i-N/2;
        dy = j-N/2;
        R = sqrt(dx*dx+dy*dy);
        if ( R<=10 )
            x(i,j)=1;
        end
        
    end         
end


%%

S = zeros(5000,1);
I = zeros(5000,1);
D =zeros(5000,1);

% Define the Moore neighborhood, i.e. the 8 nearest neighbors
neigh = [-1 -1; 0 -1; 1 -1; 1 0; 1 1; 0 1; -1 1; -1 0; -2 2; -2 1; -2 0; -2 -1; -2 -2; -1 2; -1 -2; 0 2; 0 -2; 1 2; 1 -2; 2 2; 2 1; 2 0; 2 -1; 2 -2];

% Create a new figure
figure

% main loop, iterating the time variable, t
for t=1:5000
 
    % iterate over all cells in grid x, for index i=1..N and j=1..N
    for i=1:N
        for j=1:N
            
            % Iterate over the neighbors and spread the disease
            for k=1:length(neigh)
                i2 = i+neigh(k, 1);
                j2 = j+neigh(k, 2);
                % Check that the cell is within the grid boundaries
                if ( i2>=1 && j2>=1 && i2<=N && j2<=N )
                    % if cell is in state Susceptible and neighboring cell
                    % Infected => Spread infection with probability beta
                    if ( x(i,j)==0 && x(i2, j2)==1 )
                        if ( rand<beta )
                            x(i,j) = 1;
                        end
                    end
                end
            end
            % If infected => Recover from disease with probability gamma
            if ( x(i,j)==1 && rand<gamma )
                x(i,j) = 2;
            end

            if (x(i,j) == 0)
            S(t) = S(t)+1;
        elseif (x(i,j) == 1)
                I(t) = I(t)+1;
        else
            D(t) = D(t)+1;
            end
        end
    end

    % Animate
    clf                                 % Clear figure
    imagesc(x, [0 2])                   % Display grid
    pause(0.01)                         % Pause for 0.01 s
    colormap([1 0 0; 0 1 0; 0 0 1]);    % Define colors: Red, Green, Blue
    
    % If no more infected => Stop the simulation
    if ( sum(x==1)==0 )
        break;
    end

end
%%
plot(S, 'b');
hold on;
plot(I, 'r');
plot(D, 'g');
