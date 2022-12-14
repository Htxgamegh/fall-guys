--------------------------------------------------------------------------------
-- Camera Zoom Helper                                               by DragShot
--------------------------------------------------------------------------------
-- Dependencies: ds_utils.lua
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
local scriptName = string.sub(debug.getinfo(1).source, 2);
local scriptDir = scriptName:sub(1, scriptName:match('^.*()/'));

require(scriptDir..'ds_utils');
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Internals
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
local camHandler = {
	enabled = false,
	zoomStatic = nil,
	zoomNPS = nil,
	zoom = nil
};

function camHandler.init(self)
	local zoom = getProperty('defaultCamZoom');
	self.zoomStatic = { dad = zoom, bf = zoom };
	self.zoomNPS = { hit = 0.1, miss = 0.2, decay = 1.0, enabled = false };
	self.zoom = { dad = 0, bf = 0 };
end

function camHandler.load(self, value)
	local data = readParams(value);
	if (data['_id'] == 'zoomStatic') then
		copyTo(data, self.zoomStatic);
	elseif (data['_id'] == 'zoomNPS') then
		copyTo(data, self.zoomNPS);
	end
	--debugPrint(data['_id']..' set');
end

function camHandler.bump(self, charName, amount)
	self.zoom[charName] = math.max(self.zoom[charName] + amount, 0);
end

function camHandler.hit(self, charName, isSustainNote)
	if (not self.zoomNPS.enabled) then return; end
	local bump = self.zoomNPS.hit / (isSustainNote and 2 or 1);
	self.zoom[charName] = self.zoom[charName] + bump;
	--debugPrint('hit('..charName..')');
end

function camHandler.miss(self, charName)
	if (not self.zoomNPS.enabled) then return; end
	self.zoom[charName] = math.max(self.zoom[charName] - self.zoomNPS.miss, 0);
	--debugPrint('miss('..charName..')');
end

function camHandler.decay(self, charName, elapsed)
	self.zoom[charName] = math.max(self.zoom[charName] - (self.zoomNPS.decay * elapsed), 0);
	--debugPrint('decay('..charName..')');
end

function camHandler.update(self, elapsed)
	if (not self.enabled) then return; end
	self:decay('dad', elapsed);
	self:decay('bf', elapsed);
	if (mustHitSection) then
		setProperty('defaultCamZoom', self.zoomStatic.bf + self.zoom.bf);
	else
		setProperty('defaultCamZoom', self.zoomStatic.dad + self.zoom.dad);
	end
	--debugPrint('update('..getProperty('defaultCamZoom')..')');
end
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Callbacks
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function onCreatePost()
	camHandler:init();
end

function onSongStart()
	--triggerEvent('Add Camera Zoom', '0.0001', '0.0');
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	camHandler:hit('bf', isSustainNote);
end

function noteMiss(id, direction, noteType, isSustainNote)
	camHandler:miss('bf');
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	camHandler:hit('dad', isSustainNote);
end

function onUpdate(elapsed)
	camHandler:update(elapsed);
end

--triggerEvent('Dynamic Camera Zoom', 'zoomStatic{dad=0.4|bf=0.45}', 'zoomNPS{hit=0.2|miss=0.4|decay=3.5}');
function onEvent(name, value1, value2)
	if (name == 'Dynamic Camera Zoom') then
		if (value1:len() > 0 or value2:len() > 0) then
			camHandler:load(value1);
			camHandler:load(value2);
			camHandler.enabled = true;
		else
			camHandler.enabled = false;
		end
	elseif (name == 'Character Camera Zoom') then
		if (isAny(value1, 'dad', 'bf')) then
			camHandler.zoomStatic[value1] = tonumber(value2);
			camHandler.enabled = true;
		elseif (value1 == 'off') then
			camHandler.enabled = false;
		end
	elseif (name == 'NPS Camera Zoom') then
		camHandler.zoomNPS.enabled = value1 == 'on';
		if (value2:len() > 0) then
			camHandler:load('zoomNPS{'..value2..'}');
		end
	elseif (name == 'Camera Bump') then
		if (isAny(value1, 'dad', 'bf')) then
			camHandler:bump(value1, tonumber(value2));
		end
	end
end