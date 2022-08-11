//+------------------------------------------------------------------+
//|                                                26-ObjetoHora.mq4 |
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
   string end = "9:30:";
   
   string horaActual = TimeToStr(TimeLocal(),TIME_SECONDS);
   int endOpen = StringFind(horaActual,end,0);
   
   int alto = iHighest(Symbol(),Period(),MODE_HIGH,30,0);
   int bajo = iLowest(Symbol(),Period(),MODE_LOW,30,0);
   
   Comment("Hora : ",horaActual);
   
   if(endOpen != -1)
     {
      ObjectDelete("Rectangulo");
      ObjectCreate("Rectangulo",OBJ_RECTANGLE,0,Time[0],High[alto],Time[30],Low[bajo]);
     }
 
   
  }
//+------------------------------------------------------------------+
