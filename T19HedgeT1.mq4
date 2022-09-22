//+------------------------------------------------------------------+
//|                                                   T19HedgeT1.mq4 |
//|                                                            David |
//|                                             https://www.mql5.com |
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
input int Puntos = 100;//Distancia entre Grids

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
bool LevelsBS = true; //Niveles de apertura
bool HedgeBuy = false;
bool HedgeSell = false;

double LevelBuy = -1;
double LevelSell = -1;
double LastOPOrderPrice = 0;

string Objetos[1];
int Test = 0;
void OnTick()
  {
//Balance inicial
   if(Flag)
     {
      SaldoInicial = AccountBalance();
      Flag = false;
     }
//Entrada inicial
   if(OrdersTotal() == 0)
     {
      ObjDelete(Objetos);
      LevelsBS = true;
      if(MathRand() % 2 == 0)
        {
         Buy(Lotes, Puntos, Puntos * 2);
         HedgeSell = true;
        }
      else
        {
         Sell(Lotes, Puntos, Puntos * 2);
         HedgeBuy = true;
        }
     }
//Pintar Lineas de compra y venta inicial
   LastOPOrderPrice = LastOPOpenPrice();
   if(LevelsBS)
     {
      if(LastTypeOpen() == "OP_BUY")
        {
         Test++;
         LevelsBS = false;
         ObjCreateLine(LastOPOrderPrice, "BuyLine", clrGreen);
         Objetos[0] = "BuyLine";
        }
      if(LastTypeOpen() == "OP_SELL")
        {
         Test++;
         LevelsBS = false;
         ObjCreateLine(LastOPOrderPrice, "SellLine", clrRed);
         Objetos[0] = "SellLine";
        }
     }
//Orden de cobertura
   if(HedgeSell)
     {
      Sell_STP(LastOPOpenLots() * 2, LastOPOpenPrice() - (Puntos * Point),
               LastOPOpenPrice() - ((Puntos * Point) * 2),
               LastOPOpenPrice() + ((Puntos * Point) * 5), LastOPOpenPrice() - (Puntos * Point));
      HedgeSell = false;
      HedgeBuy = true;
     }
   if(HedgeBuy)
     {
      Buy_STP(LastOPOpenLots() * 2, LastOPOpenPrice() + (Puntos * Point),
              LastOPOpenPrice() + ((Puntos * Point) * 2),
              LastOPOpenPrice() - ((Puntos * Point) * 5), LastOPOpenPrice() + (Puntos * Point));
      HedgeBuy = false;
      HedgeSell = true;
     }
//Cerrar Ordenes pendientes
if(OrdersTotal()==ContadorDePendientes())
  {
   LiquidadorPendientes();
  }
//Informacion en pantalla
   Comment("Ordenes Abiertas: ", OrdersTotal(), ENTER,
           "Ultima Ordern: ", LastTypeClose(), ENTER,
           "Ultima Ordern Abierta: ", LastTypeOpen(), ENTER,
           "Ultimo Resultado: ", LastOPProfitClose(), ENTER,
           "Ultimo ticket : ", LastTicketOpen(), ENTER,
           "Saldo Inicial: ", SaldoInicial, ENTER,
           "Balance: ", AccountBalance(), ENTER,
           "Flotante: ", Flotante(), ENTER,
           "Last Op Price: ", LastOPOpenPrice(), ENTER,
           "Ordenes abiertas: ", ContadorBS(), ENTER,
           "Ordenes pendientes: ", ContadorDePendientes(), ENTER,
           "Test: ", Test, ENTER,
           OrdenesAbiertas(),
           OrdenesCerradasSinPendientes());
  }
//+------------------------------------------------------------------+
