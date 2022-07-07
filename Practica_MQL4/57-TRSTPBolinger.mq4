//+------------------------------------------------------------------+
//|                                             57-TRSTPBolinger.mq4 |
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
   static double LASTBollinger;
   
   if(OrdersTotal()==0)
     {
      Buy(0.1,150,100);
      LASTBollinger=0;
     }
   
   double LowerBB = iBands(Symbol(),Period(),20,2,0,PRICE_CLOSE,MODE_LOWER,1);
   double UpperBB = iBands(Symbol(),Period(),20,2,0,PRICE_CLOSE,MODE_UPPER,1);
   
   CheckBBSTP(LowerBB);
   LASTBollinger = LowerBB;
  }
//+------------------------------------------------------------------+
void CheckBBSTP(double LowerBB){
   
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderProfit()>=1.5)
           {
            Comment("VAMOOOOOOOOS ",OrderProfit());
            OrderModify(OrderTicket(),OrderOpenPrice(),LowerBB,OrderTakeProfit(),0,clrNONE);
           }
        }
     }


}