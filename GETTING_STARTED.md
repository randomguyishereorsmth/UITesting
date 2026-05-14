# 🚀 Rift GUI - Getting Started Guide

Welcome to Rift GUI! This guide will help you create your first GUI in minutes.

## Prerequisites

- Roblox Studio or a LocalScript in a game
- Basic Lua knowledge (helpful but not required)
- Internet connection (for loadstring)

## Step 1: Load the Library

In your LocalScript, add this line:

```lua
local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()
```

That's it! The library is now ready to use.

## Step 2: Create Your First Window

```lua
local window = Rift.Window.new(
    "My First GUI",      -- Title
    "Hello World!",      -- Subtitle (optional)
    "👋"                 -- Icon/Emoji (optional)
)
```

Your window is now created but it's empty. Let's add content.

## Step 3: Add Tabs

Tabs organize your GUI into sections. Create at least one tab:

```lua
local homeTab = Rift.Tab.new(
    window,              -- Parent window
    "Home",              -- Tab name
    "🏠",                -- Icon
    "Home tab"           -- Description (optional)
)
```

You can create multiple tabs:

```lua
local settingsTab = Rift.Tab.new(window, "Settings", "⚙️", "Settings")
local aboutTab = Rift.Tab.new(window, "About", "ℹ️", "About")
```

## Step 4: Add Sections

Sections organize content within tabs:

```lua
local section = homeTab:AddSection(
    "Welcome",           -- Section title
    "Click the button"   -- Description (optional)
)
```

## Step 5: Add UI Elements

Now add components to your section:

### Button

```lua
Rift.Button.new(
    section,
    "Click Me",                      -- Label
    "Click to see what happens",     -- Description
    function()
        print("Button clicked!")
        window:Notify("Success", "You clicked the button!", "Success")
    end
)
```

### Toggle Switch

```lua
Rift.Toggle.new(
    section,
    "Enable Feature",                -- Label
    "Toggle this on and off",        -- Description
    false,                           -- Default value (off)
    function(value)
        print("Toggle is: " .. tostring(value))
    end
)
```

### Slider

```lua
Rift.Slider.new(
    section,
    "Volume",                        -- Label
    "Adjust volume",                 -- Description
    0,                               -- Minimum value
    100,                             -- Maximum value
    5,                               -- Increment (step)
    50,                              -- Default value
    function(value)
        print("Volume: " .. value)
    end
)
```

### Dropdown

```lua
Rift.Dropdown.new(
    section,
    "Game Mode",                     -- Label
    "Choose your mode",              -- Description
    {"Easy", "Normal", "Hard"},      -- Options
    "Normal",                        -- Default selection
    function(value)
        print("Mode: " .. value)
    end
)
```

### Textbox

```lua
Rift.Textbox.new(
    section,
    "Name",                          -- Label
    "Enter your name",               -- Placeholder
    "",                              -- Default text
    function(text)
        print("Name: " .. text)
    end
)
```

### Label

```lua
Rift.Label.new(section, "This is a simple label")
```

### Paragraph

```lua
Rift.Paragraph.new(
    section,
    "Instructions",                  -- Title
    "Here's a longer text block... " -- Content
)
```

## Complete Example

Here's a complete working example:

```lua
-- Load the library
local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()

-- Create window
local window = Rift.Window.new("My App", "v1.0", "🎮")

-- Create tab
local tab = Rift.Tab.new(window, "Main", "🏠")

-- Create sections
local controlSection = tab:AddSection("Controls")
local statsSection = tab:AddSection("Stats")

-- Add controls
Rift.Button.new(controlSection, "Start", "Begin", function()
    window:Notify("Started", "App is running!", "Success")
end)

Rift.Toggle.new(controlSection, "Sound", "", true, function(value)
    print("Sound: " .. tostring(value))
end)

Rift.Slider.new(controlSection, "Speed", "", 0, 100, 1, 50)

-- Add stats labels
Rift.Label.new(statsSection, "Players: 10")
Rift.Label.new(statsSection, "Ping: 45ms")
```

## Customization

### Change Window Size

```lua
local window = Rift.Window.new(
    "Title",
    "Subtitle",
    nil,
    UDim2.new(0, 800, 0, 600)  -- 800px wide, 600px tall
)
```

### Use a Custom Theme

```lua
local myTheme = {
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

local window = Rift.Window.new("My App", "", nil, nil, myTheme)
```

### Handle Button Clicks

```lua
Rift.Button.new(section, "Action", "", function()
    -- Your code here
    print("Button was clicked!")
    window:Notify("Title", "Message", "Success")
end)
```

### Show Notifications

```lua
-- Success
window:Notify("Complete", "Operation finished!", "Success", 2)

-- Warning
window:Notify("Caution", "This action is permanent", "Warning", 3)

-- Error
window:Notify("Error", "Something went wrong", "Error", 3)

-- Info
window:Notify("Info", "Here's some information", "Info", 3)
```

## Common Tasks

### Store User Input

```lua
local userName = ""

Rift.Textbox.new(section, "Name", "Enter name", "", function(text)
    userName = text
    print("User entered: " .. userName)
end)
```

### Get Toggle State

```lua
local myToggle = Rift.Toggle.new(section, "Feature", "", false, function(value)
    print("Current state: " .. tostring(value))
end)

-- Access state later
print(myToggle.Enabled)
```

### Get Slider Value

```lua
local mySlider = Rift.Slider.new(section, "Value", "", 0, 100, 1, 50, function(value)
    print("Value: " .. value)
end)

-- Access value later
print("Current value: " .. mySlider.Value)
```

### Get Dropdown Selection

```lua
local myDropdown = Rift.Dropdown.new(section, "Mode", "", {"A", "B", "C"}, "A")

-- Access selection later
print("Selected: " .. myDropdown.SelectedValue)
```

## Keyboard Shortcuts

### Toggle GUI with F1

```lua
Rift.Keybind.new(section, "Toggle", "Show/hide GUI", Enum.KeyCode.F1, function()
    window.MainGui.Enabled = not window.MainGui.Enabled
end)
```

## Organizing Large GUIs

For complex GUIs, organize with multiple tabs and sections:

```lua
local window = Rift.Window.new("Complex App")

-- Tab 1: Main Controls
local mainTab = Rift.Tab.new(window, "Main", "🏠")
local mainSection = mainTab:AddSection("Controls")
-- Add elements...

-- Tab 2: Settings
local settingsTab = Rift.Tab.new(window, "Settings", "⚙️")
local audioSection = settingsTab:AddSection("Audio")
-- Add elements...
local graphicsSection = settingsTab:AddSection("Graphics")
-- Add elements...

-- Tab 3: About
local aboutTab = Rift.Tab.new(window, "About", "ℹ️")
local infoSection = aboutTab:AddSection("Information")
Rift.Paragraph.new(infoSection, "About", "Your app description here...")
```

## Best Practices

### ✅ DO

- Create one window per GUI
- Use sections to organize related elements
- Provide descriptions for complex elements
- Use notifications for user feedback
- Name elements clearly
- Test on mobile and desktop

### ❌ DON'T

- Create too many windows
- Put too many elements in one section
- Use generic names like "Button1", "Toggle2"
- Forget to handle callback errors
- Ignore theme consistency
- Create infinite loops in callbacks

## Troubleshooting

### GUI doesn't appear
- Make sure you're using a LocalScript
- Check HttpGet is enabled
- Verify internet connection
- Check console for errors

### Button doesn't work
- Make sure callback function is defined
- Check for errors in the callback
- Verify section is properly created

### Text is invisible
- Check theme color contrast
- Verify TextColor3 is different from background
- Try using default theme first

### Performance issues
- Reduce number of GUI elements
- Avoid updating GUI in loops
- Use appropriate animation durations
- Check for memory leaks

## Next Steps

1. **Read the [Full Documentation](DOCUMENTATION.md)** for detailed API reference
2. **Check the [Examples](EXAMPLES.lua)** for more complex use cases
3. **Customize with [Themes](API_REFERENCE.md#theme-reference)**
4. **Learn [Advanced Features](DOCUMENTATION.md#advanced-features)**

## Need Help?

- Check the [API Reference](API_REFERENCE.md)
- Look at [Examples](EXAMPLES.lua)
- Visit the GitHub Issues page
- Ask in the Discord community

---

## Summary

You now know how to:

✅ Load the Rift GUI library  
✅ Create windows, tabs, and sections  
✅ Add all UI components  
✅ Handle user interactions  
✅ Show notifications  
✅ Customize themes  

**Start building amazing GUIs!** 🎉
