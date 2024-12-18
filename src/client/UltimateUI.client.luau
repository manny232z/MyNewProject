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


num = 0
killnum = 0
ReplicatedStorage.UltimateEvent.OnClientEvent:Connect(function()
    if num == 1 and killnum == 5 then
        return
    end
    num += 0.2
    killnum += 1
    TweenService:Create(UltimateGUI.ProgressBar, tweeninfo, {Size = UDim2.new(num, 0, 1, 0)}):Play()
    UltimateGUI.TextButton.Text = "ULTIMATE("..killnum.."/5bloodlust)"
    --[[if killnum == 5 then
        ReplicatedStorage.GivAuraEvent:FireServer()
    end--]]
end)