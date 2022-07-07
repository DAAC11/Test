//+------------------------------------------------------------------+
//|                                                92-SMACrossEA.mq4 |
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
   double MSMA1 = iMA(Symbol(),Period(),20,0,MODE_SMA,PRICE_CLOSE,0);
   double MSMA2 = iMA(Symbol(),Period(),20,0,MODE_SMA,PRICE_CLOSE,1);
   double LSMA1 = iMA(Symbol(),Period(),10,0,MODE_SMA,PRICE_CLOSE,0);
   double LSMA2 = iMA(Symbol(),Period(),10,0,MODE_SMA,PRICE_CLOSE,1);
  
   if(LSMA1<MSMA1&&LSMA2>MSMA2)
     {
      if(OrdersTotal()<=2)
        {
         Buy(0.02,200,100);
         Sell(0.01,100,100);
        }
     }
   
   if(LSMA1>MSMA1&&LSMA2<MSMA2)
     {
      if(OrdersTotal()<=2)
        {
         Sell(0.02,200,100);
         Buy(0.01,100,100);
        }
     }
   Comment("Signal: ",signal);
   
  }
//+------------------------------------------------------------------+
