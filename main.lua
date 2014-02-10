display.setStatusBar( display.HiddenStatusBar )

--ultimote = require "Ultimote";ultimote.connect();
--ultimote.connect() 
--ultimote.autoScreenCapture()

local physics = require("physics")
physics.start( )

physics.setDrawMode( "normal" )

local ancho = display.contentWidth
local alto = display.contentHeight

local velocity  = 30


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
arriba.isVisible = false
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
character:setFillColor( 0.5,1,0 )
physics.addBody( character, {density= 0.3, friction=0.3, bounce=0.4, radius = 60 } )


--function moverCharacter(event)
--		physics.setGravity(10 * event.xGravity,-10 * event.yGravity)
--		print("I am moving :oooo")
--	return true
--end



function loopGame(event)
	if background1.x >  ancho + 520 then
		background1.x = -ancho / 2 + velocity * 2 
	else
		background1.x = background1.x + velocity
	end

	if background2.x > ancho+520 then
		background2.x = -ancho / 2   + velocity * 2 
	else
		background2.x = background2.x + velocity
	end

	return true
end

Runtime:addEventListener( "enterFrame", loopGame )
--Runtime:addEventListener( "accelerometer", moveCharacter )