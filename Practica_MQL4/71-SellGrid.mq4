//+------------------------------------------------------------------+
//|                                                  71-SellGrid.mq4 |
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
string signal = "";
void OnTick()
  {
   static double NextSellPrice;
   if(OrdersTotal()==0)
     {
      NextSellPrice=0;
     }
   signal = revisarSignal();
   
   if(Bid<=NextSellPrice||NextSellPrice==0)
     {
     if(signal=="sell")
       {
         Sell(0.1,100,100);
      
         NextSellPrice=Bid-30*Point;
       }
     
     }
     
  }
//+------------------------------------------------------------------+
string revisarSignal()
   {
    if(Close[1]>Open[1])
      {
       signal="buy"; 
      }
    if(Close[1]<Open[1])
      {
       signal="sell"; 
      }
   return signal;
   }