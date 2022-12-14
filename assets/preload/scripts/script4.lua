--------------------------------------------------------------------------------
-- Utilitary Script for Funk Guys                                   by DragShot
--------------------------------------------------------------------------------
-- Support functions
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function rgbArrayToHex(rgb)
	local buffer = {};
	for key, value in ipairs(rgb) do
		local hex = string.format('%x', value) or '';
		if (hex:len() == 0) then
            hex = '00';
        elseif (hex:len() == 1) then
            hex = '0'..hex;
        end
		table.insert(buffer, hex);
	end
	return table.concat(buffer);
end

function getCharacterColor(name)
	return rgbArrayToHex(getProperty(name..'.healthColorArray'));
end

function mouseOver(obj, mx, my)
	local px, py, pw, ph = getProperty(obj..'.x'), getProperty(obj..'.y'), getProperty(obj..'.width'), getProperty(obj..'.height');
	if (mx >= px and mx <= px + pw and my >= py and my <= py + ph) then
		return true;
	end
	return false;
end

function string.startsWith(str, prefix)
   return string.sub(str, 1, string.len(prefix)) == prefix;
end

function string.endsWith(str, sufix)
   return string.sub(str, 0 - string.len(sufix)) == sufix;
end

function string.split(str, sep, noRegexp)
	sep = sep or ' ';
	noRegexp = noRegexp or false;
	local idx = 1;
	local length = string.len(str);
	local array = {};
	while (idx <= length) do
		local nid, nlen = string.find(str, sep, idx, noRegexp);
		if (nid) then
			table.insert(array, string.sub(str, idx, nid-1));
			idx = nlen + 1;
		else
			break;
		end
	end
	if (idx <= length) then
		table.insert(array, string.sub(str, idx));
	end
	return array;
end

function string.contains(str, text, noRegexp)
	if (text == nil or text:len() == 0) then
		return false;
	end
	noRegexp = noRegexp or false;
	local idx, slen = str:find(text, 1, noRegexp);
	if (idx) then
		return true;
	else
		return false;
	end
end

function string.replace(str, sfind, srep)
	local idx = 1;
	local length = string.len(str);
	local array = {};
	while (idx <= length) do
		local nid, nlen = string.find(str, sfind, idx, true);
		if (nid) then
			table.insert(array, string.sub(str, idx, nid-1));
			table.insert(array, srep);
			idx = nlen + 1;
		else
			break;
		end
	end
	if (idx <= length) then
		table.insert(array, string.sub(str, idx));
	end
	return table.concat(array,'');
end

function string.indexOf(str, sfind, start)
	start = start or 1;
	local nid, _ = string.find(str, sfind, start, true);
	return nid;
end

function string.trim(str)
   return (str:gsub("^%s*(.-)%s*$", "%1"));
end

function math.round(a)
	return math.floor(a + 0.5);
end

function clone(t)
	local u = { }
	for k, v in pairs(t) do u[k] = v end
	return u;--setmetatable(u, getmetatable(t))
end

function copyTo(src, dst)
	for k, v in pairs(src) do
		dst[k] = v;
	end
end

function try(fn)
	local tryBlock = { task = fn, etask = nil, ftask = nil };
	
	tryBlock.catch = function(fn)
		tryBlock.etask = fn;
		return tryBlock;
	end
	
	tryBlock.logErrors = function()
		tryBlock.etask = (function(ex) debugPrint('Error: '..tostring(ex)); end);
		return tryBlock;
	end
	
	tryBlock.finally = function(fn)
		tryBlock.ftask = fn;
		return tryBlock;
	end
	
	tryBlock.doIt = function()
		local status, result = pcall(tryBlock.task);
		if ((not status) and tryBlock.etask) then
			pcall(tryBlock.etask, result);
		end
		if (tryBlock.ftask) then
			pcall(tryBlock.ftask);
		end
	end
	
	return tryBlock;
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
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- String Paramater Reader Format: name{param=intValue|param="stringValue"|...}
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function readParam(data, line)
	local nsrt, nend = line:find('=', 1, true);
	if (nsrt) then
		local key = line:sub(1, nsrt-1);
		local value = line:sub(nend + 1, line:len());
		if (value:startsWith('"') and value:endsWith('"')) then
			value = value:sub(2, value:len() - 1);
		else
			value = tonumber(value);
		end
		data[key] = value;
		--debugPrint(key..'='..value..' ('..type(value)..')');
	end
end

function readParams(str) --'id{param=value|...}'
	local data = {};
	if (str == nil) then
		return data;
	end
	--Search for header
	local nsrt, nend = str:find('{', 1, true);
	if (nsrt) then
		data['_id'] = str:sub(1, nsrt-1):trim();
		--debugPrint(data['_id']);
	else
		return data; --Abort if not found
	end
	--Read parameters
	local pos = nend + 1;
	repeat
		nsrt, nend = str:find('[%|%}]', pos, false);
		if (nsrt) then
			readParam(data, str:sub(pos, nsrt-1));
			pos = nend + 1;
		end
	until (not nsrt);
	return data;
end
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- PropertyRef handle for quickly getting/setting properties
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PropertyRef = {}; --global class

function PropertyRef:new(target)
	--debugPrint('_new("'..target..'")');
	return setmetatable({ _ref_ = target }, PropertyRef);
end

function PropertyRef:__index(key)
	--debugPrint('_get("'..key..'")');
	if (key == "_ref_") then
		return self._ref_;
	else
		return getProperty(self._ref_.."."..key);
	end
end

function PropertyRef:__newindex(key, value)
	--debugPrint('_set("'..key..'", "'..tostring(value)..'")');
	return setProperty(self._ref_..".".. key, value);
end

function PropertyRef:__tostring()
	return '@PropertyRef{"'..self._ref_..'"}';
end
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
return { ['readParams'] = readParams, ['PropertyRef'] = PropertyRef }; --, [''] = 