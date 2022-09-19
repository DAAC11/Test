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
bool CancelInicial = true;
bool FGridCentral = true; //Bandera Grid Central
bool DrawGrids = true;
string Objetos[];
double GridLevels[];
double GridCentral = 0;
double PriceAVG = 0;
int GridLevel = -1;
int GridLevelVar = -1;
int Ciclos = 0;
bool OpenNewGridsBuy = false;
bool OpenNewGridsSell = false;
int Test = 0;
int OrdenesSinEjecutar = 0;

double GridMax = 0;
double GridMin = 0;
double PrecioBloqueado = -1;
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//Alimentador de variable de consulta
   OrdenesSinEjecutar = ContadorDePendientes();
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
      Ciclos ++;
      OpenNewGridsBuy = true;
      OpenNewGridsSell = true;
     }
   /*if(OrdersTotal()==0&&GridMax!=0)
     {
      BuyAtPrice(Lotes, Puntos, Puntos * Grids);
      SellAtPrice(Lotes, Puntos, Puntos * Grids);
     }*/
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
   PrecioBloqueado = LastOPOpenPrice();
   if(PBloqueadoInicial)
     {
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
   if(OpenNewGridsBuy)
     {
      int index = ArrayBsearch(GridLevels, PrecioBloqueado);
      Buy_STP(Lotes, GridLevels[index + 1], GridLevels[index + 2], GridMin, GridLevels[index + 1]);
      Buy_LMT(Lotes, GridLevels[index - 1], GridLevels[index], GridMin, GridLevels[index - 1]);
      OpenNewGridsBuy = false;
     }
   if(OpenNewGridsSell)
     {
      int index = ArrayBsearch(GridLevels, PrecioBloqueado);
      Sell_LMT(Lotes, GridLevels[index + 1], GridLevels[index ], GridMax, GridLevels[index ]);
      Sell_STP(Lotes, GridLevels[index - 1], GridLevels[index - 2], GridMax, GridLevels[index - 1]);
      OpenNewGridsSell = false;
     }
//Cambiar nuevo precio bloqueado
   if(LastOPOpenPriceBS() != PrecioBloqueado && CancelInicial)
     {
      PrecioBloqueado = LastOPOpenPriceBS();
      ObjCreateLine(PrecioBloqueado, "GridBloqueado", clrDarkOrange);
      CancelInicial = false;
     }
   if(LastOPOpenPriceBS() != PrecioBloqueado)
     {
      PrecioBloqueado = LastOPOpenPriceBS();
      ObjCreateLine(PrecioBloqueado, "GridBloqueado", clrDarkOrange);
      CancelInicial = false;
     }
//Cancelar Ordenes Pendientes
   if(OrdenesSinEjecutar ==3||OrdenesSinEjecutar ==2)
     {
      LiquidadorPendientes();
      OpenNewGridsBuy = true;
      OpenNewGridsSell = true;
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
           "Last Op Price: ", LastOPOpenPrice(), ENTER,
           "Comprobacion: ", Test, ENTER,
           "Ordernes Pendientes: ", OrdenesSinEjecutar, ENTER,
           /* "Max ", Max, ENTER,
            "Min ", Min, ENTER,*/
           OrdenesAbiertas(),
           OrdenesCerradasSinPendientes());
  }
//+------------------------------------------------------------------+
