# 🎨 Rift GUI - Professional Roblox UI Library

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Roblox](https://img.shields.io/badge/Roblox-Compatible-brightgreen)

A modern, lightweight, and fully-featured Roblox GUI library with smooth animations, comprehensive customization, and an intuitive API.

## ✨ Features

- 🎯 **Easy to Use API** - Simple, intuitive function-based design
- 🎨 **Beautiful UI Components** - Buttons, toggles, sliders, dropdowns, and more
- 🌈 **Theme Customization** - Create custom themes or use built-in presets
- ✨ **Smooth Animations** - Professional transitions and hover effects
- 📱 **Mobile & Desktop Compatible** - Works on all Roblox platforms
- 💾 **Config System** - Save and load GUI configurations
- 🔑 **Keybind Support** - Built-in key binding system
- 📢 **Notifications** - Beautiful notification popups
- 🚀 **High Performance** - Optimized for smooth gameplay

## 🚀 Quick Start

### Installation

```lua
local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()
```

### Basic Usage

```lua
-- Create a window
local window = Rift.Window.new("My GUI", "Subtitle", "🎮")

-- Add a tab
local tab = Rift.Tab.new(window, "Home", "🏠")

-- Add a section
local section = tab:AddSection("Controls")

-- Add components
Rift.Button.new(section, "Click Me", "Button description", function()
    window:Notify("Success", "Button clicked!", "Success")
end)

Rift.Toggle.new(section, "Enable Feature", "", false, function(value)
    print("Feature is " .. (value and "enabled" or "disabled"))
end)

Rift.Slider.new(section, "Speed", "", 0, 100, 1, 50, function(value)
    print("Speed: " .. value)
end)
```

## 📚 Components

### Available UI Elements

| Component | Description |
|-----------|-------------|
| **Window** | Main container for your GUI |
| **Tabs** | Organize content into sections |
| **Sections** | Group related elements |
| **Button** | Clickable button |
| **Toggle** | On/off switch |
| **Slider** | Value selector |
| **Dropdown** | Selection menu |
| **Textbox** | Text input field |
| **Label** | Simple text label |
| **Paragraph** | Formatted text block |
| **Color Picker** | Color selection |
| **Keybind** | Key binding |
| **Notification** | Popup message |

## 🎨 Theming

### Built-in Themes

```lua
-- Use the default theme
local window = Rift.Window.new("My GUI", "", nil, nil, Rift.DefaultTheme)

-- Or create a custom theme
local customTheme = {
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

local window = Rift.Window.new("My GUI", "", nil, nil, customTheme)
```

## 📖 Documentation

Full documentation is available in [DOCUMENTATION.md](DOCUMENTATION.md)

### Quick Reference

```lua
-- Window
local window = Rift.Window.new(title, subtitle, icon, size, theme)
window:SelectTab(tab)
window:Notify(title, description, type, duration)
window:SetTheme(theme)
window:SaveConfig(name)
window:LoadConfig(config)
window:Destroy()

-- Tab
local tab = Rift.Tab.new(window, name, icon, description)
local section = tab:AddSection(title, description)

-- Section
local section = Rift.Section.new(tab, title, description)

-- Components
Rift.Button.new(section, name, description, callback)
Rift.Toggle.new(section, name, description, defaultValue, callback)
Rift.Slider.new(section, name, description, min, max, increment, defaultValue, callback)
Rift.Dropdown.new(section, name, description, options, defaultValue, callback)
Rift.Textbox.new(section, name, placeholder, defaultText, callback)
Rift.Label.new(section, text)
Rift.Paragraph.new(section, title, text)
Rift.ColorPicker.new(section, name, description, defaultColor, callback)
Rift.Keybind.new(section, name, description, defaultKey, callback)
```

## 💡 Examples

### Simple Counter

```lua
local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()

local window = Rift.Window.new("Counter", "Click to count")
local tab = Rift.Tab.new(window, "Main", "🔢")
local section = tab:AddSection("Counter")

local count = 0

Rift.Button.new(section, "Increment", "Add 1", function()
    count = count + 1
    window:Notify("Count", "Count: " .. count, "Info")
end)

Rift.Button.new(section, "Decrement", "Subtract 1", function()
    count = count - 1
    window:Notify("Count", "Count: " .. count, "Info")
end)
```

### Game Control Panel

```lua
local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()

local window = Rift.Window.new("Game Panel", "v1.0", "🎮")

-- Player Stats
local statsTab = Rift.Tab.new(window, "Stats", "📊")
local statsSection = statsTab:AddSection("Character")

Rift.Label.new(statsSection, "Health: 100/100")
Rift.Label.new(statsSection, "Mana: 50/100")

-- Actions
local actionsTab = Rift.Tab.new(window, "Actions", "⚡")
local actionsSection = actionsTab:AddSection("Abilities")

Rift.Button.new(actionsSection, "Cast Fireball", "Deal 30 damage", function()
    window:Notify("Spell", "Fireball cast!", "Success")
end)

-- Settings
local settingsTab = Rift.Tab.new(window, "Settings", "⚙️")
local settingsSection = settingsTab:AddSection("Game Settings")

Rift.Slider.new(settingsSection, "Volume", "", 0, 100, 5, 70)
Rift.Toggle.new(settingsSection, "Sound", "", true)
Rift.Dropdown.new(settingsSection, "Quality", "", {"Low", "Medium", "High", "Ultra"}, "High")
```

More examples available in [EXAMPLES.lua](EXAMPLES.lua)

## 🛠️ Advanced Features

### Config System

```lua
-- Save configuration
local config = window:SaveConfig("MyConfig")

-- Load configuration
window:LoadConfig(config)
```

### Keybindings

```lua
Rift.Keybind.new(section, "Toggle GUI", "Show/hide GUI", Enum.KeyCode.F1, function()
    window.MainGui.Enabled = not window.MainGui.Enabled
end)
```

### Notifications

```lua
-- Different notification types
window:Notify("Title", "Success message", "Success", 2)
window:Notify("Title", "Info message", "Info", 3)
window:Notify("Title", "Warning message", "Warning", 3)
window:Notify("Title", "Error message", "Error", 3)
```

## 🎯 Use Cases

- Game automation scripts
- Admin panels
- Configuration menus
- Settings interfaces
- Data dashboards
- Inventory systems
- Profile managers
- Game mode selectors

## ⚙️ Requirements

- Roblox Studio or Roblox Game (LocalScript)
- `game:HttpGet()` enabled for loadstring
- `UserInputService` available
- `RunService` available

## 🐛 Troubleshooting

### GUI doesn't appear
- Ensure you're using a LocalScript
- Check that HttpGet is enabled
- Verify your internet connection

### Components not responding
- Make sure callbacks are properly defined
- Check parent section/tab creation
- Ensure UserInputService is available

### Animations are choppy
- Check your frame rate
- Reduce number of animated elements
- Verify RunService accessibility

## 📝 License

MIT License - Feel free to use this in your projects!

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## 📧 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/rift-gui/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/rift-gui/discussions)
- **Email**: your.email@example.com

## 🎉 Credits

Created by [Your Name]  
Inspired by popular Roblox GUI libraries

## 📦 Version History

### v1.0.0 (Current)
- Initial release
- All core components
- Theming system
- Config save/load
- Notifications
- Smooth animations
- Mobile & Desktop support

---

**Made with ❤️ for the Roblox community**

[⬆ back to top](#-rift-gui---professional-roblox-ui-library)
