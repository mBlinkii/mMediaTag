local L = mMT.Locales

function mMT:GreetingText()
    print(format(L["Welcome to %s %s version |CFFF7DC6F%s|r, type |CFF58D68D/mmt|r to access the in-game configuration menu."], mMT.Icon, mMT.Name, mMT.Version))
end
