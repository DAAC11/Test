//+------------------------------------------------------------------+
//|                                       36-FuncionSobrecargada.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
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
   double diff = Ask-Bid;
   
   double resultado = AddValues(Ask,Bid,diff);
   
   Comment("El resultado es = ",resultado);
  }
//+------------------------------------------------------------------+
double AddValues(double AskValue,double BidValue){

   Print("Esta funcion tomó 2 parametros");
   double re = AskValue + BidValue;
   
   return re;
}

double AddValues(double AskValue,double BidValue,double Diff){

   Print("Esta funcion tomó 3 parametros");
   double re = AskValue + BidValue + Diff;
   
   return re;
}