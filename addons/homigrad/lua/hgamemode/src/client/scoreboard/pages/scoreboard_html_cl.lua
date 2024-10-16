-- "addons\\homigrad\\lua\\hgamemode\\src\\client\\scoreboard\\pages\\scoreboard_html_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
//https://music.youtube.com/watch?v=zbxD8_F4T4k&list=RDAMVM5JWGS37Am_Y

local htmlCODE
function ScoreboardBuildOnHTML(self,scroll)
    scroll:ad(function(self) self:setPos(-30,40) end)

    local html = oop.CreatePanel("v_html",scroll):ad(function(self)
        self:setSize(scroll:W(),scroll:H())
    end)

    html:SetHTML(htmlCODE)
end

htmlCODE = [[
<html>
    <head>
    </head>
    <body style="
        margin: 0;
        
        background-size: cover;
    ">
        
    </body>
    <script>
        let height = 150

        let iteration = 0

        function addPanel(avatar,avatarFrame,background,backgroundPoster,backgroundY) {
            iteration++

            let panel = document.createElement("div")
            document.body.appendChild(panel)
            panel.style = `
                width: 100%;
                height: ` + height + `px;
                background-color: rgba(0,0,0,0.25);
                overflow: hidden; 
                display: flex;
                position: relative;
            `

            let avatarPanel = document.createElement("div")
            panel.appendChild(avatarPanel)
            avatarPanel.style = `
                width: ` + height + `px;
                height: ` + height + `px;
                background-image: url("` + avatar + `");
                background-size: cover;
                position: fixed;
            `

            if (avatarFrame) {
                let avatarFramePanel = document.createElement("div")
                avatarPanel.appendChild(avatarFramePanel)
                avatarFramePanel.style = `
                    width: ` + (height + height * 0.25) + `px;
                    height: ` + (height + height * 0.25) + `px;
                    background-image: url("` + avatarFrame + `");
                    background-size: cover;
                    position: relative;
                    left: -` + (height * 0.25 / 2) + `px;
                    top: -` + (height * 0.25 / 2) + `px;
                    
                `
            } else {
         
            }

            if (background) {
                let video = document.createElement("video")
                panel.appendChild(video)
                video.style = `
                    width: 1980px;
                    min-width: 100%;
                    height: 1080px;
                    position: relative;
                    top: ` + (backgroundY * 100) + `%;
                    left: 50%;
                    transform: translate(-50%,-` + (backgroundY * 100) + `%);

                    z-index: -1;
                `
                video.playsinline = true
                video.loop = true
                video.muted = true
                video.autoplay = true

                let source = document.createElement("source")
                video.appendChild(source)
                source.src = background
            } else if (backgroundPoster) {

            }

            //https://www.youtube.com/shorts/AevqMQnVUHc

            function addText(x,text) {
                let a = document.createElement("p")
                panel.appendChild(a)
                a.innerHTML = text
                a.style = `
                    position: absolute;
                
                    line-height: ` + height + `px;
                    margin: 0;
                    left: ` + x + `;

                    color: rgb(255,255,255);

                    font: ChatFont;
                `
            }

            addText("50%","name")
            addText("100px","live")
            addText("calc(100% - 100px)","ping")
        }

        addPanel(
            "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/items/2543050/c44df289ad2c97de9276d117d5e164c602038b5d.gif",
            "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/items/400910/27736cefed1a3045712b562d6af8ca8c5a746a55.png",
            "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/items/2543050/fc7cf3b6ee9d38d1609d7c456f7d3a4837853d76.webm",
            "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/items/2543050/9720ebdc71936e3e809f4f4fb124da8eb812980b.jpg",
            0.5
        )
    </script>
</html>
]]

if Initialize and LocalPlayer():SteamID() == "STEAM_0:1:164889146" then OpenTab() end