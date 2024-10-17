function GravityQuest()
    % Create Figure
    f = figure('Color', 'black', 'Position', [100, 100, 800, 600], ...
               'KeyPressFcn', @keyPressHandler, ...
               'CloseRequestFcn', @closeHandler);
    
    % Initialize Game Variables
    spaceshipPos = [400, 300]; % Initial position of the spaceship
    lightCollectibles = generateLightCollectibles(50); % Generate 5 light collectibles
    blackHoles = generateBlackHoles(3); % Generate 3 black holes
    score = 0; % Initial score
  
    % Main Game Loop
    while ishandle(f)
        % Update spaceship position
        plotSpaceship(spaceshipPos);
        plotCollectibles(lightCollectibles);
        plotBlackHoles(blackHoles);
        
        % Collision Detection
        [lightCollectibles, score] = collectLight(lightCollectibles, spaceshipPos, score);
        if checkCollisionWithBlackHoles(blackHoles, spaceshipPos)
            msgbox('You collided with a black hole! Game Over!', 'Game Over', 'error');
            break;
        end
        
        % Update Score Display
        title(sprintf('Score: %d', score), 'Color', 'white');
        pause(0.1); % Control the game speed
    end
    
    function closeHandler(~, ~)
        delete(f);
    end

    function keyPressHandler(~, event)
        switch event.Key
            case 'uparrow'
                spaceshipPos(2) = min(spaceshipPos(2) + 10, 600); % Move up
            case 'downarrow'
                spaceshipPos(2) = max(spaceshipPos(2) - 10, 0); % Move down
            case 'leftarrow'
                spaceshipPos(1) = max(spaceshipPos(1) - 10, 0); % Move left
            case 'rightarrow'
                spaceshipPos(1) = min(spaceshipPos(1) + 10, 800); % Move right
        end
    end
end

function lightCollectibles = generateLightCollectibles(num)
    lightCollectibles = rand(num, 2) .* [800, 600]; % Random positions
end

function blackHoles = generateBlackHoles(num)
    blackHoles = rand(num, 2) .* [800, 600]; % Random positions
end

function plotSpaceship(pos)
    hold on;
    fill(pos(1) + [-10, 10, 0], pos(2) + [-5, -5, 10], 'c'); % Simple triangular spaceship
    axis([0 800 0 600]);
    set(gca, 'Color', 'black');
    hold off;
end

function plotCollectibles(collectibles)
    hold on;
    scatter(collectibles(:, 1), collectibles(:, 2), 100, 'yellow', 'filled'); % Light collectibles
    hold off;
end

function plotBlackHoles(holes)
    hold on;
    scatter(holes(:, 1), holes(:, 2), 200, 'black', 'filled'); % Black holes
    hold off;
end

function [lightCollectibles, score] = collectLight(lightCollectibles, spaceshipPos, score)
    for i = size(lightCollectibles, 1):-1:1
        if norm(lightCollectibles(i, :) - spaceshipPos) < 15 % Detect collision
            score = score + 1; % Increase score
            lightCollectibles(i, :) = []; % Remove collected light
        end
    end
end

function collision = checkCollisionWithBlackHoles(blackHoles, spaceshipPos)
    collision = any(vecnorm(blackHoles - spaceshipPos, 2, 2) < 25); % Collision if too close
end
