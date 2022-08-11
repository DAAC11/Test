//+------------------------------------------------------------------+
//|                                                 78-DevStdrEA.mq4 |
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
   
   double desvArray[200];
   
   for(int i=199;i>0;i--)
     {
      double desvValue = iStdDev(Symbol(),Period(),20,0,MODE_SMA,PRICE_CLOSE,i);
      desvArray[i]=desvValue;
      
     }
     
   double CurrentValue =iStdDev(Symbol(),Period(),20,0,MODE_SMA,PRICE_CLOSE,0);
   
   int HighestCandle= ArrayMaximum(desvArray,WHOLE_ARRAY,0);
   int LowestCandle= ArrayMinimum(desvArray,WHOLE_ARRAY,0);
   
   if(LowestCandle==0)
     {
      signal="sell";
     }
   if(HighestCandle==0)
     {
      signal="buy";
     }
   if(signal=="buy"&&OrdersTotal()==0)
     {
      Sell(0.01,150,100);
     }
   if(signal=="sell"&&OrdersTotal()==0)
     {
      Buy(0.01,150,100);
     }
   
   Comment("Current value: ",CurrentValue,"\n",
           "HighestCandle: ",HighestCandle,"\n",
           "LowestCandle: ",LowestCandle,"\n",
           "Signal: ",signal);
  }
//+------------------------------------------------------------------+
