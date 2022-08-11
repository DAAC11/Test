//+------------------------------------------------------------------+
//|                                          30-FiboLevelsObject.mq4 |
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
   int VelaMasAlta = iHighest(Symbol(),Period(),MODE_HIGH,200,0);
   
   int VelaMasBaja = iLowest(Symbol(),Period(),MODE_LOW,200,0);
   
   ObjectDelete("Fibo");
   
   ObjectCreate("Fibo",OBJ_FIBO,0,Time[0],High[VelaMasAlta],Time[200],Low[VelaMasBaja]);
   
   //fibo Levels
   
   double lvl100 = ObjectGetDouble(0,"Fibo",OBJPROP_PRICE,0);
   double lvl0 = ObjectGetDouble(0,"Fibo",OBJPROP_PRICE,1);
   double lvl50 = (lvl100+lvl0)/2;
   
   Comment("Nivel 100 = ",lvl100,
           "\nNivel 50 = ",lvl50,
           "\nNivel 0 = ",lvl0);
  }
//+------------------------------------------------------------------+
