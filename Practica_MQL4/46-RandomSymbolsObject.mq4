//+------------------------------------------------------------------+
//|                                       46-RandomSymbolsObject.mq4 |
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
   double Ask = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_ASK),Digits());
   double Bid = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_BID),Digits());
   
   double mediumPrice = (Ask-Bid)/2;
   
   MathSrand(GetTickCount());
   long idC=ChartID();
   double randomSymbol = MathRand()%100;
   
   ObjectCreate(0,"MyObject",OBJ_ARROW,0,TimeCurrent(),mediumPrice);
   
   ObjectSetInteger(0,"MyObject",OBJPROP_ARROWCODE,randomSymbol);
   
   ObjectSetInteger(0,"MyObject",OBJPROP_WIDTH,10);
   
   ObjectMove(0,"MyObject",0,TimeCurrent(),Bid);
   
   
   Comment("Ask = ",Ask,"\n",
           "Bid = ",Bid,"\n",
           "Medium = ",mediumPrice);
  }
//+------------------------------------------------------------------+
