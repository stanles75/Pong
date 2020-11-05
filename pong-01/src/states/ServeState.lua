
ServeState = Class{__includes = BaseState}

function ServeState:init(def)

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
    --   * Match the ball's dy unless it would cause the paddle to move away from the ball
    --   * Move back toward the middle between serves
    if math.abs(self.player1.y-self.ball.y) < 10 then
        self.player1.dy = 0
    elseif self.player1.y > self.ball.y and self.ball.dy > 0 then
        self.player1.dy = -self.ball.dy
    elseif self.player1.y < self.ball.y and self.ball.dy < 0 then
        self.player1.dy = -self.ball.dy
    else
        self.player1.dy = self.ball.dy
    end
    -- if ball/paddle y coords are far apart on a shallow bounce, speed up the paddle
    if math.abs(self.player1.y - self.ball.y) > (VIRTUAL_HEIGHT * 0.05)  then
        self.player1.dy = self.player1.dy * 10
    end
    
    -- player 2
    if love.keyboard.isDown('up') then
        self.player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        self.player2.dy = PADDLE_SPEED
    else
        self.player2.dy = 0
    end

    self.player1:update(dt)
    self.player2:update(dt)
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