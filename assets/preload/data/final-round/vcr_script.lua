--------------------------------------------------------------------------------
-- Chromatic Aberration on Hit Effect                            by HaxLua#6749
--------------------------------------------------------------------------------
-- Source: https://discord.com/channels/922849922175340586/922851578996744252/1000289068871061554
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
local Chromacrap = 0;

function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end

function math.lerp(from,to,i) return from+(to-from)*i end

function setChrome(chromeOffset)
    setShaderFloat("temporaryShader", "rOffset", chromeOffset);
    setShaderFloat("temporaryShader", "gOffset", 0.0);
    setShaderFloat("temporaryShader", "bOffset", chromeOffset * -1);
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    Chromacrap = Chromacrap + 0.004; -- edit this
end

function onCreatePost()
    --luaDebugMode = true;
	if (shadersEnabled) then
		initLuaShader("vcr");
		
		makeLuaSprite("temporaryShader");
		makeGraphic("temporaryShader", screenWidth, screenHeight);
		
		setSpriteShader("temporaryShader", "vcr");
		
		addHaxeLibrary("ShaderFilter", "openfl.filters");
		runHaxeCode([[
			trace(ShaderFilter);
			game.camGame.setFilters([new ShaderFilter(game.getLuaObject("temporaryShader").shader)]);
			game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("temporaryShader").shader)]);
		]]);
	end
end

function onUpdate(elapsed)
	if (shadersEnabled) then
		Chromacrap = math.lerp(Chromacrap, 0, boundTo(elapsed * 20, 0, 1));
		setChrome(Chromacrap);
	end
end