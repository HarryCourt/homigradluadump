-- "addons\\custom_chat\\lua\\custom_chat\\client\\config.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local Config = CustomChat.Config or {}

CustomChat.Config = Config

function Config:Reset()
    self.width = 550
    self.height = 260
    self.offsetLeft = -1
    self.offsetBottom = -1

    self.fontSize = 12
    self.allowAnyURL = false
    self.timestamps = false
    self.themeId = "default"
end

function Config:ResetDefaultPosition()
    self.offsetLeft = -1
    self.offsetBottom = -1
end

function Config:GetDefaultPosition()
    --local bottomY = ( ScrH() - self.height )

    return
        /*Either( self.offsetLeft > 0, self.offsetLeft, ScrW() * 0.032 ),
        Either( self.offsetBottom > 0, bottomY - self.offsetBottom, bottomY - ScrH() * 0.2 )*/
        32,
        ScrH() - 64 - self.height
end

function Config:GetDefaultSize()
    return 550, 260
end

function Config:SetWhitelistEnabled( enabled )
    self.allowAnyURL = not enabled
    self:Save()

    CustomChat.InternalMessage( CustomChat.GetLanguageText( enabled and "whitelist.enabled" or "whitelist.disabled" ) )
end

local function ValidateNumber( n, min, max )
    return math.Clamp( tonumber( n ) or 0, min, max )
end

function Config.SetNumber( tbl, key, value, min, max )
    if value then
        tbl[key] = ValidateNumber( value, min, max )
    end
end

function Config.SetBool( tbl, key, value )
    tbl[key] = tobool( value )
end

function Config.SetColor( tbl, key, r, g, b, a )
    if r or g or b or a then
        tbl[key] = Color(
            ValidateNumber( r or 255, 0, 255 ),
            ValidateNumber( g or 255, 0, 255 ),
            ValidateNumber( b or 255, 0, 255 ),
            ValidateNumber( a or 255, 0, 255 )
        )
    end
end

function Config:Load()
    self:Reset()

    CustomChat.EnsureDataDir()

    local data = CustomChat.Unserialize( CustomChat.LoadDataFile( "client_config.json" ) )
    local SetNumber, SetBool = self.SetNumber, self.SetBool

    SetNumber( self, "width", data.width, 250, 1000 )
    SetNumber( self, "height", data.height, 150, 1000 )
    SetNumber( self, "offsetLeft", data.offset_left, -1, 1000 )
    SetNumber( self, "offsetBottom", data.offset_bottom, -1, 1000 )

    SetNumber( self, "fontSize", data.font_size, 1, 64 )
    SetBool( self, "timestamps", data.timestamps )
    SetBool( self, "allowAnyURL", data.allow_any_url )

    self.themeId = CustomChat.IsStringValid( data.theme_id ) and data.theme_id or "default"
end

function Config:Save( immediate )
    if not immediate then
        -- avoid spamming the file system
        timer.Remove( "CustomChat.SaveConfigDelay" )
        timer.Create( "CustomChat.SaveConfigDelay", 1, 1, function()
            self:Save( true )
        end )

        return
    end

    CustomChat.SaveDataFile( "client_config.json", CustomChat.Serialize( {
        width			= self.width,
        height			= self.height,
        offset_left		= self.offsetLeft,
        offset_bottom	= self.offsetBottom,

        font_size		= self.fontSize,
        allow_any_url 	= self.allowAnyURL,
        timestamps      = self.timestamps,
        theme_id        = self.themeId
    } ) )
end

Config:Load()
