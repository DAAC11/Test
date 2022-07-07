//+------------------------------------------------------------------+
//|                                                   70-BuyGrid.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Libraries\\david1.mq4"
input int puntos = 30;
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
   static double NextBuyPrice;
   
   if(OrdersTotal()==0)
     {
      NextBuyPrice=0;
      signal = revisarSignal();
     }
   
   if(Ask>=NextBuyPrice&&signal=="buy")
     {
      Buy(0.01,100,100);
      NextBuyPrice=Ask+puntos*Point;
     }
   Comment("Ask: ",Ask,"\n NextBuyPrice: ",NextBuyPrice);
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