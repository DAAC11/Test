//+------------------------------------------------------------------+
//|                                                 59-BuyButton.mq4 |
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
   ObjectCreate(
      Symbol(),
      "BuyButton",
      0,
      0,
      0
   );
   
   //Distancia del borde X
   ObjectSetInteger(Symbol(),"BuyButton",OBJPROP_XDISTANCE,200);
   
   //Ancho
   ObjectSetInteger(Symbol(),"BuyButton",OBJPROP_XSIZE,200);
   
   //Distancia del borde Y
   ObjectSetInteger(Symbol(),"BuyButton",OBJPROP_YDISTANCE,200);
   
   //Alto
   ObjectSetInteger(Symbol(),"BuyButton",OBJPROP_YSIZE,200);
   
   //Esquina del grafico
   ObjectSetInteger(Symbol(),"BuyButton",OBJPROP_CORNER,3);
   
   //Texto
   ObjectSetString(Symbol(),"BuyButton",OBJPROP_TEXT,"BUY");
  }
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,
   const string &sparam){

if(id==CHARTEVENT_OBJECT_CLICK)
  {
   if(sparam == "BuyButton")
     {
      Comment(sparam +" Fuen precionado");
      Buy(0.1,200,100);

     }
  }
}

///NO FUNCIONÖ