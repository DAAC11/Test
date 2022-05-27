//+------------------------------------------------------------------+
//|                                                        Test2.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\GitHub\\david1.mq4"
input int TGR = 200;
input int STP = 1000;
input int POS= 2;
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

int inicio=0;
void OnTick()
  {
   
   
   if(OrdersTotal()<=20 /*&& inicio <10*/)
     {
      Buy(0.01,TGR,STP);
      Sell(0.01,TGR,STP);
      inicio++;
     }
   
    
   double Balance = AccountBalance();
   double Equity = AccountEquity()-Balance;
   int OpenPositions = OrdersTotal();
   string ENTER= "\n";
   
   Comment("Balance: ",Balance,ENTER,
           "Equity: ",Equity,ENTER,
           "Open Positions: ",OpenPositions,ENTER,
           "Variable de control: ",inicio,ENTER,
           OrdenesAbiertas(),OrdenesCerradas());   
  }
//+------------------------------------------------------------------+
