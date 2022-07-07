//+------------------------------------------------------------------+
//|                                                79-StpPercent.mq4 |
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
input double Risk = 0.5;
double MaxPosLoss;
void OnTick()
  {
//---
   if(OrdersTotal()<1)
     {
      int Compra= Buy(0.1,2000,10000);
     }
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         double Profit = OrderProfit();
         MaxPosLoss = 0-(AccountBalance()/100*Risk);
         
         Print("### Position Profit: ",Profit);
         Print("### MaxPositionLoss: ",MaxPosLoss);
         
         if(Profit < MaxPosLoss)
           {
            OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,Red);
           }
        }
     }
   Comment(
   "Balamce: ", AccountBalance(),"\n",
   "MaxPosLoss: ", MaxPosLoss,"\n",
   "%Risk Value: ", Risk,"\n"
   );
  }
//+------------------------------------------------------------------+
