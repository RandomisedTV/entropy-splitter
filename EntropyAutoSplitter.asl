state("EntropyCentre-Win64-Shipping")
{
    //if loadCheck = 0x01010000, paused
    //if loadCheck = 0x01010101, unpaused
    //if loadCheck = 0x00010101, loading from level to level
    //if loadCheck = 0x00010000, loading to or from menu
    int loadCheck: 0x04FDC638, 0x5B0, 0x20, 0x50, 0xA0;

    //actId = 0x003U003T where U is the unit of the act number and T is the ten of the act number
    //actId = 0x00000073 on final credits
    //actId = 0x00000002 initial value
    int actId: 0x050F27A0, 0x7F0, 0x190, 0x20, 0x8B0, 0x68;
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
