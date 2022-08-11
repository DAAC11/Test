//+------------------------------------------------------------------+
//|                                                  28-RandomEA.mq4 |
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
extern int Masstest = 1; 
string ultima ="";
void OnTick()
  {
   string signal = "";
   MathSrand(GetTickCount()); // iniciador de los numeros aleatorios
   
   // %2 le indica a la funcion que debe arrojar 2 valores 0 o 1
   double ramNumber = MathRand()%2;
   
   if(ramNumber==0)signal="buy";
   if(ramNumber==1)signal="sell";  
   
   if(signal=="buy"&&OrdersTotal()==0)
     {
      OrderSend(NULL,OP_BUY,0.01,Ask,3,0,Ask+(150*Point),NULL,3,0,clrGreen);
      ultima = "compra";
     }
   
   
   if(signal=="sell"&&OrdersTotal()==0)
     {
      OrderSend(NULL,OP_SELL,0.01,Bid,3,0,Bid-(150*Point),NULL,3,0,clrRed);
      ultima = "venta";
     }
   
 

  
     
   //
   Comment("Flotante= ",AccountProfit(),
           "\n numero aleatorio", ramNumber,
           "\nCuenta Balance  ", AccountBalance(),
           "\nCuenta Equity  ", AccountEquity(),
           "\nCuenta Diff  ", AccountEquity()-AccountBalance()
           );
  }
//+------------------------------------------------------------------+
