state("EntropyCentre-Win64-Shipping")
{
    //if loadCheck = 01010000, paused
    //if loadCheck = 01010101, unpaused
    //if loadCheck = 00010101, loading from level to level
    //if loadCheck = 00010000, loading to or from menu
    int loadCheck: 0x05109530, 0xE8, 0x08, 0xA0;

    //actId = 003U003T where U is the unit of the act number and T is the ten of the act number
    //actId = 00000073 on final credits
    //actId = 00000002 initial value
    int actId: 0x04CF7E68, 0x60, 0x18, 0xC0, 0x8B0, 0x68;
}

start
{
    if(old.loadCheck == 0x00010000 && current.loadCheck == 0x01010101){
        return true;
    }
}

split
{
    if(current.actId != old.actId){
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
