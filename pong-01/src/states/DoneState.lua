
DoneState = Class{__includes = BaseState}

function DoneState:init(def)

end

function DoneState:enter(params)
    self.player1        = params.player1
    self.player2        = params.player2
    self.ball           = params.ball
    self.player1Score   = params.player1Score
    self.player2Score   = params.player2Score
    self.servingPlayer  = params.servingPlayer or 1
    self.winningPlayer  = params.winningPlayer
end

function DoneState:exit()
 
end

function DoneState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- reset scores to zero
        self.player1Score = 0
        self.player2Score = 0
        
        -- decide serving player as the opposite of who won    
        if self.winningPlayer == 1 then
            self.servingPlayer = 2
        else
            self.servingPlayer = 1
        end 
                  
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

function DoneState:render()
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    -- UI messages
    love.graphics.setFont(largeFont)
    love.graphics.printf('Player ' .. tostring(self.winningPlayer) .. ' wins!',
        0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')   

    self.player1:render()
    self.player2:render()
    self.ball:render()    
    self:displayScore()
end

--[[
    Simple function for rendering the scores.
]]
function DoneState:displayScore()
    -- score display
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(self.player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(self.player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end