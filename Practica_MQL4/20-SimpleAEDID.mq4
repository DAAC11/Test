//+------------------------------------------------------------------+
//|                                               20-SimpleAEDID.mq4 |
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
   string signal ="";
   
   double sma = iMA(Symbol(),Period(),20,0,MODE_SMA,PRICE_CLOSE,0);
   
   double iad= iAD(Symbol(),Period(),0);
   double lastIad =iAD(Symbol(),Period(),10);
   
   if(Ask>sma)
     {
      if(iad>lastIad)
        {
         signal="buy";
         
        }
     }
   if(Bid< sma)
     {
      if(iad<lastIad)
        {
         signal="sell";
         
       }
     }
   if(signal=="buy"&& OrdersTotal()==0)
     {
      Buy(0.05,200,100);
     }
   if(signal=="sell"&& OrdersTotal()==0)
     {
      Sell(0.05,200,100);
     }
     
   Comment("IADValue = ",iad,"\nSignal = ",signal);
  }
//+------------------------------------------------------------------+
