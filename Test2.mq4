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
input int POS= 15;
input double MaxFlotante = 20;
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
   
   //Abre primeras entradas
   if(inicio <1)
     {
      Buy(0.01,TGR,STP);
      Sell(0.01,TGR,STP);
      inicio++;
     }
   if(OrdersTotal()<=POS && LastType()=="OP_BUY")
     {
      Sell(0.01,TGR,STP);
     }
    if(OrdersTotal()<=POS && LastType()=="OP_SELL")
     {
      Buy(0.01,TGR,STP);
     }
   
    
   double Balance = AccountBalance();
   double Equity = AccountEquity()-Balance;
   int OpenPositions = OrdersTotal();
   string ENTER= "\n";
  
   
   Comment("Balance: ",Balance,ENTER,
           "Equity: ",Equity,ENTER,
           "Open Positions: ",OpenPositions,ENTER,
           "Variable de control: ",inicio,ENTER,
           "Ordenes abiertas Buy: ",OpenBuys(),ENTER,
           "Ordenes abiertas Sell: ",OpenSells(),ENTER,
           "Ultimo tipo de orden abiertas : ",LastType()," ",LastTicket(),ENTER,
           OrdenesAbiertas(),OrdenesCerradas());   
  }
//+------------------------------------------------------------------+
