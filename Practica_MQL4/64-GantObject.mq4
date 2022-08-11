//+------------------------------------------------------------------+
//|                                                64-GantObject.mq4 |
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
   int AllCandles =  WindowFirstVisibleBar();
   
   int VelaBaja = iLowest(Symbol(),Period(),MODE_HIGH,AllCandles);
   int VelaAlta = iHighest(Symbol(),Period(),MODE_LOW,AllCandles);
   
   ObjectDelete("GantFan");

   
   ObjectCreate(
                  0,
                  "GantFan",
                  OBJ_GANNFAN,
                  0,
                  Time[VelaAlta],
                  High[VelaAlta],
                  Time[0],
                  High[0]
                  );
   
                  
   ObjectSetInteger(0,"GantFan",OBJPROP_COLOR,Orange);
   
   ObjectSetInteger(0,"GantFan",OBJPROP_STYLE,STYLE_SOLID);
   
   ObjectSetInteger(0,"GantFan",OBJPROP_WIDTH,1);
   
   ObjectSetInteger(0,"GantFan",OBJPROP_RAY,true);
   
   
  }
//+------------------------------------------------------------------+
