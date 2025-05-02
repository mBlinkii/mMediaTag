local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.IDs.boss = {
	-- Algeth'ar Academy
	["194181"] = true,
	["191736"] = true,
	["196482"] = true,
	["190609"] = true,

	-- Brackenhide Hollow
	["186122"] = true,
	["186124"] = true,
	["186125"] = true,
	["186120"] = true,
	["186121"] = true,
	["186116"] = true,

	-- Halls of Infusion
	["189719"] = true,
	["189729"] = true,
	["189722"] = true,
	["189727"] = true,

	-- Neltharus
	["189901"] = true,
	["189478"] = true,
	["181861"] = true,
	["189340"] = true,

	-- Ruby Life Pools
	["188252"] = true,
	["189232"] = true,
	["190485"] = true,
	["190484"] = true,

	-- The Azure Vault
	["186738"] = true,
	["186644"] = true,
	["186739"] = true,
	["199614"] = true,

	-- The Nokhud Offensive
	["186615"] = true,
	["195723"] = true,
	["186338"] = true,
	["186151"] = true,
	["186616"] = true,
	["186339"] = true,

	-- Uldaman: Legacy of Tyr
	["184125"] = true,
	["184124"] = true,
	["184018"] = true,
	["184422"] = true,
    ["184582"] = true,
	["184581"] = true,
	["184580"] = true,

	-- Halls of Valor
	["95674"] = true,
	["99868"] = true,
	["94960"] = true,
	["95833"] = true,
	["95675"] = true,
	["95676"] = true,

	-- Court of Stars
	["104218"] = true,
	["104217"] = true,
	["104215"] = true,

	-- Shadowmoon Burial Grounds
	["76407"] = true,
	["75452"] = true,
	["75509"] = true,

	-- Temple of the Jade Serpent
	["56448"] = true,
	["59051"] = true,
	["59726"] = true,
	["56732"] = true,
	["56439"] = true,

	-- Neltharion's Lair
	["91007"] = true,
	["91005"] = true,
	["91003"] = true,
	["91004"] = true,

	-- Freehold
	["129431"] = true,
	["129432"] = true,
	["126847"] = true,
	["129440"] = true,
	["129732"] = true,
	["126983"] = true,
	["126969"] = true,
	["126848"] = true,
	["126845"] = true,
	["126832"] = true,

	-- Underrot
	["131817"] = true,
	["131318"] = true,
	["131383"] = true,
	["133007"] = true,

	-- Vortex Pinnacle
	["43878"] = true,
	["43873"] = true,
	["43875"] = true,

	-- Dawn of the Infinite
	["198933"] = true,
	["198995"] = true,
	["198996"] = true,
	["198997"] = true,
	["198998"] = true,
	["198999"] = true,
	["199000"] = true,
	["201788"] = true,
	["201790"] = true,
	["201792"] = true,
	["209207"] = true,
	["209208"] = true,
	["203679"] = true,
	["203678"] = true,

	["203861"] = true,
	["204206"] = true,
	["204449"] = true,
	["208193"] = true,

	--Darkheart Thicket
	["103344"] = true, --oakheart
	["99192"] = true, --shade-of-xavius
	["96512"] = true, --archdruid-glaidalis
	["99200"] = true, --dresaron

	--Black Rook Hold
	["94923"] = true, --lord-kurtalos-ravencrest
	["98542"] = true, --amalgam-of-souls
	["98696"] = true, --illysanna-ravencrest
	["98949"] = true, --smashspite-the-hateful
    ["98965"] = true,
	["98970"] = true,

	-- Waycrest Manor
	["131527"] = true, --lord-waycrest
	["131667"] = true, --soulbound-goliath
	["131863"] = true, --raal-the-gluttonous
	["144324"] = true, --gorak-tul
	["135360"] = true, --sister-briar
    ["131864"] = true,
	["131823"] = true,
	["131824"] = true,
	["131825"] = true,
    ["131545"] = true,

	--Atal'Dazar
	["143577"] = true, --rezan
	["129399"] = true, --volkaal
	["129412"] = true, --yazma
	["129614"] = true, --priestess-alunza
    ["122963"] = true,
	["122965"] = true,
	["122967"] = true,
	["122968"] = true,

	--The Everbloom
	["83846"] = true, --yalnu
	["81522"] = true, --witherbark
	["82682"] = true, --archmage-sol
	["83894"] = true, --dulhu
	["83892"] = true, --life-warden-gola
	["83893"] = true, --earthshaper-telu
	["84550"] = true, --xeritac

	--Throne of the Tides
	["40788"] = true, --mindbender-ghursha
	["40765"] = true, --commander-ulthok
	["40586"] = true, --lady-nazjar
	["44566"] = true, --ozumat
	["40825"] = true, --erunak-stonespeaker
	["213770"] = true, --Ink of Ozumat

	-- Vault of the Incarnates
	["190245"] = true, --Broodkeeper-Diurna
	["184972"] = true, --Eranog
	["189492"] = true, --Raszageth
	["189813"] = true, --Dathea-Ascended
	["184986"] = true, --Kurog-Grimtotem
	["187967"] = true, --Sennarth
	["190496"] = true, --Terros
	["187771"] = true, --Kadros-Icewrath
	["187768"] = true, --Dathea-Stormlash
	["187772"] = true, --Opalfang
	["187767"] = true, --Embar-Firepath

	-- Aberrus, the Shadowed Crucible
	["200913"] = true, --Thadrion
	["200918"] = true, --Rionthus
	["199659"] = true, --Warlord Kagni
	["201320"] = true, --Rashok
	["202637"] = true, --Zskarn
	["201579"] = true, --Magmorax
	["204223"] = true, --Neltharion
	["205319"] = true, --Scalecommander Sarkareth
	["201261"] = true, --Kazzara, the Hellforged
	["201773"] = true, --Eternal Blaze
	["201774"] = true, --Essence of Shadow
	["201934"] = true, --Shadowflame Amalgamation
	["200912"] = true, --Neldris

	--Amirdrassil, the Dream's Hope
	["209333"] = true, -- Gnarlroot
	["200926"] = true, -- Igira the Cruel
	["208478"] = true, -- Volcoross
	["208363"] = true, -- Council of Dreams
	["208365"] = true, -- Council of Dreams
	["208367"] = true, -- Council of Dreams
	["208445"] = true, -- Larodar, the Keeper of the Flame
	["206172"] = true, -- Nymue, Weaver of the Cycle
	["200927"] = true, -- Smolderon
	["209090"] = true, -- Tindral Sageswift, Seer of the Flame
	["204931"] = true, -- Fyrakk the Blazing

	-- The Primalist Future (storm fury bosses)
	["199502"] = true, --glakis-winters-wrath
	["199667"] = true, --nimbulatus-storms-wrath
	["199664"] = true, --seismodor-earths-wrath

	--dragonflight world bosses
	["193534"] = true, --strunraan
	["193532"] = true, --bazual
	["193535"] = true, --basrikron
	["193533"] = true, --liskanoth
	["203220"] = true, --Vakan
	["199853"] = true, --Gholna
	["209574"] = true, --Aurostor

	--shadowlands world bosses
	["167524"] = true, --valinor
	["182466"] = true, --antros
	["178958"] = true, --morgeth
	["167525"] = true, --mortanis
	["167527"] = true, --oranomonos-the-everbranching
	["167526"] = true, --nurgash-muckformed
	["169035"] = true, --nathanos-blightcaller

	--bfa world bosses
	["154638"] = true, --grand-empress-shekzara
	["160970"] = true, --vuklaz-the-earthbreaker
	["152671"] = true, --wekemara
	["152697"] = true, --ulmath
	["148295"] = true, --ivus-the-decayed
	["144946"] = true, --ivus-the-forest-lord
	["138122"] = true, --dooms-howl
	["137374"] = true, --the-lions-roar
	["132701"] = true, --tzane
	["132253"] = true, --jiarak
	["138794"] = true, --dunegorger-kraulok
	["140252"] = true, --hailstone-construct
	["136385"] = true, --azurethos
	["140163"] = true, --warbringer-yenajz

	--legion world bosses
	["109943"] = true, --ana-mouz
	["121124"] = true, --apocron
	["117239"] = true, --brutallus
	["109331"] = true, --calamir
	["110378"] = true, --drugon-the-frostblood
	["99929"] = true, --flotsam
	["108879"] = true, --humongris
	["108829"] = true, --levantus
	["117303"] = true, --malificus
	["110321"] = true, --nazak-the-fiend
	["107544"] = true, --nithogg
	["108678"] = true, --sharthos
	["117470"] = true, --sivash
	["106981"] = true, --captain-hring
	["106984"] = true, --soultrapper-mevra
	["106982"] = true, --reaver-jdorn
	["112350"] = true, --withered-jim

	--wod world bosses
	["81252"] = true, --drov-the-ruiner
	["81535"] = true, --tarlna-the-ageless
	["83746"] = true, --rukhmar
	["94015"] = true, --supreme-lord-kazzak

	--mop world bosses
	["60491"] = true, --sha-of-anger
	["62346"] = true, --galleon
	["69099"] = true, --nalak
	["69161"] = true, --oondasta
	["72057"] = true, --ordos
	["71952"] = true, --chi-ji
	["71954"] = true, --niuzao
	["71953"] = true, --xuen
	["71955"] = true, --yulon

	--cataclysm world bosses
	["50063"] = true, --akmahat
	["50056"] = true, --garr
	["50089"] = true, --julak-doom
	["50009"] = true, --mobus
	["40728"] = true, --whale-shark
	["50061"] = true, --xariona

	--tbc world bosses
	["18728"] = true, --doom-lord-kazzak
	["17711"] = true, --doomwalker

	--classic world bosses
	["6109"] = true, --azuregos
	["15205"] = true, --baron-kazum
	["15305"] = true, --lord-skwol
	["15204"] = true, --high-marshal-whirlaxis
	["15203"] = true, --prince-skaldrenox
	["14890"] = true, --taerar
	["14887"] = true, --ysondre
	["15491"] = true, --eranikus-tyrant-of-the-dream
	["12397"] = true, --lord-kazzak
	["15571"] = true, --maws
	["15818"] = true, --lieutenant-general-nokhor
	["7846"] = true, --teremus-the-devourer
	["15625"] = true, --twilight-corrupter
	["18338"] = true, --highlord-kruul
	["14889"] = true, --emeriss
	["14888"] = true, --lethon

	--wow anniversary
	["121820"] = true, --azuregos
	["121913"] = true, --emeriss
	["121821"] = true, --lethon
	["121911"] = true, --taerar
	["121912"] = true, --ysondre
	["121818"] = true, --lord-kazzak
	["167749"] = true, --doomwalker

	--darkmoon
	["58336"] = true, --darkmoon-rabbit
	["71992"] = true, --moonfang
	["15467"] = true, --omen

	--World Events

	--Love is in the Air
	["36296"] = true, --Apothecary Hummel <Crown Chemical Co.>
	["36565"] = true, --Apothecary Baxter <Crown Chemical Co.>
	["36272"] = true, --Apothecary Frye <Crown Chemical Co.>

	--SOD bosses

	--blackfathom
	["202699"] = true, --baron-aquanis
	["201722"] = true, --ghamoo-ra
	["204068"] = true, --lady-sarevess
	["204921"] = true, --gelihast
	["207356"] = true, --lorgus-jett
	["209678"] = true, --twilight-lord-kelris
	["213334"] = true, --akumai

	---gnomeregan
	["7361"] = true, --grubbis
	["7079"] = true, --viscous-fallout
	["6235"] = true, --electrocutioner-6000
	["6229"] = true, --crowd-pummeler-9-60
	["6228"] = true, --dark-iron-ambassador
	["7800"] = true, --mekgineer-thermaplugg

	--sod event bosses
	["212804"] = true, --centrius
	["212707"] = true, --larodar
	["212803"] = true, --ceredwyn
	["212801"] = true, --jubei
	["212730"] = true, --tojara
	["212802"] = true, --moogul-the-sly
	["218690"] = true, --khadamu

	--the-rookery
	["209230"] = true, --kyrioss
	["207205"] = true, --stormguard-gorren
	["207207"] = true, --voidstone-monstrosity

	--priory-of-the-sacred-flame
	["207939"] = true, --baron-braunpyke
	["207946"] = true, --captain-dailcry
	["207940"] = true, --prioress-murrpray

	--ara-kara-city-of-echoes
	["215405"] = true, --anubzekt
	["213179"] = true, --avanoxx
	["215407"] = true, --kikatal-the-harvester
    ["220599"] = true,

	--the-stonevault
	["219440"] = true, --high-speaker-eirich
	["213119"] = true, --high-speaker-eirich
	["210156"] = true, --skarmorak
	["221586"] = true, --speaker-dorlita
	["213216"] = true, --speaker-dorlita
	["213217"] = true, --speaker-brokk]
	["210108"] = true, --e-d-n-a]

	--cinderbrew-meadery
	["218000"] = true, --benk-buzzbee
	["218002"] = true, --benk-buzzbee
	["210271"] = true, --brew-master-aldryr
	["218523"] = true, --goldie-baronbottom
	["214661"] = true, --goldie-baronbottom
	["210267"] = true, --ipa

	--city-of-threads
	["216658"] = true, --izo-the-grand-splicer
	["216648"] = true, --nx
	["216649"] = true, --vx
	["216619"] = true, --orator-krixvizk
	["216320"] = true, --the-coaglamation

	--darkflame-cleft
	["208743"] = true, --blazikon
	["210149"] = true, --ol-waxbeard
	["210153"] = true, --ol-waxbeard
	["222096"] = true, --the-candle-king
	["208745"] = true, --the-candle-king
	["210797"] = true, --the-darkness

	--the dawnbreaker
	["211089"] = true, --anubikkaj
	["211087"] = true, --speaker-shadowcrown
	["213937"] = true, --rashanan
	["224552"] = true, --rashanan

	--nerub-ar-palace
	["223779"] = true, --anubarash
	["214506"] = true, --broodtwister-ovinax
	["228470"] = true, --nexus-princess-kyveza
	["227323"] = true, --queen-ansurek
	["219853"] = true, --sikran
	["214502"] = true, --the-bloodbound-horror
	["228713"] = true, --ulgrax-the-devourer
	["214504"] = true, --rashanan
	["217748"] = true, --nexus-princess-kyveza
    ["219778"] = true,

	--mists-of-tirna-scithe
	["164567"] = true, --ingra-maloch
	["170217"] = true, --mistcaller
	["164517"] = true, --tredova
    ["164501"] = true,
	["164804"] = true,

	--the-necrotic-wake
	["162691"] = true, --blightbone
	["166945"] = true, --nalthor-the-rimebinder
	["166882"] = true, --surgeon-stitchflesh
    ["162689"] = true,
	["162693"] = true,
	["163157"] = true,

	--siege-of-boralus
	["144160"] = true, --chopper-redhook
	["129208"] = true, --dread-captain-lockwood
	["130836"] = true, --hadal-darkfathom
	["144158"] = true, --sergeant-bainbridge
	["128652"] = true, --viqgoth
    ["137614"] = true,
	["137405"] = true,
    ["136549"] = true,
	["136483"] = true,
	["128651"] = true,

	--grim-batol
	["40319"] = true, --drahga-shadowburner
	["40484"] = true, --erudax
	["40177"] = true, --forgemaster-throngus
	["39625"] = true, --general-umbriss
	["45992"] = true, --valiona
    ["40320"] = true,

	--war within world bosses
	["221084"] = true, --kordac
	["229334"] = true, --kordac 2?
	["220999"] = true, --aggregation-of-horrors
	["221224"] = true, --shurrai
	["221067"] = true, --orta
}
