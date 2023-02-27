local mMT, E, L, V, P, G = unpack(select(2, ...))

local  tinsert =  tinsert

local function configTable()
	E.Options.args.mMT = {
		type = 'group',
		name = mMT.Icon .. " " .. mMT.Name,
		childGroups = "tab",
		order = 10,
		args = {

		},
	}
end

tinsert(mMT.Config, configTable)