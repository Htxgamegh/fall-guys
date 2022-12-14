function onCreate()
  setPropertyFromClass('GameOverSubstate', 'characterName', 'dead_bf'); -- your character's json file name
  setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx'); -- sound to play when the death screen is triggered
  setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); -- song that will play during the death screen
  setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --sound to play when you press the confirm button to retry
end

function onCreatePost()
	precacheImage('characters/dead_bf');
	
	triggerEvent('Apply Sustain Patch', '', '');
	triggerEvent('Character Camera Zoom', 'dad', '0.5');
	triggerEvent('Character Camera Zoom', 'bf', '0.6');
	triggerEvent('NPS Camera Zoom', 'on', 'hit=0.11|miss=0.2|decay=1.0');
	triggerEvent('Camera Anchor', 'dad', '450,420');
	triggerEvent('Camera Anchor', 'bf', '750,480');
	triggerEvent('Camera Sway', '20', '');
	triggerEvent('Load Song Tag', 'fallen', 'awe');
	--debugPrint(string.sub(debug.getinfo(1).source, 2));
	--debugPrint(scriptName);
	--debugPrint(scriptName:sub(1, scriptName:match('^.*()/')));
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    health = getProperty('health')
    if health > 0.25 then
        setProperty('health', health - 0.02 * (isSustainNote and 0.75 or 1));
    end
end

function onBeatHit()
	if (curBeat == 352) then
		triggerEvent('Camera Anchor', 'dad', '450,460');
		triggerEvent('Camera Anchor', 'bf', '750,520');
	elseif (curBeat == 416) then
		triggerEvent('Camera Anchor', 'dad', '450,420');
		triggerEvent('Camera Anchor', 'bf', '750,480');
	end
end

function onStepHit()
	if curStep == 1 then
		triggerEvent('Show Song Tag', '', '');
	end
end