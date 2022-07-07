//+------------------------------------------------------------------+
//|                                                     91-SMAEA.mq4 |
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
   double SMA = iMA(Symbol(),Period(),20,0,MODE_SMA,PRICE_CLOSE,0);
   
   if(SMA<Close[0])
     {
      if(OrdersTotal()==0)
        {
         Buy(0.01,200,100);
        }
     }
   
   if(SMA>Close[0])
     {
      if(OrdersTotal()==0)
        {
         Sell(0.01,200,100);
        }
     }
   Comment("Signal: ",signal);
   
  }
//+------------------------------------------------------------------+
