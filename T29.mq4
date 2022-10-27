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
int Compras[];
int Ventas[];
int Control = 0;
double Order1 = 0;
double Order2 = 0;
double Max =0;
double Min=0;
int Test1 = 0;
int Test2 = 0;
int Ciclos = 0;
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
      AddArray(Compras, Buy(0.01, Puntos * 2, Puntos * 2));
      AddArray(Ventas, Sell(0.01, Puntos * 2, Puntos * 2));
      Ciclos++;
     }
//Max Min
   Max = InfoByTicket(Compras[ArraySize(Compras) - 1],"OrderTakeProfit");
   Min = InfoByTicket(Ventas[ArraySize(Ventas) - 1],"OrderTakeProfit");
//Apertura
   if(InfoByTicket(Compras[ArraySize(Compras) - 1], "OrderProfit") > 1)
     {
      AddArray(Compras, BuyAtPrice(0.02, Max,Min,""));
      Control = BE(Compras[ArraySize(Compras) - 2], 25);
     }
   if(InfoByTicket(Ventas[ArraySize(Ventas) - 1], "OrderProfit") > 1)
     {
      AddArray(Ventas, SellAtPrice(0.02, Min, Max,""));
      Control = BE(Ventas[ArraySize(Ventas) - 2], 25);
     }
//Terminar Cobertura
   if(IsClose(Control))
     {
      if(LastTypeClose()==OP_BUY)
        {
         AddArray(Ventas, Sell(0.01, Puntos * 1, Puntos * 1));
        }
      if(LastTypeClose()==OP_SELL)
        {
         AddArray(Compras, Buy(0.01, Puntos * 1, Puntos * 1));
        }
     }
//Informacion en pantalla
   Comment(
      "Ordenes Abiertas: ", OrdersTotal(), ENTER,
      "Ultima Orden: ", LastTypeClose(), ENTER,
      "Saldo Inicial: ", SaldoInicial, ENTER,
      "Balance: ", AccountBalance(), ENTER,
      "Flotante: ", Flotante(), ENTER,
      "Ciclos: ", Ciclos, ENTER,
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
