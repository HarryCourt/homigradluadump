# HomigradCOM Client/Shared Lua Dump (As of 16th of October, 2024)
Just a dump of the Client + Shared Lua files from the official HomigradCOM servers.

## ***Does this mean I can finally play the real Homigrad without joining the server?***

No, and unless you intend to waste an entire day away or want to reverse engineer this code, don't bother downloading it.



## *Wait, so what's the issue?*
When starting a game in any gamemode, the game will show a black screen, and the below error message;
```
[homigrad_core] addons/homigrad_core/lua/shlib/tier_0/tier_0/player/init_protocol_cl.lua:26: Calling net.Start with unpooled message name! (Did you forget to call util.AddNetworkString serverside?)
  1. Start - [C]:-1
   2. unknown - addons/homigrad_core/lua/shlib/tier_0/tier_0/player/init_protocol_cl.lua:26

Timer Failed! [Simple][@addons/homigrad_core/lua/shlib/tier_0/tier_0/player/init_protocol_cl.lua (line 25)]
```
This is most likely caused by (what I believe to be) the lack of the server lua files, which cannot be dumped from the server.

There are server lua files that Homigrad relies on, which are not included within this repository. Unless we build them by scratch, or the source code gets leaked, this repository just exists for reasons that I can't really bother explaining.

Any basic functionality of gameplay is gone, and you will not be able to play Garry's Mod at all, as the code executes in any other gamemode. **If you download this and complain about it not working, I will personally come out to piss on your bed.**
#
*0oa, откройте исходный код своего дерьма!*
