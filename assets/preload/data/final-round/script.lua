function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'fall_guys_bf_death'); -- your character's json file name
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx'); -- sound to play when the death screen is triggered
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); -- song that will play during the death screen
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --sound to play when you press the confirm button to retry

	makeLuaSprite('luz', 'Fall Guys/Escenario 3/Iluminacion');
	setLuaSpriteScrollFactor('luz', 1, 1);
	scaleObject('luz', 1, 1);
	setObjectCamera('luz', 'hud');
	addLuaSprite('luz',true);
end

local p1y;
local p2y;

function onCreatePost()
	precacheImage('characters/bf_fall_death');

	makeLuaSprite('bwall', '', 0, 0);
	makeGraphic('bwall', 1280, 720, '0xFF000000');
	setObjectCamera('bwall', 'hud');
	setProperty('bwall.alpha', 0.0);
	addLuaSprite('bwall', true);
	
	setObjectOrder('luz', 0);
	
	triggerEvent('Character Camera Zoom', 'dad', '0.4');
	triggerEvent('Character Camera Zoom', 'bf', '0.45');
	triggerEvent('NPS Camera Zoom', 'on', 'hit=0.2|miss=0.4|decay=3.5');
	triggerEvent('Camera Anchor', 'dad', '450,405');
	triggerEvent('Camera Anchor', 'bf', '750,420');
	triggerEvent('Camera Sway', '65', '');
	triggerEvent('Load Song Tag', 'final-round', 'punkett');
	
	p1x = defaultOpponentX;
	p2x = defaultBoyfriendX;
	setProperty('dadGroup.x', p1x - 1600);
	setProperty('boyfriendGroup.x', p2x - 1600);
	doTweenX('enterOp', 'dadGroup', p1x, 2, 'quadOut');
	doTweenX('enterPl', 'boyfriendGroup', p2x, 2, 'quadOut');
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    health = getProperty('health')
    if (health > 0.1) then
        setProperty('health', health - 0.022 * (isSustainNote and 0.75 or 1));
    end
end

function onBeatHit()
	if (isAny(curBeat, 64, 224, 292)) then
		doTweenX('movPl', 'boyfriendGroup', p2x - 500, 16, 'sineInOut');
	elseif (isAny(curBeat, 127, 259, 323)) then
		doTweenX('movPl', 'boyfriendGroup', p2x, 6, 'elasticOut');
	elseif (curBeat == 387) then
		doTweenX('movPl', 'boyfriendGroup', p2x - 300, 8, 'sineInOut');
	elseif(curBeat == 420) then
		doTweenX('movPl', 'boyfriendGroup', p2x, 8, 'sineInOut');
	elseif (curBeat == 522) then
		doTweenAlpha('gameFadeOut', 'bwall', 1.0, 1.5, 'linear');
	elseif(curBeat == 520) then
		doTweenX('leaveOp', 'dadGroup', p1x + 2000 + ((rating <= 0.7) and 1200 or 0), 3, 'quadIn');
		doTweenX('leavePl', 'boyfriendGroup', p2x + 2000 + ((rating >= 0.9) and 1500 or 0), 3, 'quadIn');
	end
end

function onStepHit()
	if curStep == 1 then
		triggerEvent('Show Song Tag', '', '');
	elseif (curStep == 800) then
		triggerEvent('Camera Bump', 'dad', '0.15');
	elseif (curStep == 808) then
		triggerEvent('Camera Bump', 'dad', '0.23');
	elseif (isAny(curStep, 816, 822, 828)) then
		triggerEvent('Camera Bump', 'dad', '0.32');
	elseif (curStep == 832) then
		triggerEvent('Camera Bump', 'dad', '0.4');
	elseif (isAny(curStep, 944, 950)) then
		triggerEvent('Camera Bump', 'bf', '0.32');
		triggerEvent('Camera Anchor', 'bf', '800,470');
	elseif (isAny(curStep, 956)) then
		triggerEvent('Camera Bump', 'bf', '0.36');
	elseif (curStep == 960) then
		triggerEvent('Camera Bump', 'bf', '0.4');
		triggerEvent('Camera Anchor', 'bf', '750,420');
	end
end

function isAny(val, ...)
	local args = { ... };
	for _, target in ipairs(args) do
		if (val == target) then
			return true;
		end
	end
	return false;
end