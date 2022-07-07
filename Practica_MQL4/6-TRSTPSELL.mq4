//+------------------------------------------------------------------+
//|                                                  6-TRSTPSELL.mq4 |
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
int tr = 150;
void OnTick()
  {
 if(OrdersTotal()<1)
   {
    int venta = Sell(0.01,200,100); 
   }
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_SELL)
              {
               if(OrderStopLoss()==0||OrderStopLoss()>Bid+(tr*Point))
                 {
                  OrderModify(
                  OrderTicket(),
                  OrderOpenPrice(),
                  Bid+(tr*Point),
                  OrderTakeProfit(),
                  0,
                  Blue
                  );
                 }
              }
           }
        }
     }
   Comment(Point);
  }
//+------------------------------------------------------------------+
