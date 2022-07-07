//+------------------------------------------------------------------+
//|                                                19-BEStopSell.mq4 |
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
   if(OrdersTotal()==0)
     {
      Sell(0.1,200,100);
     }
   BE();
  }
//+------------------------------------------------------------------+
void BE(){
for(int i=OrdersTotal()-1;i>=0;i--)
  {
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
     {
      if(OrderType()==OP_SELL&&OrderStopLoss()>OrderOpenPrice())
        {
         if(Bid<OrderOpenPrice()-100*Point)
           {
            OrderModify(OrderTicket(),OrderOpenPrice(),(OrderOpenPrice()-25*Point),OrderTakeProfit(),0,Pink);
           }
        }
     }
  }



}