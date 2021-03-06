--[[ 
	QuickLanch Installer
	
	Licensed by GNU General Public License v3.0
	
	(c) 2017 by lupus
	based on sources from Team OneLua
]]

game.close()
color.loadpalette()

-- Set path (GLOBLAL)
__UXPATH = "ux0:data/qlinstall/"
files.mkdir(__UXPATH)
__URPATH = "ur0:shell/whats_new/np/"

-- Copy sample data to ux0:data/qlinstall
if not files.exists(__UXPATH.."app01.png") then files.copy("resources/installer/app01.png",__UXPATH) end
if not files.exists(__UXPATH.."app02.png") then files.copy("resources/installer/app02.png",__UXPATH) end
if not files.exists(__UXPATH.."app03.png") then files.copy("resources/installer/app03.png",__UXPATH) end
if not files.exists(__UXPATH.."whatsnew.xml") then files.copy("resources/installer/whatsnew.xml",__UXPATH) end
if not files.exists(__UXPATH.."userapps.ini") then files.copy("resources/installer/userapps.ini",__UXPATH) end

-- Loading UI GFX
back = image.load("resources/back.jpg")
box = image.load("resources/box.png")
defapp01 = image.load ("resources/installer/app01.png")
defapp02 = image.load ("resources/installer/app02.png")
defapp03 = image.load ("resources/installer/app03.png")
userapp01 = image.load (__UXPATH.."app01.png")
userapp02 = image.load (__UXPATH.."app02.png")
userapp03 = image.load (__UXPATH.."app03.png")

-- Reading system language
__LANG = os.language()

-- Loading sa0 fonts for translations
charfont = "sa0:data/font/pvf/psexchar.pvf"
cnfont = "sa0:data/font/pvf/cn0.pvf"
jpnfont = "sa0:data/font/pvf/jpn0.pvf"
ltnfont = "sa0:data/font/pvf/ltn4.pvf"
krfont = "sa0:data/font/pvf/kr0.pvf"

char_fnt = font.load(charfont)
if __LANG == "RUSSIAN" or __LANG == "POLISH"  then font.setdefault(ltnfont) else font.setdefault(jpnfont) end


-- Loading Special chars
if char_fnt then -- Use oficial ps symbols. Will not work without preloaded psexchr.pvf font
SYMBOL_CROSS	= "&"
SYMBOL_SQUARE   = "'"
SYMBOL_TRIANGLE = "$"
SYMBOL_CIRCLE	= "%"
else char_fnt = font.load(jpnfont)
SYMBOL_CROSS	= string.char(0xe2)..string.char(0x95)..string.char(0xb3)
SYMBOL_SQUARE	= string.char(0xe2)..string.char(0x96)..string.char(0xa1)
SYMBOL_TRIANGLE	= string.char(0xe2)..string.char(0x96)..string.char(0xb3)
SYMBOL_CIRCLE	= string.char(0xe2)..string.char(0x97)..string.char(0x8b)
end

-- reading lang strings from ux0:data/qlinstall/ if exist
if files.exists(__UXPATH.."lang/"..__LANG..".txt") then dofile(__UXPATH.."lang/"..__LANG..".txt")
else 
-- reading lang strings fom app folder if exist
	if files.exists("resources/lang/"..__LANG..".txt") then dofile("resources/lang/"..__LANG..".txt")
-- checking missing strings in translation file
	local cont = 0
	for key,value in pairs(strings) do cont += 1 end
	if cont < 23 then files.copy("resources/lang/english_us.txt",__UXPATH.."lang/") dofile("resources/lang/english_us.txt") end
-- reading default lang strings if no one translations founded or translation have missed strings
else files.copy("resources/lang/english_us.txt",__UXPATH.."lang/") dofile("resources/lang/english_us.txt") end
end

-- reading app version from .sfo
sfo = game.info("sce_sys/param.sfo")
if sfo then
ver = sfo.APP_VER
end

if os.access() == 0 then
	if back2 then back2:blit(0,0) end 
	screen.flip()
	custom.message(strings.unsafe,0)
	os.exit()
end

-- Functions
dofile("system/commons.lua")

-- Auto-Update
dofile("git/updater.lua")

------------------------------------------Main--------------------------------------------------------------
 -- Read userdata from .ini if exists (just once)
 if files.exists(__UXPATH.."userapps.ini") then dofile(__UXPATH.."userapps.ini") end

options = { strings.menuline01, strings.menuline02, strings.menuline03, strings.menuline04}
sel = 1

buttons.interval(10,12)
while true do
	buttons.read()

	if back then back:blit(0,0) end
	draw.fillrect(0,0,960,30, 0x64545353) --UP
	screen.print(10,10,strings.caption.." v"..ver,1,color.white,color.blue,__ALEFT)
	screen.print(641,10,os.date("%r  %d/%m/%y"),1,color.white,color.blue,__ALEFT)

	local y = 45
	for i=1,#options do
		if i == sel then
			draw.fillrect(40,y-2,360,21, color.blue:a(150)) 
			draw.rect(40,y-2,360,21, color.green:a(100)) 
		end
		screen.print(49,y,options[i],1.0,color.white,color.gray,__ALEFT)
		y += 25
	end

    if sel == 1 then modprev01() end
--	if sel == 2 then modprev02() end

	screen.flip()
	
	--Controls
	if buttons.up then sel-=1 end
	if buttons.down then sel+=1 end

	if sel > #options then sel=1 end
	if sel < 1 then sel=#options end

	if buttons.cross then
		if sel == 1 then if custom_msg(strings.qlinst01,1) == true then modinstall01() end
		elseif sel == 2 then modinstall02() --custom_msg(strings.qlinst02,1) == true then modinstall02() end
			elseif sel == 3 then if custom_msg(strings.cleardata,1) == true then modreset() end
				elseif sel == 4 then os.exit() buttons.homepopup(1)
		end
	end
    
end
