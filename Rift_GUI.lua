--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                       RIFT GUI LIBRARY                        ║
    ║              Modern Roblox UI Framework v1.0                  ║
    ║                                                               ║
    ║  Professional GUI library for Roblox with modern design,      ║
    ║  smooth animations, and comprehensive customization.         ║
    ║                                                               ║
    ║  GitHub: github.com/yourusername/rift-gui                    ║
    ║  Documentation: https://rift-gui.docs/                       ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Rift = {}
Rift.__index = Rift
Rift.Version = "1.0.0"

-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

-- Constants
local TITLE_BAR_HEIGHT = 45
local TAB_WIDTH = 120
local PADDING = 12
local CORNER_RADIUS = 8
local ANIMATION_SPEED = 0.25

-- Default Theme
local DefaultTheme = {
    Primary = Color3.fromRGB(50, 50, 50),
    Secondary = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 150, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(60, 60, 60),
    Background = Color3.fromRGB(25, 25, 25),
    Success = Color3.fromRGB(76, 175, 80),
    Warning = Color3.fromRGB(255, 152, 0),
    Error = Color3.fromRGB(244, 67, 54),
    Hover = Color3.fromRGB(60, 60, 60),
}

-- ============================================================================
-- Utility Functions
-- ============================================================================

local function Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function TweenObject(object, properties, duration)
    local tweenInfo = TweenInfo.new(
        duration or ANIMATION_SPEED,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = game:GetService("TweenService"):Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function AddCorner(instance, radius)
    local corner = Create("UICorner", {
        CornerRadius = UDim.new(0, radius or CORNER_RADIUS),
        Parent = instance
    })
    return corner
end

local function AddStroke(instance, color, thickness)
    local stroke = Create("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Parent = instance
    })
    return stroke
end

local function AddPadding(instance, padding)
    local pad = Create("UIPadding", {
        PaddingBottom = UDim.new(0, padding),
        PaddingLeft = UDim.new(0, padding),
        PaddingRight = UDim.new(0, padding),
        PaddingTop = UDim.new(0, padding),
        Parent = instance
    })
    return pad
end

-- ============================================================================
-- Window Class
-- ============================================================================

local Window = {}
Window.__index = Window

function Window.new(title, subtitle, icon, size, theme)
    local self = setmetatable({}, Window)
    
    self.Title = title or "Rift GUI"
    self.Subtitle = subtitle or ""
    self.Icon = icon
    self.Size = size or UDim2.new(0, 600, 0, 500)
    self.Theme = theme or DefaultTheme
    self.Dragging = false
    self.DragStart = nil
    self.Tabs = {}
    self.ActiveTab = nil
    self.Notifications = {}
    self.Config = {}
    
    -- Create main window container
    self.MainGui = Create("ScreenGui", {
        Name = "RiftGui_" .. self.Title,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    })
    
    -- Create main window frame
    self.Window = Create("Frame", {
        Name = "Window",
        Size = self.Size,
        Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2),
        BackgroundColor3 = self.Theme.Primary,
        BorderSizePixel = 0,
        Parent = self.MainGui
    })
    
    AddCorner(self.Window, CORNER_RADIUS)
    AddStroke(self.Window, self.Theme.Border, 1)
    
    -- Create title bar
    self.TitleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, TITLE_BAR_HEIGHT),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = self.Window
    })
    
    AddCorner(self.TitleBar, CORNER_RADIUS)
    
    -- Title text
    local titleText = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        TextWeight = Enum.FontWeight.Bold,
        Font = Enum.Font.GothamBold,
        Text = self.Title,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TitleBar
    })
    AddPadding(titleText, PADDING)
    
    -- Subtitle text
    if self.Subtitle ~= "" then
        local subtitleText = Create("TextLabel", {
            Name = "Subtitle",
            Size = UDim2.new(0.7, 0, 0.5, 0),
            Position = UDim2.new(0, PADDING, 0.5, 0),
            BackgroundTransparency = 1,
            TextColor3 = self.Theme.TextSecondary,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            Text = self.Subtitle,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.TitleBar
        })
    end
    
    -- Control buttons container
    local controlsContainer = Create("Frame", {
        Name = "Controls",
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.TitleBar
    })
    
    local controlLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        Parent = controlsContainer
    })
    AddPadding(controlsContainer, 8)
    
    -- Minimize button
    local minimizeBtn = Create("TextButton", {
        Name = "MinimizeBtn",
        Size = UDim2.new(0, 32, 0, 32),
        BackgroundColor3 = self.Theme.Hover,
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Text = "−",
        Parent = controlsContainer
    })
    AddCorner(minimizeBtn, 5)
    
    self.Minimized = false
    local function toggleMinimize()
        self.Minimized = not self.Minimized
        if self.Minimized then
            TweenObject(self.Window, {Size = UDim2.new(0, self.Size.X.Offset, 0, TITLE_BAR_HEIGHT)}, ANIMATION_SPEED)
        else
            TweenObject(self.Window, {Size = self.Size}, ANIMATION_SPEED)
        end
    end
    minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
    minimizeBtn.MouseEnter:Connect(function()
        TweenObject(minimizeBtn, {BackgroundColor3 = self.Theme.Accent}, 0.15)
    end)
    minimizeBtn.MouseLeave:Connect(function()
        TweenObject(minimizeBtn, {BackgroundColor3 = self.Theme.Hover}, 0.15)
    end)
    
    -- Close button
    local closeBtn = Create("TextButton", {
        Name = "CloseBtn",
        Size = UDim2.new(0, 32, 0, 32),
        BackgroundColor3 = self.Theme.Error,
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Text = "×",
        Parent = controlsContainer
    })
    AddCorner(closeBtn, 5)
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    closeBtn.MouseEnter:Connect(function()
        TweenObject(closeBtn, {BackgroundColor3 = Color3.fromRGB(200, 50, 40)}, 0.15)
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenObject(closeBtn, {BackgroundColor3 = self.Theme.Error}, 0.15)
    end)
    
    -- Create content container
    self.ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, 0, 1, -TITLE_BAR_HEIGHT),
        Position = UDim2.new(0, 0, 0, TITLE_BAR_HEIGHT),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = self.Window
    })
    
    -- Create tabs container
    self.TabsContainer = Create("Frame", {
        Name = "TabsContainer",
        Size = UDim2.new(0, TAB_WIDTH, 1, 0),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = self.ContentContainer
    })
    
    local tabLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 4),
        Parent = self.TabsContainer
    })
    AddPadding(self.TabsContainer, PADDING)
    
    -- Create content frame
    self.ContentFrame = Create("Frame", {
        Name = "ContentFrame",
        Size = UDim2.new(1, -TAB_WIDTH, 1, 0),
        Position = UDim2.new(0, TAB_WIDTH, 0, 0),
        BackgroundColor3 = self.Theme.Primary,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.ContentContainer
    })
    
    -- Make window draggable
    self:MakeDraggable()
    
    return self
end

function Window:MakeDraggable()
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragInput = input
            dragStart = input.Position
            startPos = self.Window.Position
            self.Dragging = true
        end
    end
    
    local function onInputChanged(input, gameProcessed)
        if input == dragInput then
            local delta = input.Position - dragStart
            self.Window.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end
    
    local function onInputEnded(input, gameProcessed)
        if input == dragInput then
            dragInput = nil
            self.Dragging = false
        end
    end
    
    self.TitleBar.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)
    UserInputService.InputEnded:Connect(onInputEnded)
end

-- ============================================================================
-- Tab Class
-- ============================================================================

local Tab = {}
Tab.__index = Tab

function Tab.new(window, name, icon, description)
    local self = setmetatable({}, Tab)
    
    self.Window = window
    self.Name = name or "Tab"
    self.Icon = icon or "📋"
    self.Description = description or ""
    self.Sections = {}
    self.Content = nil
    
    -- Create tab button
    self.Button = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = window.Theme.Secondary,
        TextColor3 = window.Theme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Text = self.Icon .. " " .. self.Name,
        TextWrapped = true,
        Parent = window.TabsContainer
    })
    AddCorner(self.Button, 5)
    
    -- Create content frame
    self.Content = Create("Frame", {
        Name = name .. "_Content",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ClipsDescendants = true,
        Parent = window.ContentFrame
    })
    
    local scrollFrame = Create("ScrollingFrame", {
        Name = "ScrollFrame",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
        CanvasSize = UDim2.new(1, 0, 0, 0),
        Parent = self.Content
    })
    
    local scrollLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, PADDING),
        Parent = scrollFrame
    })
    
    local scrollPadding = AddPadding(scrollFrame, PADDING)
    
    scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(1, 0, 0, scrollLayout.AbsoluteContentSize.Y + PADDING * 2)
    end)
    
    self.ScrollFrame = scrollFrame
    
    -- Tab button click
    self.Button.MouseButton1Click:Connect(function()
        window:SelectTab(self)
    end)
    
    -- Tab button hover effects
    self.Button.MouseEnter:Connect(function()
        if window.ActiveTab ~= self then
            TweenObject(self.Button, {BackgroundColor3 = window.Theme.Hover}, 0.15)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        if window.ActiveTab ~= self then
            TweenObject(self.Button, {BackgroundColor3 = window.Theme.Secondary}, 0.15)
        end
    end)
    
    table.insert(window.Tabs, self)
    
    -- Auto-select first tab
    if #window.Tabs == 1 then
        window:SelectTab(self)
    end
    
    return self
end

function Tab:AddSection(title, description)
    local section = Section.new(self, title, description)
    table.insert(self.Sections, section)
    return section
end

-- ============================================================================
-- Section Class
-- ============================================================================

local Section = {}
Section.__index = Section

function Section.new(tab, title, description)
    local self = setmetatable({}, Section)
    
    self.Tab = tab
    self.Title = title or "Section"
    self.Description = description or ""
    self.Elements = {}
    
    -- Create section container
    self.Container = Create("Frame", {
        Name = title,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = tab.ScrollFrame
    })
    
    local sectionLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 8),
        Parent = self.Container
    })
    
    AddPadding(self.Container, 8)
    
    -- Section header
    local header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = tab.Window.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = self.Container
    })
    AddCorner(header, 5)
    
    local headerText = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = tab.Window.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextWeight = Enum.FontWeight.Bold,
        Text = self.Title,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    AddPadding(headerText, PADDING)
    
    if self.Description ~= "" then
        local descText = Create("TextLabel", {
            Name = "Description",
            Size = UDim2.new(0.7, 0, 0.5, 0),
            Position = UDim2.new(0, PADDING, 0.5, 0),
            BackgroundTransparency = 1,
            TextColor3 = tab.Window.Theme.TextSecondary,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = header
        })
    end
    
    -- Content container
    self.ContentContainer = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.Container
    })
    
    local contentLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 8),
        Parent = self.ContentContainer
    })
    
    AddPadding(self.ContentContainer, 8)
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentContainer.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 16)
    end)
    
    sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 16)
    end)
    
    return self
end

-- ============================================================================
-- Component Classes
-- ============================================================================

local Button = {}
Button.__index = Button

function Button.new(section, name, description, callback)
    local self = setmetatable({}, Button)
    
    self.Section = section
    self.Name = name or "Button"
    self.Description = description or ""
    self.Callback = callback or function() end
    
    -- Create container
    self.Container = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = section.ContentContainer
    })
    
    local layout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 4),
        Parent = self.Container
    })
    
    AddPadding(self.Container, 0)
    
    -- Label
    if self.Name ~= "" then
        local label = Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Text = self.Name,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
    end
    
    -- Description
    if self.Description ~= "" then
        local desc = Create("TextLabel", {
            Name = "Description",
            Size = UDim2.new(1, 0, 0, 14),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.TextSecondary,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = self.Container
        })
    end
    
    -- Button
    self.Button = Create("TextButton", {
        Name = "Button",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = section.Tab.Window.Theme.Accent,
        TextColor3 = section.Tab.Window.Theme.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        Text = self.Name,
        Parent = self.Container
    })
    AddCorner(self.Button, 5)
    
    self.Button.MouseButton1Click:Connect(function()
        TweenObject(self.Button, {BackgroundColor3 = Color3.fromRGB(0, 180, 255)}, 0.1)
        task.wait(0.1)
        TweenObject(self.Button, {BackgroundColor3 = section.Tab.Window.Theme.Accent}, 0.1)
        self.Callback()
    end)
    
    self.Button.MouseEnter:Connect(function()
        TweenObject(self.Button, {BackgroundColor3 = Color3.fromRGB(30, 170, 255)}, 0.15)
    end)
    
    self.Button.MouseLeave:Connect(function()
        TweenObject(self.Button, {BackgroundColor3 = section.Tab.Window.Theme.Accent}, 0.15)
    end)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    table.insert(section.Elements, self)
    return self
end

-- ============================================================================
-- Toggle Class
-- ============================================================================

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(section, name, description, defaultValue, callback)
    local self = setmetatable({}, Toggle)
    
    self.Section = section
    self.Name = name or "Toggle"
    self.Description = description or ""
    self.Enabled = defaultValue or false
    self.Callback = callback or function() end
    
    -- Create container
    self.Container = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = section.ContentContainer
    })
    
    local layout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 4),
        Parent = self.Container
    })
    
    AddPadding(self.Container, 0)
    
    -- Header container
    local header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Parent = self.Container
    })
    
    local headerLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.SpaceBetween,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = header
    })
    
    -- Label
    local label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = section.Tab.Window.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Text = self.Name,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    -- Toggle switch
    self.Toggle = Create("Frame", {
        Name = "Toggle",
        Size = UDim2.new(0, 45, 0, 24),
        BackgroundColor3 = self.Enabled and section.Tab.Window.Theme.Success or section.Tab.Window.Theme.Hover,
        BorderSizePixel = 0,
        Parent = header
    })
    AddCorner(self.Toggle, 12)
    
    -- Toggle indicator
    self.Indicator = Create("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, self.Enabled and 23 or 2, 0.5, -10),
        BackgroundColor3 = section.Tab.Window.Theme.Text,
        BorderSizePixel = 0,
        Parent = self.Toggle
    })
    AddCorner(self.Indicator, 10)
    
    -- Toggle functionality
    local function updateToggle(newState)
        self.Enabled = newState
        local targetColor = self.Enabled and section.Tab.Window.Theme.Success or section.Tab.Window.Theme.Hover
        local targetPos = self.Enabled and 23 or 2
        TweenObject(self.Toggle, {BackgroundColor3 = targetColor}, 0.2)
        TweenObject(self.Indicator, {Position = UDim2.new(0, targetPos, 0.5, -10)}, 0.2)
        self.Callback(self.Enabled)
    end
    
    self.Toggle.MouseButton1Click:Connect(function()
        updateToggle(not self.Enabled)
    end)
    
    self.Toggle.MouseEnter:Connect(function()
        self.Toggle.BackgroundColor3 = self.Enabled and Color3.fromRGB(100, 200, 100) or section.Tab.Window.Theme.Hover
    end)
    
    self.Toggle.MouseLeave:Connect(function()
        self.Toggle.BackgroundColor3 = self.Enabled and section.Tab.Window.Theme.Success or section.Tab.Window.Theme.Hover
    end)
    
    -- Description
    if self.Description ~= "" then
        local desc = Create("TextLabel", {
            Name = "Description",
            Size = UDim2.new(1, 0, 0, 14),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.TextSecondary,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = self.Container
        })
    end
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    table.insert(section.Elements, self)
    return self
end

-- ============================================================================
-- Slider Class
-- ============================================================================

local Slider = {}
Slider.__index = Slider

function Slider.new(section, name, description, minValue, maxValue, increment, defaultValue, callback)
    local self = setmetatable({}, Slider)
    
    self.Section = section
    self.Name = name or "Slider"
    self.Description = description or ""
    self.Min = minValue or 0
    self.Max = maxValue or 100
    self.Increment = increment or 1
    self.Value = defaultValue or self.Min
    self.Callback = callback or function() end
    self.Dragging = false
    
    -- Create container
    self.Container = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = section.ContentContainer
    })
    
    local layout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 4),
        Parent = self.Container
    })
    
    AddPadding(self.Container, 0)
    
    -- Label and value
    local header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Parent = self.Container
    })
    
    local headerLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.SpaceBetween,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = header
    })
    
    local label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.6, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = section.Tab.Window.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Text = self.Name,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    self.ValueLabel = Create("TextLabel", {
        Name = "Value",
        Size = UDim2.new(0.3, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = section.Tab.Window.Theme.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Text = tostring(self.Value),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = header
    })
    
    -- Description
    if self.Description ~= "" then
        local desc = Create("TextLabel", {
            Name = "Description",
            Size = UDim2.new(1, 0, 0, 14),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.TextSecondary,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = self.Container
        })
    end
    
    -- Slider bar
    self.SliderBar = Create("Frame", {
        Name = "SliderBar",
        Size = UDim2.new(1, 0, 0, 8),
        BackgroundColor3 = section.Tab.Window.Theme.Hover,
        BorderSizePixel = 0,
        Parent = self.Container
    })
    AddCorner(self.SliderBar, 4)
    
    -- Filled portion
    self.SliderFill = Create("Frame", {
        Name = "Fill",
        Size = UDim2.new((self.Value - self.Min) / (self.Max - self.Min), 0, 1, 0),
        BackgroundColor3 = section.Tab.Window.Theme.Accent,
        BorderSizePixel = 0,
        Parent = self.SliderBar
    })
    AddCorner(self.SliderFill, 4)
    
    -- Slider button
    self.SliderButton = Create("TextButton", {
        Name = "Button",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new((self.Value - self.Min) / (self.Max - self.Min), -8, 0.5, -8),
        BackgroundColor3 = section.Tab.Window.Theme.Accent,
        Text = "",
        BorderSizePixel = 0,
        Parent = self.SliderBar
    })
    AddCorner(self.SliderButton, 8)
    
    -- Slider functionality
    local function updateSliderValue(position)
        local relativeX = math.clamp(position - self.SliderBar.AbsolutePosition.X, 0, self.SliderBar.AbsoluteSize.X)
        local percentage = relativeX / self.SliderBar.AbsoluteSize.X
        local newValue = self.Min + (self.Max - self.Min) * percentage
        newValue = math.floor((newValue / self.Increment) + 0.5) * self.Increment
        newValue = math.clamp(newValue, self.Min, self.Max)
        
        self.Value = newValue
        self.ValueLabel.Text = tostring(math.floor(self.Value * 100) / 100)
        
        local fillPercentage = (self.Value - self.Min) / (self.Max - self.Min)
        self.SliderFill.Size = UDim2.new(fillPercentage, 0, 1, 0)
        TweenObject(self.SliderButton, {
            Position = UDim2.new(fillPercentage, -8, 0.5, -8)
        }, 0.05)
        
        self.Callback(self.Value)
    end
    
    self.SliderButton.MouseButton1Down:Connect(function()
        self.Dragging = true
    end)
    
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSliderValue(input.Position.X)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)
    
    self.SliderBar.MouseButton1Click:Connect(function(x, y)
        updateSliderValue(x)
    end)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    table.insert(section.Elements, self)
    return self
end

-- ============================================================================
-- Dropdown Class
-- ============================================================================

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(section, name, description, options, defaultValue, callback)
    local self = setmetatable({}, Dropdown)
    
    self.Section = section
    self.Name = name or "Dropdown"
    self.Description = description or ""
    self.Options = options or {}
    self.SelectedValue = defaultValue or (self.Options[1] or "")
    self.Callback = callback or function() end
    self.Open = false
    
    -- Create container
    self.Container = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = section.ContentContainer
    })
    
    local layout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 4),
        Parent = self.Container
    })
    
    AddPadding(self.Container, 0)
    
    -- Label
    if self.Name ~= "" then
        local label = Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Text = self.Name,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
    end
    
    -- Description
    if self.Description ~= "" then
        local desc = Create("TextLabel", {
            Name = "Description",
            Size = UDim2.new(1, 0, 0, 14),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.TextSecondary,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = self.Container
        })
    end
    
    -- Dropdown button
    self.Button = Create("TextButton", {
        Name = "DropdownButton",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = section.Tab.Window.Theme.Secondary,
        TextColor3 = section.Tab.Window.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Text = self.SelectedValue .. " ▼",
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    AddCorner(self.Button, 5)
    local buttonPadding = AddPadding(self.Button, 12)
    
    -- Dropdown list container
    self.ListContainer = Create("Frame", {
        Name = "ListContainer",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = section.Tab.Window.Theme.Secondary,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        Parent = self.Container
    })
    AddCorner(self.ListContainer, 5)
    
    local listLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 2),
        Parent = self.ListContainer
    })
    AddPadding(self.ListContainer, 6)
    
    -- Create options
    local function createOptions()
        for _, child in ipairs(self.ListContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        for _, option in ipairs(self.Options) do
            local optionBtn = Create("TextButton", {
                Name = option,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = self.SelectedValue == option and section.Tab.Window.Theme.Accent or section.Tab.Window.Theme.Secondary,
                TextColor3 = section.Tab.Window.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                Text = option,
                Parent = self.ListContainer
            })
            AddCorner(optionBtn, 4)
            
            optionBtn.MouseButton1Click:Connect(function()
                self.SelectedValue = option
                self.Button.Text = option .. " ▼"
                self:SetOpen(false)
                
                -- Update option colors
                for _, child in ipairs(self.ListContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = (child.Name == option) and section.Tab.Window.Theme.Accent or section.Tab.Window.Theme.Secondary
                    end
                end
                
                self.Callback(option)
            end)
            
            optionBtn.MouseEnter:Connect(function()
                if self.SelectedValue ~= option then
                    TweenObject(optionBtn, {BackgroundColor3 = section.Tab.Window.Theme.Hover}, 0.15)
                end
            end)
            
            optionBtn.MouseLeave:Connect(function()
                if self.SelectedValue ~= option then
                    TweenObject(optionBtn, {BackgroundColor3 = section.Tab.Window.Theme.Secondary}, 0.15)
                end
            end)
        end
        
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            self.ListContainer.Size = UDim2.new(1, 0, 0, math.min(listLayout.AbsoluteContentSize.Y + 12, 200))
        end)
    end
    
    createOptions()
    
    -- Toggle dropdown
    function self:SetOpen(isOpen)
        self.Open = isOpen
        self.ListContainer.Visible = isOpen
        if isOpen then
            TweenObject(self.Button, {BackgroundColor3 = section.Tab.Window.Theme.Hover}, 0.15)
        else
            TweenObject(self.Button, {BackgroundColor3 = section.Tab.Window.Theme.Secondary}, 0.15)
        end
    end
    
    self.Button.MouseButton1Click:Connect(function()
        self:SetOpen(not self.Open)
    end)
    
    self.Button.MouseEnter:Connect(function()
        if not self.Open then
            TweenObject(self.Button, {BackgroundColor3 = section.Tab.Window.Theme.Hover}, 0.15)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        if not self.Open then
            TweenObject(self.Button, {BackgroundColor3 = section.Tab.Window.Theme.Secondary}, 0.15)
        end
    end)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    table.insert(section.Elements, self)
    return self
end

-- ============================================================================
-- Textbox Class
-- ============================================================================

local Textbox = {}
Textbox.__index = Textbox

function Textbox.new(section, name, placeholder, defaultText, callback)
    local self = setmetatable({}, Textbox)
    
    self.Section = section
    self.Name = name or "Textbox"
    self.Placeholder = placeholder or "Enter text..."
    self.Text = defaultText or ""
    self.Callback = callback or function() end
    
    -- Create container
    self.Container = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = section.ContentContainer
    })
    
    local layout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 4),
        Parent = self.Container
    })
    
    AddPadding(self.Container, 0)
    
    -- Label
    if self.Name ~= "" then
        local label = Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Text = self.Name,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
    end
    
    -- Textbox
    self.TextBox = Create("TextBox", {
        Name = "TextBox",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = section.Tab.Window.Theme.Secondary,
        TextColor3 = section.Tab.Window.Theme.Text,
        PlaceholderColor3 = section.Tab.Window.Theme.TextSecondary,
        PlaceholderText = self.Placeholder,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Text = self.Text,
        ClearTextOnFocus = false,
        Parent = self.Container
    })
    AddCorner(self.TextBox, 5)
    local padding = AddPadding(self.TextBox, PADDING)
    
    self.TextBox.Focused:Connect(function()
        TweenObject(self.TextBox, {BackgroundColor3 = section.Tab.Window.Theme.Hover}, 0.15)
        AddStroke(self.TextBox, section.Tab.Window.Theme.Accent, 2)
    end)
    
    self.TextBox.FocusLost:Connect(function(enterPressed)
        self.Text = self.TextBox.Text
        TweenObject(self.TextBox, {BackgroundColor3 = section.Tab.Window.Theme.Secondary}, 0.15)
        if self.TextBox:FindFirstChild("UIStroke") then
            self.TextBox:FindFirstChild("UIStroke"):Destroy()
        end
        if enterPressed then
            self.Callback(self.Text)
        end
    end)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    table.insert(section.Elements, self)
    return self
end

-- ============================================================================
-- Label Class
-- ============================================================================

local Label = {}
Label.__index = Label

function Label.new(section, text)
    local self = setmetatable({}, Label)
    
    self.Section = section
    self.Text = text or ""
    
    -- Create label
    self.Label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = section.Tab.Window.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Text = self.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = section.ContentContainer
    })
    
    task.wait() -- Wait for size to calculate
    local textSize = game:GetService("TextService"):GetTextSize(
        self.Text,
        12,
        Enum.Font.Gotham,
        Vector2.new(section.ContentContainer.AbsoluteSize.X - 32, 1000)
    )
    
    self.Label.Size = UDim2.new(1, 0, 0, textSize.Y + 4)
    
    table.insert(section.Elements, self)
    return self
end

-- ============================================================================
-- Paragraph Class
-- ============================================================================

local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(section, title, text)
    local self = setmetatable({}, Paragraph)
    
    self.Section = section
    self.Title = title or ""
    self.Text = text or ""
    
    -- Create container
    self.Container = Create("Frame", {
        Name = title,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = section.Tab.Window.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = section.ContentContainer
    })
    AddCorner(self.Container, 5)
    
    local layout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 4),
        Parent = self.Container
    })
    AddPadding(self.Container, PADDING)
    
    -- Title
    if self.Title ~= "" then
        local titleLabel = Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            TextWeight = Enum.FontWeight.Bold,
            Text = self.Title,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
    end
    
    -- Content text
    local contentLabel = Create("TextLabel", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = section.Tab.Window.Theme.TextSecondary,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        Text = self.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = self.Container
    })
    
    task.wait()
    local textSize = game:GetService("TextService"):GetTextSize(
        self.Text,
        11,
        Enum.Font.Gotham,
        Vector2.new(self.Container.AbsoluteSize.X - 32, 1000)
    )
    
    contentLabel.Size = UDim2.new(1, 0, 0, textSize.Y)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 16)
    end)
    
    table.insert(section.Elements, self)
    return self
end

-- ============================================================================
-- Color Picker Class
-- ============================================================================

local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(section, name, description, defaultColor, callback)
    local self = setmetatable({}, ColorPicker)
    
    self.Section = section
    self.Name = name or "Color"
    self.Description = description or ""
    self.Color = defaultColor or Color3.fromRGB(0, 150, 255)
    self.Callback = callback or function() end
    
    -- Create container
    self.Container = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = section.ContentContainer
    })
    
    local layout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 4),
        Parent = self.Container
    })
    
    AddPadding(self.Container, 0)
    
    -- Label
    if self.Name ~= "" then
        local label = Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Text = self.Name,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
    end
    
    -- Description
    if self.Description ~= "" then
        local desc = Create("TextLabel", {
            Name = "Description",
            Size = UDim2.new(1, 0, 0, 14),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.TextSecondary,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = self.Container
        })
    end
    
    -- Color display
    self.ColorDisplay = Create("Frame", {
        Name = "ColorDisplay",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Color,
        BorderSizePixel = 0,
        Parent = self.Container
    })
    AddCorner(self.ColorDisplay, 5)
    AddStroke(self.ColorDisplay, section.Tab.Window.Theme.Border, 1)
    
    -- Hex label
    local function updateHexLabel()
        local r, g, b = math.floor(self.Color.R * 255), math.floor(self.Color.G * 255), math.floor(self.Color.B * 255)
        local hexText = Create("TextLabel", {
            Name = "HexText",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Text = string.format("#%02X%02X%02X", r, g, b),
            Parent = self.ColorDisplay
        })
        return hexText
    end
    
    updateHexLabel()
    
    self.ColorDisplay.MouseButton1Click:Connect(function()
        -- Simple color picker - opens system color picker if available
        self.Callback(self.Color)
    end)
    
    self.ColorDisplay.MouseEnter:Connect(function()
        TweenObject(self.ColorDisplay, {BackgroundColor3 = Color3.new(
            math.min(self.Color.R + 0.1, 1),
            math.min(self.Color.G + 0.1, 1),
            math.min(self.Color.B + 0.1, 1)
        )}, 0.15)
    end)
    
    self.ColorDisplay.MouseLeave:Connect(function()
        TweenObject(self.ColorDisplay, {BackgroundColor3 = self.Color}, 0.15)
    end)
    
    -- Set color method
    function self:SetColor(newColor)
        self.Color = newColor
        self.ColorDisplay.BackgroundColor3 = newColor
        for _, child in ipairs(self.ColorDisplay:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        updateHexLabel()
    end
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    table.insert(section.Elements, self)
    return self
end

-- ============================================================================
-- Keybind Class
-- ============================================================================

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(section, name, description, defaultKey, callback)
    local self = setmetatable({}, Keybind)
    
    self.Section = section
    self.Name = name or "Keybind"
    self.Description = description or ""
    self.Key = defaultKey or Enum.KeyCode.F1
    self.Callback = callback or function() end
    self.Binding = false
    
    -- Create container
    self.Container = Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = section.ContentContainer
    })
    
    local layout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Fill,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 4),
        Parent = self.Container
    })
    
    AddPadding(self.Container, 0)
    
    -- Label
    if self.Name ~= "" then
        local label = Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Text = self.Name,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
    end
    
    -- Description
    if self.Description ~= "" then
        local desc = Create("TextLabel", {
            Name = "Description",
            Size = UDim2.new(1, 0, 0, 14),
            BackgroundTransparency = 1,
            TextColor3 = section.Tab.Window.Theme.TextSecondary,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Text = self.Description,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = self.Container
        })
    end
    
    -- Keybind button
    self.Button = Create("TextButton", {
        Name = "KeybindButton",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = section.Tab.Window.Theme.Secondary,
        TextColor3 = section.Tab.Window.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Text = self.Key.Name,
        Parent = self.Container
    })
    AddCorner(self.Button, 5)
    
    self.Button.MouseButton1Click:Connect(function()
        self.Binding = true
        self.Button.Text = "Press a key..."
        self.Button.BackgroundColor3 = section.Tab.Window.Theme.Warning
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                self.Key = input.KeyCode
                self.Button.Text = self.Key.Name
                self.Button.BackgroundColor3 = section.Tab.Window.Theme.Secondary
                self.Binding = false
                connection:Disconnect()
            end
        end)
    end)
    
    self.Button.MouseEnter:Connect(function()
        if not self.Binding then
            TweenObject(self.Button, {BackgroundColor3 = section.Tab.Window.Theme.Hover}, 0.15)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        if not self.Binding then
            TweenObject(self.Button, {BackgroundColor3 = section.Tab.Window.Theme.Secondary}, 0.15)
        end
    end)
    
    -- Global keybind listener
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or self.Binding then return end
        if input.KeyCode == self.Key then
            self.Callback()
        end
    end)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    table.insert(section.Elements, self)
    return self
end

-- ============================================================================
-- Notification Class
-- ============================================================================

local Notification = {}
Notification.__index = Notification

function Notification.new(window, title, description, notificationType, duration)
    local self = setmetatable({}, Notification)
    
    self.Window = window
    self.Title = title or "Notification"
    self.Description = description or ""
    self.Type = notificationType or "Info"
    self.Duration = duration or 3
    
    -- Determine color based on type
    local notificationColor = window.Theme.Accent
    if self.Type == "Success" then
        notificationColor = window.Theme.Success
    elseif self.Type == "Warning" then
        notificationColor = window.Theme.Warning
    elseif self.Type == "Error" then
        notificationColor = window.Theme.Error
    end
    
    -- Create notification container
    self.Container = Create("Frame", {
        Name = self.Title,
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, 10, 1, -100),
        BackgroundColor3 = window.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = window.MainGui
    })
    AddCorner(self.Container, 8)
    AddStroke(self.Container, notificationColor, 2)
    
    -- Title
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        TextColor3 = window.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Text = self.Title,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    AddPadding(titleLabel, PADDING)
    
    -- Description
    local descLabel = Create("TextLabel", {
        Name = "Description",
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundTransparency = 1,
        TextColor3 = window.Theme.TextSecondary,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        Text = self.Description,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = self.Container
    })
    AddPadding(descLabel, PADDING)
    
    -- Animation in
    self.Container.Position = UDim2.new(1, 10, 1, -100)
    TweenObject(self.Container, {
        Position = UDim2.new(1, -320, 1, -100)
    }, 0.3)
    
    -- Auto disappear
    task.wait(self.Duration)
    TweenObject(self.Container, {
        Position = UDim2.new(1, 10, 1, -100)
    }, 0.3)
    task.wait(0.3)
    self.Container:Destroy()
    
    table.insert(window.Notifications, self)
    return self
end

-- ============================================================================
-- Window Methods
-- ============================================================================

function Window:SelectTab(tab)
    if self.ActiveTab then
        self.ActiveTab.Content.Visible = false
        TweenObject(self.ActiveTab.Button, {
            BackgroundColor3 = self.Theme.Secondary,
            TextColor3 = self.Theme.TextSecondary
        }, 0.15)
    end
    
    self.ActiveTab = tab
    tab.Content.Visible = true
    TweenObject(tab.Button, {
        BackgroundColor3 = self.Theme.Accent,
        TextColor3 = self.Theme.Text
    }, 0.15)
end

function Window:Notify(title, description, notificationType, duration)
    return Notification.new(self, title, description, notificationType, duration)
end

function Window:SetTheme(newTheme)
    self.Theme = newTheme or DefaultTheme
    -- Note: Full theme application would require updating all children
    -- This is a simplified version
    self.Window.BackgroundColor3 = self.Theme.Primary
    self.TitleBar.BackgroundColor3 = self.Theme.Secondary
    self.ContentFrame.BackgroundColor3 = self.Theme.Primary
    self.TabsContainer.BackgroundColor3 = self.Theme.Secondary
end

function Window:SaveConfig(configName)
    local config = {
        WindowSize = self.Window.Size,
        WindowPosition = self.Window.Position,
        Tabs = {}
    }
    
    for _, tab in ipairs(self.Tabs) do
        local tabConfig = {
            Name = tab.Name,
            Sections = {}
        }
        
        for _, section in ipairs(tab.Sections) do
            local sectionConfig = {
                Title = section.Title,
                Elements = {}
            }
            
            for _, element in ipairs(section.Elements) do
                if element.Enabled ~= nil then
                    table.insert(sectionConfig.Elements, {Type = "Toggle", Value = element.Enabled, Name = element.Name})
                elseif element.Value ~= nil then
                    table.insert(sectionConfig.Elements, {Type = "Slider", Value = element.Value, Name = element.Name})
                elseif element.SelectedValue ~= nil then
                    table.insert(sectionConfig.Elements, {Type = "Dropdown", Value = element.SelectedValue, Name = element.Name})
                elseif element.Text ~= nil then
                    table.insert(sectionConfig.Elements, {Type = "Textbox", Value = element.Text, Name = element.Name})
                end
            end
            
            table.insert(tabConfig.Sections, sectionConfig)
        end
        
        table.insert(config.Tabs, tabConfig)
    end
    
    self.Config = config
    return config
end

function Window:LoadConfig(config)
    -- This would load previously saved configuration
    if config.WindowSize then
        self.Window.Size = config.WindowSize
    end
    if config.WindowPosition then
        self.Window.Position = config.WindowPosition
    end
end

function Window:Destroy()
    self.MainGui:Destroy()
end

-- ============================================================================
-- Export Classes
-- ============================================================================

Rift.Window = Window
Rift.Tab = Tab
Rift.Section = Section
Rift.Button = Button
Rift.Toggle = Toggle
Rift.Slider = Slider
Rift.Dropdown = Dropdown
Rift.Textbox = Textbox
Rift.Label = Label
Rift.Paragraph = Paragraph
Rift.ColorPicker = ColorPicker
Rift.Keybind = Keybind
Rift.Notification = Notification
Rift.DefaultTheme = DefaultTheme

return Rift
