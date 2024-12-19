local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local screengui = player.PlayerGui:WaitForChild("ScreenGui")

local blastpower = screengui.Abilities.BlastPower
local massiveblast = screengui.Abilities["Massive Blast"]
local regenhp = screengui.Abilities["Regen hp+"]
local wall = screengui.Abilities.Wall


local tweeninfo = TweenInfo.new(
    1,
    Enum.EasingStyle.Cubic,
    Enum.EasingDirection.Out,
    0,
    false,
    0
)

local ability1Debounce =  false
local ability2Debounce = false
local ability3Debounce = false
local ability4Debounce = false

--player.CharacterAdded:Wait()

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
            if player.PlayerGui.ScreenGui.Abilities.BlastPower:GetAttribute("Selected") == true and ability1Debounce == false and player.Character.Healing.Value == false then
                if player.Character.UltimateActivated.Value == true then
                    ability1Debounce =  true
                    print(player.Name.." Clicked super blast ability")
                    --ReplicatedStorage.RemoteEvent:FireServer(1, 0.3, Abilities.BlastPowerCD)
                    task.wait(0.3) -- ability Cool down
                    task.wait(0.2)
                    ability1Debounce = false
                elseif player.Character.UltimateActivated.Value == false then
                    ability1Debounce =  true
                    ReplicatedStorage.RemoteEvent:FireServer(1, 0.3, Abilities.BlastPowerCD)
                    task.wait(0.3) -- ability Cool down
                    task.wait(0.2)
                    ability1Debounce = false
                end
            elseif player.PlayerGui.ScreenGui.Abilities["Massive Blast"]:GetAttribute("Selected") == true and ability2Debounce == false and player.Character.Healing.Value == false then
                if player.Character.UltimateActivated.Value == true then
                    ability2Debounce = true
                    print(player.Name.." Clicked EnormousBlast ability")
                    --ReplicatedStorage.RemoteEvent:FireServer(2, 0.7, Abilities.MassiveBlastCD)
                    task.wait(0.7) -- ability Cooldown
                    task.wait(0.2)
                    ability2Debounce = false
                elseif player.Character.UltimateActivated.Value == false then
                    ability2Debounce = true
                    ReplicatedStorage.RemoteEvent:FireServer(2, 0.7, Abilities.MassiveBlastCD)
                    task.wait(0.7) -- ability Cooldown
                    task.wait(0.2)
                    ability2Debounce = false
                end
            elseif player.PlayerGui.ScreenGui.Abilities["Regen hp+"]:GetAttribute("Selected") == true and ability3Debounce == false  then
                if player.Character.UltimateActivated.Value == true then
                    ability3Debounce = true
                    print(player.Name.." Clicked Sacrifice ability")
                    --ReplicatedStorage.RemoteEvent:FireServer(3, 5, Abilities.RegenHP_CD)
                    task.wait(10) -- ability Cooldown
                    ability3Debounce = false
                elseif player.Character.UltimateActivated.Value == false then
                    ability3Debounce = true
                    ReplicatedStorage.RemoteEvent:FireServer(3, 5, Abilities.RegenHP_CD)
                    task.wait(10) -- ability Cooldown
                    ability3Debounce = false
                end
            elseif player.PlayerGui.ScreenGui.Abilities.Wall:GetAttribute("Selected") == true  and ability4Debounce == false and player.Character.Healing.Value == false then
                if player.Character.UltimateActivated.Value == true then
                    ability4Debounce = true
                    print(player.Name.." Clicked GiantWall ability")
                    --ReplicatedStorage.RemoteEvent:FireServer(4, 5, Abilities.WallCD)
                    task.wait(5) -- ability Cooldown
                    task.wait(1.5)
                    ability4Debounce = false
                elseif player.Character.UltimateActivated.Value == false then
                    ability4Debounce = true
                    ReplicatedStorage.RemoteEvent:FireServer(4, 5, Abilities.WallCD)
                    task.wait(5) -- ability Cooldown
                    task.wait(1.5)
                    ability4Debounce = false
                end
            elseif player.PlayerGui.ScreenGui.Ultimate.TextButton:GetAttribute("Selected") == true and player.Character.Healing.Value == false and player.Character.UltimateActivated.Value == false then
                local progessbar = player.PlayerGui.ScreenGui.Ultimate.ProgressBar
                --[[TweenService:Create(progessbar, tweeninfo, {Size = UDim2.new(0, 0, 1, 0)}):Play()
                SoundService["Power Outage"]:Play()--]]
                TweenService:Create(screengui.Ultimate, tweeninfo, {BorderSizePixel = 0}):Play()
                blastpower.BorderColor3 = Color3.fromHex("#aa0000")
                massiveblast.BorderColor3 = Color3.fromHex("#aa0000")
                regenhp.BorderColor3 = Color3.fromHex("#aa0000")
                wall.BorderColor3 = Color3.fromHex("#aa0000")

                SoundService["Power Outage"]:Play()
                TweenService:Create(blastpower, tweeninfo, {TextTransparency = 1}):Play()
                TweenService:Create(massiveblast, tweeninfo, {TextTransparency = 1}):Play()
                TweenService:Create(regenhp, tweeninfo, {TextTransparency = 1}):Play()
                TweenService:Create(wall, tweeninfo, {TextTransparency = 1}):Play()
                task.wait(0.5)
                screengui.Abilities.BlastPower.Text = "SuperBlast"
                screengui.Abilities["Massive Blast"].Text = "EnormousBlast"
                screengui.Abilities["Regen hp+"].Text = "Sacrifice"
                screengui.Abilities.Wall.Text = "GiantWall"
                TweenService:Create(blastpower, tweeninfo, {TextTransparency = 0}):Play()
                TweenService:Create(massiveblast, tweeninfo, {TextTransparency = 0}):Play()
                TweenService:Create(regenhp, tweeninfo, {TextTransparency = 0}):Play()
                TweenService:Create(wall, tweeninfo, {TextTransparency = 0}):Play()
                
                --TweenService:Create(progessbar, tweeninfo, {Size = UDim2.new(0, 0, 1, 0)}):Play()
                
                task.wait(1)
                ReplicatedStorage.GivAuraEvent:FireServer(1)
                for i = 60, 0, -1 do
                    task.wait(1)
                    player.PlayerGui.ScreenGui.Ultimate.TextButton.Text = "("..i..")"
                    TweenService:Create(progessbar, tweeninfo, {Size = UDim2.new(i / 60, 0, 1, 0)}):Play()
                    if i == 0 then
                        SoundService["Power Outage"]:Play()
                        TweenService:Create(screengui.Ultimate.TextButton, tweeninfo, {TextTransparency = 1}):Play()
                        TweenService:Create(blastpower, tweeninfo, {TextTransparency = 1}):Play()
                        TweenService:Create(massiveblast, tweeninfo, {TextTransparency = 1}):Play()
                        TweenService:Create(regenhp, tweeninfo, {TextTransparency = 1}):Play()
                        TweenService:Create(wall, tweeninfo, {TextTransparency = 1}):Play()
                        task.wait(0.5)
                        screengui.Ultimate.TextButton.Text = "ULTIMATE(0/5bloodlust)"
                        screengui.Abilities.BlastPower.Text = "Blast power"
                        screengui.Abilities["Massive Blast"].Text = "Massive blast"
                        screengui.Abilities["Regen hp+"].Text = "Regen hp+"
                        screengui.Abilities.Wall.Text = "Wall"
                        TweenService:Create(screengui.Ultimate.TextButton, tweeninfo, {TextTransparency = 0}):Play()
                        TweenService:Create(blastpower, tweeninfo, {TextTransparency = 0}):Play()
                        TweenService:Create(massiveblast, tweeninfo, {TextTransparency = 0}):Play()
                        TweenService:Create(regenhp, tweeninfo, {TextTransparency = 0}):Play()
                        TweenService:Create(wall, tweeninfo, {TextTransparency = 0}):Play()
                        blastpower.BorderColor3 = Color3.fromHex("#000000")
                        massiveblast.BorderColor3 = Color3.fromHex("#000000")
                        regenhp.BorderColor3 = Color3.fromHex("#000000")
                        wall.BorderColor3 = Color3.fromHex("#000000")
                        ReplicatedStorage.GivAuraEvent:FireServer(2)
                    end
                end
            end
        end
    end
end)