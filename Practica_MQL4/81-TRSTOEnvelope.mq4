//+------------------------------------------------------------------+
//|                                             81-TRSTOEnvelope.mq4 |
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
   static double LastSTP;
   static double LastTGR;
   if(OrdersTotal()==0)
     {
      Buy(0.01,100,100);
     }
   double lowerBand = iEnvelopes(Symbol(),Period(),14,MODE_SMA,0,PRICE_CLOSE,0.05,2,1);
   
   double upperBand = iEnvelopes(Symbol(),Period(),14,MODE_SMA,0,PRICE_CLOSE,0.05,1,1);
   
   if(LastSTP < lowerBand)
     {
      TRSTP(lowerBand);
      LastSTP = lowerBand;
     }
   if(LastTGR < upperBand)
     {
      TGR(upperBand);
      LastTGR = upperBand;
     }
  }
//+------------------------------------------------------------------+
void TRSTP( double lowerBand){
 for(int i=OrdersTotal()-1;i>=0;i--)
   {
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
       if(OrderStopLoss()< lowerBand)
         {
          OrderModify(OrderTicket(),OrderOpenPrice(),lowerBand,OrderTakeProfit(),0,CLR_NONE);
         }
      }
   }

}

void TGR( double upperBand){
 for(int i=OrdersTotal()-1;i>=0;i--)
   {
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
       if(OrderTakeProfit()< upperBand)
         {
          OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),upperBand,0,CLR_NONE);
         }
      }
   }

}


