--[[

]]

Paddle = Class{}

--[[

]]
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function Paddle:moveUp(dt)
    self.y = math.max(0, self.y + self.dy * dt)
end

function Paddle:moveDown(dt)
    self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
end

--[[

]]
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

--[[
    Convert to AI Player    
]]
function Paddle:processAI(ball)
    
    -- match the ball's dy unless it would cause the paddle to move away from the ball
    -- move back toward the middle between serves
    if self.y > ball.y and ball.dy > 0 then
        self.dy = -ball.dy
    elseif self.y < ball.y and ball.dy < 0 then
        self.dy = -ball.dy
    else
        self.dy = ball.dy
    end
    -- if ball/paddle y coords are far apart on a shallow bounce, speed up the paddle
    if math.abs(self.y - ball.y) > (VIRTUAL_HEIGHT * 0.05)  then
        self.dy = self.dy * 10
    end

    -- Return command based on Paddle dy
    if self.dy < 0 then
        return MoveUpCommand()
    elseif self.dy > 0 then
        return MoveDownCommand()
    else 
        return nil
    end
end
