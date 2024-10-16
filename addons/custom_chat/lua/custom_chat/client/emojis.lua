-- "addons\\custom_chat\\lua\\custom_chat\\client\\emojis.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- a dictionary of all emojis, where keys
-- are emoji IDs and values are tables
local emojis = CustomChat.emojis or {}
CustomChat.emojis = emojis

-- a array of emoji categories
local emojiCategories = CustomChat.emojiCategories or {}
CustomChat.emojiCategories = emojiCategories

local BUILT_IN_URL = "asset://garrysmod/materials/icon72/%s.png"

--- Returns the URL of a emoji, if it exists.
function CustomChat.GetEmojiURL( id )
    local emoji = emojis[id]
    if not emoji then return end

    if emoji.isBuiltIn then
        return BUILT_IN_URL:format( id )
    end

    return emoji.url
end

--- Clears all "Custom" emojis.
function CustomChat.ClearCustomEmojis()
    local categoryItems = emojiCategories[1].items

    -- remove emojis from the dictionary of all emojis too
    for _, item in ipairs( categoryItems ) do
        emojis[item.id] = nil
    end

    emojiCategories[1].items = {}
end

--- Adds a emoji to the "Custom" category.
function CustomChat.AddCustomEmoji( id, url )
    local categoryItems = emojiCategories[1].items

    -- dont allow overriding built-in emojis
    local existingEmoji = emojis[id]

    if existingEmoji and existingEmoji.isBuiltIn then
        CustomChat.PrintF( "AddCustomEmoji tried to use built-in ID '%s'!", id )
        return
    end

    -- if this emoji id already exists, remove it
    for i, item in ipairs( categoryItems ) do
        if item.id == id then
            table.remove( categoryItems, i )
            break
        end
    end

    local item = { id = id, url = url }

    emojis[id] = item
    categoryItems[#categoryItems + 1] = item
end

--- Adds a emoji category, and all of its items to the dictionary of all emojis.
local function AddEmojiCategory( name, items )
    local categoryItems = {}

    for _, item in ipairs( items ) do
        if type( item ) == "string" then
            item = { id = item, isBuiltIn = true }
        end

        emojis[item.id] = item
        categoryItems[#categoryItems + 1] = item
    end

    emojiCategories[#emojiCategories + 1] = {
        name = name,
        items = categoryItems
    }
end

-- Create the default categories

AddEmojiCategory( "category.custom", {
    { id = "rainbowplz", url = "https://emoji.gg/assets/emoji/1908_RainbowPls.gif" }
} )

AddEmojiCategory( "category.people", {
    "angel",
    "anger",
    "angry",
    "anguished",
    "astonished",
    "baby",
    "blue_heart",
    "blush",
    "boom",
    "broken_heart",
    "bust_in_silhouette",
    "clap",
    "cold_sweat",
    "cold_face",
    "confounded",
    "confused",
    "cry",
    "cupid",
    "disappointed",
    "dizzy",
    "dizzy_face",
    "droplet",
    "ear",
    "exclamation",
    "expressionless",
    "eyes",
    "fearful",
    "feet",
    "fire",
    "fist",
    "flushed",
    "frowning",
    "grey_exclamation",
    "grey_question",
    "grimacing",
    "grin",
    "grinning",
    "hand",
    "hankey",
    "hear_no_evil",
    "heart",
    "heart_eyes",
    "heartpulse",
    "hot_face",
    "hushed",
    "imp",
    "innocent",
    "joy",
    "kiss",
    "kissing",
    "kissing_heart",
    "kissing_smiling_eyes",
    "laughing",
    "lips",
    "mask",
    "muscle",
    "musical_note",
    "neutral_face",
    "no_good",
    "no_mouth",
    "nose",
    "notes",
    "ok_hand",
    "open_hands",
    "open_mouth",
    "pensive",
    "persevere",
    "point_down",
    "point_left",
    "point_right",
    "point_up",
    "pray",
    "pregnant_man",
    "pregnant_woman",
    "punch",
    "question",
    "rage",
    "raised_hands",
    "relaxed",
    "relieved",
    "revolving_hearts",
    "satisfied",
    "scream",
    "see_no_evil",
    "sick",
    "skull",
    "skull_crossbones",
    "sleeping",
    "sleepy",
    "smile",
    "smiley",
    "smirk",
    "sob",
    "sparkles",
    "speak_no_evil",
    "speaking_head",
    "star",
    "star2",
    "stuck_out_tongue",
    "stuck_out_tongue_closed_eyes",
    "stuck_out_tongue_winking_eye",
    "sunglasses",
    "sweat",
    "sweat_drops",
    "sweat_smile",
    "thought_balloon",
    "tired_face",
    "triumph",
    "unamused",
    "wave",
    "weary",
    "wink",
    "worried",
    "yum",
    "zzz",
    "alien"
} )

AddEmojiCategory( "category.objects", {
    "8ball",
    "alarm_clock",
    "apple",
    "art",
    "baby_bottle",
    "bar_chart",
    "basketball",
    "bathtub",
    "battery",
    "beer",
    "bell",
    "birthday",
    "bomb",
    "book",
    "bookmark",
    "books",
    "bread",
    "briefcase",
    "bricks",
    "bulb",
    "camera",
    "candy",
    "cd",
    "christmas_tree",
    "clapper",
    "clipboard",
    "computer",
    "corn",
    "credit_card",
    "date",
    "doughnut",
    "dvd",
    "eggplant",
    "electric_plug",
    "email",
    "eyeglasses",
    "file_folder",
    "flashlight",
    "floppy_disk",
    "game_die",
    "gem",
    "gift",
    "grapes",
    "guitar",
    "gun",
    "hamburger",
    "hammer",
    "high_brightness",
    "high_heel",
    "hourglass",
    "icecream",
    "key",
    "lock",
    "low_battery",
    "magnet",
    "mans_shoe",
    "musical_keyboard",
    "mute",
    "paperclip",
    "pencil2",
    "pill",
    "pushpin",
    "satellite",
    "soccer",
    "sound",
    "toilet",
    "tv",
    "video_game",
    "wine_glass",
    "wrench"
} )

AddEmojiCategory( "category.symbols", {
    "thumbsup",
    "thumbsdown",
    "100",
    "1234",
    "abc",
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "arrow_backward",
    "arrow_double_down",
    "arrow_double_up",
    "arrow_down",
    "arrow_down_small",
    "arrow_forward",
    "arrow_heading_down",
    "arrow_heading_up",
    "arrow_left",
    "arrow_lower_left",
    "arrow_lower_right",
    "arrow_right",
    "arrow_right_hook",
    "arrow_up",
    "arrow_up_down",
    "arrow_up_small",
    "arrow_upper_left",
    "arrow_upper_right",
    "arrows_clockwise",
    "arrows_counterclockwise",
    "bangbang",
    "black_large_square",
    "black_medium_small_square",
    "black_square_button",
    "cancer",
    "cinema",
    "clock1",
    "cool",
    "copyright",
    "fast_forward",
    "free",
    "hash",
    "heavy_check_mark",
    "heavy_division_sign",
    "heavy_dollar_sign",
    "heavy_minus_sign",
    "heavy_multiplication_x",
    "heavy_plus_sign",
    "id",
    "information_source",
    "interrobang",
    "keycap_ten",
    "koko",
    "new",
    "ng",
    "no_entry",
    "no_entry_sign",
    "ok",
    "parking",
    "radio_button",
    "recycle",
    "black_circle",
    "white_circle",
    "red_circle",
    "green_circle",
    "blue_circle",
    "yellow_circle",
    "purple_circle",
    "registered",
    "signal_strength",
    "small_blue_diamond",
    "small_orange_diamond",
    "small_red_triangle",
    "small_red_triangle_down",
    "sos",
    "tm",
    "underage",
    "up",
    "white_check_mark"
} )

AddEmojiCategory( "category.nature", {
    "bear",
    "bird",
    "blossom",
    "cat",
    "cat2",
    "cherry_blossom",
    "chicken",
    "cow2",
    "cyclone",
    "dog",
    "dog2",
    "dolphin",
    "earth_americas",
    "elephant",
    "evergreen_tree",
    "fish",
    "four_leaf_clover",
    "globe_with_meridians",
    "maple_leaf",
    "monkey_face",
    "mouse",
    "mouse2",
    "ocean",
    "rat",
    "raccoon",
    "rooster",
    "rose",
    "snowflake",
    "wolf",
    "zap"
} )

AddEmojiCategory( "category.places", {
    "airplane",
    "ambulance",
    "barber",
    "beginner",
    "bike",
    "blue_car",
    "boat",
    "bullettrain_front",
    "bus",
    "car",
    "checkered_flag",
    "helicopter",
    "moyai",
    "rainbow",
    "rocket",
    "stars",
    "traffic_light",
    "vertical_traffic_light",
    "warning"
} )

AddEmojiCategory( "category.regional", {
    "regional_indicator_a",
    "regional_indicator_b",
    "regional_indicator_c",
    "regional_indicator_d",
    "regional_indicator_e",
    "regional_indicator_f",
    "regional_indicator_g",
    "regional_indicator_h",
    "regional_indicator_i",
    "regional_indicator_j",
    "regional_indicator_k",
    "regional_indicator_l",
    "regional_indicator_m",
    "regional_indicator_n",
    "regional_indicator_o",
    "regional_indicator_p",
    "regional_indicator_q",
    "regional_indicator_r",
    "regional_indicator_s",
    "regional_indicator_t",
    "regional_indicator_u",
    "regional_indicator_v",
    "regional_indicator_w",
    "regional_indicator_x",
    "regional_indicator_y",
    "regional_indicator_z"
} )

function CustomChat.OpenEmojiEditor()
    local L = CustomChat.GetLanguageText

    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 600, 400 )
    frame:SetTitle( L"emojis.title" )
    frame:ShowCloseButton( true )
    frame:SetDeleteOnClose( true )
    frame:Center()
    frame:MakePopup()

    local customEmojis = table.Copy( emojiCategories[1].items )
    local RefreshList

    local scrollEmojis = vgui.Create( "DScrollPanel", frame )
    scrollEmojis:Dock( FILL )
    scrollEmojis:GetCanvas():DockPadding( 0, 0, 0, 4 )

    scrollEmojis.Paint = function( _, w, h )
        surface.SetDrawColor( 30, 30, 30, 255 )
        surface.DrawRect( 0, 0, w, h )
    end

    local function RemoveEmoji( index )
        table.remove( customEmojis, index )
        RefreshList()
    end

    local function UpdateEmoji( index, id, url )
        customEmojis[index].id = id
        customEmojis[index].url = url
    end

    local function MarkEntryAsValid( entry )
        entry._invalidReason = nil
        entry:SetPaintBackgroundEnabled( false )
    end

    local function MarkEntryAsInvalid( entry, reason )
        entry._invalidReason = reason
        entry:SetBGColor( Color( 153, 86, 86 ) )
        entry:SetPaintBackgroundEnabled( true )
    end

    local function FindEmojiIndexById( id )
        for k, v in ipairs( customEmojis ) do
            if v.id == id then
                return k
            end
        end
    end

    local function IsBuiltInEmoji( id )
        local emoji = emojis[id]
        if emoji then
            return emoji.isBuiltIn
        end
    end

    local function AddListItem( index, id, url, shouldScroll )
        if index == 1 then
            scrollEmojis:Clear()
        end

        local item = scrollEmojis:Add( "DPanel" )
        item:Dock( TOP )
        item:DockMargin( 2, 2, 2, 2 )
        item:DockPadding( 2, 2, 2, 2 )

        local labelIndex = vgui.Create( "DLabel", item )
        labelIndex:SetText( index )
        labelIndex:SizeToContents()
        labelIndex:Dock( LEFT )
        labelIndex:DockMargin( 2, 0, 4, 0 )
        labelIndex:SetColor( Color( 0, 0, 0, 255 ) )

        local entryId = vgui.Create( "DTextEntry", item )
        entryId:SetWide( 100 )
        entryId:Dock( LEFT )
        entryId:SetHistoryEnabled( false )
        entryId:SetMultiline( false )
        entryId:SetMaximumCharCount( 32 )
        entryId:SetUpdateOnType( true )
        entryId:SetPlaceholderText( "<emoji id>" )

        entryId.OnValueChange = function( s, value )
            local newId = string.Trim( value )
            local existingIndex = FindEmojiIndexById( newId )

            if string.len( newId ) == 0 then
                MarkEntryAsInvalid( s, L"emojis.empty_id" )

            elseif string.find( newId, "[^%w_%-]" ) then
                MarkEntryAsInvalid( s, L"emojis.invalid_characters" )

            elseif existingIndex and existingIndex ~= index then
                MarkEntryAsInvalid( s, string.format( L"emojis.id_in_use", existingIndex ) )

            elseif IsBuiltInEmoji( newId ) then
                MarkEntryAsInvalid( s, string.format( L"emojis.id_builtin", newId ) )

            else
                MarkEntryAsValid( s )
            end

            UpdateEmoji( index, newId, customEmojis[index].url )
        end

        local entryURL = vgui.Create( "DTextEntry", item )
        entryURL:Dock( FILL )
        entryURL:DockMargin( 4, 0, 4, 0 )
        entryURL:SetHistoryEnabled( false )
        entryURL:SetMultiline( false )
        entryURL:SetMaximumCharCount( 256 )
        entryURL:SetUpdateOnType( true )
        entryURL:SetPlaceholderText( L"emojis.url_placeholder" )
        entryURL._branchWarning = true

        entryURL.OnValueChange = function( s, value )
            local newURL = string.Trim( value )

            if string.len( newURL ) == 0 then
                MarkEntryAsInvalid( s, L"emojis.empty_url" )
            else
                if not s._branchWarning and BRANCH == "unknown" and newURL:sub( 1, 5 ) == "https" then
                    s._branchWarning = true
                    Derma_Message( L"emojis.branch_warning", L"emojis.title", L"ok" )
                end

                MarkEntryAsValid( s )
            end

            UpdateEmoji( index, customEmojis[index].id, newURL )
        end

        timer.Simple( 0, function()
            entryId:SetValue( id )
            entryURL:SetValue( url )
            entryURL._branchWarning = nil
        end )

        local btnRemove = vgui.Create( "DButton", item )
        btnRemove:SetIcon( "icon16/cancel.png" )
        btnRemove:SetTooltip( L"emojis.removeremove" )
        btnRemove:SetText( "" )
        btnRemove:SetWide( 24 )
        btnRemove:Dock( RIGHT )

        btnRemove.DoClick = function()
            RemoveEmoji( index )
        end

        customEmojis[index]._idEntry = entryId
        customEmojis[index]._urlEntry = entryURL

        if shouldScroll then
            timer.Simple( 0, function()
                scrollEmojis:ScrollToChild( item )
            end )
        end
    end

    RefreshList = function()
        scrollEmojis:Clear()

        if #customEmojis == 0 then
            local item = scrollEmojis:Add( "DLabel" )
            item:Dock( TOP )
            item:SetText( L"emojis.empty_list" )
            item:SetContentAlignment( 5 )
            item:DockMargin( 4, 4, 4, 4 )
            item:DockPadding( 2, 2, 2, 2 )
            return
        end

        for index, v in ipairs( customEmojis ) do
            AddListItem( index, v.id, v.url )
        end
    end

    RefreshList()

    local panelOptions = vgui.Create( "DPanel", frame )
    panelOptions:Dock( BOTTOM )
    panelOptions:DockPadding( 4, 4, 4, 4 )
    panelOptions:SetTall( 32 )

    local buttonAdd = vgui.Create( "DButton", panelOptions )
    buttonAdd:SetIcon( "icon16/add.png" )
    buttonAdd:SetText( L"emojis.add" )
    buttonAdd:SetWide( 130 )
    buttonAdd:Dock( LEFT )

    buttonAdd.DoClick = function()
        local newIndex = #customEmojis + 1
        local newId = "emoji-" .. newIndex

        table.insert( customEmojis, { id = newId, url = "" } )
        AddListItem( newIndex, newId, "", true )
    end

    local buttonAddSilk = vgui.Create( "DButton", panelOptions )
    buttonAddSilk:SetIcon( "icon16/emoticon_evilgrin.png" )
    buttonAddSilk:SetText( L"emojis.add_silkicon" )
    buttonAddSilk:SetTooltip( L"emojis.add_silkicon_tip" )
    buttonAddSilk:SetWide( 130 )
    buttonAddSilk:Dock( LEFT )

    local silkPanel

    frame.OnClose = function()
        if IsValid( silkPanel ) then
            silkPanel:Close()
        end
    end

    buttonAddSilk.DoClick = function()
        if IsValid( silkPanel ) then
            silkPanel:MakePopup()
            return
        end

        silkPanel = vgui.Create( "DFrame" )
        silkPanel:SetSize( 335, 200 )
        silkPanel:SetTitle( L"emojis.add_silkicon" )
        silkPanel:Center()
        silkPanel:MakePopup()

        local iconBrowser = vgui.Create( "DIconBrowser", silkPanel )
        iconBrowser:Dock( FILL )

        iconBrowser.OnChange = function( s )
            local iconPath = s:GetSelectedIcon()
            local newIndex = #customEmojis + 1
            local newId = string.GetFileFromFilename( iconPath ):sub( 1, -5 )
            local newUrl = "asset://garrysmod/materials/" .. iconPath

            table.insert( customEmojis, { id = newId, url = newUrl } )
            AddListItem( newIndex, newId, newUrl, true )

            silkPanel:Close()
        end

        local editFilter = vgui.Create( "DTextEntry", silkPanel )
        editFilter:SetHistoryEnabled( false )
        editFilter:SetMultiline( false )
        editFilter:SetMaximumCharCount( 50 )
        editFilter:SetUpdateOnType( true )
        editFilter:SetPlaceholderText( "<search>" )
        editFilter:Dock( BOTTOM )

        editFilter.OnValueChange = function( _, value )
            iconBrowser:FilterByText( string.Trim( value ) )
        end
    end

    local buttonApply = vgui.Create( "DButton", panelOptions )
    buttonApply:SetIcon( "icon16/accept.png" )
    buttonApply:SetText( L"emojis.apply" )
    buttonApply:SetWide( 150 )
    buttonApply:Dock( RIGHT )

    buttonApply._DefaultPaint = buttonApply.Paint

    buttonApply.Paint = function( s, w, h )
        s:_DefaultPaint( w, h )

        surface.SetDrawColor( 255, 255, 0, 180 * math.abs( math.sin( RealTime() * 3 ) ) )
        surface.DrawRect( 0, 0, w, h )
    end

    buttonApply.DoClick = function()
        local data = {}

        for k, v in ipairs( customEmojis ) do
            local invalidReason = v._idEntry._invalidReason or v._urlEntry._invalidReason

            if invalidReason then
                local text = string.format( L"emojis.invalid_reason", k, invalidReason )
                Derma_Message( text, L"emojis.invalid", L"ok" )

                return
            end

            data[k] = { id = v.id, url = v.url }
        end

        local action = ( #data > 0 ) and "emojis.apply_tip" or "emojis.remove_tip"

        data = ( #data > 0 ) and util.TableToJSON( data ) or ""

        Derma_Query( L( action ), L"emojis.apply_title", L"yes", function()
            net.Start( "customchat.set_emojis", false )
            net.WriteString( data )
            net.SendToServer()

            frame:Close()
        end, L"no" )
    end
end
