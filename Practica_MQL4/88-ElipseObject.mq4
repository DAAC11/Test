//+------------------------------------------------------------------+
//|                                              88-ElipseObject.mq4 |
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
   int  HighestCandle = iHighest(Symbol(),Period(),MODE_HIGH,30,0);
   int  LowestCandle = iLowest(Symbol(),Period(),MODE_HIGH,30,0);
   ObjectDelete("Elipse");
   ObjectCreate(0,"Elipse",OBJ_ELLIPSE,0,Time[LowestCandle],Low[LowestCandle],
      Time[HighestCandle],High[HighestCandle]);
   ObjectSetInteger(0,"Elipse",OBJPROP_COLOR,clrBlue);
   ObjectSetInteger(0,"Elipse",OBJPROP_FILL,clrBlue);
  }
//+------------------------------------------------------------------+
