//+------------------------------------------------------------------+
//|                                             12-SellPosmodify.mq4 |
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
  string signal="";
  if(AccountEquity()-AccountBalance()>5)
    {
     signal = "OOOOOOOOO\nOOOOOOOOO\nOOOOOOOOO\nOOOOOOOOO\nOOOOOOOOO\nOOOOOOOOO\nOOOOOOOOO\n";
    }
  
  Comment("Ganancia = ",AccountEquity()-AccountBalance(),signal);
  double obj = 10;
   if(OrdersTotal()<1)
     {
      Sell(0.10,200,100);
     }
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(AccountEquity()-AccountBalance()>obj)
           {
            OrderClose(OrderTicket(),0.02,Ask,3,NULL);
           }
        }
     }
  }
//+------------------------------------------------------------------+
