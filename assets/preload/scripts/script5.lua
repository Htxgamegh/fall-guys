--------------------------------------------------------------------------------
-- Sustain animation patch                                          by DragShot
--------------------------------------------------------------------------------
-- Internals
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
local enabled = false;

function initialize()
	for i = 0,getProperty('unSpawnNotes'),1 do
		if (getPropertyFromGroup('unSpawnNotes', i, 'isSustainNote')) then
			setPropertyFromGroup('unSpawnNotes', i, 'noAnimation', true);
		end
		enabled = true;
	end
end

function handleNote(charName, id)
	if (getProperty(charName..'.animation.curAnim.curFrame') > 3) then
		setProperty(charName..'.animation.curAnim.curFrame', id % 2);
		setProperty(charName..'.holdTimer', 0);
	end
end
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Callbacks
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function goodNoteHit(id, direction, noteType, isSustainNote)
	if (isSustainNote) then
		handleNote('boyfriend', id);
	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if (isSustainNote) then
		handleNote('dad', id);
	end
end

function onEvent(name, value1, value2)
	if (name == 'Apply Sustain Patch') then --Crosscript call compatible with 0.5.x
		initialize();
	end
end