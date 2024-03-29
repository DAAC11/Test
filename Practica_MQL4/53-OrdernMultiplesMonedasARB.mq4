//+------------------------------------------------------------------+
//|                                 53-OrdernMultiplesMonedasARB.mq4 |
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
   double Ask = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_ASK),Digits());//Digits importante
   double USDCADAsk = NormalizeDouble(SymbolInfoDouble("USDCAD",SYMBOL_ASK),Digits());
   double GBPUSDAsk = NormalizeDouble(SymbolInfoDouble("GBPUSD",SYMBOL_ASK),Digits());

   double Bid = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_BID),Digits());//Digits importante
   double USDCADBid = NormalizeDouble(SymbolInfoDouble("USDCAD",SYMBOL_BID),Digits());
   double GBPUSDBid = NormalizeDouble(SymbolInfoDouble("GBPUSD",SYMBOL_BID),Digits());

   string signal = "";

   MathSrand(GetTickCount());

   double ramdom = MathRand()%2;

   if(ramdom==0)
     {
      signal="buy";
     }

   if(ramdom==1)
     { 
      signal="sell";
     }

   if(signal == "buy"&& OrdersTotal()==0)
     {
      Buy(0.05,200,100);
      OrderSend("USDCAD",OP_BUY,0.01,USDCADAsk,3,USDCADAsk-(100*Point),USDCADAsk+(1000*Point),NULL,3,0,clrGreen);
      OrderSend("GBPUSD",OP_BUY,0.01,GBPUSDAsk,3,GBPUSDAsk-(100*Point),GBPUSDAsk+(1000*Point),NULL,3,0,clrGreen);
     }

   if(signal == "sell"&& OrdersTotal()==0)
     {
      Sell(0.05,200,100);
      OrderSend("USDCAD",OP_SELL,0.01,USDCADBid,3,USDCADBid+(100*Point),USDCADBid-(1000*Point),NULL,3,0,clrGreen);
      OrderSend("GBPUSD",OP_SELL,0.01,GBPUSDBid,3,GBPUSDBid+(100*Point),GBPUSDBid-(1000*Point),NULL,3,0,clrGreen);
     }

   Comment(
      "Señal = ", signal, "\n",
      "Par = ", Symbol()
   );
  }

