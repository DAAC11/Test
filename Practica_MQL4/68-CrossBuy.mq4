//+------------------------------------------------------------------+
//|                                                  68-CrossBuy.mq4 |
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
   string signal = "";
   
   double SMAS= iMA(Symbol(),Period(),20,0,MODE_SMA,PRICE_CLOSE,1);
   double SMAB= iMA(Symbol(),Period(),50,0,MODE_SMA,PRICE_CLOSE,1);
   
   if(SMAB > SMAS)
     {
      signal= "sell";
     }
   if(SMAB < SMAS)
     {
      signal= "buy";
     } 
   if(OrdersTotal()==0 && signal=="buy")
     {
      Buy(0.01,100
      ,100);
     }
 
   if(signal=="sell"&& OrdersTotal()>0)
     {
      ClosePos();
     } 
   Comment("Señal = ", signal);     
  }
//+------------------------------------------------------------------+
void ClosePos()
   {
    for(int i=OrdersTotal()-1;i>=0;i--)
      {
       if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
       {
        OrderClose(OrderTicket(),OrderLots(),Bid,3,NULL);
       
       }
       
      }   
   
   }