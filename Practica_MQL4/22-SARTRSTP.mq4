//+------------------------------------------------------------------+
//|                                                  22-SARTRSTP.mq4 |
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
double sar;
void OnTick()
  {
   if((OrdersTotal()==0)&&( sar<Ask))
     {
      Buy(0.05,150,100);
      
     }
   sar = iSAR(Symbol(),Period(),0.02,0.2,0);
   
   if(sar<Ask)
     {
      trstpSar();
     }
   
  }
//+------------------------------------------------------------------+
void trstpSar(){
   
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==OP_BUY)
           {
            if(OrderStopLoss()<sar)
              {
               OrderModify(
                  OrderTicket(),
                  OrderOpenPrice(),
                  sar,
                  OrderTakeProfit(),
                  0,
                  Pink);
              }
           }
        }
     }


}