
StartState = Class{__includes = BaseState}

function StartState:init(def)
    self.upButton   = MoveUpCommand() 
    self.downButton = MoveDownCommand()
end

function StartState:handleInput(paddle)
    paddle.dy = PADDLE_SPEED
    if love.keyboard.isDown('up') then
        return self.upButton
    elseif love.keyboard.isDown('down') then
        return self.downButton
    else
        return nil
    end
end

function StartState:enter(params)
    -- initialize our player paddles; make them global so that they can be
    -- detected by other functions and modules
    self.player1 = params and params.player1 or Paddle(10, 30, 5, 20)
    self.player2 = params and params.player2 or Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    -- place a ball in the middle of the screen
    self.ball = params and params.ball or Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    
    -- initialize score variables
    self.player1Score = 0
    self.player2Score = 0

    -- -- either going to be 1 or 2; whomever is scored on gets to serve the
    -- -- following turn
    self.servingPlayer = params and params.servingPlayer

    -- player who won the game; not set to a proper value until we reach
    -- that state in the game
    self.winningPlayer = params and params.winningPlayer or 0
end

function StartState:exit()

end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
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
    -- player 2    
    local playerCommand = self:handleInput(self.player2)
    if playerCommand then
        playerCommand:execute(self.player2, dt)
    end
end

function StartState:render()
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    -- UI messages
    love.graphics.setFont(smallFont)
    love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    
    self.player1:render()
    self.player2:render()
    self.ball:render()    
    self:displayScore()
end

--[[
    Simple function for rendering the scores.
]]
function StartState:displayScore()
    -- score display
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(self.player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(self.player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end