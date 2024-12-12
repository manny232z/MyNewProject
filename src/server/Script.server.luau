local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rig = workspace.Rig
local ball_lv = ReplicatedStorage:WaitForChild("Ball_LV")
local ball_vf = ReplicatedStorage:WaitForChild("Ball_VF")
local ball_alv = ReplicatedStorage:WaitForChild("Ball_ALV")
local HumanoidRootPart = rig:WaitForChild("HumanoidRootPart")
local ttl = 10

local function linearVelocityBall()
    local ball = ball_lv:Clone()
    ball.Parent = workspace
    ball.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 1, -3)
    local ballVelocity = ball.LinearVelocity
    ballVelocity.MaxForce = math.huge
    ballVelocity.VectorVelocity = HumanoidRootPart.CFrame.LookVector * 20
    Debris:AddItem(ball, ttl)
end

local function VectorForceBall()
    local ball = ball_vf:Clone()
    ball.Parent = workspace
    ball.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 1, -3)
    local ballVectorForce = ball.VectorForce
    ballVectorForce.Force = HumanoidRootPart.CFrame.LookVector * ball_vf:GetMass() * 20
    Debris:AddItem(ball, ttl)
end

local function AssemblyLinearVelocityBall()
    local ball = ball_alv:Clone()
    ball.Parent = workspace
    ball.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 1, -3)
    ball.AssemblyLinearVelocity = HumanoidRootPart.CFrame.LookVector * ball_vf:GetMass() * 20
    Debris:AddItem(ball, ttl)
end

task.wait(5)
for i = 1, 5 do
    task.wait(1)
    linearVelocityBall()
end

for i = 1, 5 do
    task.wait(1)
    VectorForceBall()
end

for i = 1, 5 do
    task.wait(1)
    AssemblyLinearVelocityBall()
end