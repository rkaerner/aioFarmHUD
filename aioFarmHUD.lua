local metadata = {
"## Interface:FS15 1.1.0.0 RC12",
"## Title: aioFarmHUD",
"## Notes: Silostände, Tierinformationen",
"## Author: Bauer Hannsen",
"## Version: 1.0.0",
"## Date: 20.12.2014"
}
-- set a lot of variables
cc = 20;
HeightB = cc*0.015;
WidthB = 0.165;
PosX = 0.835;
PosY = 0.908-HeightB;
show = true;
aioFarmHUD = {};
silo = {};
EggWarning = 55; -- in percent
WoolWarning = 85; -- in percent

local aioFarmHUD_directory = g_currentModDirectory;

function aioFarmHUD:loadMap(name)
	self.Overlay=createImageOverlay(aioFarmHUD_directory.."background.dds")
	if g_currentMission.onCreateLoadedObjects ~= nil then
		a = 1;
		for k, v in pairs(g_currentMission.onCreateLoadedObjects) do
			if g_currentMission.onCreateLoadedObjects[k].stationName == "BunkerSilo" then
				silo[a] = g_currentMission.onCreateLoadedObjects[g_currentMission.onCreateLoadedObjects[k].id].nodeId;
				a = a + 1;
			end;
		end;
	end;
end;

function aioFarmHUD:deleteMap()
end;

function aioFarmHUD:mouseEvent(posX, posY, isDown, isUp, button)
end;

function aioFarmHUD:keyEvent(unicode, sym, modifier, isDown)
end;

function aioFarmHUD:update(dt)
	if InputBinding.hasEvent(InputBinding.TOGGLE_FARMHUD) or InputBinding.hasEvent(InputBinding.TOGGLE_FARMHUD_ALT) then
		show = not show;
	end;
	if g_currentMission.showHelpText then
		if show then
			g_currentMission:addHelpButtonText(g_i18n:getText("TOGGLE_FARMHUD_OFF"), InputBinding.TOGGLE_FARMHUD);
		else
			g_currentMission:addHelpButtonText(g_i18n:getText("TOGGLE_FARMHUD_ON"), InputBinding.TOGGLE_FARMHUD);
		end;
	end;
end;

function aioFarmHUD:updateTick(dt)
end;

function aioFarmHUD:draw()
	if PosX < 1 and PosY < 1 and PosX > 0 and PosY > 0 then
		if show == true then
			local Font = 0.012;
			local TPosX = PosX + 0.005;
			local TPosYBegin = PosY + HeightB - 0.020;
			local APosX = PosX + WidthB - 0.005;
			local Animals = g_currentMission.husbandries;
			local startPosY = 1

			-- calculate fill levels
			local object = g_currentMission.onCreateLoadedObjectsToSave; 
			local cowLiquidManure, bgaLiquidManure, manureFillLevel, milkFillLevel; 
			for i = 1, #object do 
				if object[i].liquidManureTrigger then 
					cowLiquidManure = object[i].liquidManureTrigger.fillLevel; 
				end; 
				if object[i].liquidManureSiloTrigger then 
					bgaLiquidManure = object[i].liquidManureSiloTrigger.fillLevel; 
				end; 
				if object[i].manureHeap then 
					manureFillLevel = object[i].manureHeap.fillLevel; 
				end; 
				if object[i].fillLevelMilk then 
					milkFillLevel = object[i].fillLevelMilk; 
				end; 
			end; 

			cc = 1;
			setTextBold(false);
			setTextColor(1, 1, 1, 1);
			renderOverlay(self.Overlay, PosX, PosY, WidthB, 0);

			-- standard silos on the farm
			setTextBold(true);
			renderText(TPosX, TPosYBegin, Font, g_i18n:getText("HUD_farm_title"));
			setTextBold(false);
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_wheat_storage") .. ":");
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_barley_storage") .. ":");
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_rape_storage") .. ":");
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_maize_storage") .. ":");
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_potato_storage") .. ":");
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_sugarBeet_storage") .. ":");
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_woodChips_storage") .. ":");
			cc = cc + 1;

			-- extra storage on the map and something in it?
			if g_currentMission:getSiloAmount(Fillable.FILLTYPE_GRASS_WINDROW) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_WHEAT_WINDROW) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_SILAGE) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_FORAGE) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_CHAFF) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_MANURE) > 0 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_extrastorage_title"));
				setTextBold(false);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_grass_storage") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_straw_storage") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_silage_storage") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_forage_storage") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_chaff_storage") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_manure_storage") .. ":");
				cc = cc + 1;
			end;

			-- biogas plant and its elements
			if bgaLiquidManure > 0 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_biogas_title"));
				setTextBold(false);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_liquidManure_bga") .. ":");
				cc = cc + 1;
			end;

			-- Silage silos (cow paddock and biogas plant)
			renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
			cc = cc + 1;
			setTextAlignment(RenderText.ALIGN_LEFT);
			setTextBold(true);
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_silagesilo_title"));
			setTextBold(false);
			cc = cc + 1;
			renderText(TPosX + 0.005, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_SILO"));
			renderText(APosX - 0.02, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_AMOUNT"));
			setTextAlignment(RenderText.ALIGN_RIGHT);
			renderText(TPosX + 0.08, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_CF"));
			cc = cc + 1;
			local ccm = cc;
			setTextAlignment(RenderText.ALIGN_LEFT);
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_SILO1") .. ":");
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_SILO2") .. ":");
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_SILO3") .. ":");
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_SILO4") .. ":");
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_SILO5") .. ":");
			cc = cc + 1;

			-- cow paddock and its elements
			if Animals.cow.totalNumAnimals > 0 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_cow_title"));
				setTextBold(false);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("statisticView_cow") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("Productivity") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("FeedingTroughForage_storage") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("FeedingTroughSilage_storage") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("FeedingTroughGrass_storage") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("Straw_storage") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_milk") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_manure_cow") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_liquidManure_cow") .. ":");
				cc = cc + 1;
			end;

			-- sheep paddock and its elements
			if Animals.sheep.totalNumAnimals > 0 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_sheep_title") .. ":");
				setTextBold(false);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("statisticView_sheep") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("Productivity") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("FeedingTroughMisc_storage") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("wool") .. ":");
				cc = cc + 1;
			end;

			-- chicken house and its elements
			if Animals.chicken.totalNumAnimals > 1 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_chicken_title") .. ":");
				setTextBold(false);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("statisticView_chicken") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("egg") .. ":");
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("Eggs_carrying") .. ":");
				cc = cc + 1;
			end;

			--------------------
			-- Render Amounts --
			--------------------
			cc = 1;
			setTextBold(true);
			renderText(TPosX, TPosYBegin, Font, ""); -- empty headline right column for FARM
			setTextBold(false);
			setTextAlignment(RenderText.ALIGN_RIGHT);
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_WHEAT))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			cc = cc + 1;
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_BARLEY))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			cc = cc + 1;
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_RAPE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			cc = cc + 1;
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_MAIZE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			cc = cc + 1;
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_POTATO))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			cc = cc + 1;
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_SUGARBEET))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			cc = cc + 1;
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_WOODCHIPS))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			cc = cc + 1;
			
			-- extra storage on the map and something in it?
			if g_currentMission:getSiloAmount(Fillable.FILLTYPE_GRASS_WINDROW) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_WHEAT_WINDROW) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_SILAGE) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_FORAGE) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_CHAFF) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_MANURE) > 0 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty headline right column for EXTRA STORAGE
				setTextBold(false);
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_GRASS_WINDROW))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_WHEAT_WINDROW))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_SILAGE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_FORAGE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_CHAFF))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_MANURE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				cc = cc + 1;
			end;
			
			-- biogas plant and its elements
			if bgaLiquidManure > 0 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc= cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font*cc, Font, ""); -- empty headline right column for BGA
				setTextBold(false);
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font*cc, Font, comma_value(round(bgaLiquidManure)) .. "  " .. g_i18n:getText("fluid_unit_short"));
				cc = cc + 1;
			end;

			-- Silage silos (cow paddock and biogas plant)
			renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
			cc = cc + 1;
			setTextBold(true);
			renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty headline right column for silage silos (cow paddock and biogas plant)
			setTextBold(false);
			setTextAlignment(RenderText.ALIGN_RIGHT);
			for key, value in pairs(silo) do
				obj = g_currentMission:getNodeObject(value);
				if obj.state == 0 and obj.fillLevel > 0 then
					setTextColor(0, 1, 0, 1);
				elseif obj.state == 2 then
					setTextColor(0.3, 0.1, 0, 1);
				elseif obj.state == 0 and obj.fillLevel == 0 then
					setTextColor(1, 1, 1, 1);
				else
					setTextColor(0, 1, 1, 1);
				end;
				compact = round( tostring(obj.compactedFillLevel) / tostring(obj.fillLevel) * 100);
				ferment = round(obj.fermentingTime / obj.fermentingDuration * 100);
				if obj.state == 1 then
					renderText(TPosX + 0.08, TPosYBegin-Font * ccm, Font, ferment .. "%"); -- fermentation
				end;
				if obj.state == 0 then
					renderText(TPosX + 0.08, TPosYBegin-Font * ccm, Font, compact .. "%"); -- compacting
				end;
				renderText(APosX, TPosYBegin-Font * ccm, Font, comma_value(round(obj.fillLevel)) .. "  " .. g_i18n:getText("fluid_unit_short"));
				renderText(APosX + 0.03, TPosYBegin-Font * ccm, Font, "(" .. round(obj.fillLevel / obj.capacity * 100) .. "%)");
				ccm = ccm + 1;
			end;
			cc = ccm;
			setTextColor(1, 1, 1, 1);
			
			-- cow paddock and its elements
			if Animals.cow.totalNumAnimals > 0 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty headline right column for COW
				setTextBold(false);
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.cow.totalNumAnimals)) .. "   ");
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, round(Animals.cow.productivity * 100) .. "%");
				cc = cc + 1;
				if Animals.cow:getFillLevel(Fillable.FILLTYPE_FORAGE) <= Animals.cow.totalNumAnimals * 7.5 and Animals.cow:getFillLevel(Fillable.FILLTYPE_FORAGE) >= 1 then
					setTextColor(1,0,0,0.5);
				end;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.cow:getFillLevel(Fillable.FILLTYPE_FORAGE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				setTextColor(1, 1, 1, 1);
				cc = cc + 1;
				if Animals.cow:getFillLevel(Fillable.FILLTYPE_SILAGE) <= Animals.cow.totalNumAnimals * 7.5 and Animals.cow:getFillLevel(Fillable.FILLTYPE_SILAGE) >= 1 then
					setTextColor(1, 0, 0, 0.5);
				end;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.cow:getFillLevel(Fillable.FILLTYPE_SILAGE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				setTextColor(1, 1, 1, 1);
				cc = cc + 1;
				if Animals.cow:getFillLevel(Fillable.FILLTYPE_GRASS_WINDROW) <= Animals.cow.totalNumAnimals * 7.5 and Animals.cow:getFillLevel(Fillable.FILLTYPE_GRASS_WINDROW) >= 1 then
					setTextColor(1, 0, 0, 0.5);
				end;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.cow:getFillLevel(Fillable.FILLTYPE_WINDROW))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				setTextColor(1, 1, 1, 1);
				cc = cc + 1;
				if Animals.cow:getFillLevel(Fillable.FILLTYPE_WHEAT_WINDROW) <= Animals.cow.totalNumAnimals * 7.5 and Animals.cow:getFillLevel(Fillable.FILLTYPE_WHEAT_WINDROW) >= 1 then
					setTextColor(1, 0, 0, 0.5);
				end;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.cow:getFillLevel(Fillable.FILLTYPE_WHEAT_WINDROW))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				setTextColor(1, 1, 1, 1);
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(milkFillLevel)) .. "  " .. g_i18n:getText("fluid_unit_short"));
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(manureFillLevel)) .. "  " .. g_i18n:getText("fluid_unit_short"));
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(cowLiquidManure)) .. "  " .. g_i18n:getText("fluid_unit_short"));
				cc = cc + 1;
			end;
			
			-- sheep paddock and its elements
			if Animals.sheep.totalNumAnimals > 0 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty headline for sheep paddock and its elements
				setTextBold(false);
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.sheep.totalNumAnimals)) .. "   ");
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, round(Animals.sheep.productivity * 100) .. "%");
				cc = cc + 1;
				if Animals.sheep:getFillLevel(Fillable.FILLTYPE_FORAGE) <= Animals.sheep.totalNumAnimals * 7.5 and Animals.sheep:getFillLevel(Fillable.FILLTYPE_FORAGE) >= 1 then
					setTextColor(1, 0, 0, 0.5);
				end;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.sheep:getFillLevel(Fillable.FILLTYPE_FORAGE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				setTextColor(1, 1, 1, 1);
				cc = cc + 1;
				if Animals.sheep.currentPallet == nil then
					WoolPallet = "0%";
				else
					WoolPallet = string.format("%1.0f", 100 * Animals.sheep.currentPallet.fillLevel / Animals.sheep.currentPallet.capacity) .. "%";
					WoolPalletCalc = round(100 * Animals.sheep.currentPallet.fillLevel / Animals.sheep.currentPallet.capacity)
					if round(Animals.sheep.currentPallet.fillLevel / Animals.sheep.currentPallet.capacity * 100) >= WoolWarning then
						setTextColor(1, 0, 0, 0.5);
					end;
				end;
				renderText(APosX, TPosYBegin-Font * cc, Font, WoolPallet);
				setTextColor(1, 1, 1, 1);
				cc = cc + 1;
			end;
			
			-- chicken house and its elements
			if Animals.chicken.totalNumAnimals > 1 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty headline for chicken house and its elements
				setTextBold(false);
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.chicken.totalNumAnimals)) .. "   ");
				cc = cc + 1;
				if Animals.chicken.numActivePickupObjects >= EggWarning then
					setTextColor(1,0,0,0.5);
				end;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.chicken.numActivePickupObjects)) .. "   ");
				setTextColor(1, 1, 1, 1);
				cc = cc + 1;
				renderText(APosX, TPosYBegin-Font * cc, Font, g_currentMission:getSiloAmount(Fillable.FILLTYPE_EGG) .. "   ");
				cc = cc + 1;
			end;

			-- render again, to get the background in the height we need
			setTextAlignment(RenderText.ALIGN_LEFT);
			cc = cc + 1;
			PosY = 0.908 - HeightB;
			HeightB = cc * 0.012;
			renderOverlay(self.Overlay, PosX, PosY, WidthB, HeightB);
		end;
	end;
end;

addModEventListener(aioFarmHUD);

print("Load mod: aioFarmHUD");

function round(num, idp)
	if Utils.getNoNil(num, 0) > 0 then
		local mult = 10^(idp or 0);
		res = math.floor(num * mult) / mult;
	else 
		return 0;
	end;
	if res < 1 then res = 1 end;
	return res;
end;

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left .. (num:reverse():gsub('(%d%d%d)','%1' .. g_i18n:getText("HUD_delimiter")):reverse()) .. right
end
