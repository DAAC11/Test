//+------------------------------------------------------------------+
//|                                                        Test3.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\GitHub\\david1.mq4"
input double Gestion =5;
input double Lotes=0.01;
input int TGR =200;
input int STP =1000;

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
double MinFlotante =0;

void OnTick()
  {
   if(OrdersTotal()==0)
     {
      Buy(Lotes,TGR,STP);
     }
   if(Flotante()>Gestion)
     {
      LiquidadorBuy();
      LiquidadorSell();
      Sleep(10000);
     }
   if(LastTypeOpen()=="OP_BUY"&& Flotante()<-1&&OrdersTotal()==1)
     {
      Sell(Lotes*2,TGR*2,STP);
     }
   if(LastTypeOpen()=="OP_SELL"&& Flotante()<-3&&OrdersTotal()==2)
     {
      Buy(Lotes*3,TGR*3,STP);
     }
   if(LastTypeOpen()=="OP_BUY"&& Flotante()<-5&&OrdersTotal()==3)
     {
      Sell(Lotes*4,TGR*4,STP);
     }
   if(Flotante()<MinFlotante)
     {
      MinFlotante=NormalizeDouble(Flotante(),2);
     }
     
  

   Comment("Ultimo Type: ", LastTypeOpen(),ENTER,
           "Flotante: ", NormalizeDouble(Flotante(),2),ENTER,
           "Open Positios:  ", OrdersTotal(),ENTER,
           "Minimo Flotante: ", MinFlotante,ENTER,
           OrdenesAbiertas(),OrdenesCerradas()
            );
   
  }