//+------------------------------------------------------------------+
//|                                                   67-Reverse.mq4 |
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
string direccion = "buy";
input int TP=500;
input int STP = 300;

void OnTick()
  {
   if(OrdersTotal()==0 && direccion=="buy")
     {
      Buy(0.01,TP,STP);
      direccion= "sell";
     }
   
   if(OrdersTotal()==0 && direccion=="sell")
     {
      Sell(0.01,TP,STP);
      direccion= "buy";
     }
   Comment("Direccion = ", direccion);
  }
  
//+------------------------------------------------------------------+
