local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ball_lv = ReplicatedStorage.Ball_LV
local ttl = 10


local function linearVelocityBall(player, char)
    local ball = ball_lv:Clone()
    ball.Parent = workspace
    ball.Touched:Connect(function(hit)
        if hit.Parent:isA("Model") then
            if hit.Parent.name == char.name then
                print("touched player who shot / dmg ignored")
                --ball.Material = Enum.Material.ForceField
                return
            elseif hit.Parent.name ~= char.name then
                hit.Parent.Humanoid.Health -= 10
                print("Touched enemy player / dmg inflicted")
                ball.Material = Enum.Material.Neon
            end
        end
    end)
    local HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    local ballVelocity = ball.LinearVelocity
    ballVelocity.MaxForce = math.huge
    ballVelocity.VectorVelocity = HumanoidRootPart.CFrame.LookVector * 20
    ball.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 1, -3)
    Debris:AddItem(ball, ttl)
end

ReplicatedStorage.RemoteEvent.OnServerEvent:Connect(function(player)
    linearVelocityBall(player, player.Character)
end)