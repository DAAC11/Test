//+------------------------------------------------------------------+
//|                                                        Test6.mq4 |
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
   if(OrdersTotal()==1&& LastTypeOpen()=="OP_BUY")
     {
      Sell(Lotes,TGR,STP);
     }
   if(OrdersTotal()==1&& LastTypeOpen()=="OP_SELL")
     {
      Buy(Lotes,TGR,STP);
     }


   if(Flotante()<MinFlotante)
     {
      MinFlotante=NormalizeDouble(Flotante(),2);
     }
   TRSTP(1);
   Comment("Ultimo Type: ", LastTypeOpen(),ENTER,
           "Flotante: ", NormalizeDouble(Flotante(),2),ENTER,
           "Open Positios:  ", OrdersTotal(),ENTER,
           "Minimo Flotante: ", MinFlotante,ENTER,ENTER,
           OrdenesAbiertas(),OrdenesCerradas()
          );
  }
//+------------------------------------------------------------------+
void TRSTP(double R)
  {

   for(int i=OrdersTotal()-1; i>0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {

         if(OrderProfit()>R)
           {
            OrderModify(OrderTicket(),OrderOpenPrice()
                        ,OrderOpenPrice()+10*Point,
                        OrderTakeProfit(),0,CLR_NONE);
            Print("TRSTP");
           }


        }
     }
  }
//+------------------------------------------------------------------+
