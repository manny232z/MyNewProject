local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        print("Player clicked or tapped")
        ReplicatedStorage.RemoteEvent:FireServer()
    --[[local newpart = Instance.new("Part")
        newpart.Parent = workspace
        newpart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,math.rad(-5),0)--]]
    end
end)