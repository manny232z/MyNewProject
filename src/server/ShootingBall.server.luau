local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local ball_lv = ReplicatedStorage.Ball_LV
local ttl = 10

local Touched_Debounce = false

--[[
-- Create collision groups if they don't already exist
if not pcall(function() PhysicsService:RegisterCollisionGroup("BallGroup") end) then
    print("PartGroup already exists.")
end
if not pcall(function() PhysicsService:RegisterCollisionGroup("WallGroup") end) then
    print("WallGroup already exists.")
end

-- Set collision rules
PhysicsService:CollisionGroupSetCollidable("BallGroup", "WallGroup", true)  -- Part can collide with Wall
PhysicsService:CollisionGroupSetCollidable("BallGroup", "Default", false)  -- Part can't collide with anything else
PhysicsService:CollisionGroupSetCollidable("WallGroup", "Default", true)  -- Wall can collide with everything
--]]

local tweeninfo = TweenInfo.new(
    2,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.In,
    0,
    false,
    0
)

local goals = {
    Transparency = 1
}

-- Adding of speed and jumpheight to the players character.
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character.Humanoid.WalkSpeed = 30
        character.Humanoid.JumpHeight = 15
    end)
end)

-- Wall ability
local function WallAbility(player)
    local Wall = ReplicatedStorage.Wall:Clone()
    Wall.Parent = workspace
    Wall.CollisionGroup = "WallGroup"
    local character = player.Character
    local head = character:WaitForChild("Head")

    -- Position the wall 8 studs in front of the player's head
    Wall.CFrame = head.CFrame * CFrame.new(0, 0, -12)
    Wall.Touched:Connect(function(object)
        if object.Name == "Ball_LV" then
            object:Destroy()
            local ArmorSound = SoundService["Lamp Metal And Glass Rattle 1 (SFX)"]:Clone()
            ArmorSound.Parent = SoundService
            ArmorSound:Play()
            Debris:AddItem(ArmorSound,2)
        end
    end)
end


-- heal player function
local function HealPlayer(player)
    local character = player.Character
    local HealPart = ReplicatedStorage.HealPart:Clone()
    HealPart.Parent =  workspace 
    HealPart.CFrame = CFrame.new(character.Head.CFrame.X, 6, character.Head.CFrame.Z) *  CFrame.Angles(0, math.rad(-180), math.rad(-90))
    character.Humanoid.WalkSpeed = 5
    character.Humanoid.JumpHeight = 0
    character.Humanoid.Health = 100
    task.wait(1)
    TweenService:Create(HealPart, tweeninfo, goals):Play() -- tween heal part to fully transparent
    Debris:AddItem(HealPart, 3)
    character.Humanoid.WalkSpeed = 30
    character.Humanoid.JumpHeight = 15
end

-- shooting ball function
local function linearVelocityBall(player, char, size, effect)
    ball_lv.CollisionGroup = "BallGroup"
    local ball = ball_lv:Clone()
    if effect ~= nil then
        local newEffect = effect:Clone()
        newEffect.Parent = ball 
    end
    ball.Size = Vector3.new(size,size,size)
    if player:HasTag("RedTeam") then -- Changes ball color depending on which team the player chose
        ball.BrickColor = BrickColor.new("Bright red")
        ball.Trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))  -- Red
        ball.Trail2.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))  -- Red
    
    elseif player:HasTag("BlueTeam") then
        ball.BrickColor = BrickColor.new("Bright blue")
        ball.Trail.Color = ColorSequence.new(Color3.fromRGB(0, 0, 255))  -- Blue
        ball.Trail2.Color = ColorSequence.new(Color3.fromRGB(0, 0, 255))  -- Blue

    elseif player:HasTag("GreenTeam") then
        ball.BrickColor = BrickColor.new("Bright green")
        ball.Trail.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0))  -- Green
        ball.Trail2.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0))  -- Green
    
    elseif player:HasTag("BrownTeam") then
        ball.BrickColor = BrickColor.new("Brown")
        ball.Trail.Color = ColorSequence.new(Color3.fromRGB(139, 69, 19))  -- Brown
        ball.Trail2.Color = ColorSequence.new(Color3.fromRGB(139, 69, 19))  -- Brown
    end
    
    
    ball.Parent = workspace
    ball.Touched:Connect(function(hit)
        -- touched event for dmg on balls, and also debounce of 0.5 seconds so players won't die so fast.
        if hit.Parent:isA("Model") then
            if Touched_Debounce == false then
                
                if hit.Parent.name == char.name then
                    print("touched player who shot / dmg ignored")
                    --ball.Material = Enum.Material.ForceField
                    return
                elseif hit.Parent.name ~= char.name then
                    Touched_Debounce = true

                    if hit.Parent.Humanoid.Health == 50 then -- Checks if player has half hp to give shooter kill point - if their on 50hp that means the damage they're finna get dealt will kill them.
                        player.leaderstats.kills.Value += 1
                        SoundService["strong sword slash"]:Play()
                    end

                    hit.Parent.Humanoid.Health -= 50
                    print("Touched enemy player / dmg inflicted")
                    ball.Material = Enum.Material.Neon
                    task.wait(0.3)
                    Touched_Debounce = false
                end
            else
                print("Dmg debounce")
            end
        end
    end)

    -- Positioning of ball in front of the player and adding of velocity to the ball.
    local HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    local ballVelocity = ball.LinearVelocity
    ballVelocity.MaxForce = math.huge
    ball.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 1, -3)
    ballVelocity.VectorVelocity = HumanoidRootPart.CFrame.LookVector * 100
    Debris:AddItem(ball, ttl)
end

-- RemoteEvent for whenever the player clicks or taps their screen to fire the ball function and to do other misellinous things.
ReplicatedStorage.RemoteEvent.OnServerEvent:Connect(function(player, Ability)
    if Ability == 1 then
        local Gunshsot = SoundService["Blast Deflector 2 (SFX)"]:Clone()
        Gunshsot.Parent = SoundService
        Gunshsot:Play()
        Debris:AddItem(Gunshsot, 1)
        linearVelocityBall(player, player.Character, 2)
    elseif Ability == 2 then
        local Magic1 = SoundService.Magic1:Clone()
        Magic1.Parent = SoundService
        Magic1:Play()
        Debris:AddItem(Magic1, 1)
        linearVelocityBall(player, player.Character, 5, ReplicatedStorage.Lightningsmall)
    elseif Ability == 3 then
        local health = SoundService["UnderTale - Restoring Health Sound Effect"]:Clone()
        health.Parent = SoundService
        health:Play()
        Debris:AddItem(health, 1)
        HealPlayer(player)
        --linearVelocityBall(player, player.Character, 2)
    elseif Ability == 4 then
        local rockEffect = SoundService["Rock Impact 1 (SFX)"]:Clone()
        rockEffect.Parent = SoundService
        rockEffect:Play()
        Debris:AddItem(rockEffect, 3)
        WallAbility(player)
    end
end)