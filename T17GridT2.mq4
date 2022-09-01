//+------------------------------------------------------------------+
//|                                                    T17GridT2.mq4 |
//|                                                            David |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "David"
#property link      ""
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
input int Grids = 10; // Numero de Grids
input int Puntos = 200;//Distancia entre Grids
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
//|Variables de consulta
//+------------------------------------------------------------------+
double SaldoInicial = 0;
bool Flag = true; //Bandera del saldo inicial
bool DrawGrids = true;
string Objetos[];
double GridLevels[];
double GridCentral = 0;
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//Balance inicial
   if(Flag)
     {
      SaldoInicial = AccountBalance();
      Flag = false;
     }
//Entrada inicial y Grid Central
   if(OrdersTotal() == 0)
     {
      Buy(Lotes, Puntos, Puntos * Grids);
      Sell(Lotes, Puntos, Puntos * Grids);
      GridCentral = LastOPOpenPrice();
     }

//Alimentador de Arrays Levels y Objects
   if(DrawGrids)
     {
      ArrayGrids(Grids, Puntos, GridCentral, GridLevels);
      ObjCreateGrids(GridCentral,GridLevels, Objetos);
      DrawGrids = false;
     }
//Informacion en pantalla
   Comment("Ordenes Abiertas: ", OrdersTotal(), ENTER,
           "Ultima Ordern: ", LastTypeClose(), ENTER,
           "Ultimo Resultado: ", LastOPProfitClose(), ENTER,
           "Ultimo ticket : ", LastTicketOpen(), ENTER,
           "Saldo Inicial: ", SaldoInicial, ENTER,
           "Balance: ", AccountBalance(), ENTER,
           "Flotante: ", Flotante(), ENTER,
           "Grid Central: ", GridCentral, ENTER,
           "Grids levels: /", PrintArray(GridLevels), ENTER,
           "Objetos: ", PrintArray(Objetos), ENTER,
           /* "Max ", Max, ENTER,
            "Min ", Min, ENTER,*/
           OrdenesAbiertas(),
           OrdenesCerradas());
  }
//+------------------------------------------------------------------+
