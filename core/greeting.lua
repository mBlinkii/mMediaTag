local mMT, E, L, V, P, G = unpack((select(2, ...)))

function mMT:GreetingText()
    print(format("Welcome to %s %s version |CFFF7DC6F%s|r, type |CFF58D68D/mmt|r to access the in-game configuration menu.", mMT.Icon, mMT.Name, mMT.Version))
end