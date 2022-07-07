//+------------------------------------------------------------------+
//|                                               24-CommodityEA.mq4 |
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
   
   double ICC= iCCI(Symbol(),Period(),14,PRICE_CLOSE,0);
   
   if(ICC>100)
     {
      signal="sell";
     }
   
   if(ICC<-100)
     {
      signal="buy";
     }  
   
   if(signal=="buy" && OrdersTotal()==0)
     {
      Buy(0.05,200,100);
     }  
   
   if(signal=="sell" && OrdersTotal()==0)
     {
      Sell(0.05,200,100);
     }
  }
//+------------------------------------------------------------------+
