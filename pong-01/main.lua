--[[

]]

require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong')
    math.randomseed(os.time())

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    largeFont = love.graphics.newFont('fonts/font.ttf', 16)
    scoreFont = love.graphics.newFont('fonts/font.ttf', 32)
    love.graphics.setFont(smallFont)

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }
    
    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- the state of our game; can be any of the following:
    -- 1. 'start' (the beginning of the game, before first serve)
    -- 2. 'serve' (waiting on a key press to serve the ball)
    -- 3. 'play' (the ball is in play, bouncing between paddles)
    -- 4. 'done' (the game is over, with a victor, ready for restart)
    gameState = 'start'

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['done'] = function() return DoneState() end,
    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {} -- store key presses
end

function love.keypressed(key)
    if key == 'escape' then
       love.event.quit()
    end
    love.keyboard.keysPressed[key] = true
 end
 
 function love.keyboard.wasPressed(key)
     return love.keyboard.keysPressed[key]
 end
 
--[[
]]
function love.resize(w, h)
    push:resize(w, h)
end

--[[
]]
function love.update(dt)

    gStateMachine:update(dt)
      
    --reset key presses
    love.keyboard.keysPressed = {}    
end

 --[[
    Called each frame after update; is responsible simply for
    drawing all of our game objects and more to the screen.
]]
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')

        love.graphics.setColor(1, 1, 1, 1)
        gStateMachine:render()      
 
        -- display FPS for debugging; simply comment out to remove
        displayFPS()

    -- end our drawing to push
    push:apply('end')
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
