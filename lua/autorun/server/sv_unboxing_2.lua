include("unbox_config_2.lua")

local p = FindMetaTable("Player")

util.AddNetworkString("ub_inventory_update")
util.AddNetworkString("ub_purchase") 
util.AddNetworkString("BeginSpin")
util.AddNetworkString("StartClientSpinAnimation")
util.AddNetworkString("SpinEnded")
util.AddNetworkString("ub_equipweapon") 
util.AddNetworkString("ub_deleteItem")
util.AddNetworkString("ub_spawnEntity")
util.AddNetworkString("ub_giftitem")
util.AddNetworkString("ub_openui")
util.AddNetworkString("unboxadmin")
util.AddNetworkString("ub_admingiveitems")
util.AddNetworkString("ub_annouceunbox")

local t = CurTime()


if BUC2.ShouldDropCratesAndKeys then

	BUC2.DroppableItems = {}

	for k , v in pairs(BUC2.ITEMS) do
		
		if v.canDrop == true then
			
			table.insert(BUC2.DroppableItems , k)

		end

	end

	hook.Add("Think" , "CrateDropTimer" , function()

		if CurTime() > t + (BUC2.DropTimer * 60) then
			
			t = CurTime()

			for k , v in pairs(player.GetAll()) do
			
				if BUC2.DropsAreRankLimited then
					
					--Check there rank

					local allowedDrop = false

					for a, b in pairs(BUC2.DropRankList) do
						
						if v:GetUserGroup() == b then
							
							allowedDrop = true

						end

					end

					if allowedDrop then
						
						local item = BUC2.DroppableItems[math.random(#BUC2.DroppableItems)]

						v:ub_addItem(item)
						v:ChatPrint("[UNBOXING] Congratulations "..v:Name().."! You just received one free '"..item.."'!")

					end

				else

					local item = BUC2.DroppableItems[math.random(#BUC2.DroppableItems)]

					v:ub_addItem(item)
					v:ChatPrint("[UNBOXING] Congratulations "..v:Name().."! You just received one free '"..item.."'!")

				end

			end

		end

	end)

end

net.Receive("ub_admingiveitems" , function(len , ply)

	local isAllowed = false

	for k , v in pairs(BUC2.RanksThatCanGiveItems) do
			
		if ply:GetUserGroup() == v then
			
			isAllowed = true

		end

	end

	if isAllowed then
		
		local item = net.ReadString()
		local target = net.ReadEntity()
		local amount = net.ReadInt(8)

		if BUC2.ITEMS[item] == nil then return end
		if IsValid(target) ~= true then return end
		if amount < 1 or amount > 1000 then return end

		if BUC2.ITEMS[item].itemType ~= "Money" and BUC2.ITEMS[item].itemType ~= "Points" and BUC2.ITEMS[item].itemType ~= "PSItem" and BUC2.ITEMS[item].itemType ~= "PSItem2"then

			for i = 1 , amount do

				target:ub_addItem(item)

			end

		end 

		target:ChatPrint(ply:Name().." Gave you "..amount.." "..BUC2.ITEMS[item].name1.."('s)!")
		ply:ChatPrint("You gave "..target:Name().." "..amount.." "..BUC2.ITEMS[item].name1.."('s)!")

	else

		ply:ChatPrint("[UNBOXING] You do not have the permission to do that!")

	end



end)

net.Receive("ub_giftitem", function(len , ply)
 
	local itemID = net.ReadString()
	local target = net.ReadEntity()

	if BUC2.ITEMS[itemID] ~= nil and ply:ub_hasItem(itemID) then
		
		if BUC2.CanTradePermaWeapons == false and BUC2.ITEMS[itemID].permanent == true then
			
			 ply:ChatPrint("[UNBOXING] This server does not allow you to trade permanent weapons.")

			 return

		end

		if target ~= nil then
			
			ply:ub_removeItem(itemID)
			target:ub_addItem(itemID)

		end

	end


end)

net.Receive("ub_spawnEntity",function (len , ply)

	local itemID = net.ReadString()

	if ply:ub_hasItem(itemID) then

		ply:ub_removeItem(itemID)

		trace = ply:GetEyeTrace()
		posToSpawn = Vector(0,0,0)

		if trace.HitPos:Distance(ply:GetPos()) > 200 then
			
			posToSpawn = (ply:GetPos() + Vector(0,0,50)) + (ply:GetAimVector() * 100 )

		else

			posToSpawn = trace.HitPos

		end

		local temp = ents.Create(BUC2.ITEMS[itemID].entityClass)
		temp:SetPos(posToSpawn)
		temp:Spawn()

		if temp.Setowning_ent ~= nil then
			temp:Setowning_ent(ply)
		end

	end

end)

net.Receive("ub_deleteItem" , function(len, ply)

	local itemID = net.ReadString()

	if BUC2.ITEMS[itemID] == nil then print("nil") return end
	if ply:ub_hasItem(itemID) then
		ply:ub_removeItem(itemID)

	end

end)

net.Receive("ub_equipweapon",function(len , ply)

	local weaponID = net.ReadString()

	if BUC2.ITEMS[weaponID] == nil then return end

	print("Weapon Name : ", weaponID)
	PrintTable(BUC2.ITEMS[weaponID])

	if ply:ub_hasItem(weaponID) then
		
		if ply:HasWeapon(BUC2.ITEMS[weaponID].weaponName) ~= true then
			
			ply:Give(BUC2.ITEMS[weaponID].weaponName)

			if BUC2.ITEMS[weaponID].permanent == false then
				
				ply:ub_removeItem(weaponID)

			end

		end

	else

		print("[UNBOXING ERROR] Player "..ply:Name().." tried to equip a weapon the user does not own, This users may be trying to cheat.")

	end


end)

net.Receive("ub_purchase",function(len , ply)

	local item = net.ReadString()
	local amount = net.ReadInt(8) 

	--Removed the limit as its much harder to cause permance issues now
	--if #ply.ubinv + amount > BUC2.MaximumItemLimit then
	--	ply:ChatPrint("[UNBOXING] You don't have enougth space for this many items.")
	--	return
	--end

	if item ~= nil and amount ~= nil then
		
		if BUC2.ITEMS[item] == nil then return end

		if amount < 1 or amount > 16 then return end

		--Buy with DarkRP cash
		if BUC2.BuyItemsWithPoints == false and BUC2.BuyItemsWithPoints2 == false then

			if ply:canAfford(BUC2.ITEMS[item].price * amount) then
				
				ply:addMoney((BUC2.ITEMS[item].price * amount) * -1)

				for i = 1 , amount do 
					ply:ub_addItem(item, true)
				end
				ply:ub_saveInventory()
				ply:ub_update_client()
			end
		else --Buy with Points shop points
			if BUC2.BuyItemsWithPoints then
				if ply:PS_HasPoints(BUC2.ITEMS[item].price * amount) then
					
					ply:PS_TakePoints(BUC2.ITEMS[item].price * amount)

					for i = 1 , amount do 
						ply:ub_addItem(item, true)
					end
					ply:ub_saveInventory()
					ply:ub_update_client()
				end
			elseif BUC2.BuyItemsWithPoints2 then
				if ply.PS2_Wallet.points then				
					ply:PS2_AddStandardPoints(BUC2.ITEMS[item].price * amount * -1)
					for i = 1 , amount do 
						ply:ub_addItem(item, true)
					end
					ply:ub_saveInventory()
					ply:ub_update_client()
				end
			end

		end

	end

end)

function p:ub_addItem(itemID, supressSave)
	if supressSave == nil then
		supressSave = false
	end

	if self.ubinv[itemID] ~= nil then
		self.ubinv[itemID] = self.ubinv[itemID] + 1
	else
		self.ubinv[itemID] = 1
	end
	
	if not supressSave then
		self:ub_saveInventory()
		self:ub_update_client()
	end
end
 
function p:ub_update_client()
	--Convert from string id's to number id's
	local i = self.ubinv
	local inv = util.TableToJSON(i)
	local compressedInv = util.Compress(inv)

	net.Start("ub_inventory_update") 
		net.WriteDouble(string.len(compressedInv))
		net.WriteData(compressedInv, string.len(compressedInv))  
	net.Send(self)

end

function p:ub_removeItem(itemID)

	print("Before remove!", itemID)
	PrintTable(self.ubinv)

	if self.ubinv[itemID] ~= nil and self.ubinv[itemID] > 0 then
		self.ubinv[itemID] = self.ubinv[itemID] - 1
		if self.ubinv[itemID] == 0 then
			self.ubinv[itemID] = nil
		end
		self:ub_saveInventory()
		self:ub_update_client()
		return true
	else
		self:ub_saveInventory()
		self:ub_update_client()
		return false
	end
end


function p:ub_saveInventory()

	local i = {}
	--Convert back to data for saving
	for k ,v in pairs(self.ubinv) do
		i[BUC2.ItemToID[k]] = v
	end

	i["new"] = true

	file.CreateDir("blues_unboxing_2")
	file.Write("blues_unboxing_2/"..self:SteamID64().."_inventory.txt" , util.TableToJSON(i))
	--self:SetPData("UB_INV_IDS",util.TableToJSON(i))
	return true
end

function p:ub_loadInventory()
	local filename = "blues_unboxing_2/"..self:SteamID64().."_inventory.txt"
	if not file.Exists(filename , "DATA") then
 		self.ubinv = {} 
		self:ub_saveInventory()
	else 
		local i = util.JSONToTable(file.Read("blues_unboxing_2/"..self:SteamID64().."_inventory.txt", "DATA")) 
		self.ubinv = {}
		if i.new == true then
			local newInv = {}
			for k , v in pairs(i) do
				if k ~= "new" then
					if newInv[BUC2.IDToItem[k]] == nil then newInv[BUC2.IDToItem[k]] = 0 end
					newInv[BUC2.IDToItem[k]] = newInv[BUC2.IDToItem[k]] + v

					self.ubinv = newInv
				end
			end 
		else
			local newInv = {}
			for k , v in pairs(i) do
				if k ~= "new" then
					--To do, convert old inventories to valid new inventories when loaded
					if newInv[BUC2.IDToItem[v]] == nil then newInv[BUC2.IDToItem[v]] = 0 end
					newInv[BUC2.IDToItem[v]] = newInv[BUC2.IDToItem[v]] + 1
				end
			end 
			self.ubinv = newInv		
		end
	end
end

function p:ub_hasItem(itemID)
	if self.ubinv[itemID] ~= nil and self.ubinv[itemID] > 0 then
		return true
	else
		return false
	end
end

local function GiveItemByPrintName( ply, printName )
    local itemClass = Pointshop2.GetItemClassByPrintName( printName )
    if not itemClass then
            error( "Invalid item " .. tostring( printName ) )
    end
    return ply:PS2_EasyAddItem( itemClass.className )
end

net.Receive("BeginSpin",function(len, ply)


	local crateID = net.ReadString()

	if BUC2.ITEMS[crateID] == nil or BUC2.ITEMS[crateID].itemType ~= "Crate" and ply.spinPending == false then
		print("[UNBOXING] "..ply:Name().." sent a bad request. This could just be a mistake but he may be trying to cheat. (CODE 1)")
		return
	end

	if ply:ub_hasItem(crateID) and ply:ub_hasItem(BUC2.ITEMS[crateID].requiredKey) then
	
		if ply:ub_removeItem(crateID) ~= true then 
			print("[UNBOXING] "..ply:Nick().." sent a bad request. This could just be a mistake but he may be trying to cheat. (CODE 2)")
			return 
		end
		if ply:ub_removeItem(BUC2.ITEMS[crateID].requiredKey) ~= true then 
			print("[UNBOXING] "..ply:Nick().." sent a bad request. This could just be a mistake but he may be trying to cheat. (CODE 3)")
			return 
		end

		ply.ubpendingitem = generateItem(crateID)
		ply.spinPending = true

		net.Start("StartClientSpinAnimation")
			net.WriteString(ply.ubpendingitem)
		net.Send(ply)

	else
			print("[UNBOXING] "..ply:Nick().." sent a bad request. This could just be a mistake but he may be trying to cheat. (CODE 4)")
	end

end)

net.Receive("SpinEnded" , function(len , ply)

	if ply.spinPending == true then

		ply.spinPending = false
		if BUC2.ITEMS[ply.ubpendingitem].itemType == "Weapon" then
			ply:ub_addItem(ply.ubpendingitem)
		elseif BUC2.ITEMS[ply.ubpendingitem].itemType == "Money" then
			ply:addMoney(BUC2.ITEMS[ply.ubpendingitem].amount)
		elseif BUC2.ITEMS[ply.ubpendingitem].itemType == "PSItem" then 
			ply:PS_GiveItem(BUC2.ITEMS[ply.ubpendingitem].itemClass)
		elseif BUC2.ITEMS[ply.ubpendingitem].itemType == "PSItem2" then 
			GiveItemByPrintName(ply, BUC2.ITEMS[ply.ubpendingitem].itemClass)
		elseif BUC2.ITEMS[ply.ubpendingitem].itemType == "Points" then
			ply:PS_GivePoints(BUC2.ITEMS[ply.ubpendingitem].amount)
		elseif BUC2.ITEMS[ply.ubpendingitem].itemType == "Points2" then
			ply:PS2_AddStandardPoints(BUC2.ITEMS[ply.ubpendingitem].amount)
		elseif BUC2.ITEMS[ply.ubpendingitem].itemType == "Entity" then
			ply:ub_addItem(ply.ubpendingitem)
		end

		if BUC2.AnnounceUnboxings then
			net.Start("ub_annouceunbox")
			net.WriteEntity(ply) 
			net.WriteString(ply.ubpendingitem, 16) 
			net.Broadcast()
		end

		ply:ub_saveInventory()
		ply:ub_update_client()
	end

end) 

hook.Add("PlayerInitialSpawn" , "LoadUBPlayerInventory" , function(ply)
	ply:ub_loadInventory()
end)

hook.Add("PlayerSpawn", "UB2:GivePermaItems", function(ply)
	if ply.ubinv ~= nil and BUC2.GivePermaWeaponsOnSpawn == true then
		for k , v in pairs(ply.ubinv) do
			if BUC2.ITEMS[k].permanent == true then
				ply:Give(BUC2.ITEMS[k].weaponName)
			end
		end
	end
end)



function generateItem(itemID)

	local totalChance = 0

	for k , v in pairs(BUC2.ITEMS[itemID].items) do
		
			v = BUC2.ITEMS[v]

			totalChance = totalChance + v.chance

	end

	local itemList = {}
		
	local num = math.random(1 , totalChance)

	local prevCheck = 0
	local curCheck = 0

	local item = nil

	for k ,v in pairs(BUC2.ITEMS[itemID].items) do
		
		v = BUC2.ITEMS[v]

		if v.itemType ~= "Key" and v.itemType ~= "Crate" then

			if num >= prevCheck and num <= prevCheck + v.chance then
				

				item = v.name1

			end

			prevCheck = prevCheck + v.chance

		end

	end

	return item
 
end


hook.Add("PlayerSay" , "OpenTextCommand" , function(ply , text)

	if string.lower(text) == "!unbox" or string.lower(text) == "/unbox" then

		ply:ub_update_client()

		net.Start("ub_openui")
		net.Send(ply)

	end

	if string.lower(text) == "!unboxadmin" or string.lower(text) == "/unbox" then
		
		net.Start("unboxadmin")
		net.Send(ply)

	end

end) 

--Console commands
concommand.Add( "unboxing2_give", function(_, __, args)
	print("Giving item to ")
	local sid = args[1]
	local itemIDToGive = args[2]

	if IsValid(_) then
		if not table.HasValue(BUC2.RanksThatCanGiveItems, _:GetUserGroup()) then
			_:ChatPrint("Invalid Rank!")
			return false
		end
	end

	if sid == nil or sid == "" then
		print("Invalid SteamID64")
		print("The command works like this : unboxing2_give 7723672367262737 'Weapon Crate'")

		return 
	end

	local ply = player.GetBySteamID64(sid)

	if ply == nil or not IsValid(ply) then
		print("[UNBOXING 2] Failed to add item, either the player is not in the server or the steamid64 is wrong!")
		print("The command works like this : unboxing2_give 7723672367262737 'Weapon Crate'")
		return
	end

	--Now check the item is a valid item
	if BUC2.ItemToID[itemIDToGive] == nil then
		print("[UNBOXING 2] Tried to give an invalid item! The item '"..itemIDToGive.."' is not a valid item")
		print("The command works like this : unboxing2_give 7723672367262737 'Weapon Crate'")
		return 
	end

	--Okay all checks passed, lets give them there item
	ply:ub_addItem(itemIDToGive)

	print("[UNBOXING 2] Give '"..ply:Name().."' item '"..itemIDToGive.."'")

end )


--FastDL stuff
resource.AddFile( "materials/bu2/case.png" )
resource.AddFile( "materials/bu2/dialog_background.png" )
resource.AddFile( "materials/bu2/inventory_background.png" )
resource.AddFile( "materials/bu2/item_banner.png" )
resource.AddFile( "materials/bu2/item_shadow.png" )
resource.AddFile( "materials/bu2/key.png" )
resource.AddFile( "materials/bu2/money.png" )
resource.AddFile( "materials/bu2/points.png" )
resource.AddFile( "materials/bu2/spin_bg.png" )
resource.AddFile( "materials/bu2/spin_glass.png" )
resource.AddFile( "sound/ub_tick.wav" )
resource.AddFile( "resource/fonts/oss.ttf" )

