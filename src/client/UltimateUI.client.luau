local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local UltimateGUI = player.PlayerGui:WaitForChild("ScreenGui").Ultimate

local tweeninfo = TweenInfo.new(
    1,
    Enum.EasingStyle.Cubic,
    Enum.EasingDirection.Out,
    0,
    false,
    0
)



ReplicatedStorage.UltimateEvent.OnClientEvent:Connect(function(num, bloodlust)

    if num ~= 1 then
        TweenService:Create(UltimateGUI.ProgressBar, tweeninfo, {Size = UDim2.new(num.Value, 0, 1, 0)}):Play()
    end
    UltimateGUI.TextButton.Text = "ULTIMATE("..bloodlust.Value.."/5bloodlust)"
    --[[if killnum == 5 then
        ReplicatedStorage.GivAuraEvent:FireServer()
    end--]]
end)