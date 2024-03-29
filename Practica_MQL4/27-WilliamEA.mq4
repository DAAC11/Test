//+------------------------------------------------------------------+
//|                                                 27-WilliamEA.mq4 |
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
   double will = iWPR(Symbol(),Period(),14,0);
   
   if(will< -80)
     {
      signal = "buy";
     }
   
   if(will> -20)
     {
      signal = "sell";
     }
   
   if(signal=="buy"&&OrdersTotal()<2)
     {
      Sell(0.05,200,100);
     }
     
   
   if(signal=="sell"&&OrdersTotal()<2)
     {
      Buy(0.05,200,100);
     }  
     
   Comment("La señal es = ", signal, "\n",
           "Ordenes Abiertas = ",OrdersTotal()  );
  }
//+------------------------------------------------------------------+
