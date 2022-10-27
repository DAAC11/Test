//+------------------------------------------------------------------+
//|                                                   T19HedgeT1.mq4 |
//|                                                            David |//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "David"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
#include "..\\Experts\\OrdersExecution.mq4"
#include "..\\Experts\\OrdersInfo.mq4"
#include "..\\Experts\\CONSTANTS.mq4"
#include "..\\Experts\\ExFuntions.mq4"
#include "..\\Experts\\Hedge.mq4"
#include "..\\Experts\\Objects.mq4"

//+------------------------------------------------------------------+

input double Lotes = 0.01;
input int Puntos = 100;

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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
double SaldoInicial = 0;
bool Flag = true; //Bandera del saldo inicial
int ArrayOrders[];
int ArrayProfits[];

double Order1 = 0;
double Order2 = 0;
int Test1 = 0;
int Test2 = 0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//Balance inicial
   if(Flag)
     {
      SaldoInicial = AccountBalance();
      Flag = false;
     }
   if(OrdersTotal() == 0)
     {
      AddArray(ArrayOrders, Buy(0.01, Puntos * 10, Puntos * 10));
      AddArray(ArrayOrders, Sell(0.01, Puntos * 10, Puntos * 10));
     }
//Closer
   Order1 = ArrayOrders[ArraySize(ArrayOrders) - 1];
   Order2 = ArrayOrders[ArraySize(ArrayOrders) - 2];
   if(InfoByTicket(Order1, "OrderProfit") > 1)
     {
      Closer(Order1);
     }
   if(InfoByTicket(Order2, "OrderProfit") > 1)
     {
      Closer(Order2);
     }
//Apertura de nueva
   if(OrdersTotal() == 1)
     {
      if(TypeOpByTicket(LastTicketClose()) == OP_BUY)
        {
         AddArray(ArrayOrders, Buy(0.02, Puntos , Puntos));
        }
      else
         if(TypeOpByTicket(LastTicketClose()) == OP_SELL)
           {
            AddArray(ArrayOrders, Sell(0.02, Puntos , Puntos));
           }
     }
 
//Informacion en pantalla
   Comment(
      "Ordenes Abiertas: ", OrdersTotal(), ENTER,
      "Ultima Orden: ", LastTypeClose(), ENTER,
      "Saldo Inicial: ", SaldoInicial, ENTER,
      "Balance: ", AccountBalance(), ENTER,
      "Flotante: ", Flotante(), ENTER,
      "ArrayOrdersTicket: ", PrintArray(ArrayOrders), ENTER,
      "Buy Test: ", Test1, ENTER,
      "Sell Test: ", Test2, ENTER,
      "Last ticket Close: ", LastTicketClose(), ENTER,
      OrdenesAbiertas(2),
      OrdenesCerradasSinPendientes(2));
  }
//+------------------------------------------------------------------+
/*Apuntes
   +Los siguientes codigos buscaran limitar la cantidad de ordenes
    que se pueden tomar
   +Paso a un nuevo archivo para respaldar el codigo


    */
