display.setStatusBar( display.HiddenStatusBar )

--ultimote = require "Ultimote";ultimote.connect();
--ultimote.connect() 
--ultimote.autoScreenCapture()

local physics = require("physics")
physics.start( )
physics.setGravity(0, 0)
physics.setDrawMode( "hybrid" )

local ancho = display.contentWidth
local alto = display.contentHeight

local velocity  = 40
local score = 0
------------------
--backgrounds-----------------
-----------------------------

local background1 = display.newImageRect("back/background.jpg",ancho,alto)
background1.x = ancho / 2
background1.y = alto  / 2

local background2 = display.newImageRect("back/background.jpg",ancho,alto)
background2.x = -ancho /2
background2.y = alto  / 2

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

local character = display.newCircle( 0, 0, 50 )
character.x = ancho - 160
character.y = alto / 2
character:setFillColor( 1,0.2,0 )
physics.addBody( character, {density=0.3, friction=0.3, bounce=0.3,radius = 50} )
character.type = "character"
character.collision = onCollision
character:addEventListener( "collision", character )

local scoreText = display.newText("Score: "..score,0,0, native.systemFontBold,60 )
scoreText.x = ancho / 2
scoreText.y = alto - 50
scoreText:setFillColor( 0,1,0 )

--function moverCharacter(event)
--		physics.setGravity(10 * event.xGravity,-10 * event.yGravity)
--		print("I am moving :oooo")
--	return true
--end

function moveCharacter(event)
	if event.phase == "began" then
		character.isFocus = true
	elseif event.phase == "moved" then
		eventY = event.y 
		character.y = eventY 
	elseif event.phase == "ended" then
		character.isFocus = false
	end
	return true
end

 
function addEnemy(event)
	local enemy = display.newRect( 0, 0, 70, 70 )
	enemy.x = 50
	enemy.y = math.random(10, alto)
	enemy.name = "enemy"
	enemy:setFillColor( 0,0,1 )
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

function onCollision(self, event)
	if event.phase == "began" then
		if event.target.type == "character" and event.other.type == "enemy" then
		print("choque ")
		end
	end
	return true
end

timer.performWithDelay( 200, addEnemy, 0 )
Runtime:addEventListener( "touch", moveCharacter)
Runtime:addEventListener( "enterFrame", loopGame )
--Runtime:addEventListener( "accelerometer", moveCharacter )