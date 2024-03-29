//+------------------------------------------------------------------+
//|                                                           T1.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Libraries\\david1.mq4"
input double stp = 100;
input double tgr = 300;
input double lots = 0.01;
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
int C = 0;
int V = 0;

void OnTick()
  {

   double mac1 = iMA(NULL,NULL,10,0,MODE_SMA,PRICE_CLOSE,0);
   double map1 = iMA(NULL,NULL,10,0,MODE_SMA,PRICE_CLOSE,1);
   double mac2 = iMA(NULL,NULL,20,0,MODE_SMA,PRICE_CLOSE,0);
   double map2 = iMA(NULL,NULL,20,0,MODE_SMA,PRICE_CLOSE,1);
   bool cruce = false;
   
   if(map1<map2&&mac1>mac2)
     {
      cruce = true;
     }
   bool crucev = false;
   
   if(map1>map2&&mac1<mac2)
     {
      crucev = true;
     }

   if(OrdersTotal()==1&& cruce)
     {
      C = Buy(lots,stp,tgr);
     }
   
   if(OrdersTotal()==0 && crucev)
     {
      V= Sell(lots,stp,tgr);
     }
     
   Comment("Ordenes totales = "+OrdersTotal()+
           "\nNumero de ordenC = "+C+
           "\nNumero de ordenV = "+V+
           "\nCruceC = "+cruce+
           "\nCruceV = "+crucev
           
           );
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
