# 📚 Rift GUI Documentation

## Overview

Rift GUI is a modern, professional Roblox GUI library designed for creating beautiful, functional user interfaces. It features smooth animations, complete customization, and a comprehensive set of UI components.

**Version**: 1.0.0  
**GitHub**: github.com/yourusername/rift-gui  
**License**: MIT

---

## Table of Contents

1. [Installation](#installation)
2. [Quick Start](#quick-start)
3. [Window](#window)
4. [Tabs](#tabs)
5. [Sections](#sections)
6. [Components](#components)
7. [Themes](#themes)
8. [Advanced Features](#advanced-features)
9. [Examples](#examples)

---

## Installation

### Method 1: Direct Script Load

```lua
local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()
```

### Method 2: Manual Copy

1. Copy the `Rift_GUI.lua` file
2. Paste it into your script
3. Execute and require the module

```lua
local Rift = require(game.ServerScriptService.RiftGUI)
```

---

## Quick Start

Here's a minimal example to get you started:

```lua
local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()

-- Create a window
local window = Rift.Window.new("My First GUI", "Powered by Rift", nil, UDim2.new(0, 600, 0, 500))

-- Create a tab
local tab = Rift.Tab.new(window, "Home", "🏠", "Welcome tab")

-- Create a section
local section = Rift.Section.new(tab, "Controls", "Basic controls")

-- Add a button
local button = Rift.Button.new(section, "Click Me", "This is a button", function()
    print("Button clicked!")
end)

-- Add a toggle
local toggle = Rift.Toggle.new(section, "Enable Feature", "Toggle this on/off", false, function(value)
    print("Toggle is now: " .. tostring(value))
end)
```

---

## Window

### Creating a Window

```lua
local window = Rift.Window.new(title, subtitle, icon, size, theme)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | string | "Rift GUI" | Main window title |
| `subtitle` | string | "" | Subtitle text (optional) |
| `icon` | string | nil | Icon/emoji for the window |
| `size` | UDim2 | UDim2.new(0, 600, 0, 500) | Window size |
| `theme` | table | DefaultTheme | Custom theme (see Themes section) |

#### Returns

Window object with the following methods and properties:

| Property | Type | Description |
|----------|------|-------------|
| `Title` | string | Window title |
| `Subtitle` | string | Window subtitle |
| `Theme` | table | Current theme |
| `Tabs` | table | Array of tabs |
| `ActiveTab` | Tab | Currently selected tab |
| `MainGui` | ScreenGui | Root GUI object |
| `Window` | Frame | Main window frame |
| `Minimized` | boolean | Minimized state |

### Window Methods

#### `window:SelectTab(tab)`

Switches to a specific tab.

```lua
window:SelectTab(tab)
```

#### `window:Notify(title, description, type, duration)`

Shows a notification.

```lua
window:Notify("Success", "Operation completed!", "Success", 3)
```

Parameters:
- `title` (string): Notification title
- `description` (string): Notification text
- `type` (string): "Info", "Success", "Warning", or "Error"
- `duration` (number): Display time in seconds

#### `window:SetTheme(theme)`

Changes the window theme.

```lua
window:SetTheme(customTheme)
```

#### `window:SaveConfig(configName)`

Saves the window configuration.

```lua
local config = window:SaveConfig("MyConfig")
```

#### `window:LoadConfig(config)`

Loads a saved configuration.

```lua
window:LoadConfig(config)
```

#### `window:Destroy()`

Destroys the window and all its children.

```lua
window:Destroy()
```

---

## Tabs

### Creating a Tab

```lua
local tab = Rift.Tab.new(window, name, icon, description)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `window` | Window | required | Parent window |
| `name` | string | "Tab" | Tab name/label |
| `icon` | string | "📋" | Tab icon/emoji |
| `description` | string | "" | Tab description |

#### Returns

Tab object with the following methods:

| Method | Description |
|--------|-------------|
| `tab:AddSection(title, description)` | Creates a new section |

#### Example

```lua
local tab1 = Rift.Tab.new(window, "Home", "🏠", "Home tab")
local tab2 = Rift.Tab.new(window, "Settings", "⚙️", "Settings tab")
local tab3 = Rift.Tab.new(window, "About", "ℹ️", "About tab")
```

---

## Sections

### Creating a Section

```lua
local section = Rift.Section.new(tab, title, description)
```

Or using the tab method:

```lua
local section = tab:AddSection("My Section", "Section description")
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `tab` | Tab | required | Parent tab |
| `title` | string | "Section" | Section title |
| `description` | string | "" | Section description |

#### Returns

Section object that can contain UI elements.

#### Example

```lua
local section1 = tab:AddSection("Basic Controls", "Simple control elements")
local section2 = tab:AddSection("Advanced Settings", "Complex settings")
```

---

## Components

### Button

Creates a clickable button.

```lua
local button = Rift.Button.new(section, name, description, callback)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Button" | Button label |
| `description` | string | "" | Button description |
| `callback` | function | function() end | Function called on click |

#### Example

```lua
local button = Rift.Button.new(section, "Execute Script", "Click to run the script", function()
    print("Script executed!")
    window:Notify("Success", "Script ran successfully!", "Success", 2)
end)
```

---

### Toggle

Creates an on/off toggle switch.

```lua
local toggle = Rift.Toggle.new(section, name, description, defaultValue, callback)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Toggle" | Toggle label |
| `description` | string | "" | Toggle description |
| `defaultValue` | boolean | false | Initial state |
| `callback` | function | function() end | Called with boolean value |

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Enabled` | boolean | Current toggle state |

#### Example

```lua
local toggle = Rift.Toggle.new(section, "Infinite Stamina", "Never get tired", false, function(value)
    if value then
        print("Infinite stamina enabled!")
    else
        print("Infinite stamina disabled!")
    end
end)

-- Access the current state
print(toggle.Enabled)
```

---

### Slider

Creates a value slider.

```lua
local slider = Rift.Slider.new(section, name, description, minValue, maxValue, increment, defaultValue, callback)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Slider" | Slider label |
| `description` | string | "" | Slider description |
| `minValue` | number | 0 | Minimum value |
| `maxValue` | number | 100 | Maximum value |
| `increment` | number | 1 | Step size |
| `defaultValue` | number | minValue | Initial value |
| `callback` | function | function() end | Called with new value |

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Value` | number | Current slider value |
| `Min` | number | Minimum value |
| `Max` | number | Maximum value |

#### Example

```lua
local slider = Rift.Slider.new(section, "Speed Multiplier", "Adjust game speed", 0.5, 3, 0.1, 1, function(value)
    print("Speed set to: " .. value)
    -- Apply the value to your game
end)

-- Get current value
print("Current value: " .. slider.Value)
```

---

### Dropdown

Creates a dropdown selection menu.

```lua
local dropdown = Rift.Dropdown.new(section, name, description, options, defaultValue, callback)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Dropdown" | Dropdown label |
| `description` | string | "" | Dropdown description |
| `options` | table | {} | Array of option strings |
| `defaultValue` | string | options[1] | Initial selection |
| `callback` | function | function() end | Called with selected value |

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `SelectedValue` | string | Currently selected option |
| `Options` | table | Available options |

#### Methods

| Method | Description |
|--------|-------------|
| `dropdown:SetOpen(isOpen)` | Opens or closes the dropdown |

#### Example

```lua
local dropdown = Rift.Dropdown.new(
    section,
    "Game Mode",
    "Select your preferred game mode",
    {"Classic", "Survival", "Creative", "Adventure"},
    "Classic",
    function(value)
        print("Mode changed to: " .. value)
    end
)

-- Get selected value
print("Current mode: " .. dropdown.SelectedValue)
```

---

### Textbox

Creates a text input field.

```lua
local textbox = Rift.Textbox.new(section, name, placeholder, defaultText, callback)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Textbox" | Textbox label |
| `placeholder` | string | "Enter text..." | Placeholder text |
| `defaultText` | string | "" | Initial text |
| `callback` | function | function() end | Called when focus is lost |

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Text` | string | Current text content |
| `Placeholder` | string | Placeholder text |

#### Example

```lua
local textbox = Rift.Textbox.new(
    section,
    "Player Name",
    "Enter a player name",
    "",
    function(text)
        print("Name entered: " .. text)
        if text ~= "" then
            -- Process the name
        end
    end
)

-- Get current text
print("Text: " .. textbox.Text)
```

---

### Label

Creates a simple text label.

```lua
local label = Rift.Label.new(section, text)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `text` | string | "" | Label text |

#### Example

```lua
local label = Rift.Label.new(section, "This is a simple label")
```

---

### Paragraph

Creates a formatted text block with title and description.

```lua
local paragraph = Rift.Paragraph.new(section, title, text)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `title` | string | "" | Paragraph title |
| `text` | string | "" | Paragraph content |

#### Example

```lua
local paragraph = Rift.Paragraph.new(
    section,
    "Welcome",
    "This is a paragraph with formatted text. It can contain multiple lines and will wrap automatically."
)
```

---

### Color Picker

Creates a color selection button.

```lua
local colorPicker = Rift.ColorPicker.new(section, name, description, defaultColor, callback)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Color" | Color picker label |
| `description` | string | "" | Color picker description |
| `defaultColor` | Color3 | Color3.fromRGB(0, 150, 255) | Initial color |
| `callback` | function | function() end | Called when color is changed |

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Color` | Color3 | Current selected color |

#### Methods

| Method | Description |
|--------|-------------|
| `colorPicker:SetColor(newColor)` | Sets the color |

#### Example

```lua
local colorPicker = Rift.ColorPicker.new(
    section,
    "Primary Color",
    "Choose your primary UI color",
    Color3.fromRGB(0, 150, 255),
    function(color)
        print("Color changed!")
    end
)

-- Set a new color
colorPicker:SetColor(Color3.fromRGB(255, 100, 50))
```

---

### Keybind

Creates a keybind button.

```lua
local keybind = Rift.Keybind.new(section, name, description, defaultKey, callback)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Keybind" | Keybind label |
| `description` | string | "" | Keybind description |
| `defaultKey` | KeyCode | Enum.KeyCode.F1 | Default key |
| `callback` | function | function() end | Called when key is pressed |

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `Key` | KeyCode | Currently bound key |

#### Example

```lua
local keybind = Rift.Keybind.new(
    section,
    "Toggle GUI",
    "Press to show/hide the GUI",
    Enum.KeyCode.F1,
    function()
        print("Keybind activated!")
        -- Toggle your GUI visibility
    end
)

-- Access the key
print("Bound to: " .. keybind.Key.Name)
```

---

### Notifications

Show temporary notifications to the user.

```lua
window:Notify(title, description, notificationType, duration)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | string | "Notification" | Notification title |
| `description` | string | "" | Notification message |
| `notificationType` | string | "Info" | "Info", "Success", "Warning", or "Error" |
| `duration` | number | 3 | Display duration in seconds |

#### Example

```lua
-- Success notification
window:Notify("Success", "Operation completed successfully!", "Success", 2)

-- Warning notification
window:Notify("Warning", "This action cannot be undone", "Warning", 4)

-- Error notification
window:Notify("Error", "An error occurred", "Error", 3)

-- Info notification
window:Notify("Info", "Here's some useful information", "Info", 3)
```

---

## Themes

### Default Theme

Rift comes with a professional dark theme by default. Access it with:

```lua
local theme = Rift.DefaultTheme
```

#### Default Theme Properties

```lua
{
    Primary = Color3.fromRGB(50, 50, 50),           -- Main background
    Secondary = Color3.fromRGB(35, 35, 35),         -- Secondary background
    Accent = Color3.fromRGB(0, 150, 255),           -- Accent color
    Text = Color3.fromRGB(255, 255, 255),           -- Main text
    TextSecondary = Color3.fromRGB(180, 180, 180),  -- Secondary text
    Border = Color3.fromRGB(60, 60, 60),            -- Borders
    Background = Color3.fromRGB(25, 25, 25),        -- Deep background
    Success = Color3.fromRGB(76, 175, 80),          -- Success color
    Warning = Color3.fromRGB(255, 152, 0),          -- Warning color
    Error = Color3.fromRGB(244, 67, 54),            -- Error color
    Hover = Color3.fromRGB(60, 60, 60),             -- Hover color
}
```

### Creating a Custom Theme

```lua
local customTheme = {
    Primary = Color3.fromRGB(20, 20, 40),
    Secondary = Color3.fromRGB(30, 30, 60),
    Accent = Color3.fromRGB(100, 200, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(150, 150, 180),
    Border = Color3.fromRGB(50, 50, 80),
    Background = Color3.fromRGB(10, 10, 30),
    Success = Color3.fromRGB(100, 200, 100),
    Warning = Color3.fromRGB(255, 180, 50),
    Error = Color3.fromRGB(255, 100, 100),
    Hover = Color3.fromRGB(50, 50, 100),
}

local window = Rift.Window.new("My GUI", "", nil, UDim2.new(0, 600, 0, 500), customTheme)
```

---

## Advanced Features

### Window Configuration

#### Draggable Windows

Windows are draggable by default from the title bar.

#### Minimize/Maximize

Click the minus button in the title bar to minimize the window.

#### Resizable Windows (Future)

Windows will support resizing in future versions.

### Config System

Save and load GUI configurations:

```lua
-- Save configuration
local config = window:SaveConfig("MyConfig")

-- Load configuration
window:LoadConfig(config)
```

### Key Binding System

Keybinds automatically trigger callbacks when their assigned keys are pressed:

```lua
local keybind = Rift.Keybind.new(section, "Show/Hide", "", Enum.KeyCode.F1, function()
    window.MainGui.Enabled = not window.MainGui.Enabled
end)
```

---

## Examples

### Example 1: Basic Setup

```lua
local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()

-- Create window
local window = Rift.Window.new("My Script", "v1.0", "🎮", UDim2.new(0, 600, 0, 500))

-- Create tabs
local homeTab = Rift.Tab.new(window, "Home", "🏠")
local settingsTab = Rift.Tab.new(window, "Settings", "⚙️")

-- Home tab content
local homeSection = homeTab:AddSection("Features", "Main features")
Rift.Button.new(homeSection, "Start", "Start the script", function()
    window:Notify("Started", "Script is running!", "Success", 2)
end)

-- Settings tab content
local settingsSection = settingsTab:AddSection("Options")
local toggle = Rift.Toggle.new(settingsSection, "Debug Mode", "", false, function(value)
    print("Debug: " .. tostring(value))
end)
```

### Example 2: Complete Control Panel

```lua
local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()

local window = Rift.Window.new("Control Panel", "Full Featured", "⚙️")

-- Main tab
local mainTab = Rift.Tab.new(window, "Main", "🎮")
local mainSection = mainTab:AddSection("Player Controls")

-- Buttons
Rift.Button.new(mainSection, "Heal Player", "Restore health", function()
    window:Notify("Healing", "Player healed!", "Success", 2)
end)

Rift.Button.new(mainSection, "Reset Position", "Teleport to spawn", function()
    window:Notify("Reset", "Teleported to spawn", "Info", 2)
end)

-- Toggles
Rift.Toggle.new(mainSection, "Infinite Stamina", "", false, function(value)
    window:Notify(value and "Enabled" or "Disabled", "Infinite Stamina", "Info", 2)
end)

-- Sliders
Rift.Slider.new(mainSection, "Walk Speed", "", 5, 100, 5, 16, function(value)
    print("Speed: " .. value)
end)

Rift.Slider.new(mainSection, "Jump Power", "", 1, 100, 1, 50, function(value)
    print("Jump Power: " .. value)
end)

-- Dropdowns
Rift.Dropdown.new(mainSection, "Game Mode", "", 
    {"Easy", "Normal", "Hard", "Insane"},
    "Normal",
    function(value)
        window:Notify("Mode Changed", "Now playing " .. value, "Info", 2)
    end
)

-- Textbox
Rift.Textbox.new(mainSection, "Player Name", "Enter name", "", function(text)
    if text ~= "" then
        window:Notify("Name Set", "Name changed to " .. text, "Success", 2)
    end
end)

-- Color picker
Rift.ColorPicker.new(mainSection, "Primary Color", "", Color3.fromRGB(0, 150, 255))

-- Keybind
Rift.Keybind.new(mainSection, "Toggle GUI", "Press to show/hide", Enum.KeyCode.F1, function()
    window.MainGui.Enabled = not window.MainGui.Enabled
end)

-- Advanced tab
local advTab = Rift.Tab.new(window, "Advanced", "🔧")
local advSection = advTab:AddSection("Advanced Settings", "Complex options")

Rift.Toggle.new(advSection, "Developer Mode", "", false)
Rift.Slider.new(advSection, "Render Distance", "", 100, 512, 1, 256)

local devSection = advTab:AddSection("Info")
Rift.Paragraph.new(devSection, "About", "This is a comprehensive control panel built with Rift GUI. Visit github.com for more info.")
```

### Example 3: Settings Manager

```lua
local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()

local window = Rift.Window.new("Settings", "Manage preferences")

-- Create persistent settings
local settings = {
    sound = true,
    brightness = 0.8,
    quality = "High"
}

-- Settings tab
local settingsTab = Rift.Tab.new(window, "Preferences", "⚙️")
local audioSection = settingsTab:AddSection("Audio")
local graphicsSection = settingsTab:AddSection("Graphics")

-- Audio settings
Rift.Toggle.new(audioSection, "Sound Effects", "", settings.sound, function(value)
    settings.sound = value
end)

-- Graphics settings
Rift.Slider.new(graphicsSection, "Brightness", "", 0, 1, 0.1, settings.brightness, function(value)
    settings.brightness = value
end)

Rift.Dropdown.new(graphicsSection, "Quality", "", 
    {"Low", "Medium", "High", "Ultra"},
    settings.quality,
    function(value)
        settings.quality = value
    end
)

-- Save button
local actionSection = settingsTab:AddSection("Actions")
Rift.Button.new(actionSection, "Save Settings", "Save your preferences", function()
    local config = window:SaveConfig("UserSettings")
    window:Notify("Saved", "Settings saved successfully!", "Success", 2)
end)

Rift.Button.new(actionSection, "Reset to Default", "Reset all settings", function()
    settings.sound = true
    settings.brightness = 0.8
    settings.quality = "High"
    window:Notify("Reset", "Settings reset to default", "Info", 2)
end)
```

---

## Troubleshooting

### GUI doesn't appear
- Make sure you're executing this in a localscript or script with proper context
- Check that the game has UI elements enabled
- Verify your internet connection for loadstring

### Elements not responding
- Ensure your callbacks are properly defined
- Check that the parent section/tab is properly created
- Verify that UserInputService is available in your environment

### Animations are choppy
- Check your frame rate
- Reduce the number of animated elements
- Verify that RunService is accessible

### Components not visible
- Check theme colors for contrast
- Ensure window is not minimized
- Verify that ClipsDescendants is not causing overflow issues

---

## API Reference

### Core Classes

- `Rift.Window` - Main window container
- `Rift.Tab` - Tab container
- `Rift.Section` - Section container
- `Rift.Button` - Button component
- `Rift.Toggle` - Toggle switch
- `Rift.Slider` - Value slider
- `Rift.Dropdown` - Selection dropdown
- `Rift.Textbox` - Text input
- `Rift.Label` - Simple label
- `Rift.Paragraph` - Formatted text
- `Rift.ColorPicker` - Color selection
- `Rift.Keybind` - Key binding
- `Rift.Notification` - Notification popup

---

## License

Rift GUI is released under the MIT License. See LICENSE file for details.

---

## Support

For issues, suggestions, or contributions, visit:
- **GitHub**: github.com/yourusername/rift-gui
- **Discord**: [Discord server link]
- **Issues**: github.com/yourusername/rift-gui/issues

---

## Version History

### v1.0.0 (Current)
- Initial release
- All core components
- Theming system
- Config save/load
- Notifications
- Animations

---

**Last Updated**: May 13, 2026  
**Maintained by**: [Your Name]
