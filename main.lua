local love = require("love")

function love.load()
    camera = require("libs/camera")
    cam = camera()

    anim8 = require("libs/anim8")
    love.graphics.setDefaultFilter("nearest", "nearest")

    sti = require("libs/sti")
    gamemap = sti("maps/testmap.lua")

    player = {}
    player.x = 400
    player.y = 200
    player.speed = 5
    player.spritesheet = love.graphics.newImage("assets/player-sheet.png")
    player.grid = anim8.newGrid(12, 18, player.spritesheet:getWidth(), player.spritesheet:getHeight())

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    player.anim = player.animations.left

    background = love.graphics.newImage("assets/background.png")
end

function love.update(dt)
    local isMoving = false
    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true
    end
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed
        player.anim = player.animations.left
        isMoving = true
    end
    if love.keyboard.isDown("down") then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end
    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end

    if not isMoving then
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- Right border
    if cam.x < w / 2 then
        cam.x = w / 2
    end

    -- Left border
    if cam.y < h / 2 then
        cam.y = h / 2
    end

    local mapW = gamemap.width * gamemap.tilewidth
    local mapH = gamemap.height * gamemap.tileheight

    -- Bottom border
    if cam.x > (mapW - w / 2) then
        cam.x = mapW - w / 2
    end

    -- Top border
    if cam.y > (mapH - h / 2) then
        cam.y = mapH - h / 2
    end
end

function love.draw()
    cam:attach()
        gamemap:drawLayer(gamemap.layers["ground"])
        gamemap:drawLayer(gamemap.layers["trees"])
        player.anim:draw(player.spritesheet, player.x, player.y, nil, 6, nil, 6, 9)
    cam:detach()

    love.graphics.print("Use arrow keys to move the player", 10, 10)
end