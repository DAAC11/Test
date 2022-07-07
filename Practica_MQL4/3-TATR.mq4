//+------------------------------------------------------------------+
//|                                                         TATR.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Libraries\\david1.mq4"
input double stp = 100;
input double tgr = 150;
input double lots = 0.01;
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
   double atr1 = iATR(NULL,NULL,14,0);
   double atr2 = iATR(NULL,NULL,14,5);
   
   if(atr1>atr2 && OrdersTotal()==0)
     {
      Buy(lots,tgr,stp);
     }
   if(atr1<atr2 && OrdersTotal()==0)
     {
      Sell(lots,tgr,stp);
     }
   
  }
//+------------------------------------------------------------------+
