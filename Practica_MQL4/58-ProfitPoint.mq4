//+------------------------------------------------------------------+
//|                                               58-ProfitPoint.mq4 |
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
input int ProfitPoints=300;
void OnTick()
  {
   string signal = "";
   
   double MA = iMA(Symbol(),Period(),20,0,MODE_SMA,PRICE_CLOSE,0);
   
   if(MA< Close[0])
     {
      signal="buy";
     }
   if(MA> Close[0])
     {
      signal="sell";
     }
   if(signal=="buy"&& OrdersTotal()==0)
     {
      Buy(0.1,ProfitPoints,100);
     }
   if(signal=="sell"&& OrdersTotal()==0)
     {
      Sell(0.1,ProfitPoints,100);
     }
   
   Comment("Señal = ",signal,"\nProfit = ",ProfitPoints);
   
  }
//+------------------------------------------------------------------+
