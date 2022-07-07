//+------------------------------------------------------------------+
//|                                                34-DinamicBuy.mq4 |
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
   //,2 para 2 numeros despues del separador decimal
   // Previene el wrog position size
   double lotageDinamico = NormalizeDouble(AccountEquity()/100000,2);
   
   if(AccountEquity()>=AccountBalance())
     {
      if(OrdersTotal()==0)
        {
         Buy(lotageDinamico,200,100);
        }
     }
   Comment("Balance: ",AccountBalance(),
           "\nEquity: ",AccountEquity(),
           "\nPosition Size: ",lotageDinamico);
  }

