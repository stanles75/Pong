-- Library Items
Class    = require 'lib/class'
push     = require 'lib/push'

-- our Paddle class, which stores position and dimensions for each Paddle
-- and the logic for rendering them
require 'src/Paddle'

-- our Ball class, which isn't much different than a Paddle structure-wise
-- but which will mechanically function very differently
require 'src/Ball'