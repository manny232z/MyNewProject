local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local AuraPieces = game.ServerStorage.FolderForAuraPieces2
local HeadAura = AuraPieces.Head
local LeftArm = AuraPieces.LeftArm
local LeftLeg = AuraPieces.LeftLeg
local RightArm = AuraPieces.RightArm
local RightLeg = AuraPieces.RightLeg
local Torso = AuraPieces.Torso

local function GiveAura(player)
	local char = player.Character
	for i, v in pairs(char:GetChildren()) do
		if v.Name == "Head" then
			for i, aura in pairs(HeadAura:GetChildren()) do
				local newaura = aura:Clone()
				newaura.Name = "Aura"
				newaura.Parent = v
			end
		end
	end
	task.wait()
	for i, v in pairs(char:GetChildren()) do
		if v.Name == "LeftLowerArm" then
			for i, aura in pairs(LeftArm:GetChildren()) do
				local newaura = aura:Clone()
				newaura.Name = "Aura"
				newaura.Parent = v
			end
		end
	end
	task.wait()
	for i, v in pairs(char:GetChildren()) do
		if v.Name == "LeftLowerLeg" then
			for i, aura in pairs(LeftLeg:GetChildren()) do
				local newaura = aura:Clone()
				newaura.Name = "Aura"
				newaura.Parent = v
			end
		end
	end
	task.wait()
	for i, v in pairs(char:GetChildren()) do
		if v.Name == "RightLowerArm" then
			for i, aura in pairs(RightArm:GetChildren()) do
				local newaura = aura:Clone()
				newaura.Name = "Aura"
				newaura.Parent = v
			end
		end
	end
	task.wait()
	for i, v in pairs(char:GetChildren()) do
		if v.Name == "RightLowerLeg" then
			for i, aura in pairs(RightLeg:GetChildren()) do
				local newaura = aura:Clone()
				newaura.Name = "Aura"
				newaura.Parent = v
			end
		end
	end
	task.wait()
	for i, v in pairs(char:GetChildren()) do
		if v.Name == "LowerTorso" then
			for i, aura in pairs(Torso:GetChildren()) do
				local newaura = aura:Clone()
				newaura.Name = "Aura"
				newaura.Parent = v
			end
		end
	end
	task.wait()
	for i, v in pairs(char:GetChildren()) do
		if v.Name == "LeftUpperArm" then
			for i, aura in pairs(LeftArm:GetChildren()) do
				local newaura = aura:Clone()
				newaura.Name = "Aura"
				newaura.Parent = v
			end
		end
	end
	task.wait()
	for i, v in pairs(char:GetChildren()) do
		if v.Name == "RightUpperArm" then
			for i, aura in pairs(RightArm:GetChildren()) do
				local newaura = aura:Clone()
				newaura.Name = "Aura"
				newaura.Parent = v
			end
		end
	end
end

local function removeParticleEmitters(player)
	-- Check if the player has a character
	local character = player.Character
	if not character then
		print("Player has no character.")
		return
	end

	-- Loop through all the parts in the character
	for _, part in pairs(character:GetChildren()) do
		-- Check if the part has ParticleEmitter
		if part:IsA("BasePart") then
			for _, descendant in pairs(part:GetChildren()) do
				if descendant:IsA("ParticleEmitter") then
					-- Destroy the ParticleEmitter
					descendant:Destroy()
					print("ParticleEmitter removed from " .. part.Name)
				end
			end
		end
	end
end

local tweenInfo = TweenInfo.new(
	1.5,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.In, 
	0,
	false,
	0
)

ReplicatedStorage.GivAuraEvent.OnServerEvent:Connect(function(player, num)
	if num == 1 then
        player.UltimateActivated.Value = true
        player.transforming.Value = true
        ReplicatedStorage.CameraShakeEvent:FireClient(player, "Transformation")
        player.Character.Humanoid.WalkSpeed = 0
        task.wait(0.5)
		local highlight = Instance.new("Highlight", player.Character)
		highlight.FillColor = Color3.new(0.878431, 0.250980, 0.901960)
		highlight.OutlineColor = Color3.new(0.878431, 0.235294, 0.235294)
        SoundService["Super Smash Bros Ultimate Smash Ball Sound Effect"]:Play()

        player.Character.Humanoid.AutoRotate = false
        player.Character.Humanoid.JumpHeight = 0
        player.bloodlust.Value = 0

		--task.wait(1)
		local transformationPart = ReplicatedStorage.TransformationPart:Clone()
		transformationPart.Parent = workspace
        transformationPart.Touched:Connect(function(otherpart)
            if otherpart.Name == "Ball_LV" or otherpart.Name == "MassiveBall_LV" or otherpart.Name == "Ball_LV3" or otherpart.Name == "Ball_LV2" then
                otherpart.BrickColor = BrickColor.new("Alder")
                otherpart.Material = Enum.Material.Neon
                otherpart.LinearVelocity:Destroy()
                otherpart.Hit:Destroy()
                otherpart.CanCollide = false
                task.wait(0.3)
                otherpart.Anchored = true
                task.wait(3)
                otherpart.Anchored = false
            end
        end)
		transformationPart.CFrame = player.Character.HumanoidRootPart.CFrame 
		TweenService:Create(transformationPart, tweenInfo, {Size = Vector3.new(50,50,50)}):Play()
        task.wait(3)
		SoundService["Power Outage"]:Play()

        TweenService:Create(transformationPart, tweenInfo, {Size = Vector3.new(0,0,0)}):Play()
		task.wait(1.5)
		player.Character.Humanoid.WalkSpeed = 30
        player.Character.Humanoid.AutoRotate = true
        player.Character.Humanoid.JumpHeight = 5
		player.Character.Humanoid.Health = 100
        transformationPart:Destroy()
        highlight:Destroy()
        GiveAura(player)
        player.transforming.Value = false
	elseif num == 2 then
		removeParticleEmitters(player)
		player.UltimateActivated.Value = false
		player.Character.Humanoid.WalkSpeed = 22
		player.bloodlust.Value = 0
        player.leaderstats.bloodlust.Value = 0
		player.num.Value = 0
	end
end)

ReplicatedStorage.AuraRespawnEvent.Event:Connect(function(player)
    GiveAura(player)
end)