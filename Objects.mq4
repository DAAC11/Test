//+------------------------------------------------------------------+
//|                                                      Objects.mq4 |
//|                                                            David |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "David"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

void ObjCreateLine (double precio, string name,color clr){
    
    ObjectDelete(0,name);
    ObjectCreate(0,name,OBJ_HLINE,0,0,precio);
    ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
}

/*void ObjCreateText (double precio, string name,color clr){
    
    ObjectDelete(0,name);
    ObjectCreate(0,name,OBJ_LABEL,0,0,precio);
    ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
    ObjectSetString(0,name,OBJPROP_TEXT,name);
    ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
    ObjectSetInteger(0,name,OBJPROP_ANCHOR,10);
    
}*/