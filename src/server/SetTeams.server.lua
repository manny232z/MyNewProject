local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local TeamEvent = ReplicatedStorage.TeamEvent

TeamEvent.OnServerEvent:Connect(function(player, teamName)
    if teamName == "Red" then
        player.Team = Teams["Red Team"]
        print(player.Name.." Has chosen Red team")
        player:AddTag("RedTeam")

    elseif teamName == "Blue" then
        player.Team = Teams["Blue Team"]
        print(player.Name.." Has chosen Blue team")
        player:AddTag("BlueTeam")

    elseif teamName == "Green" then
        player.Team = Teams["Green Team"]
        print(player.Name.." Has chosen Green team")
        player:AddTag("GreenTeam")

    elseif teamName == "Brown" then
        player.Team = Teams["Brown Team"]
        print(player.Name.." Has chosen Brown team")
        player:AddTag("BrownTeam")
    end
end)