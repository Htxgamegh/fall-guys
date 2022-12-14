local VersionNeeded = '0.6.3'
local itoutdate = false

function onCreatePost()
    local CurrentVersion = version
	--debugPrint(version);
    if formatVersion(CurrentVersion) < formatVersion(VersionNeeded) then
        makeLuaSprite("cover", nil, 0,0)
        makeGraphic("cover", screenWidth * 3, screenHeight * 3, "000000")
        setObjectCamera("cover", "camHUD")
       -- addLuaSprite("cover", true)
        
   

        makeLuaText('versionchecklol', 'Your Psych is outdated\nPlease Update to Psych Engine '..VersionNeeded..'', 0, 0, 0)
        setProperty('versionchecklol.y', 330)
        setProperty('versionchecklol.x', 0)
        setTextAlignment('versionchecklol', 'center')
        setObjectCamera('versionchecklol','hud')
        setTextWidth('versionchecklol', getTextWidth('scoreTxt'))
        setTextSize('versionchecklol', 90)
        addLuaText('versionchecklol')
        itoutdate = true
    end
end

function onStartCountdown()
    debugPrint(itoutdate and 'outdated' or 'OK')
    if itoutdate then
        return Function_Stop
    end
end

function formatVersion(ver)
    local buffer = {};
    for str in string.gmatch(ver, "([^%.]+)") do
		if (str:len() == 1) then
			table.insert(buffer, '00');
		elseif (str:len() == 2) then
			table.insert(buffer, '0');
		end
        table.insert(buffer, str);
    end
    return tonumber(table.concat(buffer));
end