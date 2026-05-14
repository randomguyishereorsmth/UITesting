# 🔧 Rift GUI - Complete API Reference

## Table of Contents

1. [Window API](#window-api)
2. [Tab API](#tab-api)
3. [Section API](#section-api)
4. [Component APIs](#component-apis)
5. [Theme Reference](#theme-reference)
6. [Constants](#constants)

---

## Window API

### Window.new()

Creates a new GUI window.

**Syntax:**
```lua
local window = Rift.Window.new(title, subtitle, icon, size, theme)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `title` | string | "Rift GUI" | Window title displayed in the title bar |
| `subtitle` | string | "" | Secondary text below title (optional) |
| `icon` | string | nil | Icon or emoji for window identification |
| `size` | UDim2 | UDim2.new(0, 600, 0, 500) | Window size (width, height) |
| `theme` | table | DefaultTheme | Theme table with color definitions |

**Returns:**
- Window object with methods and properties

**Example:**
```lua
local window = Rift.Window.new(
    "My Application",
    "Version 1.0",
    "🚀",
    UDim2.new(0, 700, 0, 600),
    customTheme
)
```

---

### Window Properties

| Property | Type | Access | Description |
|----------|------|--------|-------------|
| `Title` | string | R/W | Window title |
| `Subtitle` | string | R/W | Window subtitle |
| `Theme` | table | R/W | Current theme |
| `Tabs` | table | R | Array of tabs |
| `ActiveTab` | Tab | R | Currently selected tab |
| `Minimized` | boolean | R | Is window minimized |
| `MainGui` | ScreenGui | R | Root GUI element |
| `Window` | Frame | R | Main window frame |
| `Config` | table | R | Saved configuration |

---

### window:SelectTab(tab)

Switches to a specific tab and displays its content.

**Syntax:**
```lua
window:SelectTab(tab)
```

**Parameters:**

| Name | Type | Description |
|------|------|-------------|
| `tab` | Tab | Tab object to select |

**Returns:** None

**Example:**
```lua
local tab1 = Rift.Tab.new(window, "Home", "🏠")
local tab2 = Rift.Tab.new(window, "Settings", "⚙️")

-- Switch to tab2
window:SelectTab(tab2)
```

---

### window:Notify(title, description, type, duration)

Shows a notification popup.

**Syntax:**
```lua
window:Notify(title, description, notificationType, duration)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `title` | string | "Notification" | Notification title |
| `description` | string | "" | Notification message |
| `type` | string | "Info" | "Info", "Success", "Warning", or "Error" |
| `duration` | number | 3 | How long to display (seconds) |

**Returns:** Notification object

**Example:**
```lua
-- Success notification
window:Notify("Complete", "Operation finished successfully!", "Success", 2)

-- Error notification
window:Notify("Error", "Something went wrong", "Error", 3)

-- Warning notification
window:Notify("Warning", "This action is permanent", "Warning", 4)

-- Info notification
window:Notify("Info", "Check your settings", "Info", 3)
```

---

### window:SetTheme(theme)

Changes the window theme.

**Syntax:**
```lua
window:SetTheme(newTheme)
```

**Parameters:**

| Name | Type | Description |
|------|------|-------------|
| `theme` | table | Theme table with color definitions |

**Returns:** None

**Example:**
```lua
local darkTheme = {
    Primary = Color3.fromRGB(20, 20, 30),
    -- ... other colors
}

window:SetTheme(darkTheme)
```

---

### window:SaveConfig(configName)

Saves the window configuration including tab and component states.

**Syntax:**
```lua
local config = window:SaveConfig(configName)
```

**Parameters:**

| Name | Type | Description |
|------|------|-------------|
| `configName` | string | Name for the configuration |

**Returns:** Configuration table

**Example:**
```lua
local config = window:SaveConfig("UserPreferences")
print(config)
-- Returns a table with all window settings
```

---

### window:LoadConfig(config)

Loads a previously saved configuration.

**Syntax:**
```lua
window:LoadConfig(config)
```

**Parameters:**

| Name | Type | Description |
|------|------|-------------|
| `config` | table | Configuration table from SaveConfig |

**Returns:** None

**Example:**
```lua
local savedConfig = window:SaveConfig("MyConfig")
-- ... later ...
window:LoadConfig(savedConfig)
```

---

### window:Destroy()

Destroys the window and all its children.

**Syntax:**
```lua
window:Destroy()
```

**Parameters:** None

**Returns:** None

**Example:**
```lua
window:Destroy()
-- GUI is now gone
```

---

## Tab API

### Tab.new(window, name, icon, description)

Creates a new tab within a window.

**Syntax:**
```lua
local tab = Rift.Tab.new(window, name, icon, description)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `window` | Window | required | Parent window object |
| `name` | string | "Tab" | Tab label/name |
| `icon` | string | "📋" | Icon or emoji for the tab |
| `description` | string | "" | Tooltip/description text |

**Returns:** Tab object

**Example:**
```lua
local homeTab = Rift.Tab.new(window, "Home", "🏠", "Home tab")
local settingsTab = Rift.Tab.new(window, "Settings", "⚙️", "Settings tab")
local aboutTab = Rift.Tab.new(window, "About", "ℹ️", "About this app")
```

---

### Tab Properties

| Property | Type | Access | Description |
|----------|------|--------|-------------|
| `Name` | string | R | Tab name |
| `Icon` | string | R | Tab icon |
| `Window` | Window | R | Parent window |
| `Sections` | table | R | Array of sections |
| `Content` | Frame | R | Content frame |

---

### tab:AddSection(title, description)

Creates a new section within the tab.

**Syntax:**
```lua
local section = tab:AddSection(title, description)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `title` | string | "Section" | Section title |
| `description` | string | "" | Section description |

**Returns:** Section object

**Example:**
```lua
local mainSection = tab:AddSection("Main Controls", "Primary controls")
local advancedSection = tab:AddSection("Advanced", "Advanced options")
```

---

## Section API

### Section.new(tab, title, description)

Creates a new section within a tab.

**Syntax:**
```lua
local section = Rift.Section.new(tab, title, description)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `tab` | Tab | required | Parent tab object |
| `title` | string | "Section" | Section header title |
| `description` | string | "" | Optional description text |

**Returns:** Section object

**Example:**
```lua
local section = Rift.Section.new(tab, "Character Stats", "Your character information")
```

---

### Section Properties

| Property | Type | Access | Description |
|----------|------|--------|-------------|
| `Title` | string | R | Section title |
| `Tab` | Tab | R | Parent tab |
| `Elements` | table | R | Array of elements |
| `Container` | Frame | R | Section container |

---

## Component APIs

### Button

#### Button.new(section, name, description, callback)

Creates a clickable button.

**Syntax:**
```lua
local button = Rift.Button.new(section, name, description, callback)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Button" | Button label |
| `description` | string | "" | Button description |
| `callback` | function | function() end | Function called on click |

**Returns:** Button object

**Properties:**
- `Name` (string) - Button label
- `Description` (string) - Button description
- `Callback` (function) - Click handler

**Example:**
```lua
Rift.Button.new(section, "Start Game", "Begin playing", function()
    print("Game started!")
    window:Notify("Started", "Game is running", "Success")
end)
```

---

### Toggle

#### Toggle.new(section, name, description, defaultValue, callback)

Creates an on/off toggle switch.

**Syntax:**
```lua
local toggle = Rift.Toggle.new(section, name, description, defaultValue, callback)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Toggle" | Toggle label |
| `description` | string | "" | Toggle description |
| `defaultValue` | boolean | false | Initial state (on/off) |
| `callback` | function | function() end | Called with new state |

**Returns:** Toggle object

**Properties:**
- `Enabled` (boolean) - Current toggle state
- `Name` (string) - Toggle label
- `Description` (string) - Toggle description
- `Callback` (function) - State change handler

**Example:**
```lua
local toggle = Rift.Toggle.new(
    section,
    "Infinite Stamina",
    "Never get tired",
    false,
    function(value)
        if value then
            print("Infinite stamina enabled")
        else
            print("Infinite stamina disabled")
        end
    end
)

-- Access current state
print(toggle.Enabled) -- true or false
```

---

### Slider

#### Slider.new(section, name, description, minValue, maxValue, increment, defaultValue, callback)

Creates a value slider.

**Syntax:**
```lua
local slider = Rift.Slider.new(section, name, description, min, max, increment, defaultValue, callback)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Slider" | Slider label |
| `description` | string | "" | Slider description |
| `minValue` | number | 0 | Minimum value |
| `maxValue` | number | 100 | Maximum value |
| `increment` | number | 1 | Step size |
| `defaultValue` | number | min | Initial value |
| `callback` | function | function() end | Called with new value |

**Returns:** Slider object

**Properties:**
- `Value` (number) - Current slider value
- `Min` (number) - Minimum value
- `Max` (number) - Maximum value
- `Increment` (number) - Step size
- `Name` (string) - Slider label

**Example:**
```lua
local slider = Rift.Slider.new(
    section,
    "Speed Multiplier",
    "Adjust game speed 0.5x to 3x",
    0.5,        -- min
    3,          -- max
    0.1,        -- increment
    1,          -- default
    function(value)
        print("Speed set to: " .. value .. "x")
        -- Apply value to your game
    end
)

-- Get current value
print("Current: " .. slider.Value)
```

---

### Dropdown

#### Dropdown.new(section, name, description, options, defaultValue, callback)

Creates a dropdown selection menu.

**Syntax:**
```lua
local dropdown = Rift.Dropdown.new(section, name, description, options, defaultValue, callback)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Dropdown" | Dropdown label |
| `description` | string | "" | Dropdown description |
| `options` | table | {} | Array of option strings |
| `defaultValue` | string | options[1] | Initial selection |
| `callback` | function | function() end | Called with selected value |

**Returns:** Dropdown object

**Properties:**
- `SelectedValue` (string) - Currently selected option
- `Options` (table) - Available options
- `Name` (string) - Dropdown label
- `Open` (boolean) - Is dropdown open

**Methods:**
- `dropdown:SetOpen(isOpen)` - Open/close the dropdown

**Example:**
```lua
local dropdown = Rift.Dropdown.new(
    section,
    "Game Difficulty",
    "Choose your difficulty",
    {"Easy", "Normal", "Hard", "Insane"},
    "Normal",
    function(value)
        print("Difficulty: " .. value)
    end
)

-- Get selected value
print("Selected: " .. dropdown.SelectedValue)

-- Open/close
dropdown:SetOpen(true)
```

---

### Textbox

#### Textbox.new(section, name, placeholder, defaultText, callback)

Creates a text input field.

**Syntax:**
```lua
local textbox = Rift.Textbox.new(section, name, placeholder, defaultText, callback)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Textbox" | Textbox label |
| `placeholder` | string | "Enter text..." | Placeholder text |
| `defaultText` | string | "" | Initial text |
| `callback` | function | function() end | Called on focus lost |

**Returns:** Textbox object

**Properties:**
- `Text` (string) - Current text content
- `Name` (string) - Textbox label
- `Placeholder` (string) - Placeholder text

**Example:**
```lua
local textbox = Rift.Textbox.new(
    section,
    "Username",
    "Enter your username",
    "",
    function(text)
        print("Username: " .. text)
    end
)

-- Get current text
print("Text: " .. textbox.Text)
```

---

### Label

#### Label.new(section, text)

Creates a simple text label.

**Syntax:**
```lua
local label = Rift.Label.new(section, text)
```

**Parameters:**

| Name | Type | Description |
|------|------|-------------|
| `section` | Section | Parent section |
| `text` | string | Label text |

**Returns:** Label object

**Example:**
```lua
Rift.Label.new(section, "Health: 100/100")
Rift.Label.new(section, "Mana: 50/100")
Rift.Label.new(section, "Level: 10")
```

---

### Paragraph

#### Paragraph.new(section, title, text)

Creates a formatted text block with title.

**Syntax:**
```lua
local paragraph = Rift.Paragraph.new(section, title, text)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `title` | string | "" | Paragraph title |
| `text` | string | "" | Paragraph content |

**Returns:** Paragraph object

**Example:**
```lua
Rift.Paragraph.new(
    section,
    "Instructions",
    "Click the buttons above to perform actions. Use toggles to enable/disable features. Adjust sliders to change values."
)
```

---

### Color Picker

#### ColorPicker.new(section, name, description, defaultColor, callback)

Creates a color selection button.

**Syntax:**
```lua
local colorPicker = Rift.ColorPicker.new(section, name, description, defaultColor, callback)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Color" | Color picker label |
| `description` | string | "" | Color picker description |
| `defaultColor` | Color3 | RGB(0, 150, 255) | Initial color |
| `callback` | function | function() end | Called on color change |

**Returns:** ColorPicker object

**Properties:**
- `Color` (Color3) - Current selected color
- `Name` (string) - Color picker label

**Methods:**
- `colorPicker:SetColor(newColor)` - Set the color

**Example:**
```lua
local colorPicker = Rift.ColorPicker.new(
    section,
    "Primary Color",
    "Choose your UI color",
    Color3.fromRGB(0, 150, 255),
    function(color)
        print("Color selected!")
    end
)

-- Get current color
print(colorPicker.Color)

-- Set new color
colorPicker:SetColor(Color3.fromRGB(255, 100, 50))
```

---

### Keybind

#### Keybind.new(section, name, description, defaultKey, callback)

Creates a keybind button.

**Syntax:**
```lua
local keybind = Rift.Keybind.new(section, name, description, defaultKey, callback)
```

**Parameters:**

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `section` | Section | required | Parent section |
| `name` | string | "Keybind" | Keybind label |
| `description` | string | "" | Keybind description |
| `defaultKey` | KeyCode | Enum.KeyCode.F1 | Default key |
| `callback` | function | function() end | Called when key is pressed |

**Returns:** Keybind object

**Properties:**
- `Key` (KeyCode) - Currently bound key
- `Name` (string) - Keybind label
- `Binding` (boolean) - Is currently binding

**Example:**
```lua
local keybind = Rift.Keybind.new(
    section,
    "Toggle GUI",
    "Show/hide the GUI",
    Enum.KeyCode.F1,
    function()
        print("Keybind activated!")
        window.MainGui.Enabled = not window.MainGui.Enabled
    end
)

-- Access the key
print("Bound to: " .. keybind.Key.Name)
```

---

## Theme Reference

### Default Theme

```lua
{
    Primary = Color3.fromRGB(50, 50, 50),           -- Main background color
    Secondary = Color3.fromRGB(35, 35, 35),         -- Secondary background
    Accent = Color3.fromRGB(0, 150, 255),           -- Main accent color
    Text = Color3.fromRGB(255, 255, 255),           -- Primary text color
    TextSecondary = Color3.fromRGB(180, 180, 180),  -- Secondary text color
    Border = Color3.fromRGB(60, 60, 60),            -- Border color
    Background = Color3.fromRGB(25, 25, 25),        -- Deep background
    Success = Color3.fromRGB(76, 175, 80),          -- Success/positive color
    Warning = Color3.fromRGB(255, 152, 0),          -- Warning color
    Error = Color3.fromRGB(244, 67, 54),            -- Error/negative color
    Hover = Color3.fromRGB(60, 60, 60),             -- Hover state color
}
```

### Theme Colors Explained

| Color | Used For |
|-------|----------|
| `Primary` | Main window background |
| `Secondary` | Buttons, tabs, dropdowns background |
| `Accent` | Highlighted elements, active buttons |
| `Text` | Primary text on dark backgrounds |
| `TextSecondary` | Descriptions, secondary text |
| `Border` | Borders and dividers |
| `Background` | Deepest background layer |
| `Success` | Success toggles, notifications |
| `Warning` | Warning notifications, danger indicators |
| `Error` | Error buttons, error notifications |
| `Hover` | Hover states on interactive elements |

### Creating Custom Themes

```lua
local neonTheme = {
    Primary = Color3.fromRGB(10, 10, 20),
    Secondary = Color3.fromRGB(15, 15, 35),
    Accent = Color3.fromRGB(0, 255, 150),
    Text = Color3.fromRGB(0, 255, 200),
    TextSecondary = Color3.fromRGB(0, 200, 150),
    Border = Color3.fromRGB(0, 255, 150),
    Background = Color3.fromRGB(5, 5, 15),
    Success = Color3.fromRGB(0, 255, 150),
    Warning = Color3.fromRGB(255, 255, 0),
    Error = Color3.fromRGB(255, 50, 150),
    Hover = Color3.fromRGB(0, 100, 100),
}

local window = Rift.Window.new("My GUI", "", nil, nil, neonTheme)
```

---

## Constants

### Built-in Constants

```lua
-- Default title bar height
TITLE_BAR_HEIGHT = 45

-- Default tab width
TAB_WIDTH = 120

-- Default padding
PADDING = 12

-- Default corner radius
CORNER_RADIUS = 8

-- Animation speed (in seconds)
ANIMATION_SPEED = 0.25
```

### KeyCode Examples

```lua
Enum.KeyCode.F1
Enum.KeyCode.F2
Enum.KeyCode.A
Enum.KeyCode.Space
Enum.KeyCode.Return
Enum.KeyCode.Backspace
-- ... and all other Roblox key codes
```

### Notification Types

```lua
"Info"     -- Informational notification
"Success"  -- Success notification (green)
"Warning"  -- Warning notification (orange)
"Error"    -- Error notification (red)
```

---

## Type Reference

### UDim2

Used for sizing and positioning:

```lua
UDim2.new(scaleX, offsetX, scaleY, offsetY)

-- Examples:
UDim2.new(0, 600, 0, 500)    -- 600px wide, 500px tall
UDim2.new(1, 0, 1, 0)         -- Full screen (100%)
UDim2.new(0.5, 0, 0.5, 0)     -- Half screen (50%)
```

### Color3

Used for colors:

```lua
Color3.fromRGB(red, green, blue)

-- Examples:
Color3.fromRGB(255, 255, 255) -- White
Color3.fromRGB(0, 0, 0)        -- Black
Color3.fromRGB(255, 0, 0)      -- Red
Color3.fromRGB(0, 255, 0)      -- Green
Color3.fromRGB(0, 0, 255)      -- Blue
```

---

**Last Updated**: May 13, 2026
