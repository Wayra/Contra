display.setStatusBar( display.HiddenStatusBar )

--10-ultimote = require "Ultimote";
--ultimote.connect() 
--ultimote.autoScreenCapture()

local physics = require("physics")
physics.start( )
physics.setGravity(0, 0)
physics.setDrawMode( "normal" )

local ancho = display.contentWidth
local alto = display.contentHeight

local velocity  = 70
local score = 0
------------------
--backgrounds-----------------
-----------------------------
soundTrack = audio.loadStream("Soundtrack.mp3")
local backgroundMusicChannel = audio.play( soundTrack, { channel=1, loops=-1, fadein=100 }  )
audio.setVolume( 0.5 )

local tap = audio.loadSound("back/pressB.mp3")
local background1 = display.newRect(0,0,ancho,alto)
background1.x = ancho / 2
background1.y = alto  / 2
background1:setFillColor( 1,1,1 )

local background2 = display.newRect(0,0,ancho,alto)
background2.x = ancho / 2
background2.y = alto  / 2
background2:setFillColor( 1,1,1)

------------------------------------------------------
-----------------------Limites-------------
--------------------------------------------

local enemies = display.newGroup( )

local arriba = display.newRect( 0, 0, ancho, 5 )
arriba.x = ancho/2
arriba.y = 5
local abajo = display.newRect( 0, 0, ancho, 5 )
abajo.x = ancho/2
abajo.y = alto - 5
local derecha = display.newRect( 0, 0, 5, alto )
derecha.x = 5
derecha.y = alto / 2
local izquierda = display.newRect( 0, 0, 5, alto )
izquierda.x = ancho - 5
izquierda.y = alto / 2
arriba.isVisible = faldsase
abajo.isVisible = false
derecha.isVisible = false
izquierda.isVisible = false
physics.addBody( arriba, "static",{density=0.3, friction=0.3, bounce=0.3} )
physics.addBody( abajo, "static",{density=0.3, friction=0.3, bounce=0.3} )
physics.addBody( derecha, "static",{density=0.3, friction=0.3, bounce=0.3} )
physics.addBody( izquierda, "static",{density=0.3, friction=0.3, bounce=0.3} )

------------------------------------------------------
-----------------------Limites-------------
--------------------------------------------

local character = display.newImageRect( "back/character.png",80,80)
character.x = ancho - 160
character.y = alto / 2
physics.addBody( character, {density=0.3, friction=0.3, bounce=0.3,radius = 50} )
character.type = "character"


local scoreText = display.newText("Score: "..score,0,0, native.systemFontBold,60 )
scoreText.x = ancho / 2
scoreText.y = alto - 50
scoreText:setFillColor( 0,1,0 )



local gameOver = display.newRect(0,0,ancho,alto)
gameOver.x = ancho / 2
gameOver.y = alto / 2
gameOver:setFillColor( 1,0.5,0 )
gameOver.alpha = 0

local finalScoreText = display.newText("Your Score: "..score,0,0, native.systemFontBold,80 )
finalScoreText.x = ancho / 2
finalScoreText.y = alto / 2
finalScoreText:setFillColor( 0,1,0.1 )
finalScoreText.alpha = 0

local finalText = display.newText("Tap for replay ",0,0, native.systemFontBold,80 )
finalText.x = ancho / 2
finalText.y = alto - 150
finalText:setFillColor( 0,0.1,0 )
finalText.alpha = 0

--function moverCharacter(event)
--		physics.setGravity(10 * event.xGravity,-10 * event.yGravity)
--		print("I am moving :oooo")
--	return true
--end

function moveCharacter(event)
    if "began" == event.phase then
        character.isFocus = true

        character.y0 = event.y - character.y
    elseif character.isFocus then
        if "moved" == event.phase then
            character.y = event.y - character.y0
        elseif "ended" == phase or "cancelled" == phase then
            character.isFocus = false
        end
    end

    -- Return true if the touch event has been handled.
	return true
end

 
function addEnemy(event)
	local enemy = display.newImageRect( "back/enemy.png", 50, 50 )
	enemy.x = 50
	enemy.y = math.random(10, alto)
	enemy.name = "enemy"
	physics.addBody( enemy , {density=0.3, friction=0.3, bounce=0.3 } )
	enemy.isSensor = true	
	enemies:insert(enemy)
end

function loopGame(event)
	---------------------------------------------------------
	------------------------Movimiento de Background ------
	-------------------------------------------------------

	if background1.x >  ancho + ancho / 2 - 50 then
		background1.x = -ancho / 2 + velocity + 5
	else
		background1.x = background1.x + velocity
	end

	if background2.x > ancho+ ancho / 2 - 50 then
		background2.x = -ancho / 2   + velocity + 5
	else
		background2.x = background2.x + velocity
	end
	---------------------------------------------------------
	------------------------Fin movimiento de Background ------

	----------------------------------------------------------
	---------------------------Movimiento de Enemigos-------------
	----------------------------------------------
	if enemies.numChildren ~= 0 then
		 i = 1
		while i <= enemies.numChildren do 
			enemies[i].x = enemies[i].x + velocity
			if enemies[i].x > ancho then
				enemies:remove(enemies[i])
				enemies[i] = nil
				score = score + 1
				scoreText.text = "Score: "..score
			end
		i = i + 1
		end

	end
	-------------------------------------------------------
	-------------------------Control de colisiones----------
	-----------------------------------------------------
	
	return true
end

function reStart( event )
	if event.phase == "began" then
		audio.play( tap  )
		timer.performWithDelay( 500, start, 1)
		transition.to( finalScoreText, { alpha = 0, time = 200 }  )
		transition.to( finalText, { alpha = 0, time = 200 }  )
		transition.to( gameOver, { alpha = 0, time = 200 }  )
		gameOver:removeEventListener( "touch", reStart )
		if enemies.numChildren > 0 then
		i = 0
			while i <= enemies.numChildren do
				enemies:remove(enemies[i])
				enemies[i] = nil 
				i = i + 1
			end
		end
		character.y = ancho / 2 - 200
	end
	return true
end

function onCollision(event)
	if event.phase == "began" then
		Runtime:removeEventListener( "enterFrame", loopGame )
		Runtime:removeEventListener( "touch", moveCharacter )
		character:removeEventListener( "collision", onCollision )

		audio.play( tap  )

		timer.cancel( enemiesTimer )

		finalScoreText.text = "Score: "..score 
		transition.to( finalScoreText, { alpha = 1, time = 200 }  )
		transition.to( finalText, { alpha = 1, time = 200 }  )
		transition.to( gameOver, { alpha = 1, time = 200 }  )
		gameOver:addEventListener( "touch", reStart )

		i = 0
		while i <= enemies.numChildren do
			enemies:remove(enemies[i])
			enemies[i] = nil
			i = i + 1
		end

	end
	return true
end

function start(event)

	score = 0
	scoreText.text = "Score: "..score
	Runtime:addEventListener( "enterFrame", loopGame )
	Runtime:addEventListener( "touch", moveCharacter)
	character:addEventListener( "collision", onCollision )
	enemiesTimer  = timer.performWithDelay(80, addEnemy, 0 )
	return true
end

timer.performWithDelay( 1000, start,1)
--Runtime:addEventListener( "accelerometer", moveCharacter )