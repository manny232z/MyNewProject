local BadgeService = game:GetService("BadgeService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local giveBadgeEvent = ReplicatedStorage.GiveBadgeEvent

giveBadgeEvent.OnServerEvent:Connect(function(player)
    BadgeService:AwardBadge(player.UserId, 3166302925027483)
    print(player.Name.." Has been awarded the 'You played' badge.")
end)