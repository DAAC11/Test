//+------------------------------------------------------------------+
//|                                         55-MutiSpreadChecker.mq4 |
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

double SpreadMasBajo = 1000;
double SpreadMasAlto =0;
void OnTick()
  {
//---
   int VelaActualSpread = SymbolInfoInteger(Symbol(),SYMBOL_SPREAD);
   
   if(VelaActualSpread < SpreadMasBajo)
     {
      SpreadMasBajo=VelaActualSpread;
     }
   
   if(VelaActualSpread>SpreadMasAlto)
     {
      SpreadMasAlto=VelaActualSpread;
     }
  
  Comment("Spread Actual ", VelaActualSpread,"\n"
          "Spread Mas bajo  ", SpreadMasBajo,"\n"
          "Spread Mas alto  ", SpreadMasAlto,"\n");
   
  }
//+------------------------------------------------------------------+
