//+------------------------------------------------------------------+
//|                                                     84-RSIEA.mq4 |
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
   double RSIValue = iRSI(Symbol(),Period(),14,PRICE_CLOSE,0);
   
   if(OrdersTotal()==0)
     {
      if(RSIValue<30)
        {
         Buy(0.01,20000,100);
        }
       
     }
   if(RSIValue>70)
     {
      for(int i=OrdersTotal()-1;i>=0;i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            OrderClose(OrderTicket(),OrderLots(),
            Bid,5,Red);
           }
        }
     }
   
    
   Comment("RSI Value ", RSIValue);
  }
//+------------------------------------------------------------------+
void RsiSTP(double RsiV){
 
 for(int i=OrdersTotal();i>0;i--)
   {
    if(OrderSelect(i,SELECT_BY_POS)==true)
      {
         if(OrderType()==OP_BUY)
           {
            if(OrderSymbol()==Symbol())
              {
                if(RsiV>=70)
                  {
                   OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),
                            MarketInfo(Symbol(),MODE_BID),0,Red);
                  }
              }
           }
      }
   }

}