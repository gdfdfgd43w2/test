--[[
    Dandy's World Custom GUI
    Твой дизайн: бургер, крест, кнопки вкл/выкл, лого, фон.
]]

local Settings = {
    PlayerESP = false,
    TwistedESP = false,
    GeneratorESP = false,
    ItemESP = false,
    CapsuleESP = false,
    AutoSkillCheck = false,
    AutoFarm = false,
    AutoCollect = false,
    AutoCapsule = false,
    FullBright = false,
    Noclip = false,
    SpeedValue = 16,
    JumpValue = 50
}

-- ================== ТВОИ КАРТИНКИ С GITHUB ==================
local Images = {
    Background = "https://raw.githubusercontent.com/gdfdfgd43w2/test/refs/heads/main/%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B0%D0%B7%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F59_20260620005128.png",
    Burger = "https://raw.githubusercontent.com/gdfdfgd43w2/test/refs/heads/main/%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B0%D0%B7%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F55_20260620004602.png",
    Close = "https://raw.githubusercontent.com/gdfdfgd43w2/test/refs/heads/main/%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B0%D0%B7%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F56_20260620004645.png",
    ToggleOn = "https://github.com/gdfdfgd43w2/test/blob/main/%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B0%D0%B7%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F57_20260620004836.png?raw=true",
    ToggleOff = "https://raw.githubusercontent.com/gdfdfgd43w2/test/refs/heads/main/%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B0%D0%B7%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F57_20260620004811.png",
    Logo = "https://raw.githubusercontent.com/gdfdfgd43w2/test/refs/heads/main/%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B0%D0%B7%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F58_20260620004959.png",
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

    -- Кнопка-бургер (твоя картинка)
    local burger = Instance.new("ImageButton")
    burger.Size = UDim2.new(0, 60, 0, 60)
    burger.Position = UDim2.new(0, 10, 0, 10)
    burger.BackgroundTransparency = 1
    burger.Image = Images.Burger
    burger.Parent = gui

    -- Главное меню (твой фон)
    local mainFrame = Instance.new("ImageLabel")
    mainFrame.Size = UDim2.new(0, 400, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Image = Images.Background
    mainFrame.Visible = false
    mainFrame.Parent = gui

    -- Логотип (твоя картинка)
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 200, 0, 60)
    logo.Position = UDim2.new(0.5, -100, 0, 10)
    logo.BackgroundTransparency = 1
    logo.Image = Images.Logo
    logo.Parent = mainFrame

    -- Кнопка закрытия (твоя картинка)
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -50, 0, 10)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = Images.Close
    closeBtn.Parent = mainFrame

    -- Контейнер для переключателей
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -100)
    scroll.Position = UDim2.new(0, 10, 0, 80)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(200, 180, 255)
    scroll.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = scroll

    -- Функция создания переключателя
    local function createToggle(name, state, callback)
        local f = Instance.new("ImageLabel")
        f.Size = UDim2.new(0.95, 0, 0, 50)
        f.BackgroundTransparency = 1
        f.Parent = scroll

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 18
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = f

        local btn = Instance.new("ImageButton")
        btn.Size = UDim2.new(0, 80, 0, 40)
        btn.Position = UDim2.new(1, -90, 0.5, -20)
        btn.BackgroundTransparency = 1
        btn.Image = state and Images.ToggleOn or Images.ToggleOff
        btn.Parent = f

        local cur = state
        btn.MouseButton1Click:Connect(function()
            cur = not cur
            btn.Image = cur and Images.ToggleOn or Images.ToggleOff
            if callback then callback(cur) end
        end)

        return function(ns)
            if ns ~= nil then
                cur = ns
                btn.Image = cur and Images.ToggleOn or Images.ToggleOff
            end
        end
    end

    -- ===== ВСЕ ПЕРЕКЛЮЧАТЕЛИ =====
    createToggle("ESP Игроков", Settings.PlayerESP, function(v) Settings.PlayerESP = v end)
    createToggle("ESP Твистедов", Settings.TwistedESP, function(v) Settings.TwistedESP = v end)
    createToggle("ESP Генераторов", Settings.GeneratorESP, function(v) Settings.GeneratorESP = v end)
    createToggle("ESP Предметов", Settings.ItemESP, function(v) Settings.ItemESP = v end)
    createToggle("ESP Капсул", Settings.CapsuleESP, function(v) Settings.CapsuleESP = v end)
    createToggle("Авто-скиллчек", Settings.AutoSkillCheck, function(v) Settings.AutoSkillCheck = v end)
    createToggle("Автофарм", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
    createToggle("Авто-сбор", Settings.AutoCollect, function(v) Settings.AutoCollect = v end)
    createToggle("Авто-капсулы", Settings.AutoCapsule, function(v) Settings.AutoCapsule = v end)
    createToggle("Полная яркость", Settings.FullBright, function(v) Settings.FullBright = v end)
    createToggle("Ноклип", Settings.Noclip, function(v) Settings.Noclip = v end)

    -- Обновляем размер скролла
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    -- Открытие/закрытие
    burger.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)

    -- Перетаскивание меню
    local drag = false
    local dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
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

    print("✅ Твой кастомный GUI загружен! Нажми на бургер (≡), чтобы открыть меню.")
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

        if Settings.CapsuleESP then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:lower():match("capsule") or obj.Name:lower():match("pod")) then
                    if not obj:FindFirstChild("CapsuleESP") then
                        local clone = makeESP(Color3.fromRGB(255,0,255), "CapsuleESP")
                        clone.Adornee = obj
                        clone.Parent = obj
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

-- ================== АВТО-СБОР ПРЕДМЕТОВ ==================
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

-- ================== АВТО-СБОР КАПСУЛ ==================
task.spawn(function()
    while task.wait(0.3) do
        if not Settings.AutoCapsule then continue end
        local p = game.Players.LocalPlayer
        if not p or not p.Character then continue end
        local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart
        if not root then continue end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():match("capsule") or obj.Name:lower():match("pod")) then
                local pos = obj.PrimaryPart and obj.PrimaryPart.Position or obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("HumanoidRootPart").Position
                if pos and (root.Position - pos).Magnitude < 15 then
                    teleportTo(pos + Vector3.new(0,2,0))
                    task.wait(0.1)
                    interactWith(obj)
                    break
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
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
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
print("✅ Твой скрипт с кастомным GUI полностью загружен! Нажми на бургер (≡) в левом верхнем углу.")
