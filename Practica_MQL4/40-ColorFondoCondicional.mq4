//+------------------------------------------------------------------+
//|                                     40-ColorFondoCondicional.mq4 |
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
   string signal ="";
   
   double ma = iMA(Symbol(),Period(),20,0,MODE_SMA,PRICE_CLOSE,0);
   
   if(ma < Bid)
     {
      signal="buy";
      
      CambioColorFondo(clrGreen);
     }
   
   if(ma >Ask)
     {
      signal="sell";
      
      CambioColorFondo(clrRed);
     }
   
   if(ma <Ask && ma> Bid)
     {
      signal="none";
      
      CambioColorFondo(clrBlack);
     }
     
   Comment("The current signal = ",signal);
  }
//+------------------------------------------------------------------+
void CambioColorFondo(color colorFondo){
   
   ChartSetInteger(Symbol(),CHART_COLOR_BACKGROUND,colorFondo);

}