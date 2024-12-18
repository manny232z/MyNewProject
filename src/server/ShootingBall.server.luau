local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local ball_lv = ReplicatedStorage.Ball_LV
local ttl = 10

local Touched_Debounce = false

local ability1Debounce =  false
local ability2Debounce = false
local ability3Debounce = false
local ability4Debounce = false

local wallTouched_Debouce = false
local wallTouched_Debouce2 = false

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

-- Function for ability cooldown text 
local function AbilitiesCD(Ability, TextBoxCD)
    if Ability == 1 then
        TextBoxCD.BackgroundTransparency = 0.5
        print(TextBoxCD)
        for i = 0.3, 0, -0.1 do
            TextBoxCD.Text = string.format("%.1f", i)  -- Ensure it displays one decimal place
            print(i)
            task.wait(0.1)  -- Wait for 0.1 seconds before the next iteration
        end
        TextBoxCD.BackgroundTransparency = 1
        TextBoxCD.Text = ""  -- Clear the text after the countdown ends
    end

    if Ability == 2 then
        TextBoxCD.BackgroundTransparency = 0.5
        print(TextBoxCD)
        for i = 0.7, 0, -0.1 do
            TextBoxCD.Text = string.format("%.1f", i)  -- Ensure it displays one decimal place
            print(i)
            task.wait(0.1)  -- Wait for 0.1 seconds before the next iteration
        end
        TextBoxCD.BackgroundTransparency = 1
        TextBoxCD.Text = ""  -- Clear the text after the countdown ends
    end  

    if Ability == 3 then
        TextBoxCD.BackgroundTransparency = 0.5
        print(TextBoxCD)
        for i = 5, 0, -1 do
            TextBoxCD.Text = i  -- Ensure it displays one decimal place
            print(i)
            task.wait(1)  -- Wait for 0.1 seconds before the next iteration
        end
        TextBoxCD.BackgroundTransparency = 1
        TextBoxCD.Text = ""  -- Clear the text after the countdown ends
    end  

    if Ability == 4 then
        TextBoxCD.BackgroundTransparency = 0.5
        print(TextBoxCD)
        for i = 5, 0, -1 do
            TextBoxCD.Text = i  -- Ensure it displays one decimal place
            print(i)
            task.wait(1)  -- Wait for 0.1 seconds before the next iteration
        end
        TextBoxCD.BackgroundTransparency = 1
        TextBoxCD.Text = ""  -- Clear the text after the countdown ends
    end  
end

-- Adding of speed and jumpheight to the players character.
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character.Humanoid.WalkSpeed = 22
        character.Humanoid.JumpHeight = 5
        local BoolValue = Instance.new("BoolValue", player.Character)
        BoolValue.Name = "Healing"
    end)
end)

-- Wall ability
local function WallAbility(player)
    local Wall = ReplicatedStorage.Wall:Clone()
    Wall.Parent = workspace
    Wall.CollisionGroup = "WallGroup"
    local character = player.Character
    local head = character:WaitForChild("HumanoidRootPart")

    -- Position the wall 12 studs in front of the player's head
    if player.Character.Humanoid.Jump then
        -- When the player jumps, reset the wall's rotation and apply the position offset
        Wall.CFrame = CFrame.Angles(0,0,0)
        Wall.CFrame = head.CFrame * CFrame.new(0, 0, -12)
    else
        -- When the player is not jumping, use the head's orientation and apply the position offset
        Wall.CFrame = head.CFrame * CFrame.new(0, 0, -12) --* CFrame.Angles(0, head.CFrame:ToEulerAnglesYXZ())
    end
    
    --[[if Wall.CFrame.Rotation ~= CFrame.Angles(0,0,0) then
        
    end--]]
    
    
    
    task.wait(0.1)
    Wall.Anchored = true


    Wall.Touched:Connect(function(object)
        --[[if object.Name == "Ball_LV" or object.Name == "MassiveBall_LV" then
            object:Destroy()
        end--]]
        if object:FindFirstChild("LinearVelocity") then
            object.LinearVelocity:Destroy()
        else
            print("No LinearVelocity found")
        end
        if object.Name == "Ball_LV" and wallTouched_Debouce == false then
            wallTouched_Debouce = true
            if Wall.Health.Value <= 60 then
                Wall.BillboardGui.Frame.HealthLabel.TextColor3 = Color3.new(1, 0.278431, 0.278431)
                
            end
            Wall.Health.Value -= 18
            for i, v in pairs(Wall:GetChildren()) do
                if v.Name == "MinecraftBreakDecal" then
                    v.Transparency -= 0.1 / 2
                end
            end
            local WallHP = Wall.Health.Value
            print("Wall hp is "..WallHP.."%")
            if Wall.Health.Value > -5 then
                Wall.BillboardGui.Frame.HealthLabel.Text = WallHP.."%"
            else
                Wall.BillboardGui.Frame.HealthLabel.Text = "0%"
            end
            if Wall.Health.Value <= 0 then
                Wall.CanCollide = false
                Wall.Anchored = false
            end
            local SoundSFX = SoundService["Shale Break 1 (SFX)"]:Clone()
            SoundSFX.Parent = SoundService
            if not SoundSFX.Playing then
                SoundSFX:Play()
            end
            task.wait(0.3)
            --object:Destroy()
            if object:FindFirstChild("LinearVelocity") then
                object.LinearVelocity:Destroy()
            else
                print("No LinearVelocity found")
            end
            Debris:AddItem(SoundSFX, 2)
            task.wait(0.2)
            wallTouched_Debouce = false

        elseif object.Name == "MassiveBall_LV" and wallTouched_Debouce2 == false then
            wallTouched_Debouce2 = true
            if Wall.Health.Value <= 60 then
                Wall.BillboardGui.Frame.HealthLabel.TextColor3 = Color3.new(1, 0.278431, 0.278431)
                
            end
            Wall.Health.Value -= 25
            for i, v in pairs(Wall:GetChildren()) do
                if v.Name == "MinecraftBreakDecal" then
                    v.Transparency -= 0.1 
                end
            end
            local WallHP = Wall.Health.Value
            print("Wall hp is "..WallHP.."%")
            if Wall.Health.Value > -5 then
                Wall.BillboardGui.Frame.HealthLabel.Text = WallHP.."%"
            else
                Wall.BillboardGui.Frame.HealthLabel.Text = "0%"
            end
            if Wall.Health.Value <= 0 then
                Wall.CanCollide = false
                Wall.Anchored = false
            end
            local SoundSFX = SoundService["Rock Impact 22 (SFX)"]:Clone()
            SoundSFX.Parent = SoundService
            if not SoundSFX.Playing then
                SoundSFX:Play()
            end
            task.wait(0.3)
            --object:Destroy()
            if object:FindFirstChild("LinearVelocity") then
                object.LinearVelocity:Destroy()
            else
                print("No LinearVelocity found")
            end
            Debris:AddItem(SoundSFX, 2)
            task.wait(0.2)
            wallTouched_Debouce2 = false
        end
    end)
end


-- heal player function
local function HealPlayer(player)
    local character = player.Character
    local HealPart = ReplicatedStorage.HealPart:Clone()
    character.Humanoid.WalkSpeed = 0
    character.Humanoid.JumpHeight = 0
    character.Humanoid.AutoRotate = false
    HealPart.Touched:Connect(function(otherPart)
        if otherPart.Parent:IsA("Model") then
            local Humanoid = otherPart.Parent.Humanoid
            Humanoid.Health = 100
           --[[ for i = character.Humanoid.Health, 100, 7.5 do
                task.wait(0.2)
                Humanoid.Health = i
            end--]]
        end
    end)
    task.wait(0.2)
    HealPart.CFrame = CFrame.new(character.Head.CFrame.X, 6, character.Head.CFrame.Z) *  CFrame.Angles(0, math.rad(-180), math.rad(-90))
    HealPart.Parent =  workspace 
    task.wait(1)
    TweenService:Create(HealPart, tweeninfo, goals):Play() -- tween heal part to fully transparent
    Debris:AddItem(HealPart, 3)
    task.wait(2)
    character.Humanoid.WalkSpeed = 22
    character.Humanoid.JumpHeight = 5
    character.Humanoid.AutoRotate = true
    player.Character.Healing.Value = false
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
    if size == 5 then
        ball.Name = "MassiveBall_LV"
    end
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
            print("Hit "..hit.Parent.Name)
            if ball.Hit.Value == false then
                if hit.Parent.name ~= char.name then
                    --Touched_Debounce = true
                    
                    if (hit.Parent.Humanoid.Health - 50) <= 0 then -- Checks if player has half hp to give shooter kill point - if their on 50hp that means the damage they're finna get dealt will kill them.
                        player.leaderstats.kills.Value += 1
                        SoundService["strong sword slash"]:Play()
                    end
                    if hit.Parent.Humanoid.Health > 0 then -- changes ball material to neon only if player is not dead already
                        ball.Material = Enum.Material.Neon
                    end
                    print("Touched enemy player / dmg inflicted")
                    hit.Parent.Humanoid.Health -= 50
                    ball.Hit.Value = true
                elseif hit.Parent.name == char.name then
                    print("touched player who shot / dmg ignored")
                    --ball.Material = Enum.Material.ForceField
                    return
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
    ballVelocity.VectorVelocity = HumanoidRootPart.CFrame.LookVector * 200
    Debris:AddItem(ball, ttl)
end


ReplicatedStorage.RemoteEvent.OnServerEvent:Connect(function(player, Ability, abiityCD, TextBoxCD)

    if Ability == 1 then
        local Gunshsot = SoundService["Blast Deflector 2 (SFX)"]:Clone()
        Gunshsot.Parent = SoundService
        Gunshsot:Play()
        Debris:AddItem(Gunshsot, 1)

        linearVelocityBall(player, player.Character, 2)
        local co = coroutine.create(AbilitiesCD)
        coroutine.resume(co, Ability, TextBoxCD)

    elseif Ability == 2 then
        local Magic1 = SoundService.Magic1:Clone()
        Magic1.Parent = SoundService
        Magic1:Play()
        Debris:AddItem(Magic1, 1)

        linearVelocityBall(player, player.Character, 5, ReplicatedStorage.Lightningsmall)
        local co = coroutine.create(AbilitiesCD)
        coroutine.resume(co, Ability, TextBoxCD)

    elseif Ability == 3 then
        player.Character:WaitForChild("Healing").Value = true
        local health = SoundService["Undertale - Heal"]:Clone()
        health.Parent = SoundService
        health:Play()
        Debris:AddItem(health, 1)
        HealPlayer(player)

        local co = coroutine.create(AbilitiesCD)
        coroutine.resume(co, Ability, TextBoxCD)

    elseif Ability == 4 then
        local rockEffect = SoundService["Rock Impact 1 (SFX)"]:Clone()
        rockEffect.Parent = SoundService
        rockEffect:Play()
        Debris:AddItem(rockEffect, 3)
        WallAbility(player)

        local co = coroutine.create(AbilitiesCD)
        coroutine.resume(co, Ability, TextBoxCD)
    end 
end) 
