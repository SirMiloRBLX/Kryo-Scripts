--// Roblox UI Library (De-Minified & Readable) //-- 

local UILibrary = {
    windowCount = 0,
    flags = {}
}

-- Service shortcut table
local Services = {}
setmetatable(Services, {
    __index = function(_, serviceName)
        return game:GetService(serviceName)
    end,
    __newindex = function() return end
})

-- Variables
local currentDraggingObject
local mouse = Services.Players.LocalPlayer:GetMouse()

-- Dragging Function
function Drag(frame, dragHandle)
    if currentDraggingObject then
        currentDraggingObject.ZIndex = -2
    end
    currentDraggingObject = frame
    currentDraggingObject.ZIndex = -1

    dragHandle = dragHandle or frame

    local dragging, dragInput, startPos, startFramePos

    local function update(input)
        local delta = input.Position - startPos
        frame.Position = UDim2.new(
            startFramePos.X.Scale, startFramePos.X.Offset + delta.X,
            startFramePos.Y.Scale, startFramePos.Y.Offset + delta.Y
        )
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position
            startFramePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    Services.UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Ripple Click Effect
function ClickEffect(parent)
    task.spawn(function()
        if parent.ClipsDescendants ~= true then
            parent.ClipsDescendants = true
        end

        local ripple = Instance.new("ImageLabel")
        ripple.Name = "Ripple"
        ripple.Parent = parent
        ripple.BackgroundTransparency = 1
        ripple.ZIndex = 8
        ripple.Image = "rbxassetid://2708891598"
        ripple.ImageTransparency = 0.8
        ripple.ScaleType = Enum.ScaleType.Fit
        ripple.ImageColor3 = Color3.fromRGB(131, 132, 255)
        ripple.Position = UDim2.new(
            (mouse.X - ripple.AbsolutePosition.X) / parent.AbsoluteSize.X, 0,
            (mouse.Y - ripple.AbsolutePosition.Y) / parent.AbsoluteSize.Y, 0
        )

        Services.TweenService:Create(
            ripple,
            TweenInfo.new(1),
            { Position = UDim2.new(-5.5, 0, -5.5, 0), Size = UDim2.new(12, 0, 12, 0) }
        ):Play()

        task.wait(0.25)
        Services.TweenService:Create(ripple, TweenInfo.new(0.5), { ImageTransparency = 1 }):Play()

        repeat task.wait() until ripple.ImageTransparency == 1
        ripple:Destroy()
    end)
end

-- Main ScreenGui
local mainGui = Instance.new("ScreenGui")
mainGui.Name = Services.HttpService:GenerateGUID()
mainGui.Parent = Services.RunService:IsStudio() and Services.Players.LocalPlayer:WaitForChild("PlayerGui") or Services.CoreGui

-- Toggle GUI with LeftShift
Services.UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.LeftShift and not processed then
        mainGui.Enabled = not mainGui.Enabled
    end
end)

-- Window Creation
function UILibrary:Window(title)
    self.windowCount += 1

    -- Main window frame (header)
    local windowTop = Instance.new("Frame")
    windowTop.Name = "Top"
    windowTop.Parent = mainGui
    windowTop.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
    windowTop.BorderSizePixel = 0
    windowTop.Size = UDim2.new(0, 212, 0, 36)
    windowTop.Position = UDim2.new(0, 25, 0, -30 + 36 * self.windowCount + 6 * self.windowCount)
    Drag(windowTop)

    -- Window line (with gradient)
    local windowLine = Instance.new("Frame")
    windowLine.Name = "WindowLine"
    windowLine.Parent = windowTop
    windowLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    windowLine.BorderSizePixel = 0
    windowLine.Position = UDim2.new(0, 0, 0, 34)
    windowLine.Size = UDim2.new(0, 212, 0, 2)

    local gradient = Instance.new("UIGradient")
    gradient.Name = "WindowLineGradient"
    gradient.Parent = windowLine
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(43, 43, 43)),
        ColorSequenceKeypoint.new(0.20, Color3.fromRGB(43, 43, 43)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(131, 132, 255)),
        ColorSequenceKeypoint.new(0.80, Color3.fromRGB(43, 43, 43)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(43, 43, 43))
    })

    -- Header text
    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.Parent = windowTop
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(0, 54, 0, 34)
    header.Font = Enum.Font.GothamSemibold
    header.Text = "   " .. tostring(title or "")
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 14
    header.TextXAlignment = Enum.TextXAlignment.Left

    -- Expand/Collapse Button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "WindowToggle"
    toggleButton.Parent = windowTop
    toggleButton.BackgroundTransparency = 1
    toggleButton.Size = UDim2.new(0, 34, 0, 34)
    toggleButton.Position = UDim2.new(0.835, 0, 0, 0)

    local toggleImage = Instance.new("ImageLabel")
    toggleImage.Name = "WindowToggleImg"
    toggleImage.Parent = toggleButton
    toggleImage.AnchorPoint = Vector2.new(0.5, 0.5)
    toggleImage.BackgroundTransparency = 1
    toggleImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    toggleImage.Size = UDim2.new(0, 18, 0, 18)
    toggleImage.Image = "rbxassetid://3926305904"
    toggleImage.ImageRectOffset = Vector2.new(524, 764)
    toggleImage.ImageRectSize = Vector2.new(36, 36)
    toggleImage.Rotation = 180

    -- Bottom container for elements
    local bottom = Instance.new("Frame")
    bottom.Name = "Bottom"
    bottom.Parent = windowTop
    bottom.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    bottom.ClipsDescendants = true
    bottom.BorderSizePixel = 0
    bottom.Position = UDim2.new(0, 0, 1, 0)
    bottom.Size = UDim2.new(0, 212, 0, 0)

    local layout = Instance.new("UIListLayout")
    layout.Parent = bottom
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)

    -- Window expand / collapse logic
    local expanded = false
    local animating = false

    local function toggleWindow()
        if animating then return end
        expanded = not expanded
        animating = true

        Services.TweenService:Create(
            bottom,
            TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            { Size = UDim2.new(0, 212, 0, expanded and layout.AbsoluteContentSize.Y + 4 or 0) }
        ):Play()

        Services.TweenService:Create(
            toggleImage,
            TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            { Rotation = expanded and 0 or 180 }
        ):Play()

        task.wait(0.25)
        animating = false
    end

    toggleButton.MouseButton1Click:Connect(toggleWindow)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if expanded then
            bottom.Size = UDim2.new(0, 212, 0, layout.AbsoluteContentSize.Y + 4)
        end
    end)

    -- Elements API
    local Elements = {}

    -- Label
    function Elements:Label(text)
        local lbl = Instance.new("TextButton")
        lbl.Name = "Label"
        lbl.Parent = bottom
        lbl.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
        lbl.BorderSizePixel = 0
        lbl.Size = UDim2.new(0, 203, 0, 26)
        lbl.Font = Enum.Font.GothamSemibold
        lbl.Text = tostring(text or "")
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextSize = 14
        lbl.AutoButtonColor = false
        return lbl
    end

    -- Button
    function Elements:Button(text, callback)
        callback = callback or function() end

        local container = Instance.new("Frame")
        container.Name = "ButtonObj"
        container.Parent = bottom
        container.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
        container.BorderSizePixel = 0
        container.Size = UDim2.new(0, 203, 0, 36)

        local btn = Instance.new("TextButton")
        btn.Name = "Button"
        btn.Parent = container
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(0, 203, 0, 36)
        btn.Font = Enum.Font.Gotham
        btn.Text = "  " .. tostring(text or "")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left

        btn.MouseEnter:Connect(function()
            Services.TweenService:Create(container, TweenInfo.new(0.25), { BackgroundColor3 = Color3.fromRGB(55, 55, 55) }):Play()
        end)
        btn.MouseLeave:Connect(function()
            Services.TweenService:Create(container, TweenInfo.new(0.25), { BackgroundColor3 = Color3.fromRGB(43, 43, 43) }):Play()
        end)
        btn.MouseButton1Click:Connect(function()
            ClickEffect(btn)
            callback()
        end)
    end

    -- Toggle
    function Elements:Toggle(name, flagName, default, callback, flagsTable)
        flagsTable = flagsTable or UILibrary.flags
        flagName = flagName or Services.HttpService:GenerateGUID()
        callback = callback or function() end
        default = default or false
        flagsTable[flagName] = default

        local container = Instance.new("Frame")
        container.Name = "ToggleObj"
        container.Parent = bottom
        container.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
        container.Size = UDim2.new(0, 203, 0, 36)
        container.BorderSizePixel = 0

        local btn = Instance.new("TextButton")
        btn.Name = "ToggleText"
        btn.Parent = container
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(0, 203, 0, 36)
        btn.Font = Enum.Font.Gotham
        btn.Text = "  " .. tostring(name or "")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left

        local status = Instance.new("Frame")
        status.Name = "ToggleStatus"
        status.Parent = container
        status.AnchorPoint = Vector2.new(0, 0.5)
        status.Position = UDim2.new(0.85, 0, 0.5, 0)
        status.Size = UDim2.new(0, 24, 0, 24)
        status.BorderSizePixel = 0
        status.BackgroundColor3 = default and Color3.fromRGB(14, 255, 110) or Color3.fromRGB(255, 44, 44)

        local round = Instance.new("UICorner")
        round.CornerRadius = UDim.new(0, 4)
        round.Parent = status

        btn.MouseButton1Click:Connect(function()
            flagsTable[flagName] = not flagsTable[flagName]
            Services.TweenService:Create(status, TweenInfo.new(0.25), {
                BackgroundColor3 = flagsTable[flagName] and Color3.fromRGB(14, 255, 110) or Color3.fromRGB(255, 44, 44)
            }):Play()
            ClickEffect(btn)
            callback(flagsTable[flagName])
        end)
    end

    -- Slider
    function Elements:Slider(name, flagName, min, max, callback, default, flagsTable)
        min, max = min or 0, max or 100
        flagsTable = flagsTable or UILibrary.flags
        flagName = flagName or Services.HttpService:GenerateGUID()
        callback = callback or function() end
        default = default or min
        flagsTable[flagName] = default

        local container = Instance.new("Frame")
        container.Name = "SliderObj"
        container.Parent = bottom
        container.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
        container.Size = UDim2.new(0, 203, 0, 36)
        container.BorderSizePixel = 0

        local label = Instance.new("TextButton")
        label.Name = "SliderText"
        label.Parent = container
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 203, 0, 36)
        label.Font = Enum.Font.Gotham
        label.Text = "  " .. tostring(name or "")
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left

        local back = Instance.new("Frame")
        back.Name = "SliderBack"
        back.Parent = container
        back.Position = UDim2.new(0.57, 0, 0.68, 0)
        back.Size = UDim2.new(0, 80, 0, 7)
        back.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        back.BorderSizePixel = 0

        local backRound = Instance.new("UICorner")
        backRound.CornerRadius = UDim.new(0, 4)
        backRound.Parent = back

        local fill = Instance.new("Frame")
        fill.Name = "SliderPart"
        fill.Parent = back
        fill.BackgroundColor3 = Color3.fromRGB(131, 133, 255)
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BorderSizePixel = 0

        local fillRound = Instance.new("UICorner")
        fillRound.CornerRadius = UDim.new(0, 4)
        fillRound.Parent = fill

        local valueLbl = Instance.new("TextLabel")
        valueLbl.Name = "SliderValue"
        valueLbl.Parent = container
        valueLbl.BackgroundTransparency = 1
        valueLbl.Position = UDim2.new(0.57, 0, 0.15, 0)
        valueLbl.Size = UDim2.new(0, 80, 0, 16)
        valueLbl.Font = Enum.Font.Code
        valueLbl.Text = tostring(default)
        valueLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLbl.TextSize = 14

        local dragging = false

        local function update(input)
            local percent = math.clamp((input.Position.X - back.AbsolutePosition.X) / back.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(percent * (max - min) + min)
            valueLbl.Text = tostring(val)
            flagsTable[flagName] = val
            callback(val)
        end

        label.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                update(input)
                Services.TweenService:Create(fill, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }):Play()
            end
        end)

        label.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                Services.TweenService:Create(fill, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(131, 133, 255) }):Play()
            end
        end)

        Services.UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(input)
            end
        end)
    end

    return Elements
end

return UILibrary
