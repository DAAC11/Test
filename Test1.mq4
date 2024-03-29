//+------------------------------------------------------------------+
//|                                                     ElBotija.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Experts\\david1.mq4"
input int TGR = 100;
input int STP = 1000;
input int positions = 5;
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
   if(OrdersTotal()<=positions)
     {
      Buy(0.01,TGR,STP);
      Sell(0.01,TGR*2,STP);
      Buy(0.01,TGR*3,STP);
      Sell(0.01,TGR*4,STP);
     }
    
   double Balance = AccountBalance();
   double Equity = AccountEquity()-Balance;
   int OpenPositions = OrdersTotal();
   string ENTER= "\n";
   
   Comment("Balance: ",Balance,ENTER,"Equity: ",Equity,ENTER,"Open Positions: ",OpenPositions);
  }
//+------------------------------------------------------------------+
