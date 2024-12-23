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
local function AbilitiesCD(Ability, TextBoxCD, player)
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
        if player.Character.UltimateActivated.Value == true then
            TextBoxCD.BackgroundTransparency = 0.5
            print(TextBoxCD)
            for i = 2, 0, -1 do
                TextBoxCD.Text = i -- Ensure it displays one decimal place
                print(i)
                task.wait(1)  -- Wait for 0.1 seconds before the next iteration
            end
            TextBoxCD.BackgroundTransparency = 1
            TextBoxCD.Text = ""  -- Clear the text after the countdown ends
        elseif player.Character.UltimateActivated.Value == false then
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
        local bloodlust = Instance.new("IntValue", player.character)
        bloodlust.Name = "bloodlust"
        local num = Instance.new("NumberValue", player.character)
        num.Name = "num"
        local BoolValue3 = Instance.new("BoolValue", player.character)
        BoolValue3.Name = "UltimateActivated"
        local BoolValue = Instance.new("BoolValue", player.Character)
        BoolValue.Name = "Healing"
        for i, v in pairs(workspace:GetChildren()) do
            print(v.Name)
            if v:isA("Model") then
                if v:FindFirstChild("Dead") == nil then
                    local BoolValue2 = Instance.new("BoolValue", v)
                    BoolValue2.Name = "Dead"
                end
            end
        end
    end)
end)



-- Wall ability
local function WallAbility(player)
    local Wall = ReplicatedStorage.Wall:Clone()
    Wall.Parent = workspace
    Wall.CollisionGroup = "WallGroup"
    local character = player.Character
    local head = character:WaitForChild("HumanoidRootPart")
    if player.Character.UltimateActivated.Value == true then
        print("ULTIMATE WALL ABILITY")
        Wall.Material = Enum.Material.Neon
        Wall.BrickColor = BrickColor.new("Royal purple")
        Wall.Size = Vector3.new(70, 28.997, 2)
        Wall.BillboardGui.Frame.HealthLabel.Text = "200%"
        Wall.BillboardGui.Frame.HealthLabel.TextColor3 = Color3.fromHex("#aa557f")
        Wall.Health.Value = 200
        Wall.sparkle.Enabled = true
        Wall.swirl.Enabled = true
    else
        print("NOT IN ULTIMATE FOR ULTIMATE WALL")
    end

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
        -- Handle LinearVelocity destruction
        if object:FindFirstChild("LinearVelocity") then
            object.LinearVelocity:Destroy()
        else
            print("No LinearVelocity found")
        end
    
        -- First condition block for "Ball_LV" or "Ball_LV2"
        if (object.Name == "Ball_LV" or object.Name == "Ball_LV2") and wallTouched_Debouce == false then
            wallTouched_Debouce = true
    
            -- Wall damage logic for first case
            if Wall.Health.Value <= 60 then
                Wall.BillboardGui.Frame.HealthLabel.TextColor3 = Color3.new(1, 0.278431, 0.278431)
            end
    
            if player.Character.UltimateActivated.Value == true then
                Wall.Health.Value -= 20 -- Damage if Ultimate is active
            elseif player.Character.UltimateActivated.Value == false then
                Wall.Health.Value -= 18  -- Normal damage
            else
                warn("DAMAGE DIDN'T HAPPEN - POTENTIAL ERROR")
            end
    
            -- Handle MinecraftBreakDecal transparency
            for i, v in pairs(Wall:GetChildren()) do
                if v.Name == "MinecraftBreakDecal" then
                    v.Transparency -= 0.2
                end
            end
    
            -- Update wall health text
            local WallHP = Wall.Health.Value
            print("Wall hp is "..WallHP.."%")
            if Wall.Health.Value > 0 then
                Wall.BillboardGui.Frame.HealthLabel.Text = WallHP.."%"
            else
                Wall.BillboardGui.Frame.HealthLabel.Text = "0%"
            end
    
            -- If health reaches 0, disable collision and anchoring
            if Wall.Health.Value <= 0 then
                Wall.CanCollide = false
                Wall.Anchored = false
            end
    
            -- Sound logic for the first condition
            local SoundSFX
            if player.Character.UltimateActivated.Value == false then
                SoundSFX = SoundService["Shale Break 1 (SFX)"]:Clone()
            elseif player.Character.UltimateActivated.Value == true then
                SoundSFX = SoundService["Starbound Tank Shot (Semi-Distorted)"]:Clone()
            end
            SoundSFX.Parent = SoundService
            if not SoundSFX.Playing then
                SoundSFX:Play()
            end
    
            -- Wait and reset debounce
            task.wait(0.3)
            Debris:AddItem(SoundSFX, 4)
            task.wait(0.2)
            wallTouched_Debouce = false
    
        -- Second condition block for "MassiveBall_LV" or "Ball_LV3"
        elseif (object.Name == "MassiveBall_LV" or object.Name == "Ball_LV3") and wallTouched_Debouce2 == false then
            wallTouched_Debouce2 = true
    
            -- Wall damage logic for the second case
            if Wall.Health.Value <= 60 then
                Wall.BillboardGui.Frame.HealthLabel.TextColor3 = Color3.new(1, 0.278431, 0.278431)
            end
    
            if player.Character.UltimateActivated.Value == true then
                Wall.Health.Value -= 50  -- Damage if Ultimate is active
            elseif player.Character.UltimateActivated.Value == false then
                Wall.Health.Value -= 25  -- Normal damage
            else
                warn("DAMAGE DIDN'T HAPPEN - POTENTIAL ERROR")
            end
    
            -- Handle MinecraftBreakDecal transparency
            for i, v in pairs(Wall:GetChildren()) do
                if v.Name == "MinecraftBreakDecal" then
                    v.Transparency -= 0.2
                end
            end
    
            -- Update wall health text
            local WallHP = Wall.Health.Value
            print("Wall hp is "..WallHP.."%")
            if Wall.Health.Value > 0 then
                Wall.BillboardGui.Frame.HealthLabel.Text = WallHP.."%"
            else
                Wall.BillboardGui.Frame.HealthLabel.Text = "0%"
            end
    
            -- If health reaches 0, disable collision and anchoring
            if Wall.Health.Value <= 0 then
                Wall.CanCollide = false
                Wall.Anchored = false
            end
    
            -- Sound logic for the second condition
            local SoundSFX
            if player.Character.UltimateActivated.Value == false then
                SoundSFX = SoundService["Rock Impact 22 (SFX)"]:Clone()
            elseif player.Character.UltimateActivated.Value == true then
                SoundSFX = SoundService["Starbound Tank Shot (Semi-Distorted)"]:Clone()
            end
            SoundSFX.Parent = SoundService
            if SoundSFX and not SoundSFX.Playing then
                SoundSFX:Play()
            else
                warn("SOUNDSFX NOT LOADED")
            end
    
            -- Wait and reset debounce
            task.wait(0.3)
            Debris:AddItem(SoundSFX, 5)
            task.wait(0.2)
            wallTouched_Debouce2 = false
        end
    end)    
end


local function UltimateAbility4(player)
    local highlight = Instance.new("Highlight", player.Character)
    highlight.FillColor = Color3.new(0.878431, 0.250980, 0.901960)
    highlight.OutlineColor = Color3.new(0.878431, 0.235294, 0.235294)
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
local function linearVelocityBall(player, char, size, effect, UltimateActive, abilityType)
    local ball = nil
    if UltimateActive == true then
        if abilityType == "EnormousBlast" then
            ball = ReplicatedStorage.Ball_LV3:Clone()
        else
            ball = ReplicatedStorage.Ball_LV2:Clone()
        end
    elseif UltimateActive == false then
        ball = ReplicatedStorage.Ball_LV:Clone()
    end
    if effect ~= nil then
        local newEffect = effect:Clone()
        newEffect.Parent = ball 
    end
    ball.Size = Vector3.new(size,size,size)
    if size == 5 and UltimateActive == false then
        ball.Name = "MassiveBall_LV"
    end
    if ball.Name == "Ball_LV" or ball.Name =="Ball_LV2" then
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
    end
    
    
    if player.Character.UltimateActivated.Value == true then
        ball.BrickColor = BrickColor.new("Alder")
    end
    
    ball.Parent = workspace
    ball.Touched:Connect(function(hit)
        if hit.Name == "HealPart" then
            hit.BrickColor = BrickColor.new("Really red")
        end
        -- touched event for dmg on balls, and also debounce of 0.5 seconds so players won't die so fast.
        if hit.Parent:IsA("Model") then
            print("Hit "..hit.Parent.Name)
            
            -- Check if the parent has a Humanoid
            local humanoid = hit.Parent:FindFirstChild("Humanoid")
            if humanoid then
                if ball.Hit.Value == false then
                    if hit.Parent.Name ~= char.Name then
                        -- Touched_Debounce = true
                        if (humanoid.Health - 55) <= 0 and hit.Parent.Dead.Value == false then
                            player.leaderstats.bloodlust.Value += 1
                            SoundService["strong sword slash"]:Play()
                            hit.Parent.Dead.Value = true
                            local bloodlust = player.Character.bloodlust 
                            local num = player.Character.num
                            bloodlust.Value += 1
                            if num.Value ~= 1 then
                                num.Value += 0.2
                            end
                            if player.Character.UltimateActivated.Value == false then
                                print("ULTIMATE PROGRESS BAR EVENT HAPPENED")
                                ReplicatedStorage.UltimateEvent:FireClient(player, num, bloodlust)
                            else
                                warn("Something went wrong")
                            end
                        end
                        if humanoid.Health > 0 then
                            ball.Material = Enum.Material.Neon
                        end
                        print("Touched enemy player / dmg inflicted")
                        humanoid.Health -= 55
                        ball.Hit.Value = true
                        if hit.Parent.Dead.Value == true then
                            task.wait(4)
                            hit.Parent.Dead.Value = false
                        end
                    elseif hit.Parent.Name == char.Name then
                        print("Touched player who shot / dmg ignored")
                        -- ball.Material = Enum.Material.ForceField
                        return
                    end
                else
                    print("Dmg debounce")
                end
            else
                print("No Humanoid found in " .. hit.Parent.Name)
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


ReplicatedStorage.RemoteEvent.OnServerEvent:Connect(function(player, Ability, abiityCD, TextBoxCD, UltimateActive)

    if Ability == 1 then
        if UltimateActive == false then
            local Gunshsot = SoundService["Blast Deflector 2 (SFX)"]:Clone()
            Gunshsot.Parent = SoundService
            Gunshsot:Play()
            Debris:AddItem(Gunshsot, 1)
    
            linearVelocityBall(player, player.Character, 2, nil, UltimateActive)
            local co = coroutine.create(AbilitiesCD)
            coroutine.resume(co, Ability, TextBoxCD, player)

        elseif UltimateActive == true then
            local soundsfx = SoundService["Antiproton-Delphic Pistol Blast"]:Clone()
            soundsfx.Parent = SoundService
            soundsfx:Play()
            Debris:AddItem(soundsfx, 1)
    
            linearVelocityBall(player, player.Character, 4, nil, UltimateActive)
            local co = coroutine.create(AbilitiesCD)
            coroutine.resume(co, Ability, TextBoxCD, player)
            print("Shot Ultimate ability 1")
        end
    elseif Ability == 2 then
        if UltimateActive == false then
            ReplicatedStorage.CameraShakeEvent:FireClient(player, "Ability2")
            local Magic1 = SoundService.Magic1:Clone()
            Magic1.Parent = SoundService
            Magic1:Play()
            Debris:AddItem(Magic1, 1)
    
            linearVelocityBall(player, player.Character, 5, ReplicatedStorage.Lightningsmall, UltimateActive)
            local co = coroutine.create(AbilitiesCD)
            coroutine.resume(co, Ability, TextBoxCD, player)

        elseif UltimateActive == true then
            ReplicatedStorage.CameraShakeEvent:FireClient(player, "ULT4")
            local sound = SoundService.Explosion1:Clone()
            sound.Parent = SoundService
            sound:Play()
            Debris:AddItem(sound, 4)
    
            linearVelocityBall(player, player.Character, 10, nil, UltimateActive, "EnormousBlast")
            local co = coroutine.create(AbilitiesCD)
            coroutine.resume(co, Ability, TextBoxCD, player)
            print("Shot Ultimate ability 2")
        end
    elseif Ability == 3 then
        if UltimateActive == false then
            player.Character:WaitForChild("Healing").Value = true
            local health = SoundService["Undertale - Heal"]:Clone()
            health.Parent = SoundService
            health:Play()
            Debris:AddItem(health, 1)
            HealPlayer(player)

            local co = coroutine.create(AbilitiesCD)
            coroutine.resume(co, Ability, TextBoxCD, player)

        elseif UltimateActive == true then
            print("Shot Ultimate ability 3")

            UltimateAbility4(player)

        end
    elseif Ability == 4 then
        if UltimateActive == false then
            ReplicatedStorage.CameraShakeEvent:FireClient(player, "WallAbility")
            local rockEffect = SoundService["Rock Impact 1 (SFX)"]:Clone()
            rockEffect.Parent = SoundService
            rockEffect:Play()
            Debris:AddItem(rockEffect, 3)
            WallAbility(player)

            local co = coroutine.create(AbilitiesCD)
            coroutine.resume(co, Ability, TextBoxCD, player)

        elseif UltimateActive == true then
            print("Shot Ultimate ability 4")

            ReplicatedStorage.CameraShakeEvent:FireClient(player, "WallAbility2")
            local soundsfx = SoundService.explode4:Clone()
            soundsfx.Parent = SoundService
            soundsfx:Play()
            Debris:AddItem(soundsfx, 3)
            WallAbility(player)

            local co = coroutine.create(AbilitiesCD)
            coroutine.resume(co, Ability, TextBoxCD, player)
        end
    end 
end) 
