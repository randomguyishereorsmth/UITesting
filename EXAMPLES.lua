--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                   RIFT GUI - EXAMPLE SCRIPTS                 ║
    ║                    Usage Examples & Tutorials                 ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

-- =============================================================================
-- EXAMPLE 1: Hello World - Your First GUI
-- =============================================================================

--[[
This is the most basic example. It creates a simple window with one button.
Good for learning the basics.
]]

local function Example1_HelloWorld()
    local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()
    
    -- Create a window with title and size
    local window = Rift.Window.new(
        "Hello World",      -- Title
        "My First GUI",     -- Subtitle
        "👋",               -- Icon
        UDim2.new(0, 500, 0, 300)  -- Size (width, height)
    )
    
    -- Create a tab
    local tab = Rift.Tab.new(window, "Main", "🏠", "Main tab")
    
    -- Create a section
    local section = tab:AddSection("Welcome", "Click the button below")
    
    -- Add a button
    local button = Rift.Button.new(
        section,
        "Say Hello",
        "Click me!",
        function()
            print("Hello World!")
            window:Notify("Hello", "You clicked the button!", "Success", 2)
        end
    )
end

-- =============================================================================
-- EXAMPLE 2: All Components - Feature Showcase
-- =============================================================================

--[[
This example demonstrates every component available in Rift GUI.
Perfect for understanding what's possible.
]]

local function Example2_AllComponents()
    local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()
    
    local window = Rift.Window.new("Components Demo", "See all available elements", "🎨")
    
    -- =========== BUTTONS TAB ===========
    local buttonsTab = Rift.Tab.new(window, "Buttons", "🔘")
    local buttonSection = buttonsTab:AddSection("Button Styles")
    
    Rift.Button.new(buttonSection, "Primary Button", "Standard button", function()
        window:Notify("Clicked", "Primary button pressed", "Info")
    end)
    
    Rift.Button.new(buttonSection, "Action Button", "With description", function()
        window:Notify("Action", "Performing action...", "Info")
    end)
    
    Rift.Button.new(buttonSection, "Dangerous Button", "Use with caution", function()
        window:Notify("Warning", "This action was performed", "Warning")
    end)
    
    -- =========== TOGGLES TAB ===========
    local togglesTab = Rift.Tab.new(window, "Toggles", "🔘")
    local toggleSection = togglesTab:AddSection("Switch Controls")
    
    local toggle1 = Rift.Toggle.new(toggleSection, "Feature One", "Enable or disable", false, function(value)
        print("Feature One: " .. tostring(value))
        window:Notify("Toggle", "Feature One is " .. (value and "ON" or "OFF"))
    end)
    
    local toggle2 = Rift.Toggle.new(toggleSection, "Feature Two", "", true, function(value)
        print("Feature Two: " .. tostring(value))
    end)
    
    local toggle3 = Rift.Toggle.new(toggleSection, "Feature Three", "Disabled by default", false)
    
    -- =========== SLIDERS TAB ===========
    local slidersTab = Rift.Tab.new(window, "Sliders", "📊")
    local sliderSection = slidersTab:AddSection("Numeric Controls")
    
    Rift.Slider.new(sliderSection, "Speed", "Set speed 0-100", 0, 100, 1, 50, function(value)
        print("Speed: " .. value)
    end)
    
    Rift.Slider.new(sliderSection, "Volume", "Sound level 0-100", 0, 100, 5, 70, function(value)
        print("Volume: " .. value .. "%")
    end)
    
    Rift.Slider.new(sliderSection, "Opacity", "Set transparency 0-1", 0, 1, 0.05, 1, function(value)
        print("Opacity: " .. math.floor(value * 100) .. "%")
    end)
    
    -- =========== DROPDOWNS TAB ===========
    local dropdownsTab = Rift.Tab.new(window, "Dropdowns", "📋")
    local dropdownSection = dropdownsTab:AddSection("Selection Menus")
    
    Rift.Dropdown.new(
        dropdownSection,
        "Game Mode",
        "Choose your mode",
        {"Easy", "Normal", "Hard", "Impossible"},
        "Normal",
        function(value)
            window:Notify("Mode", "Selected: " .. value)
        end
    )
    
    Rift.Dropdown.new(
        dropdownSection,
        "Theme",
        "Select color scheme",
        {"Light", "Dark", "Custom"},
        "Dark",
        function(value)
            print("Theme: " .. value)
        end
    )
    
    -- =========== TEXTBOXES TAB ===========
    local textboxesTab = Rift.Tab.new(window, "Textboxes", "📝")
    local textboxSection = textboxesTab:AddSection("Text Input")
    
    Rift.Textbox.new(
        textboxSection,
        "Username",
        "Enter your username",
        "",
        function(text)
            if text ~= "" then
                window:Notify("Name", "Username set to: " .. text, "Success")
            end
        end
    )
    
    Rift.Textbox.new(
        textboxSection,
        "Password",
        "Enter password",
        "",
        function(text)
            if text ~= "" then
                window:Notify("Password", "Password set", "Success")
            end
        end
    )
    
    -- =========== COLORS & INFO TAB ===========
    local infoTab = Rift.Tab.new(window, "Colors", "🎨")
    local colorSection = infoTab:AddSection("Color Selection")
    
    Rift.ColorPicker.new(
        colorSection,
        "Primary Color",
        "Main UI color",
        Color3.fromRGB(0, 150, 255),
        function()
            window:Notify("Color", "Color selected")
        end
    )
    
    Rift.ColorPicker.new(
        colorSection,
        "Secondary Color",
        "Accent color",
        Color3.fromRGB(255, 100, 50)
    )
    
    local labelSection = infoTab:AddSection("Information")
    Rift.Label.new(labelSection, "This is a simple label")
    
    Rift.Paragraph.new(
        labelSection,
        "How to Use",
        "This GUI demonstrates all available components. Each section shows different UI elements you can use in your own scripts."
    )
end

-- =============================================================================
-- EXAMPLE 3: Player Settings Manager
-- =============================================================================

--[[
A practical example of a settings GUI that could be used in-game.
Shows how to organize related settings logically.
]]

local function Example3_SettingsManager()
    local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()
    
    local window = Rift.Window.new("Player Settings", "Manage your preferences")
    
    -- Store settings
    local settings = {
        soundEnabled = true,
        musicVolume = 75,
        brightness = 85,
        gameMode = "Normal",
        playerName = "Player",
        primaryColor = Color3.fromRGB(0, 150, 255)
    }
    
    -- =========== AUDIO SETTINGS ===========
    local audioTab = Rift.Tab.new(window, "Audio", "🔊")
    local soundSection = audioTab:AddSection("Sound Settings")
    
    Rift.Toggle.new(
        soundSection,
        "Sound Effects",
        "Enable or disable sound",
        settings.soundEnabled,
        function(value)
            settings.soundEnabled = value
            print("Sound: " .. (value and "ON" or "OFF"))
        end
    )
    
    Rift.Slider.new(
        soundSection,
        "Music Volume",
        "Adjust music loudness",
        0, 100, 5,
        settings.musicVolume,
        function(value)
            settings.musicVolume = value
            print("Music Volume: " .. value .. "%")
        end
    )
    
    -- =========== GRAPHICS SETTINGS ===========
    local graphicsTab = Rift.Tab.new(window, "Graphics", "🎮")
    local displaySection = graphicsTab:AddSection("Display")
    
    Rift.Slider.new(
        displaySection,
        "Brightness",
        "Screen brightness 0-100",
        0, 100, 5,
        settings.brightness,
        function(value)
            settings.brightness = value
            print("Brightness: " .. value .. "%")
        end
    )
    
    local qualitySection = graphicsTab:AddSection("Quality")
    Rift.Dropdown.new(
        qualitySection,
        "Graphics Quality",
        "Choose rendering quality",
        {"Low", "Medium", "High", "Ultra"},
        "High",
        function(value)
            print("Quality: " .. value)
        end
    )
    
    -- =========== GAMEPLAY SETTINGS ===========
    local gameplayTab = Rift.Tab.new(window, "Gameplay", "🎯")
    local modeSection = gameplayTab:AddSection("Game Mode")
    
    Rift.Dropdown.new(
        modeSection,
        "Game Mode",
        "Select difficulty or mode",
        {"Easy", "Normal", "Hard", "Expert"},
        settings.gameMode,
        function(value)
            settings.gameMode = value
            window:Notify("Mode", "Game mode changed to " .. value, "Success")
        end
    )
    
    local playerSection = gameplayTab:AddSection("Player")
    Rift.Textbox.new(
        playerSection,
        "Player Name",
        "Enter your name",
        settings.playerName,
        function(text)
            if text ~= "" then
                settings.playerName = text
                window:Notify("Name", "Name changed to " .. text, "Success")
            end
        end
    )
    
    -- =========== APPEARANCE ===========
    local appearanceTab = Rift.Tab.new(window, "Appearance", "🎨")
    local colorSection = appearanceTab:AddSection("Colors")
    
    Rift.ColorPicker.new(
        colorSection,
        "Primary Color",
        "Main UI color",
        settings.primaryColor,
        function(color)
            settings.primaryColor = color
        end
    )
    
    -- =========== SAVE & LOAD ===========
    local advancedTab = Rift.Tab.new(window, "Advanced", "⚙️")
    local actionSection = advancedTab:AddSection("Configuration")
    
    Rift.Button.new(
        actionSection,
        "Save Settings",
        "Save your current settings",
        function()
            local config = window:SaveConfig("PlayerSettings")
            window:Notify("Saved", "Settings saved successfully!", "Success", 2)
            print("Settings saved:", config)
        end
    )
    
    Rift.Button.new(
        actionSection,
        "Reset to Default",
        "Reset all settings to default values",
        function()
            settings = {
                soundEnabled = true,
                musicVolume = 75,
                brightness = 85,
                gameMode = "Normal",
                playerName = "Player",
                primaryColor = Color3.fromRGB(0, 150, 255)
            }
            window:Notify("Reset", "Settings reset to default", "Info", 2)
        end
    )
    
    local infoSection = advancedTab:AddSection("Information")
    Rift.Paragraph.new(
        infoSection,
        "About Settings",
        "Your settings are automatically saved to your computer. They will be restored when you launch the game next time."
    )
end

-- =============================================================================
-- EXAMPLE 4: Game Control Panel
-- =============================================================================

--[[
A comprehensive control panel for a game with player stats and abilities.
Shows how to structure a complex multi-tab interface.
]]

local function Example4_GameControlPanel()
    local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()
    
    local window = Rift.Window.new("Game Control Panel", "v1.0", "🎮", UDim2.new(0, 700, 0, 600))
    
    -- Player stats
    local stats = {
        health = 100,
        mana = 50,
        stamina = 75,
        level = 1,
        experience = 0
    }
    
    -- =========== MAIN TAB ===========
    local mainTab = Rift.Tab.new(window, "Main", "🏠", "Main controls")
    local actionsSection = mainTab:AddSection("Quick Actions")
    
    Rift.Button.new(
        actionsSection,
        "Heal",
        "Restore health to maximum",
        function()
            stats.health = 100
            window:Notify("Healing", "Health restored!", "Success")
        end
    )
    
    Rift.Button.new(
        actionsSection,
        "Rest",
        "Restore stamina",
        function()
            stats.stamina = 100
            window:Notify("Rested", "Stamina restored!", "Success")
        end
    )
    
    Rift.Button.new(
        actionsSection,
        "Meditate",
        "Restore mana",
        function()
            stats.mana = 100
            window:Notify("Meditated", "Mana restored!", "Success")
        end
    )
    
    local statsSection = mainTab:AddSection("Character Stats")
    
    Rift.Label.new(statsSection, "Health: " .. stats.health .. "/100")
    Rift.Label.new(statsSection, "Mana: " .. stats.mana .. "/100")
    Rift.Label.new(statsSection, "Stamina: " .. stats.stamina .. "/100")
    Rift.Label.new(statsSection, "Level: " .. stats.level)
    
    -- =========== ABILITIES TAB ===========
    local abilitiesTab = Rift.Tab.new(window, "Abilities", "⚡")
    local abilitySection = abilitiesTab:AddSection("Skills")
    
    Rift.Button.new(
        abilitySection,
        "Fireball",
        "Deal 30 damage",
        function()
            window:Notify("Ability", "Fireball cast!", "Success")
        end
    )
    
    Rift.Button.new(
        abilitySection,
        "Heal",
        "Restore 50 health",
        function()
            stats.health = math.min(100, stats.health + 50)
            window:Notify("Ability", "Heal cast!", "Success")
        end
    )
    
    Rift.Button.new(
        abilitySection,
        "Dodge",
        "Evade next attack",
        function()
            window:Notify("Ability", "Dodge activated!", "Warning")
        end
    )
    
    -- =========== ITEMS TAB ===========
    local itemsTab = Rift.Tab.new(window, "Items", "🎒")
    local inventorySection = itemsTab:AddSection("Inventory")
    
    Rift.Button.new(
        inventorySection,
        "Use Health Potion",
        "Restore 30 health",
        function()
            stats.health = math.min(100, stats.health + 30)
            window:Notify("Item Used", "Health Potion used", "Success")
        end
    )
    
    Rift.Button.new(
        inventorySection,
        "Use Mana Potion",
        "Restore 25 mana",
        function()
            stats.mana = math.min(100, stats.mana + 25)
            window:Notify("Item Used", "Mana Potion used", "Success")
        end
    )
    
    Rift.Button.new(
        inventorySection,
        "Use Stamina Potion",
        "Restore 40 stamina",
        function()
            stats.stamina = math.min(100, stats.stamina + 40)
            window:Notify("Item Used", "Stamina Potion used", "Success")
        end
    )
    
    -- =========== SETTINGS TAB ===========
    local settingsTab = Rift.Tab.new(window, "Settings", "⚙️")
    local gameplaySection = settingsTab:AddSection("Gameplay")
    
    Rift.Toggle.new(
        gameplaySection,
        "Auto-Save",
        "Automatically save progress",
        true
    )
    
    Rift.Toggle.new(
        gameplaySection,
        "Blood Effects",
        "Show visual effects",
        true
    )
    
    Rift.Dropdown.new(
        gameplaySection,
        "Difficulty",
        "",
        {"Easy", "Normal", "Hard"},
        "Normal",
        function(value)
            window:Notify("Difficulty", "Changed to " .. value, "Info")
        end
    )
    
    local keybindSection = settingsTab:AddSection("Keybinds")
    Rift.Keybind.new(
        keybindSection,
        "Toggle GUI",
        "Show/hide this menu",
        Enum.KeyCode.F1,
        function()
            window.MainGui.Enabled = not window.MainGui.Enabled
        end
    )
end

-- =============================================================================
-- EXAMPLE 5: Theme Customization
-- =============================================================================

--[[
Shows how to create custom themes and apply them to windows.
Demonstrates all theme properties.
]]

local function Example5_ThemeCustomization()
    local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()
    
    -- Define custom themes
    local darkTheme = {
        Primary = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(100, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 150, 170),
        Border = Color3.fromRGB(50, 50, 70),
        Background = Color3.fromRGB(10, 10, 20),
        Success = Color3.fromRGB(100, 200, 100),
        Warning = Color3.fromRGB(255, 180, 50),
        Error = Color3.fromRGB(255, 100, 100),
        Hover = Color3.fromRGB(50, 50, 80),
    }
    
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
    
    -- Create window with dark theme
    local window = Rift.Window.new("Theme Demo", "Click theme buttons", nil, nil, darkTheme)
    
    local themeTab = Rift.Tab.new(window, "Themes", "🎨")
    local themeSection = themeTab:AddSection("Theme Selection")
    
    Rift.Button.new(
        themeSection,
        "Dark Theme",
        "Professional dark colors",
        function()
            window:SetTheme(darkTheme)
            window:Notify("Theme", "Dark theme applied", "Success")
        end
    )
    
    Rift.Button.new(
        themeSection,
        "Neon Theme",
        "Bright neon colors",
        function()
            window:SetTheme(neonTheme)
            window:Notify("Theme", "Neon theme applied", "Success")
        end
    )
    
    Rift.Button.new(
        themeSection,
        "Default Theme",
        "Rift default theme",
        function()
            window:SetTheme(Rift.DefaultTheme)
            window:Notify("Theme", "Default theme applied", "Success")
        end
    )
    
    local colorSection = themeTab:AddSection("Custom Colors")
    Rift.ColorPicker.new(
        colorSection,
        "Accent Color",
        "Change the accent color",
        Color3.fromRGB(100, 150, 255)
    )
end

-- =============================================================================
-- EXAMPLE 6: Advanced Form
-- =============================================================================

--[[
A complex form example with multiple input types.
Shows validation and form submission.
]]

local function Example6_AdvancedForm()
    local Rift = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/rift-gui/main/Rift_GUI.lua"))()
    
    local window = Rift.Window.new("Application Form", "Complete the form below")
    
    -- Form data
    local formData = {
        firstName = "",
        lastName = "",
        email = "",
        country = "USA",
        subscribe = false,
        theme = "Light"
    }
    
    local formTab = Rift.Tab.new(window, "Form", "📋")
    local personalSection = formTab:AddSection("Personal Information")
    
    Rift.Textbox.new(
        personalSection,
        "First Name",
        "Enter first name",
        "",
        function(text)
            formData.firstName = text
        end
    )
    
    Rift.Textbox.new(
        personalSection,
        "Last Name",
        "Enter last name",
        "",
        function(text)
            formData.lastName = text
        end
    )
    
    local contactSection = formTab:AddSection("Contact")
    Rift.Textbox.new(
        contactSection,
        "Email",
        "Enter email address",
        "",
        function(text)
            formData.email = text
        end
    )
    
    Rift.Dropdown.new(
        contactSection,
        "Country",
        "",
        {"USA", "Canada", "UK", "Australia", "Other"},
        "USA",
        function(value)
            formData.country = value
        end
    )
    
    local preferencesSection = formTab:AddSection("Preferences")
    Rift.Toggle.new(
        preferencesSection,
        "Subscribe to Newsletter",
        "Receive updates",
        false,
        function(value)
            formData.subscribe = value
        end
    )
    
    Rift.Dropdown.new(
        preferencesSection,
        "Theme Preference",
        "",
        {"Light", "Dark", "Auto"},
        "Light",
        function(value)
            formData.theme = value
        end
    )
    
    local submitSection = formTab:AddSection("Actions")
    Rift.Button.new(
        submitSection,
        "Submit Form",
        "Submit the application",
        function()
            -- Validate form
            if formData.firstName == "" or formData.lastName == "" then
                window:Notify("Error", "Please enter your name", "Error")
                return
            end
            
            if formData.email == "" then
                window:Notify("Error", "Please enter your email", "Error")
                return
            end
            
            -- Form is valid
            window:Notify("Success", "Form submitted successfully!", "Success", 3)
            print("Form Data:", formData)
        end
    )
    
    Rift.Button.new(
        submitSection,
        "Clear Form",
        "Clear all fields",
        function()
            formData = {
                firstName = "",
                lastName = "",
                email = "",
                country = "USA",
                subscribe = false,
                theme = "Light"
            }
            window:Notify("Info", "Form cleared", "Info")
        end
    )
end

-- =============================================================================
-- Run Examples
-- =============================================================================

--[[
Uncomment the example you want to run:
]]

-- Example1_HelloWorld()
-- Example2_AllComponents()
-- Example3_SettingsManager()
-- Example4_GameControlPanel()
-- Example5_ThemeCustomization()
-- Example6_AdvancedForm()

-- For testing, run this:
Example2_AllComponents()
