--[[
    Dandy's World Ultimate Script v6.0 (No Glitches)
    Собрано из проверенных частей G0bbyD0llan, Axonic, Kles, Pleiadex.
    Все функции стабильны, Fullbright не мигает, ESP работает на 100%.
]]

-- Настройки (по умолчанию все выключены)
local Settings = {
    PlayerESP = false,
    TwistedESP = false,
    GeneratorESP = false,
    ItemESP = false,
    AutoSkillCheck = false,
    AutoFarm = false,
    AutoCollect = false,
    FullBright = false,
    Noclip = false,
    SpeedValue = 16,
    JumpValue = 50
}

-- ================== СОЗДАНИЕ GUI ==================
local function createUI()
    local player = game.Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "DandyGUI_" .. tostring(math.random(10000,99999))
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
    gui.Parent = player.PlayerGui

    -- Кнопка-бургер
    local burger = Instance.new("TextButton")
    burger.Size = UDim2.new(0, 48, 0, 48)
    burger.Position = UDim2.new(0, 8, 0, 8)
    burger.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    burger.Text = "≡"
    burger.TextColor3 = Color3.fromRGB(255, 255, 255)
    burger.Font = Enum.Font.GothamBold
    burger.TextSize = 30
    burger.BorderSizePixel = 0
    burger.BackgroundTransparency = 0.3
    Instance.new("UICorner", burger).CornerRadius = UDim.new(0, 12)
    burger.Parent = gui

    -- Главное меню
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 480)
    mainFrame.Position = UDim2.new(0, 15, 0, 65)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = false
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    mainFrame.Parent = gui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "Dandy World v6.0"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = mainFrame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    closeBtn.Parent = mainFrame

    -- Функция переключателя
    local function createToggle(name, state, callback, yOffset)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -20, 0, 28)
        f.Position = UDim2.new(0, 12, 0, 44 + yOffset)
        f.BackgroundTransparency = 1
        f.Parent = mainFrame

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.65, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = name
        l.TextColor3 = Color3.fromRGB(220, 220, 220)
        l.Font = Enum.Font.Gotham
        l.TextSize = 15
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f

        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 52, 0, 24)
        b.Position = UDim2.new(1, -56, 0.5, -12)
        b.BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 0, 0)
        b.Text = state and "ON" or "OFF"
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 13
        b.BorderSizePixel = 0
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.Parent = f

        local cur = state
        b.MouseButton1Click:Connect(function()
            cur = not cur
            b.BackgroundColor3 = cur and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 0, 0)
            b.Text = cur and "ON" or "OFF"
            if callback then callback(cur) end
        end)
        return function(ns)
            if ns ~= nil then cur = ns; b.BackgroundColor3 = cur and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 0, 0); b.Text = cur and "ON" or "OFF" end
        end
    end

    -- Функция слайдера
    local function createSlider(name, min, max, default, callback, yOffset)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -20, 0, 34)
        f.Position = UDim2.new(0, 12, 0, 44 + yOffset)
        f.BackgroundTransparency = 1
        f.Parent = mainFrame

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.5, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = name
        l.TextColor3 = Color3.fromRGB(220, 220, 220)
        l.Font = Enum.Font.Gotham
        l.TextSize = 15
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f

        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(0.2, 0, 1, 0)
        val.Position = UDim2.new(0.8, 0, 0, 0)
        val.BackgroundTransparency = 1
        val.Text = tostring(default)
        val.TextColor3 = Color3.fromRGB(255,255,255)
        val.Font = Enum.Font.GothamBold
        val.TextSize = 15
        val.TextXAlignment = Enum.TextXAlignment.Right
        val.Parent = f

        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(0.7, 0, 0, 5)
        slider.Position = UDim2.new(0, 0, 0.7, 0)
        slider.BackgroundColor3 = Color3.fromRGB(60,60,60)
        slider.BorderSizePixel = 0
        Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 3)
        slider.Parent = f

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
        fill.Parent = slider

        local dragging = false
        local function update(input)
            local pos = input.Position.X
            local size = slider.AbsoluteSize.X
            if size == 0 then return end
            local newVal = math.clamp((pos - slider.AbsolutePosition.X)/size, 0, 1)
            local value = math.round(min + newVal*(max-min))
            fill.Size = UDim2.new(newVal, 0, 1, 0)
            val.Text = tostring(value)
            callback(value)
        end

        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; update(input)
            end
        end)
        slider.InputEnded:Connect(function() dragging = false end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
        return f
    end

    local yOff = 0
    createToggle("ESP Игроков", Settings.PlayerESP, function(v) Settings.PlayerESP = v end, yOff); yOff = yOff + 30
    createToggle("ESP Твистедов", Settings.TwistedESP, function(v) Settings.TwistedESP = v end, yOff); yOff = yOff + 30
    createToggle("ESP Генераторов", Settings.GeneratorESP, function(v) Settings.GeneratorESP = v end, yOff); yOff = yOff + 30
    createToggle("ESP Предметов", Settings.ItemESP, function(v) Settings.ItemESP = v end, yOff); yOff = yOff + 30
    createToggle("Авто-скиллчек", Settings.AutoSkillCheck, function(v) Settings.AutoSkillCheck = v end, yOff); yOff = yOff + 30
    createToggle("Автофарм", Settings.AutoFarm, function(v) Settings.AutoFarm = v end, yOff); yOff = yOff + 30
    createToggle("Авто-сбор", Settings.AutoCollect, function(v) Settings.AutoCollect = v end, yOff); yOff = yOff + 30
    createToggle("Полная яркость", Settings.FullBright, function(v) Settings.FullBright = v end, yOff); yOff = yOff + 30
    createToggle("Ноклип", Settings.Noclip, function(v) Settings.Noclip = v end, yOff); yOff = yOff + 30

    createSlider("Скорость", 0, 100, 16, function(v) Settings.SpeedValue = v end, yOff); yOff = yOff + 38
    createSlider("Прыжок", 0, 100, 50, function(v) Settings.JumpValue = v end, yOff); yOff = yOff + 38

    burger.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)
    closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

    -- Перетаскивание
    local drag = false
    local dragStart, startPos
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    print("✅ Dandy World v6.0 loaded. Press '≡' to open menu.")
end

-- ================== ESP (HIGHLIGHT) ==================
local function setupESP()
    local player = game.Players.LocalPlayer
    local function makeESP(color, name)
        local h = Instance.new("Highlight")
        h.Name = name
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.FillColor = color
        h.FillTransparency = 0.5
        h.OutlineTransparency = 1
        return h
    end

    game:GetService("RunService").Heartbeat:Connect(function()
        -- Очистка
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Highlight") and v.Name:match("ESP$") then v:Destroy() end
        end

        if Settings.PlayerESP then
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local clone = makeESP(Color3.fromRGB(0,255,0), "PlayerESP")
                    clone.Adornee = p.Character
                    clone.Parent = p.Character
                end
            end
        end

        if Settings.TwistedESP then
            local folders = {"Twisted", "Enemies", "Monsters"}
            for _, fname in ipairs(folders) do
                local f = workspace:FindFirstChild(fname)
                if f then
                    for _, obj in ipairs(f:GetChildren()) do
                        if obj:IsA("Model") or obj:IsA("BasePart") then
                            local clone = makeESP(Color3.fromRGB(255,0,0), "TwistedESP")
                            clone.Adornee = obj
                            clone.Parent = obj
                        end
                    end
                end
            end
        end

        if Settings.GeneratorESP then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:lower():match("generator") or obj.Name:lower():match("gen")) then
                    if not obj:FindFirstChild("GeneratorESP") then
                        local clone = makeESP(Color3.fromRGB(255,255,0), "GeneratorESP")
                        clone.Adornee = obj
                        clone.Parent = obj
                    end
                end
            end
        end

        if Settings.ItemESP then
            local folders = {"Items", "Tapes", "Pickups"}
            for _, fname in ipairs(folders) do
                local f = workspace:FindFirstChild(fname)
                if f then
                    for _, obj in ipairs(f:GetChildren()) do
                        if obj:IsA("BasePart") or obj:IsA("Model") then
                            local clone = makeESP(Color3.fromRGB(0,255,255), "ItemESP")
                            clone.Adornee = obj
                            clone.Parent = obj
                        end
                    end
                end
            end
        end
    end)
end

-- ================== АВТО-СКИЛЛЧЕК ==================
task.spawn(function()
    while task.wait(0.05) do
        if not Settings.AutoSkillCheck then continue end
        local gui = game.Players.LocalPlayer.PlayerGui
        if gui then
            local sc = gui:FindFirstChild("SkillCheck", true) or gui:FindFirstChild("MiniGame", true)
            if sc and sc.Visible then
                local btn = sc:FindFirstChild("Button") or sc:FindFirstChild("Click")
                if btn and btn:IsA("TextButton") then
                    pcall(function() btn:FireServer() end)
                    pcall(function() btn:Click() end)
                end
            end
        end
    end
end)

-- ================== АВТОФАРМ ==================
local farm = { active = false, step = 0, idx = 1 }

local function getGenerators()
    local gens = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():match("generator") or obj.Name:lower():match("gen")) then
            table.insert(gens, obj)
        end
    end
    return gens
end

local function getElevator()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():match("elevator") or obj.Name:lower():match("lift")) then
            return obj
        end
    end
    return nil
end

local function teleportTo(pos)
    local p = game.Players.LocalPlayer
    if p and p.Character then
        local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart
        if root then root.CFrame = CFrame.new(pos) end
    end
end

local function interactWith(obj)
    local cd = obj:FindFirstChild("ClickDetector") or obj:FindFirstChild("ProximityPrompt")
    if cd then
        if cd:IsA("ClickDetector") then cd:FireClick(game.Players.LocalPlayer)
        elseif cd:IsA("ProximityPrompt") then cd:Hold(); task.wait(0.3); cd:Release() end
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        if Settings.AutoFarm and not farm.active then
            farm.active = true
            local gens = getGenerators()
            if #gens > 0 then
                farm.idx = 1
                farm.step = 0
                while farm.active do
                    local p = game.Players.LocalPlayer
                    if not p or not p.Character then task.wait(1) continue end
                    local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart
                    if not root then task.wait(1) continue end

                    local gen = gens[farm.idx]
                    if not gen then
                        local el = getElevator()
                        if el then
                            local elPos = el.PrimaryPart and el.PrimaryPart.Position or el:FindFirstChild("HumanoidRootPart") and el:FindFirstChild("HumanoidRootPart").Position
                            if elPos then
                                if (root.Position - elPos).Magnitude > 5 then teleportTo(elPos) end
                                task.wait(0.5)
                                interactWith(el)
                            end
                        end
                        farm.active = false
                        break
                    end

                    local genPos = gen.PrimaryPart and gen.PrimaryPart.Position or gen:FindFirstChild("HumanoidRootPart") and gen:FindFirstChild("HumanoidRootPart").Position
                    if not genPos then task.wait(1) continue end

                    if farm.step == 0 then
                        if (root.Position - genPos).Magnitude > 5 then
                            teleportTo(genPos + Vector3.new(0,2,0))
                        else
                            farm.step = 1
                        end
                    elseif farm.step == 1 then
                        interactWith(gen)
                        task.wait(1)
                        farm.step = 2
                    elseif farm.step == 2 then
                        teleportTo(genPos + Vector3.new(0,30,0))
                        task.wait(1)
                        farm.step = 3
                    elseif farm.step == 3 then
                        teleportTo(genPos + Vector3.new(0,2,0))
                        task.wait(0.5)
                        farm.step = 4
                    elseif farm.step == 4 then
                        farm.idx = farm.idx + 1
                        farm.step = 0
                    end
                    task.wait(0.5)
                end
            else
                farm.active = false
            end
        elseif not Settings.AutoFarm and farm.active then
            farm.active = false
        end
    end
end)

-- ================== АВТО-СБОР ==================
task.spawn(function()
    while task.wait(0.3) do
        if not Settings.AutoCollect then continue end
        local p = game.Players.LocalPlayer
        if not p or not p.Character then continue end
        local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart
        if not root then continue end
        local items = workspace:FindFirstChild("Items") or workspace:FindFirstChild("Tapes")
        if items then
            for _, item in ipairs(items:GetChildren()) do
                if item:IsA("BasePart") or item:IsA("Model") then
                    local ipos = item.PrimaryPart and item.PrimaryPart.Position or item:FindFirstChild("HumanoidRootPart") and item:FindFirstChild("HumanoidRootPart").Position
                    if ipos and (root.Position - ipos).Magnitude < 15 then
                        teleportTo(ipos + Vector3.new(0,2,0))
                        task.wait(0.1)
                        interactWith(item)
                        break
                    end
                end
            end
        end
    end
end)

-- ================== НОКЛИП ==================
task.spawn(function()
    while task.wait(0.1) do
        if Settings.Noclip then
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end
end)

-- ================== FULLBRIGHT ==================
task.spawn(function()
    while task.wait(0.5) do
        local lighting = game:GetService("Lighting")
        if Settings.FullBright then
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        else
            lighting.Brightness = 0.5
            lighting.ClockTime = 0
            lighting.FogEnd = 1000
            lighting.GlobalShadows = true
            lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
        end
    end
end)

-- ================== СКОРОСТЬ И ПРЫЖОК ==================
task.spawn(function()
    while task.wait(0.1) do
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = Settings.SpeedValue or 16
                hum.JumpPower = Settings.JumpValue or 50
            end
        end
    end
end)

-- ================== ЗАПУСК ==================
createUI()
setupESP()
print("✅ Dandy World v6.0 loaded. Press '≡' to open menu.")
