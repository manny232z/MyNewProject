local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local ability1Debounce =  false
local ability2Debounce = false
local ability3Debounce = false
local ability4Debounce = false

player.CharacterAdded:Wait()

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- prevents player from shooting while dead
    if player.Character.Humanoid.Health <= 0 then
        print(player.Name.." Attemped to shoot while dead")
        return
    end
    local Abilities = player.PlayerGui:WaitForChild("ScreenGui").Abilities
    -- Check if the player clicked or tapped
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Only fire the event if the input was not processed by other UI elements
        if not gameProcessedEvent then
            print("Player clicked or tapped")
            if player.PlayerGui.ScreenGui.Abilities.BlastPower:GetAttribute("Selected") == true and ability1Debounce == false then
                ability1Debounce =  true
                ReplicatedStorage.RemoteEvent:FireServer(1, 0.3, Abilities.BlastPowerCD)
                task.wait(0.3) -- ability Cool down
                task.wait(0.2)
                 ability1Debounce = false
            elseif player.PlayerGui.ScreenGui.Abilities["Massive Blast"]:GetAttribute("Selected") == true and ability2Debounce == false then
                ability2Debounce = true
                ReplicatedStorage.RemoteEvent:FireServer(2, 0.7, Abilities.MassiveBlastCD)
                task.wait(0.7) -- ability Cooldown
                task.wait(0.2)
                ability2Debounce = false
            elseif player.PlayerGui.ScreenGui.Abilities["Regen hp+"]:GetAttribute("Selected") == true and ability3Debounce == false then
                ability3Debounce = true
                ReplicatedStorage.RemoteEvent:FireServer(3, 5, Abilities.RegenHP_CD)
                task.wait(10) -- ability Cooldown
                ability3Debounce = false
            elseif player.PlayerGui.ScreenGui.Abilities.Wall:GetAttribute("Selected") == true  and ability4Debounce == false then
                ability4Debounce = true
                ReplicatedStorage.RemoteEvent:FireServer(4, 5, Abilities.WallCD)
                task.wait(5) -- ability Cooldown
                task.wait(1.5)
                ability4Debounce = false
            end
        end
    end
end)