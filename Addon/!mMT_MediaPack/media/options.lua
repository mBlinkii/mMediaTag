local addonName, ns = ...

-- Cache WoW Globals
local CreateFrame = CreateFrame
local ReloadUI = ReloadUI
local ceil = ceil
local floor = floor

local COLUMNS, COLUMN_WIDTH, ROW_HEIGHT = 3, 190, 26
local LABEL_WIDTH, PREVIEW_WIDTH = 34, 96

local boxes = {}
local dirty = false
local master, reloadButton, hint

local function ApplyState()
	local textures = ns.db and ns.db.textures
	if not textures or not master then
		return
	end

	master:SetChecked(textures.all)

	for _, box in ipairs(boxes) do
		local editable = not textures.all
		box:SetChecked(textures.all or textures[box.key] or false)
		box:SetEnabled(editable)
		box.label:SetTextColor(editable and 1 or 0.5, editable and 0.82 or 0.5, editable and 0 or 0.5)
		box.preview:SetDesaturated(not editable)
	end

	reloadButton:SetEnabled(dirty)
	hint:SetShown(dirty)
end

function ns.MarkDirty()
	dirty = true
	ApplyState()
end

local function OnPackClick(self)
	local textures = ns.db.textures
	textures.all = false
	textures[self.key] = not textures[self.key]
	ns.MarkDirty()
end

local function OnMasterClick()
	local textures = ns.db.textures
	textures.all = not textures.all
	ns.MarkDirty()
end

local function CreateCheckBox(parent, text, labelWidth)
	local box = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	box:SetSize(24, 24)
	box.label = box:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	box.label:SetPoint("LEFT", box, "RIGHT", 2, 0)
	box.label:SetJustifyH("LEFT")
	if labelWidth then
		box.label:SetWidth(labelWidth)
	end
	box.label:SetText(text)
	return box
end

function ns.SetupOptions()
	if master or not (Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory) then
		return
	end

	local panel = CreateFrame("Frame")
	panel.name = "mMT Media Pack"

	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("mMT Media Pack")

	local note = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	note:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	note:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
	note:SetJustifyH("LEFT")
	note:SetText("Select which texture packs are registered. Loading fewer packs keeps the texture dropdowns short.")

	master = CreateCheckBox(panel, "Load all texture packs")
	master:SetPoint("TOPLEFT", note, "BOTTOMLEFT", 0, -14)
	master:SetScript("OnClick", OnMasterClick)

	local grid = CreateFrame("Frame", nil, panel)
	grid:SetPoint("TOPLEFT", master, "BOTTOMLEFT", 6, -12)
	grid:SetSize(COLUMNS * COLUMN_WIDTH, 1)

	for index, key in ipairs(ns.packList) do
		local box = CreateCheckBox(grid, ns.label[key], LABEL_WIDTH)
		box.key = key
		box:SetPoint("TOPLEFT", ((index - 1) % COLUMNS) * COLUMN_WIDTH, -floor((index - 1) / COLUMNS) * ROW_HEIGHT)
		box:SetScript("OnClick", OnPackClick)

		box.preview = box:CreateTexture(nil, "ARTWORK")
		box.preview:SetSize(PREVIEW_WIDTH, 14)
		box.preview:SetPoint("LEFT", box, "RIGHT", LABEL_WIDTH + 8, 0)
		box.preview:SetTexture(ns.TEXTURE_PATH .. ns.preview[key])

		boxes[#boxes + 1] = box
	end

	local gridHeight = ceil(#ns.packList / COLUMNS) * ROW_HEIGHT

	reloadButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	reloadButton:SetSize(150, 22)
	reloadButton:SetPoint("TOPLEFT", grid, "TOPLEFT", 0, -gridHeight - 14)
	reloadButton:SetText("Reload UI")
	reloadButton:SetScript("OnClick", ReloadUI)

	hint = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	hint:SetPoint("LEFT", reloadButton, "RIGHT", 10, 0)
	hint:SetText("Changes apply after a UI reload.")

	panel:SetScript("OnShow", ApplyState)

	local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
	category.ID = category.ID or panel.name
	Settings.RegisterAddOnCategory(category)

	ns.categoryID = category.GetID and category:GetID() or category.ID
	ApplyState()
end

function ns.OpenOptions()
	if not (ns.categoryID and Settings and Settings.OpenToCategory) then
		return false
	end

	Settings.OpenToCategory(ns.categoryID)
	return true
end
