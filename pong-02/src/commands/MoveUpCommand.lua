MoveUpCommand = Class{__includes = Command}

function MoveUpCommand:execute(gameObject, dt) 
    gameObject:moveUp(dt)
end
