// load = 0x01010000 - paused or main menu, 0x01010101 - unpaused, 0x00010101 - level -> level load, 0x00010000 - menu -> level load , level -> menu load & other
// pause = true - paused, false - unpaused (necessary for not timing false pauses)
state("EntropyCentre-Win64-Shipping","v1.0.X")
{
    string52 map: 0x0512E4F0, 0x118, 0xA0, 0xD0, 0x8B0, 0X38;
    int load: 0x04FDC638, 0x5B0, 0x20, 0x50, 0xA0;
    bool pause: 0x04FD95A0, 0xFD0, 0x20, 0x8A8;
}

state("EntropyCentre-Win64-Shipping", "v1.1.X")
{
    string52 map: 0x051849E8, 0x10, 0x260, 0x30, 0xF8, 0x38;
    int load: 0x05661F70, 0xE8, 0x8, 0xA0;
    bool pause: 0x056760F8, 0x8A8;
}

startup
{
    settings.Add("FullReset", true, "Fullgame Resetting");
    settings.Add("AnyReset", false, "IL Resetting");

    if(timer.CurrentTimingMethod==TimingMethod.RealTime){
        var mbox = MessageBox.Show(
            "To remove load/pause time, you must be comparing to game time rather than real time. Would you like to switch to game time?",
            "The Entropy Centre Autosplitter",
            MessageBoxButtons.YesNo);

        if(mbox==DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
    vars.doneMaps = new List<string>(){"Menu/MainMenu",null}; // to prevent quitting and continuing causing a split
}

init
{
    int moduleSize = modules.First().ModuleMemorySize;
    switch(moduleSize)
    {
        case 90165248: version = "v1.0.X";
            break;
        case 96002048: version = "v1.1.X";
            break;
        default: version = "Unknown";
            break;
    }
}

onReset
{
    vars.doneMaps.Clear();
}

start
{
    if(current.map!="EditorMainMenu" && current.load==0x01010101 && old.load==0x00010000){ // editormainmenu is excluded so that when playing custom levels the timer doesn't start upon entering the hub
        vars.doneMaps.Add(current.map);
        return true;
    }
}

split
{
    if(current.map!=old.map && !vars.doneMaps.Contains(current.map)){
        vars.doneMaps.Add(current.map);
        return true;
    }
    return old.load==0x01010101 && current.load==0x01010000 && !current.pause && current.map=="_CustomLevelLoad"; // splitting when completing a custom level
}

reset
{
    if(old.map=="Menu/MainMenu" && current.map!=old.map){
        if(settings["FullReset"] && current.map=="ter_01/Chapter_01_Level_00" || current.map=="ter_01/Chapter_01_Level_01"){
            return true;
        }
        if(settings["AnyReset"]){
            return true;
        }
    }
    return current.map=="_CustomLevelLoad" && current.load==0x00010000; // custom level resetting
}

isLoading
{
    if(current.load==0x00010101 || current.load==0x00010000 || current.pause || current.map=="Menu/MainMenu" || current.map==null){
        return true;
    }
    if(current.load==0x01010101 || !current.pause){
        return false;
    }
}

exit // for crashes - in theory checking if the map string is null would be better than this, but an actual crash never causes it to be null unlike every other method of exiting the game (including alt f4)
{
    timer.IsGameTimePaused = true;
}
