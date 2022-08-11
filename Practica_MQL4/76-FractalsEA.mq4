//+------------------------------------------------------------------+
//|                                                76-FractalsEA.mq4 |
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
//---
   string signal = "";
   
   double UpFractalValue = iFractals(Symbol(),Period(),MODE_UPPER,2);
   double LowFractalValue = iFractals(Symbol(),Period(),MODE_LOWER,2);
   
   if(LowFractalValue!=0)
     {
      if(LowFractalValue<Low[1])
        {
         signal = "buy";
         
        }
     }
    if(LowFractalValue!=0)
     {
      if(LowFractalValue>High[1])
        {
         signal = "sell";
         
        }
     }  
   if(signal =="buy"&&OrdersTotal()==0)
     {
      Buy(0.01,150,100);
     }
   if(signal =="sell"&&OrdersTotal()==0)
     {
      Sell(0.01,150,100);
     }  
   
   Comment("Current Signal: ",signal,"\n",
           "Low: ",LowFractalValue,"\n",
           "Up: ",UpFractalValue,"\n");
   
   
  }
//+------------------------------------------------------------------+
