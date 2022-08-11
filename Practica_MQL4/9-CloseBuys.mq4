//+------------------------------------------------------------------+
//|                                                  9-CloseBuys.mq4 |
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
      
   Buy(0.01,200,100);
     }
     
   if(OrdersTotal()==10)
     {
      CloseBuys();
     }
   Comment("Ordenes totales= ",OrdersTotal());
  }
//+------------------------------------------------------------------+
void CloseBuys(){
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()==OP_BUY)
        {
         OrderClose(OrderTicket(),OrderLots(),Bid,3,NULL);
        }
     }
     }

