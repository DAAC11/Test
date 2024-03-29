//+------------------------------------------------------------------+
//|                                      29-ExternalCandleNumber.mq4 |
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
extern int velas =100;
void OnTick()
  {
   string signal ="";
   
   double ma = iMA(Symbol(),Period(),velas,0,MODE_SMA,PRICE_CLOSE,0);
   
   if(ma< Close[0])
     {
      signal = "buy";
     }
   
   if(ma>Close[0])
     {
      signal = "sell";
     }
   if(signal=="buy"&&OrdersTotal()==0)
     {
      Sell(0.05,80,100);
     }
   
   if(signal=="sell"&&OrdersTotal()==0)
     {
      Buy(0.05,80,100);
     }  
   
   Comment("Numero de velas = ",velas,
           "\nSeñal actual = ",signal,
           "\nPorfavor ajuste el numero de velas en la grafica");
  }
//+------------------------------------------------------------------+
