--------------------------------------------------------------------------------
-- Camera sway script                                               by DragShot
--------------------------------------------------------------------------------
-- Dependencies: ds_utils.lua
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
local scriptName = string.sub(debug.getinfo(1).source, 2);
local scriptDir = scriptName:sub(1, scriptName:match('^.*()/'));

require(scriptDir..'ds_utils');
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
local followchars = false;
local fixedpos = false;
local debugpos = false;
local xx = {0, 0}; xx[0] = 0; --dad, bf
local yy = {0, 0}; yy[0] = 0;
local ofs = 20;

function onUpdate(elapsed)
	if followchars == true then
		local move = nil;
		local px;
		local py;
		if (fixedpos) then
			px = xx[0];
			py = yy[0];
		end
		if (mustHitSection) then
			if (not fixedpos) then
				px = xx[2];
				py = yy[2];
			end
			move = evalMovement('boyfriend');
		else
			if (not fixedpos) then
				px = xx[1];
				py = yy[1];
			end
			move = evalMovement('dad');
		end
		if (move == 'up') then
			triggerEvent('Camera Follow Pos', px, py-ofs);
		elseif (move == 'down') then
			triggerEvent('Camera Follow Pos', px, py+ofs);
		elseif (move == 'left') then
			triggerEvent('Camera Follow Pos', px-ofs, py);
		elseif (move == 'right') then
			triggerEvent('Camera Follow Pos', px+ofs, py);
		else
			triggerEvent('Camera Follow Pos',px,py);
		end
	else
		triggerEvent('Camera Follow Pos','','')
	end
end

function evalMovement(charName)
	local animName = getProperty(charName..'.animation.curAnim.name');
	if (animName ~= 'singUPmiss' and string.startsWith(animName, 'singUP')) then
		return 'up';
	elseif (animName ~= 'singDOWNmiss' and string.startsWith(animName, 'singDOWN')) then
		return 'down';
	elseif (animName ~= 'singLEFTmiss' and string.startsWith(animName, 'singLEFT')) then
		return 'left';
	elseif (animName ~= 'singRIGHTmiss' and string.startsWith(animName, 'singRIGHT')) then
		return 'right';
	--elseif (string.startsWith(animName, 'idle')) then
		--return 'idle';
	end
	return nil;
end

function onEvent(name, value1, value2)
	if (name == "Camera Custom Pos") then
		fixedpos = value1 and (string.len(value1) > 0);
		if (fixedpos) then
			xx[0] = tonumber(value1);
			yy[0] = tonumber(value2);
		end
	elseif (name == "Camera Anchor") then
		local valid = value1 and (string.len(value1) > 0) and value2 and (string.len(value2) > 0);
		if (valid) then
			local idx = (value1 == 'dad') and 1 or 2;
			local args = value2:split(',', true);
			xx[idx] = tonumber(args[1]);
			yy[idx] = tonumber(args[2]);
		end
	elseif (name == "Camera Sway") then
		if (value1 and (string.len(value1) > 0)) then
			ofs = tonumber(value1) or ofs;
			followchars = true;
		else
			followchars = false;
		end
	end
end

function onBeatHit()
	if (debugpos and curBeat % 4 == 2) then
		local posX = getProperty('camGame.target.x');
		local posY = getProperty('camGame.target.y');
		debugPrint('Camera pos: '..posX..', '..posY);
	end
end