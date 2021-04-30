

--[[

	Each sprite sheet contains one or multiple states
	Each states is represented as a line in the image file
	The following object describes the different states
	Switching between different states can be done through code

	members ->
		imageSrc : path to the image (png, tga, bmp or jpg)
		defaultState : the first state
		states : a table containing each state

	(State)
	Each state contains the following members ->
		frameCount : the number of frames in the state
		offsetX : starting from the left, the position (in px) of the first frame of the state (aka on the line)
		offsetY : starting from the top, the position of the line (px)
		framwW : the width of each frame in the state
		frameH : the height of each frame in the state
		nextState : the state which will follow after the last frame is reached
		switchDelay : the time between each frame (seconds as floating point)

]]

-- the return statement is mandatory
return {
	imageSrc = "Assets/Player/player_ship_sprite.png",
	defaultState = "neutral",
	states = {
		-- 1st line
		neutral = { -- the name of the state is arbitrary
			frameCount = 1,
			offsetX = 0, 
			offsetY = 0, 
			frameW = 87,
			frameH = 80,
			nextState = "neutral", -- we loop the running state
			switchDelay = 0.07
		},
		right = {
			frameCount = 5,
			offsetX = 0, 
			offsetY = 83, 
			frameW = 87,
			frameH = 80,
			nextState = "right", -- we loop the running state
			switchDelay = 0.2
		},
		left = {
			frameCount = 5,
			offsetX = 0, 
			offsetY = 171, 
			frameW = 87,
			frameH = 80,
			nextState = "left", -- we loop the running state
			switchDelay = 0.07
		}
	}
}
