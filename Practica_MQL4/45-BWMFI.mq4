//+------------------------------------------------------------------+
//|                                                     45-BWMFI.mq4 |
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
   double indicador0 = iBWMFI(Symbol(),Period(),0);
   double indicador1 = iBWMFI(Symbol(),Period(),1);
   
   if(indicador0>indicador1)
     {
      signal = "buy";
     }
   
   
   if(indicador0<indicador1)
     {
      signal = "sell";
     }  
   
   
   if(signal=="buy"&&OrdersTotal()==0)
     {
      Sell(0.1,200,100);
     }
     
   
   if(signal=="sell"&&OrdersTotal()==0)
     {
      Buy(0.1,200,100);
     }
   
   Comment("signal = ",signal);
  }
//+------------------------------------------------------------------+
