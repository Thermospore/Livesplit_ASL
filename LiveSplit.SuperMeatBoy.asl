state("SuperMeatBoy")
{
	byte uiState : "SuperMeatBoy.exe", 0x2D5EA0, 0x8D4;
	byte notCutscene : "SuperMeatBoy.exe", 0x2D4C6C, 0x3A0;
	byte world : "SuperMeatBoy.exe", 0x1B7CBC;
	byte level : "SuperMeatBoy.exe", 0x2D5EA0, 0x8D0;
	uint fetus : "SuperMeatBoy.exe", 0x2D64BC, 0x10C;
	byte exit : "SuperMeatBoy.exe", 0x2D54BC, 0x14;
	byte notLevelBeaten : "SuperMeatBoy.exe", 0x1B6638;
}

startup
{
	settings.Add("menuReset", false, "Reset timer on main menu");
	settings.Add("individualLevels", false, "Split on each level");
}

start
{
	return current.uiState == 13; // State: pressed "Start Game"
}

split
{
	return
	(current.uiState == 0 // State: inside a level
	&& current.notCutscene == 0
	&& old.notCutscene == 1
	&& current.world != 6 // Don't split after Dr. Fetus phase 1
	&& current.level == 99) // Inside a boss fight
	||
	(current.fetus == 0x80000000 // Split after Dr. Fetus phase 2 (slightly hacky but working solution)
	&& old.fetus != 0x80000000)
	||
	(settings["individualLevels"] // Split on each level enabled
	&& current.notLevelBeaten == 0
	&& old.notLevelBeaten == 1);
}

reset
{
	return
	current.exit == 1 // Exiting game (only works if exiting through "Exit Game")
	||
	current.uiState == 11 // State: on title screen
	||
	(settings["menuReset"] // Reset on main menu enabled
	&& current.uiState == 15); // State: main menu
}