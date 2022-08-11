//+------------------------------------------------------------------+
//|                                               44-SMAMultiple.mq4 |
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
   double myAsk = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_ASK),Digits());
   
   double AskAUDUSD = NormalizeDouble(SymbolInfoDouble("AUDUSD",SYMBOL_ASK),Digits());
   
   double myMA = iMA(Symbol(),PERIOD_M1,20,0,MODE_SMA,PRICE_CLOSE,0);
   double AUDUSDMA = iMA("AUDUSD",PERIOD_M1,20,0,MODE_SMA,PRICE_CLOSE,0);
    
   Comment("Ask = ", myAsk,"\n",
           "AUDUSD Ask = ", AskAUDUSD,"\n",
           "MA = ", myMA,"\n",
           "AUDUSD MA = ", AUDUSDMA,"\n");
   
   
  }
//+------------------------------------------------------------------+
