MoveDownCommand = Class{__includes = Command}

function MoveDownCommand:execute(gameObject, dt) 
    -- print('execute move down')
    gameObject:moveDown(dt)
end
