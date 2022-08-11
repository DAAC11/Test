//+------------------------------------------------------------------+
//|                                                        Test7.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Experts\\david1.mq4"
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
int Tickets[1];
void OnTick()
  {
//-

   if(OrdersTotal()<2)
     {
      AddArray(Tickets,Buy(Lotes,TGR,STP));
       AddArray(Tickets,Sell(Lotes,TGR,STP));
     }
   if(Flotante()<MinFlotante)
     {
      MinFlotante=NormalizeDouble(Flotante(),2);
     }

   Comment("Min Flotante: ",MinFlotante,ENTER,
           "Ordenes Array: ",PrintArray(Tickets),ENTER,
           OrdenesAbiertas(),
           OrdenesCerradas(),ENTER,
           MinFlotante
           );
  }
//+------------------------------------------------------------------+
