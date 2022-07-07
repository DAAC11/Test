//+------------------------------------------------------------------+
//|                                       49-EnvelopesIndicators.mq4 |
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
//---
   string signal = "";

   double lowerBand = iEnvelopes(Symbol(),Period(),14,MODE_SMA,0,PRICE_CLOSE,0.05,MODE_LOWER,0);

   double upperBand = iEnvelopes(Symbol(),Period(),14,MODE_SMA,0,PRICE_CLOSE,0.05,MODE_UPPER,0);

   if(Close[1]<lowerBand)
     {
      signal="buy";
     }

   if(Close[1]>upperBand)
     {
      signal="sell";
     }

   if(signal == "buy"&& OrdersTotal()==0)
     {
      Buy(0.05,200,100);
     }

   if(signal == "sell"&& OrdersTotal()==0)
     {
      Sell(0.05,200,100);
     }
     
   
  }
//+------------------------------------------------------------------+
