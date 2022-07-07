//+------------------------------------------------------------------+
//|                                                      45-3EMA.mq4 |
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
   
   double EMA10 = iMA(Symbol(),Period(),10,0,MODE_EMA,PRICE_CLOSE,0);
   double EMA50 = iMA(Symbol(),Period(),50,0,MODE_EMA,PRICE_CLOSE,0);
   double EMA100 = iMA(Symbol(),Period(),100,0,MODE_EMA,PRICE_CLOSE,0);
   
   if(EMA10>EMA50&& EMA50>EMA100)
     {
      signal="buy";
     }
     
   if(EMA10<EMA50&& EMA50<EMA100)
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
