state("EntropyCentre-Win64-Shipping")
{
    int loadCheck: 0x05109530, 0xE8, 0x08, 0xA0;
}

start
{
    if(old.loadCheck == 0x00010000 && current.loadCheck == 0x01010101){
        return true;
    }
}

split
{
    if(old.loadCheck == 0x01010101 && current.loadCheck == 0x00010101){
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