//+------------------------------------------------------------------+
//|                                                10-CloseSells.mq4 |
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
   if(OrdersTotal()<10)
     {
      Sell(0.01,200,100);
     }
   if(OrdersTotal()==10)
     {
      CloseSells();
     }
     Comment("Ordenes totales= ",OrdersTotal());
  }
//+------------------------------------------------------------------+
void CloseSells(){
for(int i=OrdersTotal()-1;i>=0;i--)
  {
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
     {
      if(OrderType()==OP_SELL)
        {
         OrderClose(OrderTicket(),OrderLots(),Ask,3,NULL);
        }
     }
  }



}