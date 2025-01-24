local mMT, DB, M, F, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)


mMT.options = {
	name = mMT.Name,
	handler = mMT,
	type = "group",
	childGroups = "tab",
    args = {
        logo = {
            type = "description",
            name = "",
            order = 1,
            image = function()
                return "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo.tga", 512, 64
            end,
        },
    },
}
