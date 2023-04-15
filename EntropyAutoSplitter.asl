state("EntropyCentre-Win64-Shipping","v1.0.X")
{
    int loadCheck: 0x04FDC638, 0x5B0, 0x20, 0x50, 0xA0;
    int actId: 0x050F27A0, 0x7F0, 0x190, 0x20, 0x8B0, 0x68;
}

state("EntropyCentre-Win64-Shipping","v1.1.X")
{
    int loadCheck: 0x05661F70, 0xE8, 0x8, 0xA0;
    int actId: 0x05676110, 0x58, 0x30, 0xF8, 0x68;
    int customlevelValue: 0x05676110, 0xE8, 0x280;
}

/*
loadCheck:
0x01010000 - paused or main menu
0x01010101 - unpaused
0x00010101 - level -> level load
0x00010000 - menu -> level or level -> menu load
actId:
0x00000073 - credits
0x003U003T - act number, where U is the unit & T is the tens (e.g. act 12 = 0x00320031)
customlevelValue:
0 - loading
2 - not in custom level
9 - in custom level
10 - on level end screen
*/

startup
{
    settings.Add("CLs", false, "Custom Level Timing");
    settings.SetToolTip("CLs", "Time starts upon entering any custom level, and ends when completing it. Disables the normal timer.");

    if(timer.CurrentTimingMethod == TimingMethod.RealTime){
        var mbox = MessageBox.Show(
            "To remove load/pause time, you must be comparing to game time rather than real time. Would you like to switch to game time?",
            "The Entropy Centre Autosplitter",
            MessageBoxButtons.YesNo);

        if(mbox == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
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

start
{
    if(settings["CLs"]){
        return current.customlevelValue==9;
    }
    else if(old.loadCheck == 0x00010000 && current.loadCheck == 0x01010101){
        return true;
    }
}

reset
{
    if(settings["CLs"] && current.customlevelValue==0){
        return true;
    }
}

split
{
    if(current.actId != old.actId){
        return true;
    }
    if(settings["CLs"] && current.customlevelValue==10 && old.customlevelValue==9){
        return true;
    }
}

isLoading
{
    if(current.loadCheck == 0x01010101){
        return false;
    }
    else{
        return true;
    }
}
