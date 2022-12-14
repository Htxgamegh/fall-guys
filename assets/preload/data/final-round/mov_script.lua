--------------------------------------------------------------------------------
-- Character run aligment script                                    by DragShot
--------------------------------------------------------------------------------
local ids = { 'dad', 'boyfriend' };
local chars = { 'skeleton', 'fall_bf_run' };
local frameMax = { 13, 23 };
local framePos = { 0, 0 };
local frameRate = { 36, 40 };

function onUpdatePost(elapsed)
	for i = 1,2,1 do
		framePos[i] = framePos[i] + frameRate[i] * elapsed;
		if (math.floor(framePos[i]) > frameMax[i]) then
			framePos[i] = framePos[i] - frameMax[i];
		end
		if (getProperty(ids[i]..'.curCharacter') == chars[i]) then
			if (getProperty(ids[i]..'.animation.curAnim.name'):endsWith('miss')) then
				setProperty(ids[i]..'.animation.curAnim.frameRate', 24);
			else
				setProperty(ids[i]..'.animation.curAnim.frameRate', 0);
				setProperty(ids[i]..'.animation.curAnim.curFrame', math.min(math.floor(framePos[i]), frameMax[i]));
			end
		end
	end
end

function string.endsWith(str, sufix)
   return string.sub(str, 0 - string.len(sufix)) == sufix;
end