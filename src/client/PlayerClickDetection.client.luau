local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- Check if the player clicked or tapped
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Only fire the event if the input was not processed by other UI elements
        if not gameProcessedEvent then
            print("Player clicked or tapped")
            if player.PlayerGui.ScreenGui.Abilities.BlastPower:GetAttribute("Selected") == true then
                ReplicatedStorage.RemoteEvent:FireServer(1)
            elseif player.PlayerGui.ScreenGui.Abilities["Massive Blast"]:GetAttribute("Selected") == true then
                ReplicatedStorage.RemoteEvent:FireServer(2)
            elseif player.PlayerGui.ScreenGui.Abilities["Regen hp+"]:GetAttribute("Selected") == true then
                ReplicatedStorage.RemoteEvent:FireServer(3)
            elseif player.PlayerGui.ScreenGui.Abilities.Wall:GetAttribute("Selected") == true then
                ReplicatedStorage.RemoteEvent:FireServer(4)
            end
        end
    end
end)