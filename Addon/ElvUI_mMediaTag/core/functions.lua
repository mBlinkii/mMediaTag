local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

function mMT:Print(...)
	print(MEDIA.icon16 .. " " .. mMT.Name .. ":", ...)
end

function mMT:TableCopy(orig)
	local copy
	if type(orig) == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[mMT:TableCopy(orig_key)] = mMT:TableCopy(orig_value)
		end
		setmetatable(copy, mMT:TableCopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function mMT:CopyTable(current, default, merge)
	if type(current) ~= 'table' then
		current = {}
	end

	if type(default) == 'table' then
		for option, value in pairs(default) do
			local isTable = type(value) == 'table'
			if not merge or (isTable or current[option] == nil) then
				current[option] = (isTable and E:CopyTable(current[option], value, merge)) or value
			end
		end
	end

	return current
end
