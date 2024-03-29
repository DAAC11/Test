//+------------------------------------------------------------------+
//|                                         82-MultiCHartTrendEA.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Libraries\\david1.mq4"
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
   string signalCurrent = "",EURUSDSignal="";
   double EMA20 = iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,0);
   double oldEMA20 = iMA(Symbol(),Period(),20,0,MODE_EMA,PRICE_CLOSE,2);
   double EMAEURUSD= iMA("EURUSD",Period(),20,0,MODE_EMA,PRICE_CLOSE,0);
   double oldEMAEURUSD= iMA("EURUSD",Period(),20,0,MODE_EMA,PRICE_CLOSE,2);
   if(EMA20>oldEMA20)
     {
      signalCurrent="buy";
     }
   if(EMA20<oldEMA20)
     {
      signalCurrent="sell";
     }
    if(EMAEURUSD>oldEMAEURUSD)
     {
      EURUSDSignal="buy";
     }
   if(EMAEURUSD<oldEMAEURUSD)
     {
      EURUSDSignal="sell";
     }
   Comment("señal 1 = ",signalCurrent," signal2= ",EURUSDSignal );
  }
//+------------------------------------------------------------------+
