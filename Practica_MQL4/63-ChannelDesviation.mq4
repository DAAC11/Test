//+------------------------------------------------------------------+
//|                                         63-ChannelDesviation.mq4 |
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
   
   ObjectDelete("ChannelDev");

   
   ObjectCreate(
                  0,
                  "ChannelDev",
                  OBJ_STDDEVCHANNEL,
                  0,
                  Time[AllCandles],
                  Low[VelaBaja],
                  Time[0],
                  Low[VelaBaja],
                  Time[AllCandles],
                  High[VelaAlta]);
   
                  
   ObjectSetInteger(0,"ChannelDev",OBJPROP_COLOR,Yellow);
   
   ObjectSetInteger(0,"ChannelDev",OBJPROP_STYLE,STYLE_SOLID);
   
   ObjectSetInteger(0,"ChannelDev",OBJPROP_WIDTH,3);
   
   ObjectSetInteger(0,"ChannelDev",OBJPROP_RAY,true);
   
  }
//+------------------------------------------------------------------+
