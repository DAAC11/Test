//+------------------------------------------------------------------+
//|                                                  FuntionTest.mq4 |
//|                                                            David |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "David"
#property link      ""
#property version   "1.00"
#property strict

#include "..\\Experts\\OrdersExecution.mq4"
#include "..\\Experts\\OrdersInfo.mq4"
#include "..\\Experts\\CONSTANTS.mq4"
#include "..\\Experts\\ExFuntions.mq4"
#include "..\\Experts\\Hedge.mq4"


input double Lotes=0.01;
input int TGR =200;
input int STP =200;
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
bool Flag= true;
int SaldoInicial;
bool Hedge = false;
int Contador =0;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//Slado inicial
   if(Flag)
     {
      SaldoInicial=AccountBalance();
      Flag=false;
     }

   if(OrdersTotal()==0)
     {
      if(OrdersHistoryTotal()%2!=0)
        {
         Sell(Lotes,TGR,STP);
        }
      else
        {
         Buy(Lotes,TGR,STP);
        }

     }

   if(LastOPProfitOpen()>1.5)
     {
      BE(LastTicketOpen(),50);
      Contador++;
     }

//Informacion en pantalla
   Comment("Ordenes Abiertas: ", OrdersTotal(),"/",OrdersHistoryTotal(),ENTER,
           "Ultima Ordern: ",LastTypeClose(),ENTER,
           "Ultimo Resultado: ",LastOPProfitClose(),ENTER,
           "Ultimo ticket : ",LastTicketOpen(),ENTER,
           "Saldo Inicial: ",SaldoInicial,ENTER,
           "Balance: ",AccountBalance(),ENTER,
           "Flotante: ",Flotante(),ENTER,
           "Contador: ",Contador,ENTER,



           OrdenesAbiertas(),
           OrdenesCerradas());
  }
//+------------------------------------------------------------------+
