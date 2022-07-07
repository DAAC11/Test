//+------------------------------------------------------------------+
//|                                          90-BollingerBandsEA.mq4 |
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
   string signal ="";
   double LowerBB= iBands(Symbol(),Period(),20,2,0,PRICE_CLOSE,MODE_LOWER,1);
   double UpperBB= iBands(Symbol(),Period(),20,2,0,PRICE_CLOSE,MODE_UPPER,1);
   
   double PrevLowerBB= iBands(Symbol(),Period(),20,2,0,PRICE_CLOSE,MODE_LOWER,2);
   double PrevUpperBB= iBands(Symbol(),Period(),20,2,0,PRICE_CLOSE,MODE_UPPER,2);
   
   if(Close[2]<LowerBB)
     {
      if(Close[1]>LowerBB)
        {
         signal="buy";
        }
     }
     
   if(Close[2]>LowerBB)
     {
      if(Close[1]<LowerBB)
        {
         signal="sell";
        }
     }
     
   if(signal=="buy"&&OrdersTotal()==0)
     {
      Buy(0.02,200,100);
      Sell(0.01,100,100);
     }
   
   if(signal=="sell"&&OrdersTotal()==0)
     {
      Sell(0.02,200,100);
      Buy(0.01,100,100);
     }
   Comment("Signal: ",signal);
  }
  
  
  
//+------------------------------------------------------------------+
