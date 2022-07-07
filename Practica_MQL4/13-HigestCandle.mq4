//+------------------------------------------------------------------+
//|                                              13-HigestCandle.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   int VelaMasAlta= iHighest(Symbol(),Period(),MODE_HIGH,100,0);
   
   ObjectDelete("line");//cada vez que se llama un objeto se borra antes en on ticck
   ObjectCreate("line", OBJ_HLINE,0,Time[0],High[VelaMasAlta]);
   Comment("Vela mas alta ",VelaMasAlta," Precio mas alto = ",High[VelaMasAlta]);
  }
//+------------------------------------------------------------------+
