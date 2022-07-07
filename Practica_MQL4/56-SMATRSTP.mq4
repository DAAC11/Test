//+------------------------------------------------------------------+
//|                                                  56-SMATRSTP.mq4 |
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

void OnTick()
  {
  static double SMALast;
  
  if(OrdersTotal()==0)
    {
     Buy(0.1,200,100);
    }
  
  double SMASTP = iMA(Symbol(),Period(),50,0,MODE_SMA,PRICE_CLOSE,1);
  
  if(SMASTP>SMALast)
    {
     if(SMASTP<Bid)
       {
        SMATR(SMASTP);
        SMALast = SMASTP;
       }
    }
   
  }
//+------------------------------------------------------------------+
void SMATR(double stp)
{
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
       if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         {
          if(OrderStopLoss()<stp)
            {
             OrderModify(OrderTicket(),OrderOpenPrice(),stp,OrderTakeProfit()+10,0,clrNONE);
            }
         }
     }


}