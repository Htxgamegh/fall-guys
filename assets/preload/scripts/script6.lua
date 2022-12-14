--------------------------------------------------------------------------------
-- FlxTrail Lua implementation for PsychEngine v0.6.x               by DragShot
--------------------------------------------------------------------------------
-- Dependencies: ds_utils.lua
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
local scriptName = string.sub(debug.getinfo(1).source, 2);
local scriptDir = scriptName:sub(1, scriptName:match('^.*()/'));
--local libDir = scriptDir:sub(1, scriptDir:sub(1, scriptDir:len()-1):match('^.*()/'))..'scripts/';

require(scriptDir..'ds_utils');
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Internals
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
FlxTrail = {}; --[global class]

--new(Target:FlxSprite, ?Graphic:Null<FlxGraphicAsset>, Length:Int = 10, Delay:Int = 3, Alpha:Float = 0.4, Diff:Float = 0.05)
--Vs Selever defaults: new FlxTrail('boyfriend', 4, 12, 0.3, 0.069);
function FlxTrail:new(_target, _length, _delay, _alpha, _diff, _blendMode)
	local obj = setmetatable({
		curTime = 0,
		curFrame = 0,
		enabled = false,
		target = _target or 'boyfriend',
		length = math.max(0, _length or 10),
		delay = math.max(0, _delay or 3),
		alpha = math.max(0, _alpha or 0.4),
		diff = math.max(0, _diff or 0.05),
		blendMode = _blendMode or 'normal',
		speedX = 0,
		speedY = 0,
		color = nil,
		stcolor = nil,
		nghosts = 0
	}, FlxTrail);
	obj.href = PropertyRef:new(obj.target);
	self.__index = self;
	return obj;
end

function FlxTrail:update(elapsed)
	self.curTime = self.curTime + math.floor(elapsed * 1000);
	local curFrame = self.curTime * math.floor(self.curTime / (1000 / 60.0));
	if (self.curFrame ~= curFrame and self.curFrame % (self.delay + 1) == 0) then
		self.stcolor = FlxTrail.getStockColor(self.target); --Making sure this is up-to-date
		if (self.nghosts > 0) then
			for i = 1, self.length, 1 do
				local idx = self.nghosts - (i - 1);
				if (idx <= 0) then break; end
				local sprName = 'FlxTrail:'..self.target..':'..tostring(idx);
				local alpha = getProperty(sprName..'.alpha');
				if (alpha == 'alpha') then break; end --There is no sprite anymore
				alpha = math.max(0, alpha - (alpha * self.diff));
				setProperty(sprName..'.alpha', alpha);
			end
		end
		if (self.enabled) then
			self:makeTrailFrame();
		end
		if (self.nghosts > self.length) then
			local sprName = 'FlxTrail:'..self.target..':'..(self.nghosts - self.length);
			removeLuaSprite(sprName, true);
		end
	end
	self.curFrame = curFrame;
end

function FlxTrail:setEnabled(enabled)
	self.enabled = enabled;
end

function FlxTrail:makeTrailFrame()
	local order = getObjectOrder(self.target..'Group') - 1;
	--debugPrint('makeTrailFrame('..self.target..') order: '..tostring(order));
	local href = self.href;
	if (href['imageFile'] ~= '') then
		self.nghosts = self.nghosts + 1;
		local sprName = 'FlxTrail:'..self.target..':'..self.nghosts;
		makeAnimatedLuaSprite(sprName, href['imageFile'], href['x'], href['y']);
		setProperty(sprName .. '.offset.x', href['offset.x']);
		setProperty(sprName .. '.offset.y', href['offset.y']);
		setProperty(sprName .. '.scale.x', href['scale.x']);
		setProperty(sprName .. '.scale.y', href['scale.y']);
		setProperty(sprName .. '.flipX', href['flipX']);
		setProperty(sprName .. '.flipY', href['flipY']);
		setProperty(sprName .. '.antialiasing', href['antialiasing']);
		setProperty(sprName .. '.alpha', self.alpha);
		--debugPrint('color = '..tostring(self.color)..' ('..type(self.color)..')');
		if (self.color) then
			setProperty(sprName .. '.color', self.color);
		elseif (self.stcolor) then
			setProperty(sprName .. '.color', self.stcolor);
		end
		setProperty(sprName..'.velocity.x', self.speedX);
		setProperty(sprName..'.velocity.y', self.speedY);
		setScrollFactor(sprName, href['scrollFactor.x'], href['scrollFactor.x']);
		setObjectOrder(sprName, order);
		setBlendMode(sprName, self.blendMode);
		addAnimationByPrefix(sprName, 'default', href['animation.frameName'], 0, false);
		--playAnim(sprName, 'default', false, href['animation.curAnim.curFrame']); --unnecessary?
		addLuaSprite(sprName, false);
	end
end

function FlxTrail.getStockColor(target) --[static]
	local color = nil;
	if (target == 'gf') then
		color = getColorFromHex('A5004D'); --Fetched manually from json
	elseif (isAny(target, 'boyfriend', 'dad')) then
		color = getColorFromHex(getCharacterColor(target));
	end
	return color;
end
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
return { ['FlxTrail'] = FlxTrail }; --, [''] = 