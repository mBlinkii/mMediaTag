local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local function Disabled()
	return not E.db.mMediaTag.mail_helper.enable
end

local function Feature(args, order, key, name, desc)
	args[key] = {
		order = order,
		type = "toggle",
		width = "full",
		descStyle = "inline",
		name = name,
		desc = desc,
		disabled = Disabled,
		get = function()
			return E.db.mMediaTag.mail_helper[key]
		end,
		set = function(_, value)
			E.db.mMediaTag.mail_helper[key] = value
			mMT:UpdateModule("MailHelper")
		end,
	}
end

local inbox, send = {}, {}
Feature(inbox, 1, "overview", L["Inbox Overview"], L["Shows the number of mails, the waiting gold and the mails that expire soon above the inbox."])
Feature(inbox, 2, "gold_button", L["Gold Button"], L["Adds a button to the inbox that only takes the gold from all mails and leaves the items."])
Feature(inbox, 3, "continue", L["Continue Opening"], L["Keeps opening mail when the inbox holds more mails than it can show and waits for the inbox to refresh."])
Feature(inbox, 4, "summary", L["Chat Summary"], L["Prints the collected gold and items to the chat when opening the mail is done."])
Feature(send, 1, "recipient_list", L["Recipient List"], L["Adds a button next to the recipient field that lists your alts, friends, guild members and recently mailed characters."])

mMT.options.args.comfort.args.mail_helper.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.mail_helper.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function()
			return E.db.mMediaTag.mail_helper.enable
		end,
		set = function(_, value)
			E.db.mMediaTag.mail_helper.enable = value
			mMT:UpdateModule("MailHelper")
		end,
	},
	inbox = {
		order = 2,
		type = "group",
		inline = true,
		name = _G.INBOX,
		args = inbox,
	},
	send = {
		order = 3,
		type = "group",
		inline = true,
		name = _G.SENDMAIL,
		args = send,
	},
}
