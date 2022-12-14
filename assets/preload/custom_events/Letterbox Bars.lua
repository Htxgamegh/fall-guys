--------------------------------------------------------------------------------
-- Widescreen in Letterbox Bars Event                               by DragShot
--------------------------------------------------------------------------------
local barLocations = nil;
local defaultPos = 0.24;
local rolloutTime = 0.5;

function onCreate()
	barLocations = { -screenHeight, screenHeight }; --Top, Bottom
	for i = 1,2,1 do
		local name = 'letterbox:bar'..i;
		makeLuaSprite(name, '', 0, barLocations[i]);
		makeGraphic(name, screenWidth, screenHeight, '000000');
		setObjectCamera(name, 'hud');
		addLuaSprite(name, false);
	end
end

function applyLetterbox(pos, ease)
	for i = 1,2,1 do
		local name = 'letterbox:bar'..i;
		local py = barLocations[i] - (barLocations[i] * pos * 0.5);
		doTweenY('slide::'..name, name, py, rolloutTime, ease);
	end
end

function hideLetterbox(ease)
	for i = 1,2,1 do
		local name = 'letterbox:bar'..i;
		doTweenY('slide::'..name, name, barLocations[i], rolloutTime, ease);
	end
end

function onEvent(name, value1, value2)
	if (name == 'Letterbox Bars') then
		if (value1:len() == 0 or value1 == 'off') then
			local ease = (value2:len() > 0) and value2 or 'cubicOut';
			hideLetterbox(ease);
		else
			local pos = math.min(math.max(0.0, tonumber(value1) or defaultPos), 1.0);
			local ease = (value2:len() > 0) and value2 or 'cubicOut';
			applyLetterbox(pos, ease);
		end
	end
end