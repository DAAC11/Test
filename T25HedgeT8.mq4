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
bool HedgeBuys = false;
bool HedgeSells = false;
bool Liquidar = false;
double OpenLevel = 0;
double ExitLevel = 0;
int ControlTicket = 0;
double SupLevel = 0;
double InfLevel = 0;
int ArrayBuys[];
int ArraySells[];
int MaxOrders = 0;

int Test1 = 0;
int Test2 = 0;
string Etapa = "";



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
      ObjectsDeleteAll();
      ArrayFree(ArrayBuys);
      ArrayFree(ArraySells);
      ExitLevel = 0;
      Etapa = "Etapa1";
      MaxOrders = 3;
      AddArray(ArrayBuys, Buy(Lotes, Puntos * 3, Puntos * 3));
      AddArray(ArraySells, Sell(Lotes, Puntos * 3, Puntos * 3));
      //Nivel maximo y minimo
      SupLevel = InfoByTicket(ArrayBuys[ArraySize(ArrayBuys) - 1], "OrderTakeProfit");
      InfLevel = InfoByTicket(ArraySells[ArraySize(ArraySells) - 1], "OrderTakeProfit");
     }
   if(OrdersTotal() == 2)
     {
      OpenLevel = LastOPOpenPriceBS();
      ObjCreateLine(OpenLevel, "OpenLevel", clrAqua);
     }
//Orden de Refuerzo Buys
   if(InfoByTicket(ArrayBuys[ArraySize(ArrayBuys) - 1], "OrderProfit") > 1)
     {
      HedgeBuys = true;
     }
   if(HedgeBuys)
     {
      AddArray(ArrayBuys, BuyAtPrice(Lotes, SupLevel, InfLevel, "AddBuy"));
      Test1++;
      ControlTicket = ArrayBuys[ArraySize(ArrayBuys) - 1];
      //Exit level control
      if(OrdersTotal() == 3)
        {
         ExitLevel = OpenLevel + (50 * Point);
        }
      else
        {
         ExitLevel += (1* Point);
        }
      //TRSTP
      for(int i = ArraySize(ArrayBuys) - 1; i >= 0; i--)
        {
         BEPrice(ArrayBuys[i], ExitLevel);
        }
      Liquidar = true;
      HedgeBuys = false;
     }
//Orden de Refuerzo Sells
   if(InfoByTicket(ArraySells[ArraySize(ArraySells) - 1], "OrderProfit") > 1)
     {
      HedgeSells = true;
     }
   if(HedgeSells)
     {
      AddArray(ArraySells, SellAtPrice(Lotes, InfLevel, SupLevel, "AddSell"));
      ControlTicket = ArraySells[ArraySize(ArraySells) - 1];
      Test2++;
      //Exit level control
      if(OrdersTotal() == 3)
        {
         ExitLevel = OpenLevel - (50 * Point);
        }
      else
        {
         ExitLevel -= (1 * Point);
        }
      //TRSTP
      for(int i = ArraySize(ArraySells) - 1; i >= 0; i--)
        {
         BEPrice(ArraySells[i], ExitLevel);
        }
      Liquidar = true;
      HedgeSells = false;
     }
//Liquidador
   if(Liquidar && IsClose(ControlTicket))
     {
      Liquidar = false;
      Liquidador();
     }
//Linea de salida
   if(ExitLevel != 0)
     {
      if(ExitLevel > OpenLevel)
        {
         ObjCreateLine(ExitLevel, "BuyExit", clrBlue);
        }
      if(ExitLevel < OpenLevel)
        {
         ObjCreateLine(ExitLevel, "SellExit", clrBlue);
        }
     }
//Informacion en pantalla
   Comment(
      "Ordenes Abiertas: ", OrdersTotal(), ENTER,
      "Ultima Orden: ", LastTypeClose(), ENTER,
      "Saldo Inicial: ", SaldoInicial, ENTER,
      "Balance: ", AccountBalance(), ENTER,
      "Flotante: ", Flotante(), ENTER,
      "Etapa: ", Etapa, ENTER,
      "Buy Tickets: ", PrintArray(ArrayBuys), ENTER,
      "Sell Tickets: ", PrintArray(ArraySells), ENTER,
      "Buy Test: ", Test1, ENTER,
      "Sell Test: ", Test2, ENTER,
      "Last Buy: ", ArrayBuys[ArraySize(ArrayBuys) - 1], ENTER,
      "Last Sell: ", ArraySells[ArraySize(ArraySells) - 1], ENTER,
      OrdenesAbiertas(2),
      OrdenesCerradasSinPendientes(2));
  }
//+------------------------------------------------------------------+
/*Apuntes
   +Los siguientes codigos buscaran limitar la cantidad de ordenes
    que se pueden tomar
   +Paso a un nuevo archivo para respaldar el codigo


    */
