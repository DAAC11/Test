//+------------------------------------------------------------------+
//|                                                17-LabelChart.mq4 |
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
   ObjectCreate("Bid",OBJ_LABEL,0,0,0);

   ObjectSet("Bid",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSet("Bid",OBJPROP_XDISTANCE,30);
   ObjectSet("Bid",OBJPROP_YDISTANCE,60);
   ObjectSetText("Bid","Precio Bid = "+DoubleToStr(Bid,Digits),15,"Arial",White);
  }
//+------------------------------------------------------------------+
