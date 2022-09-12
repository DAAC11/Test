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
bool PBloqueadoInicial = true;
bool FGridCentral = true; //Bandera Grid Central
bool DrawGrids = true;
string Objetos[];
double GridLevels[];
double GridCentral = 0;
double PriceAVG = 0;
int GridLevel = -1;
int GridLevelVar = -1;
bool OpenNewGrids = false;


double GridMax = 0;
double GridMin = 0;
double PrecioBloqueado = -1;
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
      OpenNewGrids = true;
     }
//Entrada inicial y Grid Central
   if(FGridCentral)
     {
      GridCentral = LastOPOpenPrice();
      FGridCentral = false;
     }
//Alimentador de Arrays Levels y Objects
   if(DrawGrids)
     {
      ArrayGrids(Grids, Puntos, GridCentral, GridLevels);
      ObjCreateGrids(GridCentral, GridLevels, Objetos);
      DrawGrids = false;
     }
//Pintar Grid Bloqueado
   if(PBloqueadoInicial)
     {
      PrecioBloqueado = LastOPOpenPrice();
      PBloqueadoInicial = false;
      ObjCreateLine(PrecioBloqueado, "GridBloqueado", clrDarkOrange);
     }
//Grid Maximo y minimo
   if(GridMax == 0)
     {
      GridMax = GridLevels[ArrayMaximum(GridLevels)];
      GridMin = GridLevels[ArrayMinimum(GridLevels)];
     }
//Abrir nuevas OPs
   if(OpenNewGrids)
     {
      int index = ArrayBsearch(GridLevels, PrecioBloqueado);
      ///Superior
      Buy_STP(Lotes, GridLevels[index + 1], GridLevels[index + 2], GridMin, GridLevels[index + 1]);
      Sell_STP(Lotes, GridLevels[index], GridLevels[index - 1], GridMax, GridLevels[index + 1]);
      ///Inferior
      Buy_LMT(Lotes, GridLevels[index - 1], GridLevels[index], GridMin, GridLevels[index - 1]);
      Sell_STP(Lotes, GridLevels[index - 1], GridLevels[index - 2], GridMax, GridLevels[index - 1]);
      OpenNewGrids = false;
     }
//Cambiar Precio Bloqueado y cerrar Open espera
   if(StrToDouble(LastOPOpenComment())!=PrecioBloqueado)
     {
      LiquidadorPendientes();
      PrecioBloqueado=LastOPOpenComment();
      PBloqueadoInicial=true;
      OpenNewGrids = false;
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
           "Pos: ", GridLevel, ENTER,
           "Grid Bloqueado: ", PrecioBloqueado, ENTER,
           /* "Max ", Max, ENTER,
            "Min ", Min, ENTER,*/
           OrdenesAbiertas(),
           OrdenesCerradas());
  }
//+------------------------------------------------------------------+
