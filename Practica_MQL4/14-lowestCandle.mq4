//+------------------------------------------------------------------+
//|                                              14-lowestCandle.mq4 |
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
   int VelaMasBaja = iLowest(Symbol(),Period(),MODE_LOW,100,0);
   
   ObjectDelete("line");
   ObjectCreate("line",OBJ_HLINE,0,Time[0],Low[VelaMasBaja]);
   Comment("Vela mas baja ",VelaMasBaja," Precio mas alto = ",Low[VelaMasBaja]);
   
  }
//+------------------------------------------------------------------+
