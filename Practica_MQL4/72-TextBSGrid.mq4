//+------------------------------------------------------------------+
//|                                                72-TextBSGrid.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Libraries\\david1.mq4"
input int puntos = 100;
input int TGR = 100;
input int STP = 100;
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
      Buy(0.01,TGR,STP);
      NextBuyPrice=Ask+puntos*Point;
     }
   
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
         Sell(0.01,TGR,STP);
      
         NextSellPrice=Bid-puntos*Point;
       }
     
     }
   Comment("Ask: ",Ask,"\nNextBuyPrice: ",NextBuyPrice
            ,"\nSignal: ",signal,"\n",
            "Flotante: ",round( AccountEquity()-AccountBalance()));
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
   
/* 
TEST 1
puntos = 80;
TGR = 100;
STP = 1000;

TEST 2
puntos = 80;
TGR = 150;
STP = 2000;

TEST3
puntos = 10;
TGR = 100;
STP = 1000;
*/