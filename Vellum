--[[
	Vellum — Modern Roblox UI library (Rayfield-inspired)
	Self-contained single file for loadstring + HttpGet hosting.
	Luau 5.1 / Roblox compatible.
]]

local Vellum = {}
Vellum.Version = "1.0.0"
Vellum.Themes = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local function safeGetHui()
	local ok, result = pcall(function()
		if gethui then
			return gethui()
		end
		return nil
	end)
	if ok and result then
		return result
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local function hasExecutorFilesystem()
	return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
end

local function jsonEncode(value)
	local ok, res = pcall(function()
		return HttpService:JSONEncode(value)
	end)
	if ok then
		return res
	end
	return "{}"
end

local function jsonDecode(str)
	local ok, res = pcall(function()
		return HttpService:JSONDecode(str)
	end)
	if ok then
		return res
	end
	return nil
end

local function shallowCopy(t)
	local out = {}
	for k, v in pairs(t or {}) do
		out[k] = v
	end
	return out
end

local function merge(a, b)
	local out = shallowCopy(a)
	for k, v in pairs(b or {}) do
		out[k] = v
	end
	return out
end

local function color3ToTable(c)
	return { R = math.floor(c.R * 255 + 0.5), G = math.floor(c.G * 255 + 0.5), B = math.floor(c.B * 255 + 0.5) }
end

local function tableToColor3(t)
	if type(t) ~= "table" then
		return Color3.fromRGB(255, 255, 255)
	end
	return Color3.fromRGB(tonumber(t.R) or 255, tonumber(t.G) or 255, tonumber(t.B) or 255)
end

local function parseColor3(v)
	if typeof(v) == "Color3" then
		return v
	end
	if type(v) == "table" and v.R then
		return tableToColor3(v)
	end
	if type(v) == "string" then
		local ok, c = pcall(function()
			return Color3.fromHex(v)
		end)
		if ok then
			return c
		end
	end
	return Color3.fromRGB(240, 240, 245)
end

local function tween(inst, ti, props)
	local tw = TweenService:Create(inst, ti, props)
	tw:Play()
	return tw
end

local defaultTheme = {
	Name = "Vellum Default",
	Background = Color3.fromRGB(18, 18, 22),
	Surface = Color3.fromRGB(26, 26, 32),
	SurfaceElevated = Color3.fromRGB(34, 34, 42),
	Stroke = Color3.fromRGB(52, 52, 64),
	TitleBar = Color3.fromRGB(22, 22, 28),
	Accent = Color3.fromRGB(99, 102, 241),
	AccentMuted = Color3.fromRGB(79, 82, 220),
	Text = Color3.fromRGB(244, 244, 250),
	TextMuted = Color3.fromRGB(160, 160, 176),
	Success = Color3.fromRGB(52, 211, 153),
	Danger = Color3.fromRGB(248, 113, 113),
	Warning = Color3.fromRGB(251, 191, 36),
	TabInactive = Color3.fromRGB(30, 30, 38),
	TabHover = Color3.fromRGB(38, 38, 48),
	Shadow = Color3.fromRGB(0, 0, 0),
	Corner = 10,
	FontTitle = Enum.Font.GothamBold,
	FontBody = Enum.Font.Gotham,
	AnimationFast = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	AnimationMedium = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
}

Vellum.Themes.Default = shallowCopy(defaultTheme)
Vellum.Themes.Midnight = merge(defaultTheme, {
	Name = "Midnight",
	Accent = Color3.fromRGB(56, 189, 248),
	AccentMuted = Color3.fromRGB(14, 165, 233),
})
Vellum.Themes.Rose = merge(defaultTheme, {
	Name = "Rose",
	Accent = Color3.fromRGB(244, 114, 182),
	AccentMuted = Color3.fromRGB(219, 39, 119),
})
Vellum.Themes.Amber = merge(defaultTheme, {
	Name = "Amber",
	Accent = Color3.fromRGB(251, 191, 36),
	AccentMuted = Color3.fromRGB(245, 158, 11),
	Text = Color3.fromRGB(18, 18, 22),
	TextMuted = Color3.fromRGB(60, 60, 70),
})

local function isMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function scaleForDevice()
	return isMobile() and 0.92 or 1
end

local function createCorner(parent, px)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, px)
	c.Parent = parent
	return c
end

local function createStroke(parent, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = thickness or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local function createPadding(parent, p)
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, p)
	pad.PaddingBottom = UDim.new(0, p)
	pad.PaddingLeft = UDim.new(0, p)
	pad.PaddingRight = UDim.new(0, p)
	pad.Parent = parent
	return pad
end

local function createList(parent, padding, fill)
	local l = Instance.new("UIListLayout")
	l.Padding = UDim.new(0, padding)
	l.SortOrder = Enum.SortOrder.LayoutOrder
	l.HorizontalAlignment = Enum.HorizontalAlignment.Center
	if fill then
		l.FillDirection = Enum.FillDirection.Horizontal
	end
	l.Parent = parent
	return l
end

local function textLabel(parent, props)
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Text = props.Text or ""
	t.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
	t.Font = props.Font or Enum.Font.Gotham
	t.TextSize = props.TextSize or 14
	t.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	t.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
	t.TextWrapped = props.TextWrapped or false
	t.RichText = props.RichText or false
	t.AutomaticSize = props.AutomaticSize or Enum.AutomaticSize.None
	t.Size = props.Size or UDim2.fromScale(1, 0)
	t.LayoutOrder = props.LayoutOrder or 0
	t.Visible = props.Visible ~= false
	t.Parent = parent
	return t
end

local function textButton(parent, props)
	local b = Instance.new("TextButton")
	b.AutoButtonColor = false
	b.Text = props.Text or ""
	b.TextColor3 = props.TextColor3 or Color3.new(1, 1, 1)
	b.Font = props.Font or Enum.Font.GothamMedium
	b.TextSize = props.TextSize or 14
	b.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(40, 40, 50)
	b.Size = props.Size or UDim2.new(1, 0, 0, 36)
	b.LayoutOrder = props.LayoutOrder or 0
	b.ClipsDescendants = true
	b.Parent = parent
	createCorner(b, props.Corner or 8)
	return b
end

local function imageLabel(parent, props)
	local i = Instance.new("ImageLabel")
	i.BackgroundTransparency = 1
	i.Image = props.Image or ""
	i.Size = props.Size or UDim2.fromOffset(18, 18)
	i.ScaleType = Enum.ScaleType.Fit
	i.LayoutOrder = props.LayoutOrder or 0
	i.Parent = parent
	return i
end

local function scrollingFrame(parent, props)
	local s = Instance.new("ScrollingFrame")
	s.BackgroundTransparency = 1
	s.BorderSizePixel = 0
	s.ScrollBarThickness = props.ScrollBarThickness or (isMobile() and 10 or 6)
	s.ScrollBarImageColor3 = props.ScrollBarImageColor3 or Color3.fromRGB(120, 120, 140)
	s.CanvasSize = UDim2.new(0, 0, 0, 0)
	s.AutomaticCanvasSize = Enum.AutomaticSize.Y
	s.Size = props.Size or UDim2.fromScale(1, 1)
	s.ClipsDescendants = true
	s.Parent = parent
	local l = Instance.new("UIListLayout")
	l.Padding = UDim.new(0, props.Padding or 10)
	l.SortOrder = Enum.SortOrder.LayoutOrder
	l.Parent = s
	createPadding(s, props.InnerPadding or 12)
	return s, l
end

local function bindHoverScale(button, theme)
	local original = button.Size
	button.MouseEnter:Connect(function()
		tween(button, theme.AnimationFast, { Size = UDim2.new(original.X.Scale, original.X.Offset * 1.01, original.Y.Scale, original.Y.Offset) })
	end)
	button.MouseLeave:Connect(function()
		tween(button, theme.AnimationFast, { Size = original })
	end)
end

function Vellum.CreateWindow(options)
	options = options or {}
	local theme = merge(defaultTheme, Vellum.Themes[options.Theme] or options.Theme or {})

	local state = {
		theme = theme,
		tabs = {},
		activeTab = nil,
		registry = {},
		searchIndex = {},
		notifications = {},
		destroyed = false,
		minimized = false,
		maximized = false,
		dragging = false,
		resizing = false,
		dragStart = nil,
		sizeStart = nil,
		posStart = nil,
		configFolder = options.ConfigFolder or "VellumConfigs",
	}

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Vellum"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 1000
	screenGui.Parent = safeGetHui()

	local shadow = Instance.new("Frame")
	shadow.Name = "Shadow"
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.fromScale(0.5, 0.5)
	shadow.Size = options.Size or UDim2.fromOffset(720, 460)
	shadow.BackgroundColor3 = theme.Shadow
	shadow.BackgroundTransparency = 0.65
	shadow.BorderSizePixel = 0
	shadow.Parent = screenGui
	createCorner(shadow, theme.Corner + 4)

	local root = Instance.new("Frame")
	root.Name = "Window"
	root.AnchorPoint = Vector2.new(0.5, 0.5)
	root.Position = UDim2.fromScale(0.5, 0.5)
	root.Size = options.Size or UDim2.fromOffset(720, 460)
	root.BackgroundColor3 = theme.Background
	root.BorderSizePixel = 0
	root.ClipsDescendants = true
	root.Parent = screenGui
	createCorner(root, theme.Corner)
	local rootStroke = createStroke(root, theme.Stroke, 1)

	local uiScale = Instance.new("UIScale")
	uiScale.Scale = scaleForDevice()
	uiScale.Parent = root

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 52)
	titleBar.BackgroundColor3 = theme.TitleBar
	titleBar.BorderSizePixel = 0
	titleBar.Parent = root
	local titleBarStroke = createStroke(titleBar, theme.Stroke, 1)

	local titleTop = Instance.new("Frame")
	titleTop.Name = "TitleTop"
	titleTop.BackgroundTransparency = 1
	titleTop.Size = UDim2.new(1, -24, 1, 0)
	titleTop.Position = UDim2.fromOffset(12, 0)
	titleTop.Parent = titleBar
	createList(titleTop, 10, true).VerticalAlignment = Enum.VerticalAlignment.Center

	local icon = imageLabel(titleTop, {
		Image = options.Icon or "rbxassetid://7733960981",
		Size = UDim2.fromOffset(26, 26),
		LayoutOrder = 1,
	})

	local titleStack = Instance.new("Frame")
	titleStack.Name = "Titles"
	titleStack.BackgroundTransparency = 1
	titleStack.Size = UDim2.new(1, -220, 1, 0)
	titleStack.LayoutOrder = 2
	titleStack.Parent = titleTop
	local titleLayout = Instance.new("UIListLayout")
	titleLayout.FillDirection = Enum.FillDirection.Vertical
	titleLayout.Padding = UDim.new(0, 2)
	titleLayout.SortOrder = Enum.SortOrder.LayoutOrder
	titleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	titleLayout.Parent = titleStack

	local titleText = textLabel(titleStack, {
		Text = options.Title or "Vellum",
		Font = theme.FontTitle,
		TextSize = 18,
		TextColor3 = theme.Text,
		Size = UDim2.new(1, 0, 0, 22),
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	local subtitleText = textLabel(titleStack, {
		Text = options.Subtitle or "",
		Font = theme.FontBody,
		TextSize = 13,
		TextColor3 = theme.TextMuted,
		Size = UDim2.new(1, 0, 0, 18),
		TextXAlignment = Enum.TextXAlignment.Left,
		Visible = (options.Subtitle ~= nil and options.Subtitle ~= ""),
	})

	local windowControls = Instance.new("Frame")
	windowControls.Name = "Controls"
	windowControls.BackgroundTransparency = 1
	windowControls.Size = UDim2.fromOffset(120, 32)
	windowControls.LayoutOrder = 99
	windowControls.Parent = titleTop
	local controlLayout = createList(windowControls, 8, true)
	controlLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	local minimizeBtn = textButton(windowControls, {
		Text = "—",
		Size = UDim2.fromOffset(36, 30),
		TextSize = 18,
		BackgroundColor3 = theme.SurfaceElevated,
		TextColor3 = theme.Text,
		Corner = 8,
	})
	local maximizeBtn = textButton(windowControls, {
		Text = "▢",
		Size = UDim2.fromOffset(36, 30),
		TextSize = 14,
		BackgroundColor3 = theme.SurfaceElevated,
		TextColor3 = theme.Text,
		Corner = 8,
	})
	local closeBtn = textButton(windowControls, {
		Text = "✕",
		Size = UDim2.fromOffset(36, 30),
		TextSize = 14,
		BackgroundColor3 = theme.Danger,
		TextColor3 = Color3.fromRGB(20, 20, 20),
		Corner = 8,
	})

	local searchBoxContainer = nil

	local body = Instance.new("Frame")
	body.Name = "Body"
	body.BackgroundTransparency = 1
	body.Position = UDim2.fromOffset(0, 52)
	body.Size = UDim2.new(1, 0, 1, -52)
	body.Parent = root

	local tabRail = Instance.new("Frame")
	tabRail.Name = "TabRail"
	tabRail.Size = UDim2.new(0, isMobile() and 200 or 220, 1, 0)
	tabRail.BackgroundColor3 = theme.Surface
	tabRail.BorderSizePixel = 0
	tabRail.Parent = body
	local tabRailStroke = createStroke(tabRail, theme.Stroke, 1)

	local tabScroll, tabListLayout = scrollingFrame(tabRail, {
		Size = UDim2.new(1, 0, 1, 0),
		Padding = 10,
		InnerPadding = 12,
		ScrollBarImageColor3 = theme.TextMuted,
	})
	tabScroll.Name = "TabScroll"

	local contentHost = Instance.new("Frame")
	contentHost.Name = "Content"
	contentHost.BackgroundTransparency = 1
	contentHost.Position = UDim2.new(0, tabRail.Size.X.Offset, 0, 0)
	contentHost.Size = UDim2.new(1, -tabRail.Size.X.Offset, 1, 0)
	contentHost.Parent = body

	local notificationLayer = Instance.new("Frame")
	notificationLayer.Name = "Notifications"
	notificationLayer.BackgroundTransparency = 1
	notificationLayer.Size = UDim2.fromScale(1, 1)
	notificationLayer.Parent = screenGui

	local watermarkLayer = Instance.new("Frame")
	watermarkLayer.Name = "WatermarkLayer"
	watermarkLayer.BackgroundTransparency = 1
	watermarkLayer.Size = UDim2.fromScale(1, 1)
	watermarkLayer.Parent = screenGui

	local keyOverlay = nil

	local function destroyGui()
		if state.destroyed then
			return
		end
		state.destroyed = true
		for _, conn in pairs(state._connections or {}) do
			if typeof(conn) == "RBXScriptConnection" then
				conn:Disconnect()
			end
		end
		screenGui:Destroy()
	end

	state._connections = {}

	local function track(conn)
		table.insert(state._connections, conn)
	end

	-- Key gate
	if type(options.Key) == "string" and options.Key ~= "" then
		keyOverlay = Instance.new("Frame")
		keyOverlay.Name = "KeyGate"
		keyOverlay.Size = UDim2.fromScale(1, 1)
		keyOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
		keyOverlay.BackgroundTransparency = 0.35
		keyOverlay.ZIndex = 50
		keyOverlay.Parent = screenGui

		local card = Instance.new("Frame")
		card.Size = UDim2.fromOffset(360, 200)
		card.AnchorPoint = Vector2.new(0.5, 0.5)
		card.Position = UDim2.fromScale(0.5, 0.5)
		card.BackgroundColor3 = theme.Surface
		card.ZIndex = 51
		card.Parent = keyOverlay
		createCorner(card, 12)
		createStroke(card, theme.Stroke, 1)

		local prompt = textLabel(card, {
			Text = "Enter key",
			Font = theme.FontTitle,
			TextSize = 18,
			TextColor3 = theme.Text,
			Size = UDim2.new(1, -24, 0, 28),
			Position = UDim2.fromOffset(12, 12),
		})

		local keyInput = Instance.new("TextBox")
		keyInput.Size = UDim2.new(1, -24, 0, 40)
		keyInput.Position = UDim2.fromOffset(12, 52)
		keyInput.BackgroundColor3 = theme.SurfaceElevated
		keyInput.TextColor3 = theme.Text
		keyInput.PlaceholderText = "License key"
		keyInput.PlaceholderColor3 = theme.TextMuted
		keyInput.Font = theme.FontBody
		keyInput.TextSize = 15
		keyInput.ClearTextOnFocus = false
		keyInput.ZIndex = 52
		keyInput.Parent = card
		createCorner(keyInput, 8)
		createPadding(keyInput, 10)

		local submit = textButton(card, {
			Text = "Unlock",
			Size = UDim2.new(1, -24, 0, 40),
			Position = UDim2.fromOffset(12, 110),
			BackgroundColor3 = theme.Accent,
			TextColor3 = Color3.fromRGB(15, 15, 20),
			Corner = 8,
		})

		root.Visible = false
		shadow.Visible = false

		submit.MouseButton1Click:Connect(function()
			local attempt = keyInput.Text
			local ok = attempt == options.Key
			if options.KeyCallback then
				options.KeyCallback(ok, attempt)
			end
			if ok then
				keyOverlay.Visible = false
				root.Visible = true
				shadow.Visible = true
			else
				tween(keyInput, theme.AnimationFast, { BackgroundColor3 = theme.Danger })
				task.delay(0.35, function()
					if keyInput then
						tween(keyInput, theme.AnimationFast, { BackgroundColor3 = theme.SurfaceElevated })
					end
				end)
			end
		end)
	end

	local minSize = options.MinSize or Vector2.new(520, 360)
	local maxSize = options.MaxSize or Vector2.new(1200, 800)

	local function clampSize(s: Vector2)
		return Vector2.new(
			math.clamp(s.X, minSize.X, maxSize.X),
			math.clamp(s.Y, minSize.Y, maxSize.Y)
		)
	end

	-- Dragging
	if options.Draggable ~= false then
		local dragInput = nil
		track(titleBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				state.dragging = true
				dragInput = input
				local abs = root.AbsolutePosition
				local mouse = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
				state.dragStart = Vector2.new(mouse.X, mouse.Y) - Vector2.new(abs.X, abs.Y)
			end
		end))
		track(UserInputService.InputChanged:Connect(function(input)
			if state.dragging and dragInput and input == dragInput then
				local mouse = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
				local newPos = Vector2.new(mouse.X, mouse.Y) - (state.dragStart or Vector2.zero)
				root.Position = UDim2.fromOffset(newPos.X, newPos.Y)
			end
		end))
		track(UserInputService.InputEnded:Connect(function(input)
			if input == dragInput then
				state.dragging = false
				dragInput = nil
			end
		end))
	end

	-- Resizing (bottom-right grip)
	local resizeGrip = Instance.new("TextButton")
	resizeGrip.Name = "ResizeGrip"
	resizeGrip.Size = UDim2.fromOffset(18, 18)
	resizeGrip.Position = UDim2.new(1, -20, 1, -20)
	resizeGrip.BackgroundTransparency = 0.85
	resizeGrip.BackgroundColor3 = theme.SurfaceElevated
	resizeGrip.Text = ""
	resizeGrip.AutoButtonColor = false
	resizeGrip.ZIndex = 5
	resizeGrip.Parent = root
	createCorner(resizeGrip, 4)

	if options.Resizable ~= false then
		local resizeInput = nil
		track(resizeGrip.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				state.resizing = true
				resizeInput = input
				state.sizeStart = root.Size
				state.posStart = root.Position
			end
		end))
		track(UserInputService.InputChanged:Connect(function(input)
			if state.resizing and resizeInput and input == resizeInput then
				local mouse = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
				local absPos = root.AbsolutePosition
				local newSize = clampSize(Vector2.new(mouse.X - absPos.X + 8, mouse.Y - absPos.Y + 8))
				root.Size = UDim2.fromOffset(newSize.X, newSize.Y)
				shadow.Size = root.Size
			end
		end))
		track(UserInputService.InputEnded:Connect(function(input)
			if input == resizeInput then
				state.resizing = false
				resizeInput = nil
			end
		end))
	else
		resizeGrip.Visible = false
	end

	-- Window controls behavior
	track(minimizeBtn.MouseButton1Click:Connect(function()
		state.minimized = not state.minimized
		if state.minimized then
			tween(body, theme.AnimationMedium, { Size = UDim2.new(1, 0, 0, 0) })
			body.Visible = false
			tween(root, theme.AnimationMedium, { Size = UDim2.new(root.Size.X.Scale, root.Size.X.Offset, 0, 52) })
			tween(shadow, theme.AnimationMedium, { Size = UDim2.new(shadow.Size.X.Scale, shadow.Size.X.Offset, 0, 56) })
		else
			body.Visible = true
			tween(root, theme.AnimationMedium, { Size = options.Size or UDim2.fromOffset(720, 460) })
			tween(shadow, theme.AnimationMedium, { Size = options.Size or UDim2.fromOffset(720, 460) })
			tween(body, theme.AnimationMedium, { Size = UDim2.new(1, 0, 1, -52) })
		end
	end))

	track(maximizeBtn.MouseButton1Click:Connect(function()
		state.maximized = not state.maximized
		local cam = workspace.CurrentCamera
		local vs = cam and cam.ViewportSize or Vector2.new(1920, 1080)
		if state.maximized then
			tween(root, theme.AnimationMedium, {
				Size = UDim2.fromOffset(vs.X * 0.94, vs.Y * 0.9),
				Position = UDim2.fromScale(0.5, 0.5),
			})
			tween(shadow, theme.AnimationMedium, { Size = UDim2.fromOffset(vs.X * 0.94 + 8, vs.Y * 0.9 + 8) })
		else
			tween(root, theme.AnimationMedium, {
				Size = options.Size or UDim2.fromOffset(720, 460),
				Position = UDim2.fromScale(0.5, 0.5),
			})
			tween(shadow, theme.AnimationMedium, { Size = options.Size or UDim2.fromOffset(720, 460) })
		end
	end))

	track(closeBtn.MouseButton1Click:Connect(function()
		destroyGui()
	end))

	-- Hover micro-interactions on controls
	bindHoverScale(minimizeBtn, theme)
	bindHoverScale(maximizeBtn, theme)

	local window = {}
	window._state = state
	window._root = root
	window._screenGui = screenGui
	window._contentHost = contentHost
	window._tabRailScroll = tabScroll
	window._tabListLayout = tabListLayout
	window._theme = theme
	window._title = titleText
	window._subtitle = subtitleText
	window._notificationLayer = notificationLayer
	window._watermarkLayer = watermarkLayer

	if options.DestroyOnCleanup then
		track(LocalPlayer.AncestryChanged:Connect(function()
			if not LocalPlayer.Parent then
				destroyGui()
			end
		end))
	end

	function window:SetTheme(themeOrName)
		local t = type(themeOrName) == "string" and (Vellum.Themes[themeOrName] or Vellum.Themes.Default) or merge(defaultTheme, themeOrName)
		state.theme = t
		window._theme = t
		root.BackgroundColor3 = t.Background
		titleBar.BackgroundColor3 = t.TitleBar
		tabRail.BackgroundColor3 = t.Surface
		rootStroke.Color = t.Stroke
		titleBarStroke.Color = t.Stroke
		tabRailStroke.Color = t.Stroke
		titleText.TextColor3 = t.Text
		subtitleText.TextColor3 = t.TextMuted
		minimizeBtn.BackgroundColor3 = t.SurfaceElevated
		maximizeBtn.BackgroundColor3 = t.SurfaceElevated
		tabScroll.ScrollBarImageColor3 = t.TextMuted
	end

	function window:Notify(opts)
		opts = opts or {}
		local t = state.theme
		local card = Instance.new("Frame")
		card.Size = UDim2.fromOffset(320, 0)
		card.AutomaticSize = Enum.AutomaticSize.Y
		card.AnchorPoint = Vector2.new(1, 0)
		card.Position = UDim2.new(1, -20, 0, 20 + #state.notifications * 86)
		card.BackgroundColor3 = t.Surface
		card.BackgroundTransparency = 0.05
		card.ZIndex = 200
		card.Parent = notificationLayer
		createCorner(card, 10)
		createStroke(card, t.Stroke, 1)
		createPadding(card, 12)

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 6)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent = card

		local header = Instance.new("Frame")
		header.BackgroundTransparency = 1
		header.Size = UDim2.new(1, 0, 0, 26)
		header.Parent = card
		local hl = createList(header, 8, true)
		hl.VerticalAlignment = Enum.VerticalAlignment.Center

		if opts.Icon then
			imageLabel(header, { Image = opts.Icon, Size = UDim2.fromOffset(22, 22), LayoutOrder = 1 })
		end
		local accent = t.Accent
		if opts.Type == "Success" then
			accent = t.Success
		elseif opts.Type == "Warning" then
			accent = t.Warning
		elseif opts.Type == "Error" then
			accent = t.Danger
		end

		textLabel(header, {
			Text = opts.Title or "Notice",
			Font = t.FontTitle,
			TextSize = 16,
			TextColor3 = t.Text,
			Size = UDim2.new(1, -30, 1, 0),
			LayoutOrder = 2,
		})

		textLabel(card, {
			Text = opts.Content or "",
			Font = t.FontBody,
			TextSize = 13,
			TextColor3 = t.TextMuted,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 3,
		})

		table.insert(state.notifications, card)
		card.Position = UDim2.new(1, 420, 0, card.Position.Y.Offset)
		tween(card, t.AnimationMedium, { Position = UDim2.new(1, -20, 0, card.Position.Y.Offset) })

		task.delay(opts.Duration or 4, function()
			if card.Parent then
				tween(card, t.AnimationFast, { Position = UDim2.new(1, 420, 0, card.Position.Y.Offset), BackgroundTransparency = 1 })
				for _, d in ipairs(card:GetDescendants()) do
					if d:IsA("GuiObject") then
						tween(d, t.AnimationFast, { BackgroundTransparency = 1, TextTransparency = 1 })
					end
				end
				task.wait(0.25)
				card:Destroy()
				for i, c in ipairs(state.notifications) do
					if c == card then
						table.remove(state.notifications, i)
						break
					end
				end
			end
		end)
	end

	function window:PromptDiscord(opts)
		opts = opts or {}
		self:Notify({
			Title = opts.Title or "Join our Discord",
			Content = opts.Content or (opts.Invite and ("Invite: " .. opts.Invite)) or "",
			Duration = opts.Duration or 8,
			Icon = opts.Icon,
			Type = "Info",
		})
		if opts.Invite and type(setclipboard) == "function" then
			local ok = pcall(setclipboard, opts.Invite)
			if ok then
				self:Notify({ Title = "Copied", Content = "Invite link copied to clipboard.", Duration = 3, Type = "Success" })
			end
		end
	end

	function window:AddSearchBar(opts)
		opts = opts or {}
		if searchBoxContainer then
			return searchBoxContainer
		end
		searchBoxContainer = Instance.new("Frame")
		searchBoxContainer.Name = "Search"
		searchBoxContainer.BackgroundTransparency = 1
		searchBoxContainer.Size = UDim2.new(0, 200, 1, 0)
		searchBoxContainer.LayoutOrder = 50
		searchBoxContainer.Parent = titleTop

		local box = Instance.new("TextBox")
		box.BackgroundColor3 = state.theme.SurfaceElevated
		box.TextColor3 = state.theme.Text
		box.PlaceholderText = opts.Placeholder or "Search..."
		box.PlaceholderColor3 = state.theme.TextMuted
		box.Size = UDim2.new(1, 0, 0, 32)
		box.Position = UDim2.fromScale(0, 0.5)
		box.AnchorPoint = Vector2.new(0, 0.5)
		box.Font = state.theme.FontBody
		box.TextSize = 13
		box.ClearTextOnFocus = false
		box.Parent = searchBoxContainer
		createCorner(box, 8)
		createPadding(box, 8)

		track(box:GetPropertyChangedSignal("Text"):Connect(function()
			local q = string.lower(box.Text)
			for _, entry in ipairs(state.searchIndex) do
				if q == "" then
					entry.frame.Visible = true
				else
					entry.frame.Visible = string.find(entry.haystack, q, 1, true) ~= nil
				end
			end
		end))

		return searchBoxContainer
	end

	function window:AddWatermark(opts)
		opts = opts or {}
		local t = state.theme
		local holder = Instance.new("Frame")
		holder.BackgroundTransparency = 1
		holder.Size = UDim2.fromOffset(260, 28)
		holder.AnchorPoint = Vector2.new(1, 1)
		holder.Position = UDim2.new(1, -16, 1, -16)
		holder.Parent = watermarkLayer

		local bg = Instance.new("Frame")
		bg.Size = UDim2.fromScale(1, 1)
		bg.BackgroundColor3 = t.Surface
		bg.BackgroundTransparency = 0.15
		bg.Parent = holder
		createCorner(bg, 8)
		createStroke(bg, t.Stroke, 1)

		local label = textLabel(bg, {
			Text = opts.Text or ("Vellum " .. Vellum.Version),
			Font = t.FontBody,
			TextSize = 13,
			TextColor3 = t.Text,
			Size = UDim2.new(1, -16, 1, 0),
			Position = UDim2.fromOffset(8, 0),
		})

		if opts.ShowPerformance then
			local acc = 0
			local frames = 0
			track(RunService.RenderStepped:Connect(function(dt)
				acc = acc + dt
				frames = frames + 1
				if acc >= 0.5 then
					local fps = math.floor(frames / acc + 0.5)
					acc = 0
					frames = 0
					label.Text = (opts.Text or ("Vellum " .. Vellum.Version)) .. "  •  " .. fps .. " FPS"
				end
			end))
		end

		return holder
	end

	function window:RegisterSearchEntry(frame, haystack)
		table.insert(state.searchIndex, { frame = frame, haystack = string.lower(haystack) })
	end

	function window:RegisterConfigKey(key, getter, setter)
		state.registry[key] = { get = getter, set = setter }
	end

	function window:SaveConfig(fileName)
		if not hasExecutorFilesystem() then
			warn("[Vellum] SaveConfig requires executor filesystem (writefile).")
			return false
		end
		local name = fileName or "config.json"
		local data = {}
		for k, entry in pairs(state.registry) do
			data[k] = entry.get()
		end
		local path = state.configFolder .. "/" .. name
		pcall(function()
			if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(state.configFolder) then
				makefolder(state.configFolder)
			end
		end)
		local ok = pcall(writefile, path, jsonEncode(data))
		return ok
	end

	function window:LoadConfig(fileName)
		if not hasExecutorFilesystem() then
			warn("[Vellum] LoadConfig requires executor filesystem (readfile).")
			return false
		end
		local name = fileName or "config.json"
		local path = state.configFolder .. "/" .. name
		if not isfile(path) then
			return false
		end
		local ok, contents = pcall(readfile, path)
		if not ok or type(contents) ~= "string" then
			return false
		end
		local data = jsonDecode(contents)
		if type(data) ~= "table" then
			return false
		end
		for k, v in pairs(data) do
			local entry = state.registry[k]
			if entry and entry.set then
				pcall(entry.set, v)
			end
		end
		return true
	end

	function window:Destroy()
		destroyGui()
	end

	function window:CreateTab(tabOptions)
		local t = state.theme
		local tabButton = textButton(tabScroll, {
			Text = "",
			Size = UDim2.new(1, -4, 0, isMobile() and 64 or 58),
			BackgroundColor3 = t.TabInactive,
			Corner = 10,
		})
		tabButton.ClipsDescendants = false

		local btnLayout = Instance.new("Frame")
		btnLayout.BackgroundTransparency = 1
		btnLayout.Size = UDim2.fromScale(1, 1)
		btnLayout.Parent = tabButton
		local row = Instance.new("Frame")
		row.BackgroundTransparency = 1
		row.Size = UDim2.new(1, -16, 1, -12)
		row.Position = UDim2.fromOffset(8, 6)
		row.Parent = btnLayout
		local list = Instance.new("UIListLayout")
		list.FillDirection = Enum.FillDirection.Horizontal
		list.Padding = UDim.new(0, 10)
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.VerticalAlignment = Enum.VerticalAlignment.Center
		list.Parent = row

		local tabIcon = imageLabel(row, {
			Image = tabOptions.Icon or "rbxassetid://7733992981",
			Size = UDim2.fromOffset(22, 22),
			LayoutOrder = 1,
		})

		local textStack = Instance.new("Frame")
		textStack.BackgroundTransparency = 1
		textStack.Size = UDim2.new(1, -40, 1, 0)
		textStack.LayoutOrder = 2
		textStack.Parent = row
		local v = Instance.new("UIListLayout")
		v.FillDirection = Enum.FillDirection.Vertical
		v.Padding = UDim.new(0, 2)
		v.SortOrder = Enum.SortOrder.LayoutOrder
		v.VerticalAlignment = Enum.VerticalAlignment.Center
		v.Parent = textStack

		local tabName = textLabel(textStack, {
			Text = tabOptions.Name or "Tab",
			Font = t.FontTitle,
			TextSize = 15,
			TextColor3 = t.Text,
			Size = UDim2.new(1, 0, 0, 20),
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		local tabDesc = textLabel(textStack, {
			Text = tabOptions.Description or "",
			Font = t.FontBody,
			TextSize = 12,
			TextColor3 = t.TextMuted,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 32),
			TextXAlignment = Enum.TextXAlignment.Left,
			Visible = (tabOptions.Description ~= nil and tabOptions.Description ~= ""),
		})

		local accentBar = Instance.new("Frame")
		accentBar.Size = UDim2.new(0, 4, 0.7, 0)
		accentBar.AnchorPoint = Vector2.new(0, 0.5)
		accentBar.Position = UDim2.new(0, 0, 0.5, 0)
		accentBar.BackgroundColor3 = t.Accent
		accentBar.BorderSizePixel = 0
		accentBar.Visible = false
		accentBar.Parent = tabButton
		createCorner(accentBar, 2)

		local page = Instance.new("Frame")
		page.Name = tabOptions.Name or "TabPage"
		page.BackgroundTransparency = 1
		page.Size = UDim2.fromScale(1, 1)
		page.Visible = false
		page.Parent = contentHost

		local pageScroll, pageList = scrollingFrame(page, {
			Size = UDim2.fromScale(1, 1),
			Padding = 12,
			InnerPadding = 16,
			ScrollBarImageColor3 = t.TextMuted,
		})

		local tabObject = {
			_button = tabButton,
			_page = page,
			_scroll = pageScroll,
			_list = pageList,
			_window = window,
			Name = tabOptions.Name,
		}

		function tabObject:Select()
			for _, other in ipairs(state.tabs) do
				other._page.Visible = false
				tween(other._button, t.AnimationFast, { BackgroundColor3 = t.TabInactive })
				other._accent.Visible = false
			end
			page.Visible = true
			tween(tabButton, t.AnimationFast, { BackgroundColor3 = t.TabHover })
			accentBar.Visible = true
			state.activeTab = tabObject
		end

		tabButton.MouseButton1Click:Connect(function()
			tabObject:Select()
		end)

		accentBar.Name = "Accent"
		tabObject._accent = accentBar

		table.insert(state.tabs, tabObject)
		if #state.tabs == 1 then
			tabObject:Select()
		end

		function tabObject:CreateSection(sectionOptions)
			local s = state.theme
			local holder = Instance.new("Frame")
			holder.BackgroundColor3 = s.SurfaceElevated
			holder.Size = UDim2.new(1, -8, 0, 0)
			holder.AutomaticSize = Enum.AutomaticSize.Y
			holder.Parent = pageScroll
			createCorner(holder, 10)
			createStroke(holder, s.Stroke, 1)
			createPadding(holder, 14)

			local vLayout = Instance.new("UIListLayout")
			vLayout.Padding = UDim.new(0, 10)
			vLayout.SortOrder = Enum.SortOrder.LayoutOrder
			vLayout.Parent = holder

			local head = Instance.new("Frame")
			head.BackgroundTransparency = 1
			head.Size = UDim2.new(1, 0, 0, 0)
			head.AutomaticSize = Enum.AutomaticSize.Y
			head.Parent = holder

			textLabel(head, {
				Text = sectionOptions.Title or "Section",
				Font = s.FontTitle,
				TextSize = 16,
				TextColor3 = s.Text,
				Size = UDim2.new(1, 0, 0, 22),
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			if sectionOptions.Description and sectionOptions.Description ~= "" then
				textLabel(head, {
					Text = sectionOptions.Description,
					Font = s.FontBody,
					TextSize = 13,
					TextColor3 = s.TextMuted,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
				})
			end

			local content = Instance.new("Frame")
			content.Name = "Content"
			content.BackgroundTransparency = 1
			content.Size = UDim2.new(1, 0, 0, 0)
			content.AutomaticSize = Enum.AutomaticSize.Y
			content.Parent = holder
			local cLayout = Instance.new("UIListLayout")
			cLayout.Padding = UDim.new(0, 10)
			cLayout.SortOrder = Enum.SortOrder.LayoutOrder
			cLayout.Parent = content

			local section = { _holder = holder, _content = content, _window = window }

			window:RegisterSearchEntry(holder, (sectionOptions.Title or "") .. " " .. (sectionOptions.Description or ""))

			function section:CreateParagraph(o)
				o = o or {}
				local fr = Instance.new("Frame")
				fr.BackgroundTransparency = 1
				fr.Size = UDim2.new(1, 0, 0, 0)
				fr.AutomaticSize = Enum.AutomaticSize.Y
				fr.Parent = content
				textLabel(fr, {
					Text = o.Title or "Paragraph",
					Font = s.FontTitle,
					TextSize = 14,
					TextColor3 = s.Text,
					Size = UDim2.new(1, 0, 0, 20),
					TextXAlignment = Enum.TextXAlignment.Left,
				})
				textLabel(fr, {
					Text = o.Content or "",
					Font = s.FontBody,
					TextSize = 13,
					TextColor3 = s.TextMuted,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
				})
				window:RegisterSearchEntry(fr, (o.Title or "") .. " " .. (o.Content or ""))
				return { Destroy = function()
					fr:Destroy()
				end }
			end

			function section:CreateLabel(o)
				o = o or {}
				local lbl = textLabel(content, {
					Text = o.Text or "Label",
					Font = s.FontBody,
					TextSize = o.TextSize or 14,
					TextColor3 = o.Color and parseColor3(o.Color) or s.TextMuted,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
				})
				local api = {}
				function api:SetText(v)
					lbl.Text = tostring(v)
				end
				function api:Destroy()
					lbl:Destroy()
				end
				window:RegisterSearchEntry(lbl, o.Text or "")
				return api
			end

			function section:CreateButton(o)
				o = o or {}
				local row = Instance.new("Frame")
				row.BackgroundTransparency = 1
				row.Size = UDim2.new(1, 0, 0, 0)
				row.AutomaticSize = Enum.AutomaticSize.Y
				row.Parent = content

				local title = textLabel(row, {
					Text = o.Name or "Button",
					Font = s.FontTitle,
					TextSize = 15,
					TextColor3 = s.Text,
					Size = UDim2.new(1, 0, 0, 20),
					TextXAlignment = Enum.TextXAlignment.Left,
				})
				if o.Description and o.Description ~= "" then
					textLabel(row, {
						Text = o.Description,
						Font = s.FontBody,
						TextSize = 13,
						TextColor3 = s.TextMuted,
						TextWrapped = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0),
						TextXAlignment = Enum.TextXAlignment.Left,
					})
				end
				local b = textButton(row, {
					Text = o.ButtonText or "Run",
					Size = UDim2.new(1, 0, 0, 38),
					BackgroundColor3 = s.Accent,
					TextColor3 = Color3.fromRGB(12, 12, 18),
					Font = s.FontTitle,
					TextSize = 14,
					Corner = 9,
				})
				b.MouseButton1Click:Connect(function()
					if o.Callback then
						o.Callback()
					end
				end)
				bindHoverScale(b, s)
				window:RegisterSearchEntry(row, (o.Name or "") .. " " .. (o.Description or ""))
				return {
					Trigger = function()
						if o.Callback then
							o.Callback()
						end
					end,
					Destroy = function()
						row:Destroy()
					end,
				}
			end

			function section:CreateToggle(o)
				o = o or {}
				local row = Instance.new("Frame")
				row.BackgroundTransparency = 1
				row.Size = UDim2.new(1, 0, 0, 52)
				row.Parent = content

				local labels = Instance.new("Frame")
				labels.BackgroundTransparency = 1
				labels.Size = UDim2.new(1, -70, 1, 0)
				labels.Parent = row
				local vl = Instance.new("UIListLayout")
				vl.Parent = labels
				vl.SortOrder = Enum.SortOrder.LayoutOrder
				vl.Padding = UDim.new(0, 2)

				textLabel(labels, {
					Text = o.Name or "Toggle",
					Font = s.FontTitle,
					TextSize = 15,
					TextColor3 = s.Text,
					Size = UDim2.new(1, 0, 0, 20),
					TextXAlignment = Enum.TextXAlignment.Left,
				})
				if o.Description and o.Description ~= "" then
					textLabel(labels, {
						Text = o.Description,
						Font = s.FontBody,
						TextSize = 12,
						TextColor3 = s.TextMuted,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 28),
						TextXAlignment = Enum.TextXAlignment.Left,
					})
				end

				local switch = Instance.new("TextButton")
				switch.Size = UDim2.fromOffset(52, 28)
				switch.Position = UDim2.new(1, -52, 0.5, 0)
				switch.AnchorPoint = Vector2.new(0, 0.5)
				switch.BackgroundColor3 = s.Surface
				switch.Text = ""
				switch.AutoButtonColor = false
				switch.Parent = row
				createCorner(switch, 14)

				local knob = Instance.new("Frame")
				knob.Size = UDim2.fromOffset(22, 22)
				knob.Position = UDim2.fromOffset(3, 3)
				knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				knob.Parent = switch
				createCorner(knob, 11)

				local value = not not o.Default
				local function paint()
					if value then
						tween(switch, s.AnimationFast, { BackgroundColor3 = s.Accent })
						tween(knob, s.AnimationFast, { Position = UDim2.new(1, -25, 0, 3) })
					else
						tween(switch, s.AnimationFast, { BackgroundColor3 = s.Surface })
						tween(knob, s.AnimationFast, { Position = UDim2.fromOffset(3, 3) })
					end
				end
				paint()

				switch.MouseButton1Click:Connect(function()
					value = not value
					paint()
					if o.Callback then
						o.Callback(value)
					end
				end)

				if o.ConfigKey then
					window:RegisterConfigKey(o.ConfigKey, function()
						return value
					end, function(v)
						value = not not v
						paint()
					end)
				end

				window:RegisterSearchEntry(row, (o.Name or "") .. " " .. (o.Description or ""))
				return {
					Get = function()
						return value
					end,
					Set = function(v)
						value = not not v
						paint()
					end,
					Destroy = function()
						row:Destroy()
					end,
				}
			end

			function section:CreateSlider(o)
				o = o or {}
				local min = tonumber(o.Min) or 0
				local max = tonumber(o.Max) or 100
				local inc = tonumber(o.Increment) or 1
				local val = tonumber(o.Default) or min

				local row = Instance.new("Frame")
				row.BackgroundTransparency = 1
				row.Size = UDim2.new(1, 0, 0, 0)
				row.AutomaticSize = Enum.AutomaticSize.Y
				row.Parent = content

				local titleLbl = textLabel(row, {
					Text = (o.Name or "Slider") .. "  •  " .. tostring(val),
					Font = s.FontTitle,
					TextSize = 14,
					TextColor3 = s.Text,
					Size = UDim2.new(1, 0, 0, 20),
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 1,
				})
				if o.Description and o.Description ~= "" then
					textLabel(row, {
						Text = o.Description,
						Font = s.FontBody,
						TextSize = 12,
						TextColor3 = s.TextMuted,
						TextWrapped = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0),
						TextXAlignment = Enum.TextXAlignment.Left,
						LayoutOrder = 2,
					})
				end

				local trackFr = Instance.new("Frame")
				trackFr.Size = UDim2.new(1, 0, 0, 10)
				trackFr.BackgroundColor3 = s.Surface
				trackFr.LayoutOrder = 3
				trackFr.Parent = row
				createCorner(trackFr, 5)

				local fill = Instance.new("Frame")
				fill.BackgroundColor3 = s.Accent
				fill.Size = UDim2.new(0.5, 0, 1, 0)
				fill.BorderSizePixel = 0
				fill.Parent = trackFr
				createCorner(fill, 5)

				local knobBtn = Instance.new("TextButton")
				knobBtn.Text = ""
				knobBtn.Size = UDim2.fromOffset(18, 18)
				knobBtn.AnchorPoint = Vector2.new(0.5, 0.5)
				knobBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
				knobBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				knobBtn.AutoButtonColor = false
				knobBtn.ZIndex = 2
				knobBtn.Parent = trackFr
				createCorner(knobBtn, 9)

				local function snap(n)
					return math.clamp(math.floor((n - min) / inc + 0.5) * inc + min, min, max)
				end

				local function setFromAlpha(a)
					val = snap(min + (max - min) * a)
					local a2 = (val - min) / math.max(max - min, 1e-6)
					fill.Size = UDim2.new(a2, 0, 1, 0)
					knobBtn.Position = UDim2.new(a2, 0, 0.5, 0)
					titleLbl.Text = (o.Name or "Slider") .. "  •  " .. tostring(val)
					if o.Callback then
						o.Callback(val)
					end
				end
				setFromAlpha((val - min) / math.max(max - min, 1e-6))

				local dragging = false
				knobBtn.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
					end
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)
				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						local absPos = trackFr.AbsolutePosition
						local absSize = trackFr.AbsoluteSize
						local mouse = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
						local a = math.clamp((mouse.X - absPos.X) / absSize.X, 0, 1)
						setFromAlpha(a)
					end
				end)

				if o.ConfigKey then
					window:RegisterConfigKey(o.ConfigKey, function()
						return val
					end, function(v)
						val = tonumber(v) or val
						setFromAlpha((val - min) / math.max(max - min, 1e-6))
					end)
				end

				window:RegisterSearchEntry(row, (o.Name or "") .. " " .. (o.Description or ""))
				return {
					Get = function()
						return val
					end,
					Set = function(v)
						val = snap(tonumber(v) or val)
						setFromAlpha((val - min) / math.max(max - min, 1e-6))
					end,
					Destroy = function()
						row:Destroy()
					end,
				}
			end

			function section:CreateDropdown(o)
				o = o or {}
				local optionsList = o.Options or {}
				local selected = o.Default or (optionsList[1] or "")
				local open = false

				local row = Instance.new("Frame")
				row.BackgroundTransparency = 1
				row.Size = UDim2.new(1, 0, 0, 0)
				row.AutomaticSize = Enum.AutomaticSize.Y
				row.ClipsDescendants = false
				row.Parent = content

				textLabel(row, {
					Text = o.Name or "Dropdown",
					Font = s.FontTitle,
					TextSize = 15,
					TextColor3 = s.Text,
					Size = UDim2.new(1, 0, 0, 20),
					TextXAlignment = Enum.TextXAlignment.Left,
				})
				if o.Description and o.Description ~= "" then
					textLabel(row, {
						Text = o.Description,
						Font = s.FontBody,
						TextSize = 12,
						TextColor3 = s.TextMuted,
						TextWrapped = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0),
						TextXAlignment = Enum.TextXAlignment.Left,
					})
				end

				local main = textButton(row, {
					Text = tostring(selected) .. "   ▾",
					Size = UDim2.new(1, 0, 0, 38),
					BackgroundColor3 = s.Surface,
					TextColor3 = s.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					Corner = 8,
				})
				createPadding(main, 10)

				local listHolder = Instance.new("Frame")
				listHolder.Visible = false
				listHolder.Size = UDim2.new(1, 0, 0, 0)
				listHolder.AutomaticSize = Enum.AutomaticSize.Y
				listHolder.BackgroundColor3 = s.SurfaceElevated
				listHolder.Parent = row
				listHolder.ZIndex = 5
				createCorner(listHolder, 8)
				createStroke(listHolder, s.Stroke, 1)

				local listLayout = Instance.new("UIListLayout")
				listLayout.Padding = UDim.new(0, 4)
				listLayout.SortOrder = Enum.SortOrder.LayoutOrder
				listLayout.Parent = listHolder
				createPadding(listHolder, 6)

				local function rebuild()
					for _, c in ipairs(listHolder:GetChildren()) do
						if c:IsA("GuiObject") and c ~= listLayout then
							c:Destroy()
						end
					end
					for _, opt in ipairs(optionsList) do
						local item = textButton(listHolder, {
							Text = tostring(opt),
							Size = UDim2.new(1, -8, 0, 32),
							BackgroundColor3 = s.Surface,
							TextColor3 = s.Text,
							TextXAlignment = Enum.TextXAlignment.Left,
							Corner = 6,
						})
						createPadding(item, 8)
						item.MouseButton1Click:Connect(function()
							selected = opt
							main.Text = tostring(selected) .. "   ▾"
							open = false
							listHolder.Visible = false
							if o.Callback then
								o.Callback(selected)
							end
						end)
					end
				end
				rebuild()

				main.MouseButton1Click:Connect(function()
					open = not open
					listHolder.Visible = open
				end)

				if o.ConfigKey then
					window:RegisterConfigKey(o.ConfigKey, function()
						return selected
					end, function(v)
						selected = v
						main.Text = tostring(selected) .. "   ▾"
					end)
				end

				window:RegisterSearchEntry(row, (o.Name or "") .. " " .. (o.Description or ""))
				return {
					Get = function()
						return selected
					end,
					Set = function(v)
						selected = v
						main.Text = tostring(selected) .. "   ▾"
					end,
					SetOptions = function(newOpts)
						optionsList = newOpts
						rebuild()
					end,
					Destroy = function()
						row:Destroy()
					end,
				}
			end

			function section:CreateMultiDropdown(o)
				o = o or {}
				local optionsList = o.Options or {}
				local selectedSet = {}
				for _, v in ipairs(o.Default or {}) do
					selectedSet[tostring(v)] = true
				end
				local open = false

				local row = Instance.new("Frame")
				row.BackgroundTransparency = 1
				row.Size = UDim2.new(1, 0, 0, 0)
				row.AutomaticSize = Enum.AutomaticSize.Y
				row.ClipsDescendants = false
				row.Parent = content

				textLabel(row, {
					Text = o.Name or "Multi Dropdown",
					Font = s.FontTitle,
					TextSize = 15,
					TextColor3 = s.Text,
					Size = UDim2.new(1, 0, 0, 20),
					TextXAlignment = Enum.TextXAlignment.Left,
				})

				local main = textButton(row, {
					Text = "Select...   ▾",
					Size = UDim2.new(1, 0, 0, 38),
					BackgroundColor3 = s.Surface,
					TextColor3 = s.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					Corner = 8,
				})
				createPadding(main, 10)

				local function summary()
					local t2 = {}
					for k in pairs(selectedSet) do
						table.insert(t2, k)
					end
					table.sort(t2)
					return #t2 > 0 and table.concat(t2, ", ") or "None"
				end

				local function refreshMain()
					main.Text = summary() .. "   ▾"
				end
				refreshMain()

				local listHolder = Instance.new("Frame")
				listHolder.Visible = false
				listHolder.Size = UDim2.new(1, 0, 0, 0)
				listHolder.AutomaticSize = Enum.AutomaticSize.Y
				listHolder.BackgroundColor3 = s.SurfaceElevated
				listHolder.Parent = row
				listHolder.ZIndex = 5
				createCorner(listHolder, 8)
				createStroke(listHolder, s.Stroke, 1)
				local listLayout = Instance.new("UIListLayout")
				listLayout.Padding = UDim.new(0, 4)
				listLayout.SortOrder = Enum.SortOrder.LayoutOrder
				listLayout.Parent = listHolder
				createPadding(listHolder, 6)

				local function rebuild()
					for _, c in ipairs(listHolder:GetChildren()) do
						if c:IsA("GuiObject") and c ~= listLayout then
							c:Destroy()
						end
					end
					for _, opt in ipairs(optionsList) do
						local itemRow = Instance.new("Frame")
						itemRow.Size = UDim2.new(1, -8, 0, 32)
						itemRow.BackgroundColor3 = s.Surface
						itemRow.Parent = listHolder
						createCorner(itemRow, 6)

						local chk = Instance.new("Frame")
						chk.Size = UDim2.fromOffset(18, 18)
						chk.Position = UDim2.fromOffset(8, 7)
						chk.BackgroundColor3 = selectedSet[tostring(opt)] and s.Accent or s.SurfaceElevated
						chk.Parent = itemRow
						createCorner(chk, 4)

						local hit = Instance.new("TextButton")
						hit.BackgroundTransparency = 1
						hit.Text = "  " .. tostring(opt)
						hit.TextXAlignment = Enum.TextXAlignment.Left
						hit.Font = s.FontBody
						hit.TextSize = 13
						hit.TextColor3 = s.Text
						hit.Size = UDim2.new(1, 0, 1, 0)
						hit.Parent = itemRow

						hit.MouseButton1Click:Connect(function()
							local key = tostring(opt)
							selectedSet[key] = not selectedSet[key]
							if not selectedSet[key] then
								selectedSet[key] = nil
							end
							chk.BackgroundColor3 = selectedSet[key] and s.Accent or s.SurfaceElevated
							refreshMain()
							if o.Callback then
								local arr = {}
								for k in pairs(selectedSet) do
									table.insert(arr, k)
								end
								o.Callback(arr)
							end
						end)
					end
				end
				rebuild()

				main.MouseButton1Click:Connect(function()
					open = not open
					listHolder.Visible = open
				end)

				if o.ConfigKey then
					window:RegisterConfigKey(o.ConfigKey, function()
						local arr = {}
						for k in pairs(selectedSet) do
							table.insert(arr, k)
						end
						return arr
					end, function(v)
						selectedSet = {}
						if type(v) == "table" then
							for _, x in ipairs(v) do
								selectedSet[tostring(x)] = true
							end
						end
						rebuild()
						refreshMain()
					end)
				end

				window:RegisterSearchEntry(row, o.Name or "")
				return {
					Get = function()
						local arr = {}
						for k in pairs(selectedSet) do
							table.insert(arr, k)
						end
						return arr
					end,
					Destroy = function()
						row:Destroy()
					end,
				}
			end

			function section:CreateInput(o)
				o = o or {}
				local row = Instance.new("Frame")
				row.BackgroundTransparency = 1
				row.Size = UDim2.new(1, 0, 0, 0)
				row.AutomaticSize = Enum.AutomaticSize.Y
				row.Parent = content

				textLabel(row, {
					Text = o.Name or "Input",
					Font = s.FontTitle,
					TextSize = 15,
					TextColor3 = s.Text,
					Size = UDim2.new(1, 0, 0, 20),
					TextXAlignment = Enum.TextXAlignment.Left,
				})
				if o.Description and o.Description ~= "" then
					textLabel(row, {
						Text = o.Description,
						Font = s.FontBody,
						TextSize = 12,
						TextColor3 = s.TextMuted,
						TextWrapped = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0),
						TextXAlignment = Enum.TextXAlignment.Left,
					})
				end

				local box = Instance.new("TextBox")
				box.Size = UDim2.new(1, 0, 0, 38)
				box.BackgroundColor3 = s.Surface
				box.TextColor3 = s.Text
				box.PlaceholderText = o.Placeholder or "Type here..."
				box.PlaceholderColor3 = s.TextMuted
				box.Text = o.Default or ""
				box.ClearTextOnFocus = false
				box.Font = s.FontBody
				box.TextSize = 14
				box.TextXAlignment = Enum.TextXAlignment.Left
				box.Parent = row
				createCorner(box, 8)
				createPadding(box, 10)

				box.FocusLost:Connect(function()
					if o.Callback then
						o.Callback(box.Text)
					end
				end)

				if o.ConfigKey then
					window:RegisterConfigKey(o.ConfigKey, function()
						return box.Text
					end, function(v)
						box.Text = tostring(v or "")
					end)
				end

				window:RegisterSearchEntry(row, (o.Name or "") .. " " .. (o.Description or ""))
				return {
					Get = function()
						return box.Text
					end,
					Set = function(v)
						box.Text = v
					end,
					Destroy = function()
						row:Destroy()
					end,
				}
			end

			function section:CreateKeybind(o)
				o = o or {}
				local key = o.Default or Enum.KeyCode.RightControl
				local listening = false

				local row = Instance.new("Frame")
				row.BackgroundTransparency = 1
				row.Size = UDim2.new(1, 0, 0, 44)
				row.Parent = content

				textLabel(row, {
					Text = o.Name or "Keybind",
					Font = s.FontTitle,
					TextSize = 15,
					TextColor3 = s.Text,
					Size = UDim2.new(1, -120, 1, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
				})

				local binder = textButton(row, {
					Text = key and key.Name or "...",
					Size = UDim2.fromOffset(110, 34),
					Position = UDim2.new(1, -110, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundColor3 = s.SurfaceElevated,
					TextColor3 = s.Text,
					Corner = 8,
				})

				binder.MouseButton1Click:Connect(function()
					listening = true
					binder.Text = "..."
				end)

				local conn = UserInputService.InputBegan:Connect(function(input, gp)
					if gp then
						return
					end
					if listening then
						if input.UserInputType == Enum.UserInputType.Keyboard then
							key = input.KeyCode
							binder.Text = key.Name
							listening = false
							if o.OnBind then
								o.OnBind(key)
							end
						end
					elseif input.KeyCode == key then
						if o.Callback then
							o.Callback(key)
						end
					end
				end)
				track(conn)

				if o.ConfigKey then
					window:RegisterConfigKey(o.ConfigKey, function()
						return key and key.Name or "Unknown"
					end, function(v)
						local k = Enum.KeyCode[tostring(v)]
						if k then
							key = k
							binder.Text = key.Name
						end
					end)
				end

				window:RegisterSearchEntry(row, o.Name or "")
				return {
					Get = function()
						return key
					end,
					Set = function(k)
						key = k
						binder.Text = key.Name
					end,
					Destroy = function()
						conn:Disconnect()
						row:Destroy()
					end,
				}
			end

			function section:CreateColorPicker(o)
				o = o or {}
				local c = parseColor3(o.Default or Color3.fromRGB(255, 255, 255))

				local row = Instance.new("Frame")
				row.BackgroundTransparency = 1
				row.Size = UDim2.new(1, 0, 0, 0)
				row.AutomaticSize = Enum.AutomaticSize.Y
				row.Parent = content

				textLabel(row, {
					Text = o.Name or "Color",
					Font = s.FontTitle,
					TextSize = 15,
					TextColor3 = s.Text,
					Size = UDim2.new(1, 0, 0, 20),
					TextXAlignment = Enum.TextXAlignment.Left,
				})

				local preview = Instance.new("Frame")
				preview.Size = UDim2.new(1, 0, 0, 28)
				preview.BackgroundColor3 = c
				preview.Parent = row
				createCorner(preview, 8)
				createStroke(preview, s.Stroke, 1)

				local sliders = { "R", "G", "B" }
				local vals = { math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255) }
				local function apply()
					c = Color3.fromRGB(vals[1], vals[2], vals[3])
					preview.BackgroundColor3 = c
					if o.Callback then
						o.Callback(c)
					end
				end

				for i, name in ipairs(sliders) do
					local trackFr = Instance.new("Frame")
					trackFr.Size = UDim2.new(1, 0, 0, 10)
					trackFr.BackgroundColor3 = s.Surface
					trackFr.Parent = row
					createCorner(trackFr, 5)
					local fill = Instance.new("Frame")
					fill.Size = UDim2.new(vals[i] / 255, 0, 1, 0)
					fill.BackgroundColor3 = Color3.fromRGB(name == "R" and 255 or 0, name == "G" and 255 or 0, name == "B" and 255 or 0)
					fill.BorderSizePixel = 0
					fill.Parent = trackFr
					createCorner(fill, 5)
					local dragging = false
					local hit = Instance.new("TextButton")
					hit.Text = ""
					hit.Size = UDim2.fromScale(1, 1)
					hit.BackgroundTransparency = 1
					hit.Parent = trackFr
					hit.MouseButton1Down:Connect(function()
						dragging = true
					end)
					UserInputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							dragging = false
						end
					end)
					UserInputService.InputChanged:Connect(function(input)
						if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
							local absPos = trackFr.AbsolutePosition
							local absSize = trackFr.AbsoluteSize
							local mouse = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
							local a = math.clamp((mouse.X - absPos.X) / absSize.X, 0, 1)
							vals[i] = math.floor(a * 255)
							fill.Size = UDim2.new(a, 0, 1, 0)
							apply()
						end
					end)
				end

				if o.ConfigKey then
					window:RegisterConfigKey(o.ConfigKey, function()
						return color3ToTable(c)
					end, function(v)
						c = tableToColor3(v)
						vals = { math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255) }
						preview.BackgroundColor3 = c
					end)
				end

				window:RegisterSearchEntry(row, o.Name or "")
				return {
					Get = function()
						return c
					end,
					Set = function(col)
						c = parseColor3(col)
						preview.BackgroundColor3 = c
					end,
					Destroy = function()
						row:Destroy()
					end,
				}
			end

			section.CreateTextBox = section.CreateInput

			return section
		end

		function tabObject:CreateLabel(o)
			o = o or {}
			local s = state.theme
			local lbl = textLabel(pageScroll, {
				Text = o.Text or "Label",
				Font = s.FontBody,
				TextSize = o.TextSize or 14,
				TextColor3 = o.Color and parseColor3(o.Color) or s.TextMuted,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, -8, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			local api = {}
			function api:SetText(v)
				lbl.Text = tostring(v)
			end
			function api:Destroy()
				lbl:Destroy()
			end
			window:RegisterSearchEntry(lbl, o.Text or "")
			return api
		end

		function tabObject:CreateParagraph(o)
			o = o or {}
			local s = state.theme
			local fr = Instance.new("Frame")
			fr.BackgroundTransparency = 1
			fr.Size = UDim2.new(1, -8, 0, 0)
			fr.AutomaticSize = Enum.AutomaticSize.Y
			fr.Parent = pageScroll
			textLabel(fr, {
				Text = o.Title or "Paragraph",
				Font = s.FontTitle,
				TextSize = 14,
				TextColor3 = s.Text,
				Size = UDim2.new(1, 0, 0, 20),
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			textLabel(fr, {
				Text = o.Content or "",
				Font = s.FontBody,
				TextSize = 13,
				TextColor3 = s.TextMuted,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			window:RegisterSearchEntry(fr, (o.Title or "") .. " " .. (o.Content or ""))
			return {
				Destroy = function()
					fr:Destroy()
				end,
			}
		end

		return tabObject
	end

	return window
end

return Vellum
