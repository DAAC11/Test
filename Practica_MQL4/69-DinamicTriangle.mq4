//+------------------------------------------------------------------+
//|                                           69-DinamicTriangle.mq4 |
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
   int velaAlta = iHighest(Symbol(),Period(),MODE_HIGH,30,0);
   int velaBaja = iHighest(Symbol(),Period(),MODE_LOW,30,0);
   
   ObjectDelete("Triangulo");
   
   ObjectCreate("Triangulo",OBJ_TRIANGLE,0,Time[30],Close[30],Time[velaBaja],Low[velaBaja],
   Time[velaAlta],High[velaAlta]);
   
  }
//+------------------------------------------------------------------+
