local sprMarqData = {};

function getMqsprId(name, idx)
	return 'mqspr:'..name..'_'..tostring(idx);
end

function removeMarqueeSprite(name)
	local sprData = sprMarqData[name];
	if (sprData) then
		for i = 1,sprData.instances,1 do
			local sprName = getMqsprId(name, i);
			removeLuaSprite(sprName, true);
		end
	end
end

function makeMqspr(data, idx, px)
	local sprName = getMqsprId(data.name, idx);
	makeLuaSprite(sprName, data.src, px, data.y);
	scaleObject(sprName, data.scale, data.scale);
	setLuaSpriteScrollFactor(name, data.scrfact, data.scrfact);
	setProperty(sprName..'.velocity.x', data.speed);
	addLuaSprite(sprName, data.ontop);
end

function addMarqueeSprite(name, src, x, y, width, speed, copies, scale, scrfact, ontop)
	scale = scale or 1.0;
	scrfact = scrfact or 1.0;
	ontop = ontop or false;
	removeMarqueeSprite(name);
	local sprData = {};
	sprData.name = name;
	sprData.src = src;
	sprData.x = x; sprData.y = y;
	sprData.width = width;
	sprData.speed = speed;
	sprData.scale = scale;
	sprData.scrfact = scrfact;
	sprData.ontop = ontop;
	for i = 1,copies,1 do
		makeMqspr(sprData, i, x);
		x = x + (width * scale);
		sprData.instances = i;
	end
	sprMarqData[name] = sprData;
end

function addBackgroundSprite(name, src, x, y, scale, scrollfact)
	makeLuaSprite(name, src, x, y);
	scaleObject(name, scale, scale);
	setLuaSpriteScrollFactor(name, scrollfact, scrollfact);
	addLuaSprite(name,false);
end

local etime = 0;

function checkMarquees(elapsed)
	etime = etime + elapsed;
	local seq = 1;
	for name, data in pairs(sprMarqData) do
		--debugPrint('checkMarquees("'..data.name..'")');
		local targetWidth = 1280 * 2;
		local instances = data.instances;
		local px = getProperty(getMqsprId(name, 1)..'.x');
		--debugPrint('checkMarquees("'..getMqsprId(name, 1)..'")');
		if (data.speed >= 0) then
			--TO-DO
		else
			if (px + (data.width * data.scale) < -targetWidth) then
				--debugPrint('checkMarquees("'..data.name..'"): pushback');
				for i = 1,instances,1 do
					local sprName = getMqsprId(name, i);
					px = px + (data.width * data.scale);
					setProperty(sprName..'.x', px);
					--debugPrint('checkMarquees() -> pushback: '..sprName..'.x = '..tostring(px));
				end
			end
			data.instances = instances;
		end
		if (name:startsWith('bg4')) then
			local py = data.y + 50 * math.sin((etime / 2) + (seq * 1.25));
			for i = 1,instances,1 do
				local sprName = getMqsprId(name, i);
				setProperty(sprName..'.y', py);
			end
			seq = seq + 1;
		end
	end
end

function onCreate()
	local path = {
		'Fall Guys/Escenario 3/',
		'Fall Guys/Escenario 3/'
	};
	local size = { 1, 0.5 };
	local slot = 2;
	local src = '';
	local width = 4000 * size[slot];
	local scale = 0.9 / size[slot];

	src = path[slot]..'Fondo';		addBackgroundSprite('bg1', src, -1200, -550, scale, 1);
	src = path[slot]..'Objetos';	addMarqueeSprite('bg2-1', src, -1200, -1000, width, -400, 3, scale);
	src = path[slot]..'Objeto_5';	addMarqueeSprite('bg2-2', src, -900, -1000, width, -400, 3, scale);
	src = path[slot]..'Blood_2';	addMarqueeSprite('bg3', src, -1200, -1000, width, -500, 3, scale);
	src = path[slot]..'Objeto_1';	addMarqueeSprite('bg4-1', src, -1200, -1000, width, -700, 3, scale);
	src = path[slot]..'Objeto_2';	addMarqueeSprite('bg4-2', src, -1200, -1000, width, -700, 3, scale);
	src = path[slot]..'Objeto_3';	addMarqueeSprite('bg4-3', src, -1200, -1000, width, -700, 3, scale);
	src = path[slot]..'Objeto_4';	addMarqueeSprite('bg4-4', src, -1200, -1000, width, -700, 3, scale);
	src = path[slot]..'Objeto_6';	addMarqueeSprite('bg4-6', src, -1650, -900, width, -700, 3, scale);
	src = path[slot]..'Objeto_7';	addMarqueeSprite('bg4-7', src, -950, -1000, width, -700, 3, scale);
	src = path[slot]..'Blood_3';	addMarqueeSprite('bg5', src, -1200, -1000, width, -1200, 3, scale);
	src = path[slot]..'Piso';		addMarqueeSprite('bg6', src, -1200, -750, width, -2000, 3, scale);
	src = path[slot]..'Blood_1';	addMarqueeSprite('bg7', src, -1200, -600, width, -800, 3, scale);
end

function onCreatePost()
	setProperty('gf.alpha', 0.0);
	checkMarquees(0); --why??
end

function onUpdate(elapsed)
	checkMarquees(elapsed);
end

function string.startsWith(String, Start)
   return string.sub(String, 1, string.len(Start))==Start
end