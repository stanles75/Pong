
ServeState = Class{__includes = BaseState}

function ServeState:init(def)
    self.upButton   = MoveUpCommand() 
    self.downButton = MoveDownCommand()
end

function ServeState:handleInput(paddle)
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

function ServeState:enter(params)
    self.player1        = params.player1
    self.player2        = params.player2
    self.ball           = params.ball
    self.player1Score   = params.player1Score
    self.player2Score   = params.player2Score
    self.servingPlayer  = params.servingPlayer or 1
    self.winningPlayer  = params.winningPlayer

    -- before switching to play, initialize ball's velocity based on player who last scored
    self.ball:reset()
    self.ball.dy = math.random(-50, 50)
    if self.servingPlayer == 1 then
        self.ball.dx = math.random(140, 200)
    else
        self.ball.dx = -math.random(140, 200)
    end
end

function ServeState:exit()

end

function ServeState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            player1         = self.player1,
            player2         = self.player2,
            ball            = self.ball,
            winningPlayer   = self.winningPlayer,
            servingPlayer   = self.servingPlayer,
            player1Score    = self.player1Score,
            player2Score    = self.player2Score            
        })
    end

    -- player 1 - convert to AI Player
    local aiCommand
    aiCommand = self.player1:processAI(self.ball)
    if aiCommand then
        aiCommand:execute(self.player1, dt)
    end

    -- player 2    
    local playerCommand = self:handleInput(self.player2)
    if playerCommand then
        playerCommand:execute(self.player2, dt)
    end
end

function ServeState:render()
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    -- UI messages
    love.graphics.setFont(smallFont)
    love.graphics.printf('Player ' .. tostring(self.servingPlayer) .. "'s serve!", 
        0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center') 

    self.player1:render()
    self.player2:render()
    self.ball:render()    
    self:displayScore()
end

--[[
    Simple function for rendering the scores.
]]
function ServeState:displayScore()
    -- score display
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(self.player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(self.player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end