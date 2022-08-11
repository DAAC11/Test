//+------------------------------------------------------------------+
//|                                                  8-CountSell.mq4 |
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
   OpenTestPosition();
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
   Comment("Ordenes de venta = ",contadorSell());

  }
//+------------------------------------------------------------------+
void OpenTestPosition()
  {
   MathSrand(GetTickCount());

   int Posiciones = MathRand()%10;

   for(int i=0; i<Posiciones; i++)
     {
      Buy(0.01,200,100);
      Sell(0.01,200,100);
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int contadorSell()
  {
   int acc=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==OP_SELL)
           {
            acc++;
           }
        }

     }

   return acc;

  }
//+------------------------------------------------------------------+
