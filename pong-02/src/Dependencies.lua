-- Library Items
Class    = require 'lib/class'
push     = require 'lib/push'
require 'lib/StateMachine'

--Commands
require 'src/commands/Command'
require 'src/commands/MoveDownCommand'
require 'src/commands/MoveUpCommand'

-- States
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/ServeState'
require 'src/states/PlayState'
require 'src/states/DoneState'

-- our Paddle class, which stores position and dimensions for each Paddle
-- and the logic for rendering them
require 'src/Paddle'

-- our Ball class, which isn't much different than a Paddle structure-wise
-- but which will mechanically function very differently
require 'src/Ball'
require 'src/constants'

-- debug
require 'conf'
