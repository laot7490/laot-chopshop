local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
LAOT = nil

USER = {}
USER.Wrecking = false
USER.Car = nil

USER.rim1 = false
USER.rim2 = false
USER.rim3 = false
USER.rim4 = false
USER.allRims = false
USER.radio = false
USER.radioDone = false
USER.engine = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while LAOT == nil do
		TriggerEvent('LAOTCore:GetObject', function(obj) LAOT = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	createPeds()
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function playerAnim()
	loadAnimDict( "mp_safehouselost@" )
    TaskPlayAnim( PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
end

createPeds = function()
	local hash = LAOT.Streaming.LoadModel(C.NPC["hash"])
	NPC = CreatePed(0, hash, C.NPC["coords"].x, C.NPC["coords"].y, C.NPC["coords"].z, C.NPC["coords"].h, false)
    FreezeEntityPosition(NPC, true)
	SetEntityInvincible(NPC, true)
	SetBlockingOfNonTemporaryEvents(NPC, true)
end

RegisterNetEvent('laot-chopshop:Notification')
AddEventHandler('laot-chopshop:Notification', function(type, text)
	LAOT.Functions.Notify(type, text)
end)


-- local l = GetOffsetFromEntityInWorldCoords(callback_vehicle, 0.0, 4.8, 0.0 + 1.2)

Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), C.Car["x"], C.Car["y"], C.Car["z"], true) <= 3 then
				sleep = 2
				LAOT.Functions.DrawText3D(C.Car["x"], C.Car["y"], C.Car["z"]+0.50, L["wreck"])
				if IsControlJustPressed(0, Keys["E"]) then
					ESX.TriggerServerCallback('laot-chopshop:GetPolice', function(laot)
						if laot == 1 then
							local ped = GetPlayerPed(-1)
							local veh = GetVehiclePedIsIn(ped, false)
							if veh then
								USER.Car = veh
								USER.Wrecking = true
								USER.rim1 = false
								USER.rim2 = false
								USER.rim3 = false
								USER.rim4 = false
								USER.allRims = false
								USER.radio = false
								USER.radioDone = false
								USER.engine = false
								SetEntityCoords(veh, C.Car["x"], C.Car["y"], C.Car["z"], 0.0,0.0,0.0, true)
								SetEntityHeading(veh, C.Car["h"])
								SetVehicleDoorOpen(veh, 0, false, false)
								SetVehicleDoorOpen(veh, 1, false, false)
								SetVehicleDoorOpen(veh, 2, false, false)
								SetVehicleDoorOpen(veh, 3, false, false)
								SetVehicleDoorOpen(veh, 4, false, false)
								SetVehicleDoorOpen(veh, 5, false, false)
								TaskLeaveVehicle(ped, veh, 256)
								SetVehicleDoorsLocked(veh, 2)

								if math.random(1,3) > 1 then
									Citizen.Wait(3500)
									local playerPed = GetPlayerPed(-1)
									local plyPos = GetEntityCoords(GetPlayerPed(-1))
									local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
									local street1 = GetStreetNameFromHashKey(s1)
									zone = tostring(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
									local playerStreetsLocation = zoneNames[tostring(zone)]
									local street1 = street1 .. ", " .. playerStreetsLocation
									local street2 = GetStreetNameFromHashKey(s2)
									local adres = street1.. " " .. street2
									local v = GetEntityCoords(playerPed)
									print(v)
									TriggerServerEvent('esx_outlawalert:laotCarChop', {
									  x = ESX.Math.Round(v.x, 1),
									  y = ESX.Math.Round(v.y, 1),
									  z = ESX.Math.Round(v.z, 1)
									}, adres, playerGender, 'Çalıntı araç parçalanıyor!')
								end
							end
						else
							LAOT.Functions.Notify("error", "Yeterli polis yok!")
						end
					end)
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		if USER.Wrecking and USER.Car and not USER.rim1 then
			local C1 = GetOffsetFromEntityInWorldCoords(USER.Car, -1.1, 1.1, 0.0)

			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), C1.x, C1.y, C1.z, true) <= 1 then
				sleep = 2
				LAOT.Functions.DrawText3D(C1.x, C1.y, C1.z, "~b~E ~w~- Jantı Çıkar")
				if IsControlJustPressed(0, 38) then
					USER.rim1 = true
					TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
					exports["t0sic_loadingbar"]:StartDelayedFunction("Jantı yerinden çıkarıyorsun", 8000, function()
						TriggerServerEvent("laot-chopshop:AddItem", C.Items["rim"]["name"], 1)
						TriggerServerEvent("laot-chopshop:AddItem", C.Items["wire"]["name"], math.random(3,5))
						ClearPedTasks(GetPlayerPed(-1))
						SetVehicleDoorBroken(USER.Car, 0, false)
						SetVehicleDoorBroken(USER.Car, 5, false)

						if USER.rim1 and USER.rim2 and USER.rim3 and USER.rim4 then
							USER.allRims = true
						end
					end)
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		if USER.Wrecking and USER.Car and not USER.rim2 then
			local C1 = GetOffsetFromEntityInWorldCoords(USER.Car, -1.1, -1.1, 0.0)

			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), C1.x, C1.y, C1.z, true) <= 1 then
				sleep = 2
				LAOT.Functions.DrawText3D(C1.x, C1.y, C1.z, "~y~E ~w~- Jantı Çıkar")
				if IsControlJustPressed(0, 38) then
					USER.rim2 = true
					TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
					exports["t0sic_loadingbar"]:StartDelayedFunction("Jantı yerinden çıkarıyorsun", 8000, function()
						TriggerServerEvent("laot-chopshop:AddItem", C.Items["rim"]["name"], 1)
						TriggerServerEvent("laot-chopshop:AddItem", C.Items["wire"]["name"], math.random(3,5))
						ClearPedTasks(GetPlayerPed(-1))
						SetVehicleDoorBroken(USER.Car, 4, false)

						if USER.rim1 and USER.rim2 and USER.rim3 and USER.rim4 then
							USER.allRims = true
						end
					end)
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		if USER.Wrecking and USER.Car and not USER.rim3 then
			local C1 = GetOffsetFromEntityInWorldCoords(USER.Car, 1.1, 1.1, 0.0)

			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), C1.x, C1.y, C1.z, true) <= 1 then
				sleep = 2
				LAOT.Functions.DrawText3D(C1.x, C1.y, C1.z, "~g~E ~w~- Jantı Çıkar")
				if IsControlJustPressed(0, 38) then
					USER.rim3 = true
					TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
					exports["t0sic_loadingbar"]:StartDelayedFunction("Jantı yerinden çıkarıyorsun", 8000, function()
						TriggerServerEvent("laot-chopshop:AddItem", C.Items["rim"]["name"], 1)
						TriggerServerEvent("laot-chopshop:AddItem", C.Items["wire"]["name"], math.random(3,5))
						ClearPedTasks(GetPlayerPed(-1))
						SetVehicleDoorBroken(USER.Car, 1, false)

						if USER.rim1 and USER.rim2 and USER.rim3 and USER.rim4 then
							USER.allRims = true
						end
					end)
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		if USER.Wrecking and USER.Car and not USER.rim4 then
			local C1 = GetOffsetFromEntityInWorldCoords(USER.Car, 1.1, -1.1, 0.0)

			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), C1.x, C1.y, C1.z, true) <= 1 then
				sleep = 2
				LAOT.Functions.DrawText3D(C1.x, C1.y, C1.z, "~r~E ~w~- Jantı Çıkar")
				if IsControlJustPressed(0, 38) then
					USER.rim4 = true
					TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
					exports["t0sic_loadingbar"]:StartDelayedFunction("Jantı yerinden çıkarıyorsun", 8000, function()
						TriggerServerEvent("laot-chopshop:AddItem", C.Items["rim"]["name"], 1)
						TriggerServerEvent("laot-chopshop:AddItem", C.Items["wire"]["name"], math.random(3,5))
						ClearPedTasks(GetPlayerPed(-1))

						if USER.rim1 and USER.rim2 and USER.rim3 and USER.rim4 then
							USER.allRims = true
						end
					end)
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

Finish = function()
	DeleteEntity(USER.Car)
	USER.Car = nil
	USER.Wrecking = false
	USER.rim1 = false
	USER.rim2 = false
	USER.rim3 = false
	USER.rim4 = false
	USER.allRims = false
	USER.radio = false
	USER.radioDone = false
	USER.engine = false
	LAOT.Functions.Notify("inform", "Araç parçalandı.")
end

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		if USER.Wrecking and USER.Car and USER.rim1 and USER.rim2 and USER.rim3 and USER.rim4 and not USER.radio and USER.allRims then
			local C1 = GetOffsetFromEntityInWorldCoords(USER.Car, -0.4, 0.5, 0.0)

			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), C1.x, C1.y, C1.z, true) <= 1.5 then
				sleep = 2
				LAOT.Functions.DrawText3D(C1.x, C1.y, C1.z, "~b~E ~w~- Radyoyu Çıkar")
				if IsControlJustPressed(0, 38) then
					USER.radio = true
					TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
					exports["t0sic_loadingbar"]:StartDelayedFunction("Radyoyu yerinden çıkarıyorsun", 10000, function()
						TriggerServerEvent("laot-chopshop:AddItem", C.Items["radio"]["name"], 1)
						TriggerServerEvent("laot-chopshop:AddItem", C.Items["wire"]["name"], math.random(5,9))
						ClearPedTasks(GetPlayerPed(-1))
						USER.radioDone = true
					end)
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		if USER.Wrecking and USER.Car and USER.rim1 and USER.rim2 and USER.rim3 and USER.rim4 and USER.radio and not USER.engine and USER.radioDone then
			local C1 = GetOffsetFromEntityInWorldCoords(USER.Car, -0.1, 2.0, 0.1)

			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), C1.x, C1.y, C1.z, true) <= 1.5 then
				sleep = 2
				LAOT.Functions.DrawText3D(C1.x, C1.y, C1.z, "~b~E ~w~- Motoru Çıkar")
				if IsControlJustPressed(0, 38) then
					USER.engine = true
					TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
					exports["t0sic_loadingbar"]:StartDelayedFunction("Motoru çıkartıyorsun", 18500, function()
						TriggerServerEvent("laot-chopshop:AddItem", C.Items["motor"]["name"], 1)
						TriggerServerEvent("laot-chopshop:AddItem", C.Items["wire"]["name"], math.random(7,12))
						ClearPedTasks(GetPlayerPed(-1))

						if math.random(1,10) == 1 then
							LAOT.Functions.Notify("inform", "Motoru çıkarırken araçta NOS buldun!")
							TriggerServerEvent("laot-chopshop:AddItem", "nitro", 1)
						end
						
						Finish()
					end)
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 850
		if not USER.Wrecking then
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), C.NPC["coords"].x, C.NPC["coords"].y, C.NPC["coords"].z, true) <= 3 then
				sleep = 2
				LAOT.Functions.DrawText3D(C.NPC["coords"].x, C.NPC["coords"].y, C.NPC["coords"].z+2.0, L["sell"])
				if IsControlJustPressed(0, 38) then
					playerAnim()
					Citizen.Wait(2000)
					TriggerServerEvent("laot-chopshop:SellNPC")
				end
			else
				Citizen.Wait(1000)
			end
		end
		Citizen.Wait(sleep)
	end
end)


zoneNames = { AIRP = "Los Santos Uluslararası Havalimanı", ALAMO = "Alamo Denizi", ALTA = "Alta", ARMYB = "Zancuda Askeri Üs", BANHAMC = "Banham Kanyonu", BANNING = "Banning", BAYTRE = "Baytree Kanyonu",  BEACH = "Vespucci Kumsalı", BHAMCA = "Banham Kanyonu", BRADP = "Braddock Geçişi", BRADT = "Braddock Tüneli", BURTON = "Burton", CALAFB = "Calafia Köprüsü", CANNY = "Raton Kanyonu", CCREAK = "Cassidy Deresi", CHAMH = "Chamberlain Tepesi", CHIL = "Vinewood Tepesi", CHU = "Chumash", CMSW = "Chiliad Dağı Eyalet Bölgesi", CYPRE = "Cypress Evleri", DAVIS = "Davis", DELBE = "Del Perro Sahili", DELPE = "Del Perro", DELSOL = "La Puerta", DESRT = "Büyük Senora Çölü", DOWNT = "Downtown", DTVINE = "Downtown Vinewood", EAST_V = "Doğu Vinewood", EBURO = "El Burro Tepeleri", ELGORL = "El Gordo Deniz Feneri", ELYSIAN = "Cennet Adası", GALFISH = "Galilee Takas Kampı", GALLI = "Galileo Parkı", golf = "GWC ve Golf	Topluluğu", GRAPES = "Grapeseed", GREATC = "Büyük Chaparral", HARMO = "Harmony", HAWICK = "Hawick", HORS = "Vinewood Yarış Pisti", HUMLAB = "Humane Lab. ve Araştırma Ens.", JAIL = "Federal Hapishane", KOREAT = "Little Seoul", LACT = "Land Act Baraj Gölü", LAGO = "Zancudo Gölü", LDAM = "Land Act Barajı", LEGSQU = "Legion Meydanı", LMESA = "La Mesa", LOSPUER = "La Puerta", MIRR = "Mirror Park", MORN = "Morningwood", MOVIE = "Görkemli Richards", MTCHIL = "Chiliad Dağı", MTGORDO = "Gordo Dağı", MTJOSE = "Josiah Dağı", MURRI = "Murrieta Tepeleri", NCHU = "Kuzey Chumash", NOOSE = "N.O.O.S.E", OCEANA = "Pasifik Okyanusu", PALCOV = "Paleto Koy", PALETO = "Paleto Körefezi", PALFOR = "Paleto Ormanı", PALHIGH = "Palomino Dağlıkları", PALMPOW = "Palmer-Taylor Güç İstasyonu", PBLUFF = "Pacific Kayalıkları", PBOX = "Pillbox Tepeleri", PROCOB = "Procopio Sahili", RANCHO = "Rancho", RGLEN = "Richman Glen", RICHM = "Richman", ROCKF = "Rockford Tepeleri", RTRAK = "Redwood Motocross Pisti", SanAnd = "San Andreas", SANCHIA = "San Chianski Range Dağları", SANDY = "Sandy Shores", SKID = "Mission Row", SLAB = "Stab City", STAD = "Maze Bank Bölgesi", STRAW = "Strawberry", TATAMO = "Tataviam Dağları", TERMINA = "Terminal", TEXTI = "Textile City", TONGVAH = "Tongva Hills", TONGVAV = "Tongva Valley", VCANA = "Vespucci Kanalları", VESP = "Vespucci", VINE = "Vinewood", WINDF = "Ron Alternates Rüzgar Çiftliği", WVINE = "Güney Vinewood", ZANCUDO = "Zancudo Nehri", ZP_ORT = "Güney Los Santos Limanı", ZQ_UAR = "Davis Quartz Madencilik Sahası"}

