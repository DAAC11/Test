//+------------------------------------------------------------------+
//|                                                          5.TRSTP |
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
int Trstp=125;
void OnTick()
  {
  
   
   if(OrdersTotal()<1)
     {
      int compra= Buy(0.01,200,100);
     }
   
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY)
              {
               if(OrderStopLoss()<Ask-(Trstp*Point))
                 {
                  OrderModify(
                  OrderTicket(),
                  OrderOpenPrice(),
                  Ask-(Trstp*Point),
                  OrderTakeProfit(),
                  0,Blue);
                 }
              }
           }
        }
      
      
     }
  }
//+------------------------------------------------------------------+
