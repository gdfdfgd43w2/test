local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Автоматическое создание сетевого события
local DevMenuEvent = ReplicatedStorage:FindFirstChild("DevMenuEvent")
if not DevMenuEvent then
	DevMenuEvent = Instance.new("RemoteEvent")
	DevMenuEvent.Name = "DevMenuEvent"
	DevMenuEvent.Parent = ReplicatedStorage
end

-- СЕРВЕРНАЯ ЧАСТЬ: Выполнение команд (Работает для всех без ограничений)
DevMenuEvent.OnServerEvent:Connect(function(player, action, targetPlayerName)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	local pRoot = character.HumanoidRootPart

	-- 1. Телепорт еды
	if action == "TP_FOOD" then
		for _, item in pairs(workspace:GetDescendants()) do
			if item:IsA("Part") or item:IsA("MeshPart") or item:IsA("Model") then
				local nameLower = item.Name:lower()
				if nameLower:match("pizza") or nameLower:match("food") then
					if item:IsA("Model") then
						item:MoveTo(pRoot.Position + pRoot.CFrame.LookVector * 4)
					else
						item.CFrame = pRoot.CFrame * CFrame.new(0, 0, -4)
					end
				end
			end
		end
		
	-- 2. Работников за карту
	elseif action == "KILL_STAFF" then
		for _, npc in pairs(workspace:GetDescendants()) do
			if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
				local nameLower = npc.Name:lower()
				if nameLower:match("staff") or nameLower:match("employee") then
					local root = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso")
					if root then
						root.CFrame = CFrame.new(0, -2000, 0)
					end
				end
			end
		end
		
	-- 3. Телепорт к выбранному игроку из списка
	elseif action == "TP_TO_PLAYER" and targetPlayerName then
		local targetPlayer = Players:FindFirstChild(targetPlayerName)
		if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
			pRoot.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
		end
	end
end)

-- КЛИЕНТСКАЯ ЧАСТЬ: Интерфейс со списком игроков
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		local clientScript = Instance.new("LocalScript")
		clientScript.Name = "DevMenuUI_Generator"
		
		clientScript.Source = [[
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local Players = game:GetService("Players")
			local DevMenuEvent = ReplicatedStorage:WaitForChild("DevMenuEvent")
			local localPlayer = Players.LocalPlayer

			-- Создание основного интерфейса
			local ScreenGui = Instance.new("ScreenGui")
			ScreenGui.Name = "EasyDevMenu"
			ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")
			ScreenGui.ResetOnSpawn = false

			local MainFrame = Instance.new("Frame")
			MainFrame.Name = "MainFrame"
			MainFrame.Parent = ScreenGui
			MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			MainFrame.Position = UDim2.new(0, 15, 0.25, 0)
			MainFrame.Size = UDim2.new(0, 220, 0, 360)
			MainFrame.BorderSizePixel = 0

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.Parent = MainFrame
			Title.Size = UDim2.new(1, 0, 0, 35)
			Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			Title.Text = "3008 PANEL"
			Title.TextColor3 = Color3.fromRGB(255, 215, 0)
			Title.TextSize = 16
			Title.Font = Enum.Font.SourceSansBold

			-- Кнопки основных функций
			local TPPizzaBtn = Instance.new("TextButton")
			local KillStaffBtn = Instance.new("TextButton")
			
			local function styleMainButton(btn, text, pos)
				btn.Parent = MainFrame
				btn.Size = UDim2.new(0, 200, 0, 35)
				btn.Position = UDim2.new(0, 10, 0, pos)
				btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				btn.TextColor3 = Color3.fromRGB(240, 240, 240)
				btn.Text = text
				btn.TextSize = 14
				btn.Font = Enum.Font.SourceSansBold
				btn.BorderSizePixel = 0
			end

			styleMainButton(TPPizzaBtn, "🍎 Притянуть Еду", 45)
			styleMainButton(KillStaffBtn, "👹 Работников за карту", 85)

			TPPizzaBtn.MouseButton1Click:Connect(function() DevMenuEvent:FireServer("TP_FOOD") end)
			KillStaffBtn.MouseButton1Click:Connect(function() DevMenuEvent:FireServer("KILL_STAFF") end)

			-- Подзаголовок для списка игроков
			local ListTitle = Instance.new("TextLabel")
			ListTitle.Parent = MainFrame
			ListTitle.Size = UDim2.new(1, 0, 0, 25)
			ListTitle.Position = UDim2.new(0, 0, 0, 130)
			ListTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			ListTitle.Text = "ТЕЛЕПОРТ К ИГРОКАМ:"
			ListTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
			ListTitle.TextSize = 12
			ListTitle.Font = Enum.Font.SourceSansBold

			-- Прокручиваемый список игроков (ScrollingFrame)
			local ScrollFrame = Instance.new("ScrollingFrame")
			ScrollFrame.Parent = MainFrame
			ScrollFrame.Size = UDim2.new(0, 200, 0, 190)
			ScrollFrame.Position = UDim2.new(0, 10, 0, 160)
			ScrollFrame.BackgroundTransparency = 1
			ScrollFrame.BorderSizePixel = 0
			ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

			local UIListLayout = Instance.new("UIListLayout")
			UIListLayout.Parent = ScrollFrame
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)

			-- Функция обновления списка игроков
			local function updatePlayerList()
				-- Очищаем старые кнопки игроков
				for _, child in pairs(ScrollFrame:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end

				-- Создаем новые кнопки для каждого игрока в игре
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= localPlayer then -- Себя в список не добавляем
						local PBtn = Instance.new("TextButton")
						PBtn.Parent = ScrollFrame
						PBtn.Size = UDim2.new(1, -10, 0, 30)
						PBtn.BackgroundColor3 = Color3.fromRGB(60, 70, 80)
						PBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
						PBtn.Text = "👤 " .. p.DisplayName
						PBtn.TextSize = 13
						PBtn.Font = Enum.Font.SourceSans
						PBtn.BorderSizePixel = 0

						PBtn.MouseButton1Click:Connect(function()
							DevMenuEvent:FireServer("TP_TO_PLAYER", p.Name)
						end)
					end
				end
				ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
			end

			-- Следим за тем, кто заходит и выходит из игры, чтобы обновлять список
			Players.PlayerAdded:Connect(updatePlayerList)
			Players.PlayerRemoving:Connect(updatePlayerList)
			updatePlayerList() -- Первый запуск обновления
		]]
		
		clientScript.Parent = player:WaitForChild("PlayerGui")
	end
end)
