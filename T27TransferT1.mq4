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

double OpenLevel = 0;
double SupLevel = 0;
double InfLevel = 0;
int BuyOrder = 0;
int SellOrder = 0;
int Test1 = 0;
int Test2 = 0;
string Etapa = "";
int Ciclos = 0; //+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+




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
      //ObjectsDeleteAll();
      BuyOrder = Buy(Lotes, Puntos * 3, Puntos * 10);
      SellOrder = Sell(Lotes, Puntos * 3, Puntos * 10);
      //Nivel maximo y minimo
      SupLevel = InfoByTicket(SellOrder, "OrderStopLoss");
      InfLevel = InfoByTicket(BuyOrder, "OrderStopLoss");
      Ciclos++;
     }
   if(OrdersTotal() == 2)
     {
      OpenLevel = LastOPOpenPriceBS();
      ObjCreateLine(OpenLevel, "OpenLevel", clrAqua);
     }
//Salida, Reapertura y BE BUY
   if(InfoByTicket(BuyOrder, "OrderProfit") > 1.5)
     {
      if(OrderSelect(BuyOrder, SELECT_BY_TICKET))
        {
         OrderClose(BuyOrder, OrderLots(), Bid, 3, clrLightGreen);
        }
      TRSTP(SellOrder, 75);
      if(OrdersTotal() == 1)
        {
         BuyOrder =  BuyAtPrice(Lotes, SupLevel, InfLevel, " ");
        }
     }
//Salida, Reapertura y BE Sell
   if(InfoByTicket(SellOrder, "OrderProfit") > 1.5)
     {
      if(OrderSelect(SellOrder, SELECT_BY_TICKET))
        {
         OrderClose(SellOrder, OrderLots(), Ask, 3, clrLightGreen);
        }
      TRSTP(BuyOrder, 75);
      if(OrdersTotal() == 1)
        {
         SellOrder = SellAtPrice(Lotes, InfLevel, SupLevel,  " ");
        }
     }
//Por si se queda una orden sola
   if(OrdersTotal() == 1)
     {
      if(TypeOpByTicket(LastTicketOpen()) == OP_BUY)
        {
         SellOrder = SellAtPrice(Lotes, InfLevel, SupLevel,  " ");
         TRSTP(BuyOrder, 50);
        }
      else
         if(TypeOpByTicket(LastTicketOpen()) == OP_SELL)
           {
            BuyOrder =  BuyAtPrice(Lotes, SupLevel, InfLevel, " ");
            TRSTP(SellOrder, 75);
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
      "Buy Test: ", Test1, ENTER,
      "Sell Test: ", Test2, ENTER,
      OrdenesAbiertas(2),
      OrdenesCerradasSinPendientes(2));
  }
//+------------------------------------------------------------------+
/*Apuntes
   +Los siguientes codigos buscaran limitar la cantidad de ordenes
    que se pueden tomar
   +Paso a un nuevo archivo para respaldar el codigo


    */
