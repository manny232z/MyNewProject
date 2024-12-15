local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local ball_lv = ReplicatedStorage.Ball_LV
local ttl = 10

local Touched_Debounce = false

-- Adding of speed and jumpheight to the players character.
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character.Humanoid.WalkSpeed = 30
        character.Humanoid.JumpHeight = 15
    end)
end)

local function linearVelocityBall(player, char)
    local ball = ball_lv:Clone()
    --ball.Size = Vector3.new(7,7,7)
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
ReplicatedStorage.RemoteEvent.OnServerEvent:Connect(function(player)
    local Gunshsot = SoundService["Blast Deflector 2 (SFX)"]:Clone()
    Gunshsot.Parent = SoundService
    Gunshsot:Play()
    Debris:AddItem(Gunshsot, 1)
    linearVelocityBall(player, player.Character)
end)