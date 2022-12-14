--------------------------------------------------------------------------------
-- Ghost Trail Effect for Funk Guys                                 by DragShot
--------------------------------------------------------------------------------
-- Dependencies: ds_flxtrail.lua
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function _pathSplice(limit)
	local path = string.sub(debug.getinfo(1).source, 2);
	local idx = 0; for i = 1, limit do idx, _ = string.find(path, '/', idx + 1, true); end
	return string.sub(path, 1, idx);
end

require(_pathSplice(2)..'scripts/ds_flxtrail');
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Callbacks
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
local trails = {
	bf = nil,
	dad = nil,
	gf = nil
};

local targets = { 'bf', 'gf', 'dad' };

--You may set your default preferences here
local defs = {
	length = 5,
	delay = 6,
	alpha = 1.0,
	diff = 0.02,
	blendMode = 'add'
}

function sparkTrail(target)
	if (trails[target] == nil) then
		trails[target] = FlxTrail:new((target == 'bf') and 'boyfriend' or target,
			defs.length, defs.delay, defs.alpha, defs.diff, defs.blendMode);
	end
end

function onUpdatePost(elapsed)
	for i = 1,#targets,1 do
		local trail = trails[targets[i]];
		if (trail ~= nil) then
			trail:update(elapsed);
		end
	end
end

function onEvent(name, value1, value2)
	if (name == 'Toggle Ghost Trail') then
		local chars = value1:split(',', true);
		for i = 1,#chars,1 do
			if (isAny(chars[i], 'bf', 'gf', 'dad') and value2:len() > 0) then
				sparkTrail(chars[i]);
				trails[chars[i]]:setEnabled(isAny(value2, 'on', '1', 'true'));
			end
		end
	elseif (name == 'Set Trail Blend') then
		local chars = value1:split(',', true);
		for i = 1,#chars,1 do
			if (isAny(chars[i], 'bf', 'gf', 'dad') and value2:len() > 0) then
				sparkTrail(chars[i]);
				trails[chars[i]].blendMode = value2;
			end
		end
	elseif (name == 'Set Trail Color') then
		local chars = value1:split(',', true);
		for i = 1,#chars,1 do
			if (isAny(chars[i], 'bf', 'gf', 'dad')) then --table.unpack(targets) --broken?
				sparkTrail(chars[i]);
				if (value2:len() == 0 or value2 == 'null' or value2 == 'nil') then
					trails[chars[i]].color = nil;
				else
					trails[chars[i]].color = getColorFromHex(value2);
				end
			end
		end
	end
end