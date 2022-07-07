//+------------------------------------------------------------------+
//|                                               39-MultipleRSI.mq4 |
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
   string signal = "";
   
   double rsi0 = iRSI(Symbol(),Period(),14,PRICE_CLOSE,0);
   double rsi1 = iRSI(Symbol(),PERIOD_M30,14,PRICE_CLOSE,0);
   double rsi2 = iRSI(Symbol(),PERIOD_H1,14,PRICE_CLOSE,0);
   
   
   if(rsi0>70&&rsi1>70&&rsi2>70)
     {
      signal = "sell";
     }
   
   if(rsi0<30&&rsi1<30&&rsi2<30)
     {
      signal = "buy";
     } 
        
   if(signal=="buy"&&OrdersTotal()==0)
     {
      Sell(0.1,200,100);
     }
   
   if(signal=="sell"&&OrdersTotal()==0)
     {
      Buy(0.1,200,100);
     }
   
   Comment("RSI actual = ",rsi0,"\n",
           "RSI 30m = ",rsi1,"\n",
           "RSI H1 = ",rsi0);
  }
//+------------------------------------------------------------------+
