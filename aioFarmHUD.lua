local metadata = {
"## Interface:FS15 1.1.0.0 RC12",
"## Title: aioFarmHUD",
"## Notes: Silostände, Tierinformationen",
"## Author: Bauer Hannsen",
"## Version: 2.0.2",
"## Date: 23.12.2014"
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
EggWarning = 55; -- in pieces
WoolWarning = 85; -- in percent
ManureWarning = 85; -- in percent

local aioFarmHUD_directory = g_currentModDirectory;
local file = getUserProfileAppPath() .. "/mods/MischStation.zip";

function aioFarmHUD:loadMap(name)
	self.Overlay=createImageOverlay(aioFarmHUD_directory .. "background.dds")
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
			local cowLiquidManure, cowLiquidManureMax, bgaLiquidManure, bgaLiquidManureMax, manureFillLevel, manureFillLevelmax, milkFillLevel, bunkerFillLevel, bunkerFillLevelMax; 
			for i = 1, #object do 
				if object[i].liquidManureTrigger then 
					cowLiquidManure = object[i].liquidManureTrigger.fillLevel;
					cowLiquidManureMax = object[i].liquidManureTrigger.capacity;
				end; 
				if object[i].liquidManureSiloTrigger then 
					bgaLiquidManure = object[i].liquidManureSiloTrigger.fillLevel;
					bgaLiquidManureMax = object[i].liquidManureSiloTrigger.capacity;
				end; 
				if object[i].manureHeap then 
					manureFillLevel = object[i].manureHeap.fillLevel;
					manureFillLevelMax = object[i].manureHeap.capacity;
				end; 
				if object[i].fillLevelMilk then 
					milkFillLevel = object[i].fillLevelMilk; 
				end; 
				if object[i].bunker then
					bunkerFillLevel = object[i].bunker.fillLevel;
					bunkerFillLevelMax = object[i].bunker.capacity;
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
			setTextAlignment(RenderText.ALIGN_RIGHT);
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_WHEAT))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			setTextAlignment(RenderText.ALIGN_LEFT);
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_barley_storage") .. ":");
			setTextAlignment(RenderText.ALIGN_RIGHT);
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_BARLEY))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			setTextAlignment(RenderText.ALIGN_LEFT);
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_rape_storage") .. ":");
			setTextAlignment(RenderText.ALIGN_RIGHT);
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_RAPE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			setTextAlignment(RenderText.ALIGN_LEFT);
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_maize_storage") .. ":");
			setTextAlignment(RenderText.ALIGN_RIGHT);
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_MAIZE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			setTextAlignment(RenderText.ALIGN_LEFT);
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_potato_storage") .. ":");
			setTextAlignment(RenderText.ALIGN_RIGHT);
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_POTATO))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			setTextAlignment(RenderText.ALIGN_LEFT);
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_sugarBeet_storage") .. ":");
			setTextAlignment(RenderText.ALIGN_RIGHT);
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_SUGARBEET))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			setTextAlignment(RenderText.ALIGN_LEFT);
			cc = cc + 1;
			renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_woodChips_storage") .. ":");
			setTextAlignment(RenderText.ALIGN_RIGHT);
			renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_WOODCHIPS))) .. "  " .. g_i18n:getText("fluid_unit_short"));
			setTextAlignment(RenderText.ALIGN_LEFT);
			cc = cc + 1;

			-- extra storage on the map and something in it? (text, left column)
			if g_currentMission:getSiloAmount(Fillable.FILLTYPE_GRASS_WINDROW) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_WHEAT_WINDROW) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_SILAGE) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_FORAGE) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_CHAFF) > 0 or g_currentMission:getSiloAmount(Fillable.FILLTYPE_MANURE) > 0 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_extrastorage_title"));
				setTextBold(false);
				cc = cc + 1;
				if g_currentMission:getSiloAmount(Fillable.FILLTYPE_GRASS_WINDROW) ~= nil and g_currentMission:getSiloAmount(Fillable.FILLTYPE_GRASS_WINDROW) > 0 then
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_grass_storage") .. ":");
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_GRASS_WINDROW))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				if g_currentMission:getSiloAmount(Fillable.FILLTYPE_WHEAT_WINDROW) ~= nil and g_currentMission:getSiloAmount(Fillable.FILLTYPE_WHEAT_WINDROW) > 0 then
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_straw_storage") .. ":");
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_WHEAT_WINDROW))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				if g_currentMission:getSiloAmount(Fillable.FILLTYPE_SILAGE) ~= nil and g_currentMission:getSiloAmount(Fillable.FILLTYPE_SILAGE) > 0 then
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_silage_storage") .. ":");
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_SILAGE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				if g_currentMission:getSiloAmount(Fillable.FILLTYPE_FORAGE) ~= nil and g_currentMission:getSiloAmount(Fillable.FILLTYPE_FORAGE) > 0 then
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_forage_storage") .. ":");
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_FORAGE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				if g_currentMission:getSiloAmount(Fillable.FILLTYPE_CHAFF) ~= nil and g_currentMission:getSiloAmount(Fillable.FILLTYPE_CHAFF) > 0 then
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_chaff_storage") .. ":");
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_CHAFF))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				if g_currentMission:getSiloAmount(Fillable.FILLTYPE_MANURE) ~= nil and g_currentMission:getSiloAmount(Fillable.FILLTYPE_MANURE) > 0 then
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_manure_storage") .. ":");
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_MANURE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
			end;

			-- is there a liquid manure storage on the map?
			if g_currentMission:getSiloAmount(Fillable.FILLTYPE_LIQUIDMANURE) > 0 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_liquidManure_storage_title"));
				setTextBold(false);
				cc = cc + 1;
				if g_currentMission:getSiloAmount(Fillable.FILLTYPE_LIQUIDMANURE) ~= nil and g_currentMission:getSiloAmount(Fillable.FILLTYPE_LIQUIDMANURE) > 0 then
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_liquidManure_storage") .. ":");
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(g_currentMission:getSiloAmount(Fillable.FILLTYPE_LIQUIDMANURE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
			end;

			-- biogas plant and its elements
			if bgaLiquidManure ~= nil and bgaLiquidManure > 0 then
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_biogas_title"));
				setTextBold(false);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_liquidManure_bga") .. ":");
				setTextAlignment(RenderText.ALIGN_RIGHT);
				if round(bgaLiquidManure * 100 / bgaLiquidManureMax) >= ManureWarning then
					setTextColor(1, 0, 0, 0.5);
				end;
				renderText(APosX, TPosYBegin-Font*cc, Font, comma_value(round(bgaLiquidManure)) .. "  " .. g_i18n:getText("fluid_unit_short"));
				setTextColor(1, 1, 1, 1);
				setTextAlignment(RenderText.ALIGN_LEFT);
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
			local bgacount = 1;
			for key, value in pairs(silo) do
				obj = g_currentMission:getNodeObject(value);
				if obj.state == 0 and obj.fillLevel > 0 then
					setTextColor(0, 1, 0, 1);
				elseif obj.state == 2 then
					setTextColor(1, 0.47, 0, 1);
				elseif obj.state == 0 and obj.fillLevel == 0 then
					setTextColor(1, 1, 1, 1);
				else
					setTextColor(0, 1, 1, 1);
				end;
				setTextAlignment(RenderText.ALIGN_LEFT);
				renderText(TPosX, TPosYBegin-Font * cc, Font, "BGA #" .. bgacount .. ":");
				setTextAlignment(RenderText.ALIGN_RIGHT);
				compact = round( tostring(obj.compactedFillLevel) / tostring(obj.fillLevel) * 100);
				ferment = round(obj.fermentingTime / obj.fermentingDuration * 100);
				if obj.state == 1 then
					renderText(TPosX + 0.08, TPosYBegin-Font * cc, Font, ferment .. "%"); -- fermentation
				end;
				if obj.state == 0 then
					renderText(TPosX + 0.08, TPosYBegin-Font * cc, Font, compact .. "%"); -- compacting
				end;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(obj.fillLevel)) .. "  " .. g_i18n:getText("fluid_unit_short"));
				renderText(APosX + 0.03, TPosYBegin-Font * cc, Font, "(" .. round(obj.fillLevel / obj.capacity * 100) .. "%)");
				bgacount = bgacount + 1;
				cc = cc + 1;
			end;
			setTextColor(1, 1, 1, 1);
			setTextAlignment(RenderText.ALIGN_LEFT);

			-- cow paddock and its elements
			if Animals.cow.totalNumAnimals > 0 then
				DaysFeedingStrawCowLeft = Animals.cow:getFillLevel(Fillable.FILLTYPE_WHEAT_WINDROW) / Animals.cow.totalNumAnimals / 100;
				DaysFeedingGrassCowLeft = Animals.cow:getFillLevel(Fillable.FILLTYPE_GRASS_WINDROW) / Animals.cow.totalNumAnimals / 115;
				DaysFeedingSilageCowLeft = Animals.cow:getFillLevel(Fillable.FILLTYPE_SILAGE) / Animals.cow.totalNumAnimals / 85;
				DaysFeedingForageCowLeft = Animals.cow:getFillLevel(Fillable.FILLTYPE_FORAGE) / Animals.cow.totalNumAnimals / 330;
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_cow_title"));
				setTextBold(false);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("statisticView_cow") .. ":");
				setTextAlignment(RenderText.ALIGN_RIGHT);
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.cow.totalNumAnimals)) .. "   ");
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("Productivity") .. ":");
				setTextAlignment(RenderText.ALIGN_RIGHT);
				renderText(APosX, TPosYBegin-Font * cc, Font, round(Animals.cow.productivity * 100) .. "%");
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
				if Animals.cow:getFillLevel(Fillable.FILLTYPE_FORAGE) == 0 and Animals.cow:getFillLevel(Fillable.FILLTYPE_SILAGE) == 0 and Animals.cow:getFillLevel(Fillable.FILLTYPE_GRASS_WINDROW) == 0 then
					setTextColor(1,0,0,0.5);
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_FeedingTrough") .. ":");
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(APosX, TPosYBegin-Font * cc, Font, "0  " .. g_i18n:getText("fluid_unit_short"));
					setTextColor(1, 1, 1, 1);
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				if Animals.cow:getFillLevel(Fillable.FILLTYPE_FORAGE) ~= nil and Animals.cow:getFillLevel(Fillable.FILLTYPE_FORAGE) > 0 then
					--renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("FeedingTroughForage_storage") .. ":");
					renderText(TPosX, TPosYBegin-Font * cc, Font, "Futtertrog" .. ":");
					if Animals.cow:getFillLevel(Fillable.FILLTYPE_FORAGE) <= Animals.cow.totalNumAnimals * 190 and Animals.cow:getFillLevel(Fillable.FILLTYPE_FORAGE) >= 1 then
						setTextColor(1,0,0,0.5);
					end;
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(TPosX + 0.09, TPosYBegin-Font * cc, Font, string.format("%.1f", comma_value(DaysFeedingForageCowLeft)) .. " " .. g_i18n:getText("HUD_day"));
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.cow:getFillLevel(Fillable.FILLTYPE_FORAGE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextColor(1, 1, 1, 1);
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				if Animals.cow:getFillLevel(Fillable.FILLTYPE_SILAGE) ~= nil and Animals.cow:getFillLevel(Fillable.FILLTYPE_SILAGE) > 0 then
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("FeedingTroughSilage_storage") .. ":");
					if Animals.cow:getFillLevel(Fillable.FILLTYPE_SILAGE) <= Animals.cow.totalNumAnimals * 85 and Animals.cow:getFillLevel(Fillable.FILLTYPE_SILAGE) >= 1 then
						setTextColor(1,0,0,0.5);
					end;
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(TPosX + 0.09, TPosYBegin-Font * cc, Font, string.format("%.1f", comma_value(DaysFeedingSilageCowLeft)) .. " " .. g_i18n:getText("HUD_day"));
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.cow:getFillLevel(Fillable.FILLTYPE_SILAGE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextColor(1, 1, 1, 1);
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				if Animals.cow:getFillLevel(Fillable.FILLTYPE_GRASS_WINDROW) ~= nil and Animals.cow:getFillLevel(Fillable.FILLTYPE_GRASS_WINDROW) > 0 then
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("FeedingTroughGrass_storage") .. ":");
					if Animals.cow:getFillLevel(Fillable.FILLTYPE_GRASS_WINDROW) <= Animals.cow.totalNumAnimals * 115 and Animals.cow:getFillLevel(Fillable.FILLTYPE_GRASS_WINDROW) >= 1 then
						setTextColor(1,0,0,0.5);
					end;
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(TPosX + 0.09, TPosYBegin-Font * cc, Font, string.format("%.1f", comma_value(DaysFeedingGrassCowLeft)) .. " " .. g_i18n:getText("HUD_day"));
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.cow:getFillLevel(Fillable.FILLTYPE_GRASS_WINDROW))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextColor(1, 1, 1, 1);
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("Straw_storage") .. ":");
				if Animals.cow:getFillLevel(Fillable.FILLTYPE_WHEAT_WINDROW) <= Animals.cow.totalNumAnimals * 60 and Animals.cow:getFillLevel(Fillable.FILLTYPE_WHEAT_WINDROW) >= 1 then
					setTextColor(1, 0, 0, 0.5);
				end;
				setTextAlignment(RenderText.ALIGN_RIGHT);
				renderText(TPosX + 0.09, TPosYBegin-Font * cc, Font, string.format("%.1f", comma_value(DaysFeedingStrawCowLeft)) .. " " .. g_i18n:getText("HUD_day"));
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.cow:getFillLevel(Fillable.FILLTYPE_WHEAT_WINDROW))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				setTextColor(1, 1, 1, 1);
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
				if Animals.cow:getFillLevel(Fillable.FILLTYPE_WATER) ~= nil and Animals.cow:getFillLevel(Fillable.FILLTYPE_WATER) > 0 then
					DaysFeedingWaterCowLeft = Animals.cow:getFillLevel(Fillable.FILLTYPE_WATER) / Animals.cow.totalNumAnimals / 60;
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_water") .. ":");
					if Animals.cow:getFillLevel(Fillable.FILLTYPE_WATER) <= Animals.cow.totalNumAnimals * 60 and Animals.cow:getFillLevel(Fillable.FILLTYPE_WATER) >= 1 then
						setTextColor(1, 0, 0, 0.5);
					end;
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(TPosX + 0.09, TPosYBegin-Font * cc, Font, string.format("%.1f", comma_value(DaysFeedingWaterCowLeft)) .. " " .. g_i18n:getText("HUD_day"));
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.cow:getFillLevel(Fillable.FILLTYPE_WATER))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextColor(1, 1, 1, 1);
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_milk") .. ":");
				setTextAlignment(RenderText.ALIGN_RIGHT);
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(milkFillLevel)) .. "  " .. g_i18n:getText("fluid_unit_short"));
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_manure_cow") .. ":");
				if manureFillLevel * 100 / manureFillLevelMax >= ManureWarning then
					setTextColor(1, 0, 0, 0.5);
				end;
				setTextAlignment(RenderText.ALIGN_RIGHT);
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(manureFillLevel)) .. "  " .. g_i18n:getText("fluid_unit_short"));
				setTextColor(1, 1, 1, 1);
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_liquidManure_cow") .. ":");
				if cowLiquidManure * 100 / cowLiquidManureMax >= ManureWarning then
					setTextColor(1, 0, 0, 0.5);
				end;
				setTextAlignment(RenderText.ALIGN_RIGHT);
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(cowLiquidManure)) .. "  " .. g_i18n:getText("fluid_unit_short"));
				setTextColor(1, 1, 1, 1);
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
			end;

			-- hopefully we are able to read and display fill states of marhu's mixing station (the mod version, not the one which has to be build into the map with GE
			if fileExists(file) then
				--for i = 1, table.getn(MischStation:self.MixTypName) do
					--local text = string.format("%s",MischStation:self.MixTypName[i].name.." [l]");
					--local Percentage = math.abs(MischStation:self.MixTypLvl[i] / MischStation:self.TipTriggers[i].capacity * 100);
					--text = text.." "..string.format("%d (%d%%)",MischStation:self.MixTypLvl[i],Percentage);
				--end;
			end;

			-- sheep paddock and its elements
			if Animals.sheep.totalNumAnimals > 0 then
				DaysFeedingGrassSheepLeft = Animals.sheep:getFillLevel(Fillable.FILLTYPE_FORAGE) / Animals.sheep.totalNumAnimals / 20;
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_sheep_title") .. ":");
				setTextBold(false);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("statisticView_sheep") .. ":");
				setTextAlignment(RenderText.ALIGN_RIGHT);
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.sheep.totalNumAnimals)) .. "   ");
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("Productivity") .. ":");
				setTextAlignment(RenderText.ALIGN_RIGHT);
				renderText(APosX, TPosYBegin-Font * cc, Font, round(Animals.sheep.productivity * 100) .. "%");
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("FeedingTroughMisc_storage") .. ":");
				if Animals.sheep:getFillLevel(Fillable.FILLTYPE_FORAGE) <= Animals.sheep.totalNumAnimals * 20 and Animals.sheep:getFillLevel(Fillable.FILLTYPE_FORAGE) >= 1 then
					setTextColor(1, 0, 0, 0.5);
				end;
				setTextAlignment(RenderText.ALIGN_RIGHT);
				renderText(TPosX + 0.09, TPosYBegin-Font * cc, Font, string.format("%.1f", comma_value(DaysFeedingGrassSheepLeft)) .. " " .. g_i18n:getText("HUD_day"));
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.sheep:getFillLevel(Fillable.FILLTYPE_FORAGE))) .. "  " .. g_i18n:getText("fluid_unit_short"));
				setTextColor(1, 1, 1, 1);
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
				if Animals.sheep:getFillLevel(Fillable.FILLTYPE_WATER) ~= nil and Animals.sheep:getFillLevel(Fillable.FILLTYPE_WATER) > 0 then
					DaysFeedingWaterSheepLeft = Animals.sheep:getFillLevel(Fillable.FILLTYPE_WATER) / Animals.sheep.totalNumAnimals / 10;
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_water") .. ":");
					if Animals.sheep:getFillLevel(Fillable.FILLTYPE_WATER) <= Animals.sheep.totalNumAnimals * 10 and Animals.sheep:getFillLevel(Fillable.FILLTYPE_WATER) >= 1 then
						setTextColor(1, 0, 0, 0.5);
					end;
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(TPosX + 0.09, TPosYBegin-Font * cc, Font, string.format("%.1f", comma_value(DaysFeedingWaterSheepLeft)) .. " " .. g_i18n:getText("HUD_day"));
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.sheep:getFillLevel(Fillable.FILLTYPE_WATER))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextColor(1, 1, 1, 1);
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("wool") .. ":");
				setTextAlignment(RenderText.ALIGN_RIGHT);
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
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
			end;

			-- chicken house and its elements
			if Animals.chicken.totalNumAnimals > 1 then
				DaysFeedingWheatChickenLeft = Animals.chicken:getFillLevel(Fillable.FILLTYPE_WHEAT) / Animals.chicken.totalNumAnimals / 0.5;
				DaysFeedingWaterChickenLeft = Animals.chicken:getFillLevel(Fillable.FILLTYPE_WATER) / Animals.chicken.totalNumAnimals / 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, ""); -- empty line
				cc = cc + 1;
				setTextBold(true);
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_chicken_title") .. ":");
				setTextBold(false);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("statisticView_chicken") .. ":");
				setTextAlignment(RenderText.ALIGN_RIGHT);
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.chicken.totalNumAnimals)) .. "   ");
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("Productivity") .. ":");
				setTextAlignment(RenderText.ALIGN_RIGHT);
				renderText(APosX, TPosYBegin-Font * cc, Font, round(Animals.chicken.productivity * 100) .. "%");
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
				if Animals.chicken:getFillLevel(Fillable.FILLTYPE_WATER) ~= nil and Animals.chicken:getFillLevel(Fillable.FILLTYPE_WATER) > 0 then
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_water") .. ":");
					if Animals.chicken:getFillLevel(Fillable.FILLTYPE_WATER) <= Animals.chicken.totalNumAnimals * 1 / 24 and Animals.chicken:getFillLevel(Fillable.FILLTYPE_WATER) >= 1 then
						setTextColor(1, 0, 0, 0.5);
					end;
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(TPosX + 0.09, TPosYBegin-Font * cc, Font, string.format("%.1f", comma_value(DaysFeedingWaterChickenLeft)) .. " " .. g_i18n:getText("HUD_day"));
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.chicken:getFillLevel(Fillable.FILLTYPE_WATER))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextColor(1, 1, 1, 1);
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				if Animals.chicken:getFillLevel(Fillable.FILLTYPE_WHEAT) ~= nil and Animals.chicken:getFillLevel(Fillable.FILLTYPE_WHEAT) > 0 then
					renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("HUD_wheat_storage") .. ":");
					if Animals.chicken:getFillLevel(Fillable.FILLTYPE_WHEAT) <= Animals.chicken.totalNumAnimals * 0.5 / 24 and Animals.chicken:getFillLevel(Fillable.FILLTYPE_WHEAT) >= 1 then
						setTextColor(1, 0, 0, 0.5);
					end;
					setTextAlignment(RenderText.ALIGN_RIGHT);
					renderText(TPosX + 0.09, TPosYBegin-Font * cc, Font, string.format("%.1f", comma_value(DaysFeedingWheatChickenLeft)) .. " " .. g_i18n:getText("HUD_day"));
					renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.chicken:getFillLevel(Fillable.FILLTYPE_WHEAT))) .. "  " .. g_i18n:getText("fluid_unit_short"));
					setTextColor(1, 1, 1, 1);
					setTextAlignment(RenderText.ALIGN_LEFT);
					cc = cc + 1;
				end;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("egg") .. ":");
				setTextAlignment(RenderText.ALIGN_RIGHT);
				if Animals.chicken.numActivePickupObjects >= EggWarning then
					setTextColor(1,0,0,0.5);
				end;
				renderText(APosX, TPosYBegin-Font * cc, Font, comma_value(round(Animals.chicken.numActivePickupObjects)) .. "   ");
				setTextColor(1, 1, 1, 1);
				setTextAlignment(RenderText.ALIGN_LEFT);
				cc = cc + 1;
				renderText(TPosX, TPosYBegin-Font * cc, Font, g_i18n:getText("Eggs_carrying") .. ":");
				setTextAlignment(RenderText.ALIGN_RIGHT);
				renderText(APosX, TPosYBegin-Font * cc, Font, g_currentMission:getSiloAmount(Fillable.FILLTYPE_EGG) .. "   ");
				setTextAlignment(RenderText.ALIGN_LEFT);
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
