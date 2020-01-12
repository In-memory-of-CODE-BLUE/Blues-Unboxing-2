-- Pointshop 2 points
-- Pointshop 2 items should drop
-- Can pay with pointshop 2

/////////////////////////////////////////////////////////////////////////////
////////PLEASE READ THIS ITS IMPORTANT OR YOUR SERVER WILL BREAK!////////////
/////////////////////////////////////////////////////////////////////////////
//Each item now requires a unqie NUMBER id before anything else.
//If you look at the examples below all items have an id before the item name now
//Dont ever change an item ID or the item will be deleted from the ivnentory
//Dont ever replace an ID either (Or the old items turn into the new ones)

--Dont edit this part
if SERVER then  
    AddCSLuaFile()
    AddCSLuaFile("uc2_subconfig.lua")
end
include("uc2_subconfig.lua")

--If set to true, when the player spawns it will give them all the permamanet weapons they have so they dont have to spawn it from the menu.
BUC2.GivePermaWeaponsOnSpawn = true

--This will announce when ever someone unboxing something.
BUC2.AnnounceUnboxings = true

BUC2.CanTradePermaWeapons = false --If this is true then user can trade permanent items. This can be used to abuse buy equiping then trading. (False is recomended)
--Edit under here.
BUC2.BuyItemsWithPoints = false --If this is false then it WILL use darkrp cash.
BUC2.BuyItemsWithPoints2 = false --If this is false then it WILL use darkrp cash (Make sure only 1 is try at a time).

--If this is true then it will use point shop points rather than DarkRP cash.
 
BUC2.RanksThatCanGiveItems = { --This is the ranks that have access to give items using !unboxadmin
	"superadmin",
	"owner"
}

BUC2.ShouldDropCratesAndKeys = true --If this is false then keys and crates wont drop to users
BUC2.DropTimer = 25 --This is in minutes how long it will wait before dropping the next crate or key
BUC2.DropsAreRankLimited = true --If this is true then items will only drop for people in the drop rank list below
BUC2.DropRankList = { --This is a list of ulx ranks the items can drop for, If BUC2.DropsAreRankLimited is false then this wont be used.
	"donator1",
	"donator2",
	"admins",
	"superadmin",
	"mod",
	"vip"
} --Add what ever ulx ranks you want to the list.


--for bu_addCrate argument 1 is the main name, argument 2 is the description, argument 3 is the colour, 
--argument 4 is the only key that can open this crate, argument 5 is if it can randomly drop, 
--argument 6 is if you can buy it and argument 7 is the price 
bu_addCrate(1, "Weapon Crate" , "Contains weapons." , Color(128, 128, 128, 255) , "Weapon Key" , true , true ,  100)
bu_addCrate(2, "Money Crate" , "Contains DarkRP cash" , Color(249,200,7,255) , "Money Key" , true , true ,  100)
bu_addCrate(3, "Points Crate" , "Contains DarkRP cash" , Color(0,255,25,255) , "Points Key" , true , true ,  100)
bu_addCrate(4, "Entity Crate" , "Contains Entities" , Color(255,100,0,255) , "Entity Key" , true , true ,  100)
bu_addCrate(33, "Points2 Crate" , "Contains DarkRP cash" , Color(0,255,25,255) , "Points2 Key" , true , true ,  100)


--for bu_addKeyargument 1 is the main name, argument 2 is the description, argument 3 is the colour, 
--argument 4 is if it can drop, argument 5 is if you can buy it and argument 6 is the price 
bu_addKey(5,"Weapon Key" , "Opens money crates" , Color(249,200,7,255)  , false, true , 1000)
bu_addKey(6,"Money Key" , "Opens money crates" , Color(249,200,7,255)  , false, true , 1000)
bu_addKey(7,"Points Key" , "Opens points crates" , Color(0,255,25,255) , false, true , 1000)
bu_addKey(8,"Entity Key" , "Opens entity crates" , Color(255,100,0,255)  , false, true , 1000)
bu_addKey(38,"Points2 Key" , "Contains DankRP cash" , Color(255,100,0,255)  , false, true , 1000)

--for bu_addWeaponthe first argument is the weapons name , the second argument is the description, 
--the third argument is the weapons classname like fas2_ak47 you find it by right clicking a weapon 
--and copying to clipboard, argument 4 is the model you want displayed you need the model directory for 
--this which you find by right clicking the prop version and copying to clipboard, argument 5 is the colour, 
--argument 6 is the name of the crate it is found in, argument 7 is the chance the user will get it and argument 8 
--dictates if the weapon is permanent or not
bu_addWeapon(9,"Pistol", "A Pistol", "weapon_pistol" , "models/weapons/w_pistol.mdl", Color(100,100,255) , "Weapon Crate" , 1000 , false)
bu_addWeapon(10,"[P] Pistol", "A Permanent Pistol", "weapon_pistol" , "models/weapons/w_pistol.mdl", Color(100,100,255) , "Weapon Crate" , 100 , true)
bu_addWeapon(11,"Shotgun", "A Shotgun", "weapon_shotgun" , "models/weapons/w_shotgun.mdl", Color(255,0,200) , "Weapon Crate" , 300 , false)
bu_addWeapon(12,"[P] Shotgun", "A Permanent Shotgun", "weapon_shotgun" , "models/weapons/w_shotgun.mdl", Color(255,0,200) , "Weapon Crate" , 30 , true)
bu_addWeapon(13,"RPG", "A RPG", "weapon_rpg" , "models/weapons/w_rocket_launcher.mdl", Color(255,15,15) , "Weapon Crate" , 50 , false)
bu_addWeapon(14,"[P] RPG", "A Permanent RPG", "weapon_rpg" , "models/weapons/w_rocket_launcher.mdl", Color(255,15,15) , "Weapon Crate" , 5 , true)
 
--for bu_addMoney the first argument is the main name, the second argument is the description, 
--the third argument is the ammount of money the user recieves, the fourth argument is the colour, 
--the fifth argument is the name of the crate that holds it, the sixth argument is the chance it will appear
bu_addMoney(15,"$1000 Cash" , "An instant $1000" , 1000 , Color(50,50,255) , "Money Crate", 100)
bu_addMoney(16,"$2000 Cash" , "An instant $2000" , 2000 , Color(50,50,255) , "Money Crate", 100)
bu_addMoney(17,"$10000 Cash" , "An instant $10000" , 10000 , Color(255,0,200) , "Money Crate", 10)
bu_addMoney(18,"$15000 Cash" , "An instant $15000" , 15000 , Color(255,0,200) , "Money Crate", 10)
bu_addMoney(19,"$25000 Cash" , "An instant $25000" , 25000 , Color(255,15,15) , "Money Crate", 5)
bu_addMoney(20,"$50000 Cash" , "An instant $50000" , 50000 , Color(255,15,15) , "Money Crate", 5)
bu_addMoney(21,"$100000 Cash" , "An instant $100000" , 100000 , Color(255,215,0) , "Money Crate", 1)

--for bu_addPSPoints the first argument is the main name, the second argument is the description, 
--the third argument is the ammount of money the user recieves, the fourth argument is the colour, 
--the fifth argument is the name of the crate that holds it, the sixth argument is the chance it will appear
 
bu_addPSPoints(22,"10 Points" , "An instant 10 Points" , 10 , Color(50,50,255) , "Points Crate", 100)
bu_addPSPoints(23,"20 Points" , "An instant 20 Points" , 20 , Color(50,50,255) , "Points Crate", 100)
bu_addPSPoints(24,"100 Points" , "An instant 100 Points" , 100 , Color(255,0,200) , "Points Crate", 10)
bu_addPSPoints(25,"150 Points" , "An instant 150 Points" , 100 , Color(255,0,200) , "Points Crate", 10)
bu_addPSPoints(26,"250 Points" , "An instant 250 Points" , 250 , Color(255,15,15) , "Points Crate", 5)
bu_addPSPoints(27,"500 Points" , "An instant 500 Points" , 500 , Color(255,15,15) , "Points Crate", 5)
bu_addPSPoints(28,"1000 Points" , "An instant 1000 Points" , 1000 , Color(255,215,0) , "Points Crate", 1)

--bu_addPS2Points(37,"1000 Points" , "An instant 1000 Points" , 1000 , Color(255,215,0) , "Points2 Crate", 100)


--for bu_AddEntity the first argument is the name, the second argument is the description, 
--the third argument is the class name of the entity you find it by copying the entity from 
--the entity tab to clipboard, the fourth argument is the model name, the fifth argument is the colour, 
--the sixth argument is the name of the crate it is in, the seventh argument is the chance it will appear
bu_addEntity(29,"Printer" , "A Money printer" ,  "money_printer" , "models/props_c17/consolebox01a.mdl", Color(100,100,255) , "Entity Crate", 1000)
bu_addEntity(30,"Gun Lab" , "A Gun Lab" ,  "gunlab" , "models/props_c17/trappropeller_engine.mdl", Color(255,0,255) , "Entity Crate", 500)
bu_addEntity(31,"Drug Lab" , "A Drug Lab" ,  "drug_lab" , "models/props_lab/crematorcase.mdl", Color(2255,15,15) , "Entity Crate", 200)

--A Pointshop item is also done like rest, See the comment bellow.

--the first argument is the main name, the second argument is the description, 
--the third argument is the print name of the pointshop item if you're unsure export the items and see "Name", 
--the fourth argument is the model, the fifth argument is the colour, the sixth is the name of the crate 
--that holds it, the seventh argument is the chance it will appear

--bu_addPSItem("Cone hat" , "A Cool hat" ,  "conehat" , "somemodel",Color(255,255,255,255) , "SomeCrateName", 100)

--To add pointshop2 items do the below
//bu_addPS2Item(id, name1 , name2 ,  itemPrintName , model,color , crateName, chance)
bu_addPS2Item(34, "Cool!" , "A Cool hat" ,  "Top Hat" , "models/props_junk/trafficcone001a.mdl", Color(255,255,255,255) , "Points2 Crate", 100)
--You can remove this line, Its just to let you know the config loaded properly
 
print("[UNBOXING INFO] UNBOXING CONFIG LOADED!")