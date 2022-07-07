//+------------------------------------------------------------------+
//|                                          89-LongTrendBuySell.mq4 |
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
input int SmallSMA=950;
input int BigSMA=1000;

void OnTick()
  {
   string signal="";
   double SmallMA = iMA(Symbol(),Period(),SmallSMA,0,MODE_SMA,PRICE_CLOSE,1);
   double BigMA = iMA(Symbol(),Period(),BigSMA,0,MODE_SMA,PRICE_CLOSE,1);  
   
   if(BigMA>SmallMA)
     {
      signal="sell";
     }
   
   if(BigMA<SmallMA)
     {
      signal="buy";
     }
     
   if(OrdersTotal()==0&&signal=="sell")
     {
      Sell(0.02,200,100);
      Sell(0.01,100,100);
      Buy(0.01,100,100);
     }  
   
   if(OrdersTotal()==0&&signal=="buy")
     {
      Buy(0.02,200,100);
      Buy(0.01,100,100);
      Sell(0.01,100,100);
     }  
  }
//+------------------------------------------------------------------+
