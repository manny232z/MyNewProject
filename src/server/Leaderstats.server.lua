local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local kills = Instance.new("IntValue")
    kills.Name = "bloodlust"
    kills.Parent = leaderstats
end)
