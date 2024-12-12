local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        print("Player clicked mouse button 1")
        local newpart = Instance.new("Part")
        newpart.Parent = workspace
        newpart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,math.rad(-5),0)
    end
end)