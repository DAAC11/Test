//+------------------------------------------------------------------+
//|                                                  35-RangoBuy.mq4 |
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

extern double LimiteS = 10;
extern double LimiteI = 0;
void OnTick()
  {
   if(OrdersTotal()==0)
     {
      if(PriceRange()==true)
        {
         Buy(0.1,200,100);
        }
     }
   Comment("Limite Superior: ", LimiteS,"\n",
           "Limite Inferior: ", LimiteI,"\n", 
           "Ask price: ", Ask,"\n",
           "Esta en rango?: ", PriceRange(),"\n");
  }
//+------------------------------------------------------------------+
bool PriceRange(){
   bool re = false;
   
   if(Ask>LimiteI)
     {
      if(Ask<LimiteS)
        {
         re=true;
        }
     }
   return re;

}