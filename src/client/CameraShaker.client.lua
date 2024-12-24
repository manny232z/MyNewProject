local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
local camera = game.Workspace.Camera

local function ShakeCamera(shakeCF)
    camera.CFrame = camera.CFrame * shakeCF
end

local renderpriority = Enum.RenderPriority.Camera.Value + 1
local camshake = CameraShaker.new(renderpriority, ShakeCamera)

camshake:Start()

ReplicatedStorage.CameraShakeEvent.OnClientEvent:Connect(function(ability)
    if ability == "ULT4" then
        camshake:Shake(CameraShaker.Presets.Explosion)
    elseif ability == "Ability2" then
        --camshake:ShakeOnce(5, 3, 0.3, 0.3)
    elseif ability == "WallAbility" then
        camshake:Shake(CameraShaker.Presets.Bump)
    elseif ability == "WallAbility2" then
        camshake:Shake(CameraShaker.Presets.Explosion)
    elseif ability == "Transformation" then
        camshake:ShakeSustain(CameraShaker.Presets.Earthquake)
        task.wait(6)
        camshake:StopSustained(1)
    elseif ability == "SunAttack" then
        camshake:ShakeSustain(CameraShaker.Presets.Earthquake)
        task.wait(10)
        camshake:StopSustained(15)
    end
end)