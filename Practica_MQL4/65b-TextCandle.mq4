//+------------------------------------------------------------------+
//|                                               65b-TextCandle.mq4 |
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
    ObjectCreate(
                  0,
                  "Text",
                  OBJ_TEXT,
                  0,
                  0,
                  0);
                  
    ObjectSetText("Text","Low Price: "+DoubleToStr(Low[0],Digits),8,"Arial",White);
    ObjectSetDouble(0,"Text",OBJPROP_ANGLE,90);
    ObjectMove("Text",0,Time[0],Low[0]);
   
  }
//+------------------------------------------------------------------+
