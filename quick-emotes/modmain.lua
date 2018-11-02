local UserCommands = GLOBAL.require("usercommands")

function KeyHandler( key, down )
	if down then
		local emotes_map = { "waves", "bye", "cheer", "angry", "sad", "annoyed", "click", "dance", "bonesaw" }
		if key >= GLOBAL.KEY_F1 and key <= GLOBAL.KEY_F12 then
			local emote = emotes_map[key - GLOBAL.KEY_F1 + 1]
			if emote ~= nil then
				UserCommands.RunTextUserCommand(emote, GLOBAL.ThePlayer, false)
			end
		end
	end
end

	
function gamepostinit()	
	GLOBAL.TheInput:AddKeyHandler( KeyHandler )
end

--add a post init to the game starting up
AddGamePostInit(gamepostinit)