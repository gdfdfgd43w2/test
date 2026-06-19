--[[
    Dandy's World Custom GUI v2 (исправлены ссылки)
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

-- ================== ПРАВИЛЬНЫЕ ССЫЛКИ (raw) ==================
local Images = {
    Background = "https://raw.githubusercontent.com/gdfdfgd43w2/test/refs/heads/main/%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B0%D0%B7%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F59_20260620005128.png",
    Burger = "https://raw.githubusercontent.com/gdfdfgd43w2/test/refs/heads/main/%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B0%D0%B7%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F55_20260620004602.png",
    Close = "https://raw.githubusercontent.com/gdfdfgd43w2/test/refs/heads/main/%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B0%D0%B7%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F56_20260620004645.png",
    ToggleOn = "https://raw.githubusercontent.com/gdfdfgd43w2/test/refs/heads/main/%D0%91%D0%B5%D0%B7%20%D0%BD%D0%B0%D0%B7%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F57_20260620004836.png",
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

    -- Кнопка-бургер
    local burger = Instance.new("ImageButton")
    burger.Size = UDim2.new(0, 60, 0, 60)
    burger.Position = UDim2.new(0, 10, 0, 10)
    burger.BackgroundTransparency = 1
    burger.Image = Images.Burger
    burger.Parent = gui

    -- Главное меню
    local mainFrame = Instance.new("ImageLabel")
    mainFrame.Size = UDim2.new(0, 400, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Image = Images.Background
    mainFrame.Visible = false
    mainFrame.Parent = gui

    -- Логотип
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 200, 0, 60)
    logo.Position = UDim2.new(0.5, -100, 0, 10)
    logo.BackgroundTransparency = 1
    logo.Image = Images.Logo
    logo.Parent = mainFrame

    -- Кнопка закрытия
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

    -- Все переключатели
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

    -- Обновление размера скролла
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

    -- Перетаскивание
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

    print("✅ GUI с картинками загружен. Нажми на бургер.")
end

-- ================== ESP, автофарм и остальные функции ==================
-- (они такие же, как в прошлом скрипте, но я их здесь не повторяю, чтобы не было дублирования)
-- Вставь их сюда из предыдущей версии.

-- ================== ЗАПУСК ==================
createUI()
-- setupESP() -- если нужно
print("✅ Исправленный скрипт загружен. Теперь картинки должны отображаться.")
