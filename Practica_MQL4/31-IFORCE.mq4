//+------------------------------------------------------------------+
//|                                                    31-IFORCE.mq4 |
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
   
   double iforce0 = iForce(Symbol(),Period(),13,MODE_SMA,PRICE_CLOSE,0);
   double iforce1 = iForce(Symbol(),Period(),13,MODE_SMA,PRICE_CLOSE,1);
   
   if( iforce1<0 &&iforce0>0)
     {
      signal="buy";
     }
   
   if( iforce1>0 &&iforce0<0)
     {
      signal="sell";
     } 
   
   if(signal=="buy" && OrdersTotal()==0)
     {
      Sell(0.05,200,100);
     }
   
   if(signal=="sell" && OrdersTotal()==0)
     {
      Buy(0.05,200,100);
     }  
    
  }
//+------------------------------------------------------------------+
