//+------------------------------------------------------------------+
//|                                               85-TrueRangeEA.mq4 |
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
int STPpoints =100;
int STPCalculated;

void OnTick()
  {
//---
   string signal ="";
   double ATR = iATR(Symbol(),Period(),14,0);
   static double OldValue;
   
   if(ATR>OldValue)
     {
      signal="buy";
     }
   if(OrdersTotal()==0&&signal=="buy")
     {
      Buy(0.01,200,100);
     }
   STPCalculated = CheckATRTRSTP(ATR);
   Comment("Signal ",signal,"\n",
           "ATR ",ATR,"\n",
           "STP Calculado ",STPCalculated);
           
   OldValue=ATR;
  }
//+------------------------------------------------------------------+
int CheckATRTRSTP(double ATR)
{
   STPCalculated = STPpoints+(ATR*100000);
   double CalcSTPPrice = Ask-STPCalculated*Point();
   
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderStopLoss()<CalcSTPPrice)
           {
            OrderModify(OrderTicket(),
            OrderOpenPrice(),
            CalcSTPPrice,
            OrderTakeProfit(),
            0,Pink);
           }
        }
     }
   return CalcSTPPrice;
}