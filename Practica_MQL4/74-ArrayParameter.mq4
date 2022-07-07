//+------------------------------------------------------------------+
//|                                            74-ArrayParameter.mq4 |
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
//---
   int array[10];
   
   array[0]=8;
   array[1]=16;
   array[2]=32;
   array[3]=64;
   
   int RResult = AddValue(array);
   
   Comment("Resultado= ", RResult);
  }
//+------------------------------------------------------------------+
int AddValue (int& array[]){
   int Result = array[0]+ array[1]+array[2]+array[3];
   return Result;


}