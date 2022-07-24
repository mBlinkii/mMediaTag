local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local format = format
local mInsert = table.insert

local function OptionsCurrencys()
	E.Options.args.mMediaTag.args.datatext.args.currencys.args = {
		headerAnima = {
			order = 100,
			type = "header",
			name = format("|CFF3390FF%s|r", L["Anima"]),
		},
		colorAnima = {
			order = 110,
			type = "select",
			name = L["Anima Color Style"],
			get = function(info)
				return E.db[mPlugin].mAnima.style
			end,
			set = function(info, value)
				E.db[mPlugin].mAnima.style = value
				DT:ForceUpdate_DataText("mAnima")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconAnima = {
			order = 120,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mAnima.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mAnima.icon = value
				DT:ForceUpdate_DataText("mAnima")
			end,
		},
		numberAnima = {
			order = 130,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mAnima.short
			end,
			set = function(info, value)
				E.db[mPlugin].mAnima.short = value
				DT:ForceUpdate_DataText("mAnima")
			end,
		},
		showmaxAnima = {
			order = 131,
			type = "toggle",
			name = L["Show Max Value"],
			desc = L["Show Max Value"],
			get = function(info)
				return E.db[mPlugin].mAnima.showmax
			end,
			set = function(info, value)
				E.db[mPlugin].mAnima.showmax = value
				DT:ForceUpdate_DataText("mAnima")
			end,
		},
		nameAnima = {
			order = 140,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mAnima.name
			end,
			set = function(info, value)
				E.db[mPlugin].mAnima.name = value
				DT:ForceUpdate_DataText("mAnima")
			end,
		},
		bagAnima = {
			order = 150,
			type = "toggle",
			name = L["Show Anima in Bags"],
			desc = L["Shows Anima in your Bags"],
			get = function(info)
				return E.db[mPlugin].mAnima.bag
			end,
			set = function(info, value)
				E.db[mPlugin].mAnima.bag = value
				DT:ForceUpdate_DataText("mAnima")
			end,
		},
		hideAnima = {
			order = 160,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mAnima.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mAnima.hide = value
				DT:ForceUpdate_DataText("mAnima")
			end,
		},
		spacerAnimaStygia = {
			order = 200,
			type = "description",
			name = "\n\n",
		},
		headerStygia = {
			order = 300,
			type = "header",
			name = format("|CFF85C1E9%s|r", L["Stygia"]),
		},
		colorStygia = {
			order = 310,
			type = "select",
			name = L["Stygia Color Style"],
			get = function(info)
				return E.db[mPlugin].mStygia.style
			end,
			set = function(info, value)
				E.db[mPlugin].mStygia.style = value
				DT:ForceUpdate_DataText("mStygia")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconStygia = {
			order = 320,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mStygia.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mStygia.icon = value
				DT:ForceUpdate_DataText("mStygia")
			end,
		},
		numberStygia = {
			order = 320,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mStygia.short
			end,
			set = function(info, value)
				E.db[mPlugin].mStygia.short = value
				DT:ForceUpdate_DataText("mStygia")
			end,
		},
		nameStygia = {
			order = 330,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mStygia.name
			end,
			set = function(info, value)
				E.db[mPlugin].mStygia.name = value
				DT:ForceUpdate_DataText("mStygia")
			end,
		},
		hideStygia = {
			order = 340,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mStygia.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mStygia.hide = value
				DT:ForceUpdate_DataText("mStygia")
			end,
		},
		spacerStygiaSoulAsh = {
			order = 400,
			type = "description",
			name = "\n\n",
		},
		headerSoulAsh = {
			order = 500,
			type = "header",
			name = format("|CFFF39C12%s|r", L["Soul Ash"]),
		},
		colorSoulAsh = {
			order = 510,
			type = "select",
			name = L["Soul Ash Color Style"],
			get = function(info)
				return E.db[mPlugin].mSoulAsh.style
			end,
			set = function(info, value)
				E.db[mPlugin].mSoulAsh.style = value
				DT:ForceUpdate_DataText("mSoulAsh")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconSoulAsh = {
			order = 520,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mSoulAsh.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mSoulAsh.icon = value
				DT:ForceUpdate_DataText("mSoulAsh")
			end,
		},
		numberSoulAsh = {
			order = 530,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mSoulAsh.short
			end,
			set = function(info, value)
				E.db[mPlugin].mSoulAsh.short = value
				DT:ForceUpdate_DataText("mSoulAsh")
			end,
		},
		showmaxSoulAsh = {
			order = 531,
			type = "toggle",
			name = L["Show Max Value"],
			desc = L["Show Max Value"],
			get = function(info)
				return E.db[mPlugin].mSoulAsh.showmax
			end,
			set = function(info, value)
				E.db[mPlugin].mSoulAsh.showmax = value
				DT:ForceUpdate_DataText("mSoulAsh")
			end,
		},
		nameSoulAsh = {
			order = 540,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mSoulAsh.name
			end,
			set = function(info, value)
				E.db[mPlugin].mSoulAsh.name = value
				DT:ForceUpdate_DataText("mSoulAsh")
			end,
		},
		hideSoulAsh = {
			order = 560,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mSoulAsh.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mSoulAsh.hide = value
				DT:ForceUpdate_DataText("mSoulAsh")
			end,
		},
		spacerSoulAshInfusedRuby = {
			order = 600,
			type = "description",
			name = "\n\n",
		},
		headerInfusedRub = {
			order = 700,
			type = "header",
			name = format("|CFFEC7063%s|r", L["Infused Ruby"]),
		},
		colorInfusedRub = {
			order = 710,
			type = "select",
			name = L["Infused Ruby Color Style"],
			get = function(info)
				return E.db[mPlugin].mInfusedRuby.style
			end,
			set = function(info, value)
				E.db[mPlugin].mInfusedRuby.style = value
				DT:ForceUpdate_DataText("mInfusedRuby")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconInfusedRub = {
			order = 720,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mInfusedRuby.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mInfusedRuby.icon = value
				DT:ForceUpdate_DataText("mInfusedRuby")
			end,
		},
		numberInfusedRub = {
			order = 730,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mInfusedRuby.short
			end,
			set = function(info, value)
				E.db[mPlugin].mInfusedRuby.short = value
				DT:ForceUpdate_DataText("mInfusedRuby")
			end,
		},
		showmaxInfusedRuby = {
			order = 731,
			type = "toggle",
			name = L["Show Max Value"],
			desc = L["Show Max Value"],
			get = function(info)
				return E.db[mPlugin].mInfusedRuby.showmax
			end,
			set = function(info, value)
				E.db[mPlugin].mInfusedRuby.showmax = value
				DT:ForceUpdate_DataText("mInfusedRuby")
			end,
		},
		nameInfusedRub = {
			order = 740,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mInfusedRuby.name
			end,
			set = function(info, value)
				E.db[mPlugin].mInfusedRuby.name = value
				DT:ForceUpdate_DataText("mInfusedRuby")
			end,
		},
		hideInfusedRub = {
			order = 750,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mInfusedRuby.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mInfusedRuby.hide = value
				DT:ForceUpdate_DataText("mInfusedRuby")
			end,
		},
		spacerInfusedRubGratefulOffering = {
			order = 800,
			type = "description",
			name = "\n\n",
		},
		headerGratefulOffering = {
			order = 900,
			type = "header",
			name = format("|CFFF4D03F%s|r", L["Grateful Offering"]),
		},
		colorGratefulOffering = {
			order = 910,
			type = "select",
			name = L["Grateful Offering Color Style"],
			get = function(info)
				return E.db[mPlugin].mGratefulOffering.style
			end,
			set = function(info, value)
				E.db[mPlugin].mGratefulOffering.style = value
				DT:ForceUpdate_DataText("mGratefulOffering")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconGratefulOffering = {
			order = 920,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mGratefulOffering.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mGratefulOffering.icon = value
				DT:ForceUpdate_DataText("mGratefulOffering")
			end,
		},
		numberGratefulOffering = {
			order = 930,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mGratefulOffering.short
			end,
			set = function(info, value)
				E.db[mPlugin].mGratefulOffering.short = value
				DT:ForceUpdate_DataText("mGratefulOffering")
			end,
		},
		nameGratefulOffering = {
			order = 940,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mGratefulOffering.name
			end,
			set = function(info, value)
				E.db[mPlugin].mGratefulOffering.name = value
				DT:ForceUpdate_DataText("mGratefulOffering")
			end,
		},
		hideGratefulOffering = {
			order = 950,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mGratefulOffering.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mGratefulOffering.hide = value
				DT:ForceUpdate_DataText("mGratefulOffering")
			end,
		},
		spacerGratefulOfferingValor = {
			order = 1000,
			type = "description",
			name = "\n\n",
		},
		headerValor = {
			order = 1100,
			type = "header",
			name = format("|CFFA569BD%s|r", L["Valor"]),
		},
		colorValor = {
			order = 1110,
			type = "select",
			name = L["Valor Color Style"],
			get = function(info)
				return E.db[mPlugin].mValor.style
			end,
			set = function(info, value)
				E.db[mPlugin].mValor.style = value
				DT:ForceUpdate_DataText("mValor")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconValorh = {
			order = 1120,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mValor.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mValor.icon = value
				DT:ForceUpdate_DataText("mValor")
			end,
		},
		numberValor = {
			order = 1130,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mValor.short
			end,
			set = function(info, value)
				E.db[mPlugin].mValor.short = value
				DT:ForceUpdate_DataText("mValor")
			end,
		},
		showmaxValor = {
			order = 1131,
			type = "toggle",
			name = L["Show Max Value"],
			desc = L["Show Max Value"],
			get = function(info)
				return E.db[mPlugin].mValor.showmax
			end,
			set = function(info, value)
				E.db[mPlugin].mValor.showmax = value
				DT:ForceUpdate_DataText("mValor")
			end,
		},
		nameValor = {
			order = 1140,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mValor.name
			end,
			set = function(info, value)
				E.db[mPlugin].mValor.name = value
				DT:ForceUpdate_DataText("mValor")
			end,
		},
		hideValor = {
			order = 1150,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mValor.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mValor.hide = value
				DT:ForceUpdate_DataText("mValor")
			end,
		},
		spacerCatalogedResearchValor = {
			order = 1150,
			type = "description",
			name = "\n\n",
		},
		headerCatalogedResearch = {
			order = 1200,
			type = "header",
			name = format("|CFF87FC0B%s|r", L["Cataloged Research"]),
		},
		colorCatalogedResearch = {
			order = 1210,
			type = "select",
			name = L["Cataloged Research Color Style"],
			get = function(info)
				return E.db[mPlugin].mCatalogedResearch.style
			end,
			set = function(info, value)
				E.db[mPlugin].mCatalogedResearch.style = value
				DT:ForceUpdate_DataText("mCatalogedResearch")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconCatalogedResearch = {
			order = 1220,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mCatalogedResearch.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mCatalogedResearch.icon = value
				DT:ForceUpdate_DataText("mCatalogedResearch")
			end,
		},
		numberCatalogedResearch = {
			order = 1230,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mCatalogedResearch.short
			end,
			set = function(info, value)
				E.db[mPlugin].mCatalogedResearch.short = value
				DT:ForceUpdate_DataText("mCatalogedResearch")
			end,
		},
		showmaxCatalogedResearch = {
			order = 1231,
			type = "toggle",
			name = L["Show Max Value"],
			desc = L["Show Max Value"],
			get = function(info)
				return E.db[mPlugin].mCatalogedResearch.showmax
			end,
			set = function(info, value)
				E.db[mPlugin].mCatalogedResearch.showmax = value
				DT:ForceUpdate_DataText("mCatalogedResearch")
			end,
		},
		nameCatalogedResearch = {
			order = 1240,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mCatalogedResearch.name
			end,
			set = function(info, value)
				E.db[mPlugin].mCatalogedResearch.name = value
				DT:ForceUpdate_DataText("mCatalogedResearch")
			end,
		},
		bagCatalogedResearch = {
			order = 1250,
			type = "toggle",
			name = L["Show Cataloged Research in Bags"],
			desc = L["Shows Cataloged Research in your Bags"],
			get = function(info)
				return E.db[mPlugin].mCatalogedResearch.bag
			end,
			set = function(info, value)
				E.db[mPlugin].mCatalogedResearch.bag = value
				DT:ForceUpdate_DataText("mCatalogedResearch")
			end,
		},
		hideCatalogedResearch = {
			order = 1260,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mCatalogedResearch.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mCatalogedResearch.hide = value
				DT:ForceUpdate_DataText("mCatalogedResearch")
			end,
		},
		spacerCatalogedResearchSoulCinders = {
			order = 1260,
			type = "description",
			name = "\n\n",
		},
		headerSoulCinders = {
			order = 1300,
			type = "header",
			name = format("|CFFFF5500%s|r", L["Soul Cinders"]),
		},
		colorSoulCinders = {
			order = 1310,
			type = "select",
			name = L["Soul Cinders Color Style"],
			get = function(info)
				return E.db[mPlugin].mSoulCinders.style
			end,
			set = function(info, value)
				E.db[mPlugin].mSoulCinders.style = value
				DT:ForceUpdate_DataText("mSoulCinders")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconSoulCinders = {
			order = 1320,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mSoulCinders.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mSoulCinders.icon = value
				DT:ForceUpdate_DataText("mSoulCinders")
			end,
		},
		numberSoulCinders = {
			order = 1330,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mSoulCinders.short
			end,
			set = function(info, value)
				E.db[mPlugin].mSoulCinders.short = value
				DT:ForceUpdate_DataText("mSoulCinders")
			end,
		},
		nameSoulCinders = {
			order = 1340,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mSoulCinders.name
			end,
			set = function(info, value)
				E.db[mPlugin].mSoulCinders.name = value
				DT:ForceUpdate_DataText("mSoulCinders")
			end,
		},
		hideSoulCinders = {
			order = 1350,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mSoulCinders.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mSoulCinders.hide = value
				DT:ForceUpdate_DataText("mSoulCinders")
			end,
		},
		spacerSoulCindersStygianEmber = {
			order = 1350,
			type = "description",
			name = "\n\n",
		},
		headerStygianEmber = {
			order = 1400,
			type = "header",
			name = format("|CFFAC0BFC%s|r", L["Stygian Ember"]),
		},
		colorStygianEmber = {
			order = 1410,
			type = "select",
			name = L["Stygian Ember Color Style"],
			get = function(info)
				return E.db[mPlugin].mStygianEmber.style
			end,
			set = function(info, value)
				E.db[mPlugin].mStygianEmber.style = value
				DT:ForceUpdate_DataText("mStygianEmber")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconStygianEmber = {
			order = 1420,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mStygianEmber.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mStygianEmber.icon = value
				DT:ForceUpdate_DataText("mStygianEmber")
			end,
		},
		numberStygianEmber = {
			order = 1430,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mStygianEmber.short
			end,
			set = function(info, value)
				E.db[mPlugin].mStygianEmber.short = value
				DT:ForceUpdate_DataText("mStygianEmber")
			end,
		},
		nameStygianEmber = {
			order = 1440,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mStygianEmber.name
			end,
			set = function(info, value)
				E.db[mPlugin].mStygianEmber.name = value
				DT:ForceUpdate_DataText("mStygianEmber")
			end,
		},
		hideStygianEmber = {
			order = 1450,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mStygianEmber.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mStygianEmber.hide = value
				DT:ForceUpdate_DataText("mStygianEmber")
			end,
		},
		spacerStygianEmberTowerKnowledge = {
			order = 1450,
			type = "description",
			name = "\n\n",
		},
		headerTowerKnowledge = {
			order = 1500,
			type = "header",
			name = format("|CFFCCF7E4%s|r", L["Tower Knowledge"]),
		},
		colorTowerKnowledge = {
			order = 1510,
			type = "select",
			name = L["Tower Knowledge Color Style"],
			get = function(info)
				return E.db[mPlugin].mTowerKnowledge.style
			end,
			set = function(info, value)
				E.db[mPlugin].mTowerKnowledge.style = value
				DT:ForceUpdate_DataText("mTowerKnowledge")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconTowerKnowledge = {
			order = 1520,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mTowerKnowledge.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mTowerKnowledge.icon = value
				DT:ForceUpdate_DataText("mTowerKnowledge")
			end,
		},
		numberTowerKnowledge = {
			order = 1530,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mTowerKnowledge.short
			end,
			set = function(info, value)
				E.db[mPlugin].mTowerKnowledge.short = value
				DT:ForceUpdate_DataText("mTowerKnowledge")
			end,
		},
		nameTowerKnowledge = {
			order = 1540,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mTowerKnowledge.name
			end,
			set = function(info, value)
				E.db[mPlugin].mTowerKnowledge.name = value
				DT:ForceUpdate_DataText("mTowerKnowledge")
			end,
		},
		hideTowerKnowledge = {
			order = 1550,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mTowerKnowledge.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mTowerKnowledge.hide = value
				DT:ForceUpdate_DataText("mTowerKnowledge")
			end,
		},
		spacerStygianEmberCosmicFlux = {
			order = 1600,
			type = "description",
			name = "\n\n",
		},
		headerCosmicFlux = {
			order = 1610,
			type = "header",
			name = format("|CFFFFD968%s|r", L["Cosmic Flux"]),
		},
		colorCosmicFlux = {
			order = 1620,
			type = "select",
			name = L["Stygian Ember Color Style"],
			get = function(info)
				return E.db[mPlugin].mCosmicFlux.style
			end,
			set = function(info, value)
				E.db[mPlugin].mCosmicFlux.style = value
				DT:ForceUpdate_DataText("mCosmicFlux")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconCosmicFlux = {
			order = 1630,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mCosmicFlux.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mCosmicFlux.icon = value
				DT:ForceUpdate_DataText("mCosmicFlux")
			end,
		},
		numberCosmicFlux = {
			order = 1640,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mCosmicFlux.short
			end,
			set = function(info, value)
				E.db[mPlugin].mCosmicFlux.short = value
				DT:ForceUpdate_DataText("mCosmicFlux")
			end,
		},
		nameCosmicFlux = {
			order = 1650,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mCosmicFlux.name
			end,
			set = function(info, value)
				E.db[mPlugin].mCosmicFlux.name = value
				DT:ForceUpdate_DataText("mCosmicFlux")
			end,
		},
		hideCosmicFlux = {
			order = 1660,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mCosmicFlux.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mCosmicFlux.hide = value
				DT:ForceUpdate_DataText("mCosmicFlux")
			end,
		},
		spacerCosmicFluxCyphersFirstOnes = {
			order = 1700,
			type = "description",
			name = "\n\n",
		},
		headerCyphersFirstOnes = {
			order = 1710,
			type = "header",
			name = format("|CFFAED0E1%s|r", L["Cyphers of the First Ones"]),
		},
		colorCyphersFirstOnes = {
			order = 1720,
			type = "select",
			name = L["Stygian Ember Color Style"],
			get = function(info)
				return E.db[mPlugin].mCyphersFirstOnes.style
			end,
			set = function(info, value)
				E.db[mPlugin].mCyphersFirstOnes.style = value
				DT:ForceUpdate_DataText("mCyphersFirstOnes")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconCyphersFirstOnes = {
			order = 1730,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mCyphersFirstOnes.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mCyphersFirstOnes.icon = value
				DT:ForceUpdate_DataText("mCyphersFirstOnes")
			end,
		},
		numberCyphersFirstOnes = {
			order = 1740,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mCyphersFirstOnes.short
			end,
			set = function(info, value)
				E.db[mPlugin].mCyphersFirstOnes.short = value
				DT:ForceUpdate_DataText("mCyphersFirstOnes")
			end,
		},
		nameCyphersFirstOnes = {
			order = 1750,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mCyphersFirstOnes.name
			end,
			set = function(info, value)
				E.db[mPlugin].mCyphersFirstOnes.name = value
				DT:ForceUpdate_DataText("mCyphersFirstOnes")
			end,
		},
		hideCyphersFirstOnes = {
			order = 1760,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mCyphersFirstOnes.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mCyphersFirstOnes.hide = value
				DT:ForceUpdate_DataText("mCyphersFirstOnes")
			end,
		},
		spacerTimewarpedBadgeTimewarpedBadge = {
			order = 1800,
			type = "description",
			name = "\n\n",
		},
		headerTimewarpedBadge = {
			order = 1810,
			type = "header",
			name = format("|CFF0873B9%s|r", L["Timewarped Badge"]),
		},
		colorTimewarpedBadge = {
			order = 1820,
			type = "select",
			name = L["Stygian Ember Color Style"],
			get = function(info)
				return E.db[mPlugin].mTimewarpedBadge.style
			end,
			set = function(info, value)
				E.db[mPlugin].mTimewarpedBadge.style = value
				DT:ForceUpdate_DataText("mTimewarpedBadge")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconTimewarpedBadge = {
			order = 1830,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mTimewarpedBadge.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mTimewarpedBadge.icon = value
				DT:ForceUpdate_DataText("mTimewarpedBadge")
			end,
		},
		numberTimewarpedBadge = {
			order = 1840,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mTimewarpedBadge.short
			end,
			set = function(info, value)
				E.db[mPlugin].mTimewarpedBadge.short = value
				DT:ForceUpdate_DataText("mTimewarpedBadge")
			end,
		},
		nameTimewarpedBadge = {
			order = 1850,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mTimewarpedBadge.name
			end,
			set = function(info, value)
				E.db[mPlugin].mTimewarpedBadge.name = value
				DT:ForceUpdate_DataText("mTimewarpedBadge")
			end,
		},
		hideTimewarpedBadge = {
			order = 1860,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mTimewarpedBadge.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mTimewarpedBadge.hide = value
				DT:ForceUpdate_DataText("mTimewarpedBadge")
			end,
		},
		spacerConquestConquest = {
			order = 1900,
			type = "description",
			name = "\n\n",
		},
		headerConquest = {
			order = 1910,
			type = "header",
			name = format("|CFFC9913C%s|r", L["Conquest"]),
		},
		colorConquest = {
			order = 1920,
			type = "select",
			name = L["Color Style"],
			get = function(info)
				return E.db[mPlugin].mConquest.style
			end,
			set = function(info, value)
				E.db[mPlugin].mConquest.style = value
				DT:ForceUpdate_DataText("mConquest")
			end,
			values = {
				auto = L["Auto"],
				color = L["Color"],
				white = L["White"],
			},
		},
		iconConquest = {
			order = 1930,
			type = "toggle",
			name = L["Icon"],
			desc = L["Show Icon"],
			get = function(info)
				return E.db[mPlugin].mConquest.icon
			end,
			set = function(info, value)
				E.db[mPlugin].mConquest.icon = value
				DT:ForceUpdate_DataText("mConquest")
			end,
		},
		numberConquest = {
			order = 1940,
			type = "toggle",
			name = L["Short Number"],
			desc = L["Short Number"],
			get = function(info)
				return E.db[mPlugin].mConquest.short
			end,
			set = function(info, value)
				E.db[mPlugin].mConquest.short = value
				DT:ForceUpdate_DataText("mConquest")
			end,
		},
		showmaxConquest = {
			order = 1941,
			type = "toggle",
			name = L["Show Max Value"],
			desc = L["Show Max Value"],
			get = function(info)
				return E.db[mPlugin].mConquest.showmax
			end,
			set = function(info, value)
				E.db[mPlugin].mConquest.showmax = value
				DT:ForceUpdate_DataText("mConquest ")
			end,
		},
		nameConquest = {
			order = 1950,
			type = "toggle",
			name = L["Name"],
			desc = L["Shows Name"],
			get = function(info)
				return E.db[mPlugin].mConquest.name
			end,
			set = function(info, value)
				E.db[mPlugin].mConquest.name = value
				DT:ForceUpdate_DataText("mConquest")
			end,
		},
		hideConquest = {
			order = 1960,
			type = "toggle",
			name = L["Hide if Zero"],
			get = function(info)
				return E.db[mPlugin].mConquest.hide
			end,
			set = function(info, value)
				E.db[mPlugin].mConquest.hide = value
				DT:ForceUpdate_DataText("mConquest")
			end,
		},
	}
end
mInsert(ns.Config, OptionsCurrencys)
