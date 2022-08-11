//+------------------------------------------------------------------+
//|                                           43-MonitorMomentum.mq4 |
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
   string momentumActual = "";
   
   double momentum0= iMomentum(Symbol(),Period(),14,PRICE_CLOSE,0);
   
   double momentumArray[14];
   
   double avgMomentum =0;
   
   double momentumSumary =0;
   
   for(int i=13;i>=0;i--)
     {
      
      double tempMomentum = iMomentum(Symbol(),Period(),14,PRICE_CLOSE,i);
      
      momentumSumary = momentumSumary+ tempMomentum;
      
      avgMomentum = momentumSumary /14;
     }
     
   if(momentum0>avgMomentum)
     {
      momentumActual = "Momentum arriba del Promedio";
     }
   if(momentum0<avgMomentum)
     {
      momentumActual = "Momentum debajo del Promedio";
     }
     
   Comment("Momentum actual = ", momentum0,"\n",
           "Momentum promedio = ", avgMomentum,"\n",
           "Momentum state = ", momentumActual);
  }
//+------------------------------------------------------------------+
