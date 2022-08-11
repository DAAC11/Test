//+------------------------------------------------------------------+
//|                                                   25-StochEA.mq4 |
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
   
   double K0 = iStochastic(Symbol(),Period(),5,3,3,MODE_EMA,0,MODE_MAIN,0);
   double D0 = iStochastic(Symbol(),Period(),5,3,3,MODE_EMA,0,MODE_SIGNAL,0);
   
   double K1 = iStochastic(Symbol(),Period(),5,3,3,MODE_EMA,0,MODE_MAIN,1);
   double D1 = iStochastic(Symbol(),Period(),5,3,3,MODE_EMA,0,MODE_SIGNAL,1);
   
   if((K0>80)&&(D0>80))
     {
      if((D0>K0)&&(D1<K1))
        {
         signal = "sell";
        }
     }
   
    if((K0<20)&&(D0<20))
     {
      if((D0<K0)&&(D1>K1))
        {
         signal = "buy";
        }
     }
   if(signal=="buy"&& OrdersTotal()==0)
     {
      Buy(0.05,100,100);
     }
   
   if(signal=="sell"&& OrdersTotal()==0)
     {
      Sell(0.05,100,100);
     }
  }
//+------------------------------------------------------------------+
