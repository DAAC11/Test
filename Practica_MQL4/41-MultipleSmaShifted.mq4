//+------------------------------------------------------------------+
//|                                        41-MultipleSmaShifted.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Libraries\\david1.mq4"
input int barras = 20;
input int shift0 = 20;
input int shift1 = 100;
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
void OnTick()
  {
   string signal = "";
   
   double ma0 = iMA(Symbol(),Period(),barras,shift0,MODE_EMA,PRICE_CLOSE,0);
   double ma1 = iMA(Symbol(),Period(),barras,shift1,MODE_EMA,PRICE_CLOSE,0);
   
   if(Bid>ma0 && Bid>ma1)
     {
      signal="buy";
     }
   
   if(Bid<ma0 && Bid<ma1)
     {
      signal="sell";
     }
     
   if(signal == "buy" && OrdersTotal()==0)
     {
      Buy(0.5,200,100);
     }
   
   if(signal == "sell" && OrdersTotal()==0)
     {
      Sell(0.5,200,100);
     }  
   
  }
//+------------------------------------------------------------------+
