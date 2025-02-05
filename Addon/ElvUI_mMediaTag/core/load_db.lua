local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local function tablecopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[tablecopy(orig_key)] = tablecopy(orig_value)
        end
        setmetatable(copy, tablecopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

