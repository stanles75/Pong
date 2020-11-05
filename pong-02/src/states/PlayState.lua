
PlayState = Class{__includes = BaseState}

function PlayState:init(def)
    self.upButton   = MoveUpCommand() 
    self.downButton = MoveDownCommand()
    -- self.upButton   = MoveDownCommand()
    -- self.downButton = MoveUpCommand() 
end

function PlayState:enter(params)
    self.player1        = params.player1
    self.player2        = params.player2
    self.ball           = params.ball
    self.player1Score   = params.player1Score
    self.player2Score   = params.player2Score
    self.servingPlayer  = params.servingPlayer or 1
    self.winningPlayer  = params.winningPlayer
end

function PlayState:exit()

end

function PlayState:handleInput(paddle)
    if love.keyboard.isDown('up') then
        paddle.dy = -PADDLE_SPEED
        return self.upButton
    elseif love.keyboard.isDown('down') then
        paddle.dy = PADDLE_SPEED
        return self.downButton
    else
        return nil
    end
end

function PlayState:update(dt)

    self:checkCollisions()
    self:checkForWin()

    -- player 1 - convert to AI Player
    local aiCommand
    aiCommand = self.player1:processAI(self.ball)
    if aiCommand then
        aiCommand:execute(self.player1, dt)
    end

    -- player 2 - convert to AI Player
    -- local aiCommand
    -- aiCommand = self.player2:processAI(self.ball)
    -- if aiCommand then
    --     aiCommand:execute(self.player2, dt)
    -- end

    -- player 2    
    local playerCommand = self:handleInput(self.player2)
    if playerCommand then
        playerCommand:execute(self.player2, dt)
    end

    self.ball:update(dt)    
end

function PlayState:checkCollisions()
    -- detect ball collision with paddles, reversing dx if true and
    -- slightly increasing it, then altering the dy based on the position
    -- at which it collided, then playing a sound effect
    if self.ball:collides(self.player1) then
        self.ball.dx = -self.ball.dx * 1.03
        self.ball.x = self.player1.x + 5

        -- keep velocity going in the same direction, but randomize it
        if self.ball.dy < 0 then
            self.ball.dy = -math.random(10, 150)
        else
            self.ball.dy = math.random(10, 150)
        end

        sounds['paddle_hit']:play()
    elseif self.ball:collides(self.player2) then
        self.ball.dx = -self.ball.dx * 1.03
        self.ball.x = self.player2.x - 4

        -- keep velocity going in the same direction, but randomize it
        if self.ball.dy < 0 then
            self.ball.dy = -math.random(10, 150)
        else
            self.ball.dy = math.random(10, 150)
        end

        sounds['paddle_hit']:play()
    end

    -- detect upper and lower screen boundary collision, playing a sound
    -- effect and reversing dy if true
    if self.ball.y <= 0 then
        self.ball.y = 0
        self.ball.dy = -self.ball.dy
        sounds['wall_hit']:play()
    -- -4 to account for the ball's size
    elseif self.ball.y >= VIRTUAL_HEIGHT - 4 then
        self.ball.y = VIRTUAL_HEIGHT - 4
        self.ball.dy = -self.ball.dy
        sounds['wall_hit']:play()
    end
end

function PlayState:checkForWin()
    -- if we reach the left edge of the screen, go back to serve
    -- and update the score and serving player
    if self.ball.x < 0 then
        self.servingPlayer = 1
        self.player2Score = self.player2Score + 1
        sounds['score']:play()

        -- if we've reached a score of 10, the game is over; set the
        -- state to done so we can show the victory message
        if self.player2Score == 10 then
            self.winningPlayer = 2
            gStateMachine:change('done', { 
                player1         = self.player1,
                player2         = self.player2,
                ball            = self.ball,
                winningPlayer   = self.winningPlayer,
                servingPlayer   = self.servingPlayer,
                player1Score    = self.player1Score,
                player2Score    = self.player2Score
            })
        else
            gStateMachine:change('serve', { 
                player1         = self.player1,
                player2         = self.player2,
                ball            = self.ball,
                winningPlayer   = self.winningPlayer,
                servingPlayer   = self.servingPlayer,
                player1Score    = self.player1Score,
                player2Score    = self.player2Score
            })
        end
    end

    -- if we reach the right edge of the screen, go back to serve
    -- and update the score and serving player
    if self.ball.x > VIRTUAL_WIDTH then
        self.servingPlayer = 2
        self.player1Score = self.player1Score + 1
        sounds['score']:play()

        -- if we've reached a score of 10, the game is over; set the
        -- state to done so we can show the victory message
        if self.player1Score == 10 then
            self.winningPlayer = 1
            gStateMachine:change('done', { 
                player1         = self.player1,
                player2         = self.player2,
                ball            = self.ball,
                winningPlayer   = self.winningPlayer,
                servingPlayer   = self.servingPlayer,
                player1Score    = self.player1Score,
                player2Score    = self.player2Score
            })
        else
            gStateMachine:change('serve', { 
                player1         = self.player1,
                player2         = self.player2,
                ball            = self.ball,
                winningPlayer   = self.winningPlayer,
                servingPlayer   = self.servingPlayer,
                player1Score    = self.player1Score,
                player2Score    = self.player2Score
            })
        end
    end
end


function PlayState:render()
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    
    self.player1:render()
    self.player2:render()
    self.ball:render()    
    self:displayScore()
end

--[[
    Simple function for rendering the scores.
]]
function PlayState:displayScore()
    -- score display
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(self.player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(self.player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end