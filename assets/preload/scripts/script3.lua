--------------------------------------------------------------------------------
-- Themed SongTag for Funk Guys                                     by DragShot
--------------------------------------------------------------------------------
local ready = false;

function addHudSprite(name, src, x, y, scale, visible)
	makeLuaSprite(name, src, x, y);
	scaleObject(name, scale, scale);
	setObjectCamera(name, 'hud');
	setProperty(name..'.visible', visible);
	addLuaSprite(name, true);
end

function loadSongTag(song, artist)
	local dir = 'Fall Guys/songtags/';
	addHudSprite('fg:stag:artist', dir..'artist_'..artist, -480, 470, 0.7, false);
	addHudSprite('fg:stag:separator', dir..'separator', -242, 470, 0.7, false);
	addHudSprite('fg:stag:song', dir..'song_'..song, -1200, 470, 0.7, true);
	ready = true;
end

function showSongTag()
	if (ready) then
		doTweenX('tweenX@fg:stag:song', 'fg:stag:song', 0, 0.75, 'quadOut');
		runTimer('slideIn@fg:stag:separator', 0.75);
		runTimer('slideIn@fg:stag:artist', 1.0);
		runTimer('hide@fg:stag', 6.0);
		ready = false;
	end
end

function onEvent(name, value1, value2)
	if (name == 'Load Song Tag') then
		if (value1:len() > 0 and value2:len() > 0) then
			loadSongTag(value1, value2);
		end
	elseif (name == 'Show Song Tag') then
		showSongTag();
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if (tag == 'slideIn@fg:stag:separator') then
		setProperty('fg:stag:separator.visible', true);
		doTweenX('tweenX@fg:stag:separator', 'fg:stag:separator', 0, 1, 'elasticOut');
	elseif (tag == 'slideIn@fg:stag:artist') then
		setProperty('fg:stag:artist.visible', true);
		doTweenX('tweenX@fg:stag:artist', 'fg:stag:artist', 0, 1.5, 'elasticOut');
	elseif (tag == 'hide@fg:stag') then
		doTweenX('tweenX@fg:stag:artist', 'fg:stag:artist', -1200, 0.5, 'sinIn');
		runTimer('slideOut@fg:stag:separator', 0.5);
		runTimer('slideOut@fg:stag:song', 0.75);
	elseif (tag == 'slideOut@fg:stag:separator') then
		doTweenX('tweenX@fg:stag:separator', 'fg:stag:separator', -1200, 1, 'sinIn');
	elseif (tag == 'slideOut@fg:stag:song') then
		doTweenX('tweenX@fg:stag:song', 'fg:stag:song', -1200, 0.5, 'sinIn');
	end
end