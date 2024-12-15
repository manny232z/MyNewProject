local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- Check if the player clicked or tapped
    --[[if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Only fire the event if the input was not processed by other UI elements
        if not gameProcessedEvent then
            print("Player clicked or tapped")
            ReplicatedStorage.RemoteEvent:FireServer()
        end
    end--]]
end)