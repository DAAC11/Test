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
#include "..\\Experts\\Objects.mq4"

input double Lotes = 0.01;
input int TGR = 400;
input int STP = 200;
input int Grids = 10; // Numero de Grids
input int TGrids = 100;//Distancia entre Grids
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
bool Flag = true;
int SaldoInicial;
double PrecioInicial = 0;
double GridsA[];
double GridsB[];
string ObjetosCerados[];
int GridArrayPrint = 0;
double GridBloqueado = 0;
double GridBloqueadoD = 0;
double PrecioInicialD = 0;
int GridPosA = 0;
int GridPosB = 0;
int GridActual = GridPosA + GridPosB;
int ContadorA = 0;
double Max = 0;
double Min = 0;
int Ordenes = 0;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//Slado inicial
   if(Flag)
     {
      SaldoInicial = AccountBalance();
      //entrada inicial
      if(OrdersTotal() == 0)
        {
         Buy(Lotes, TGrids, TGrids * 10);
         Sell(Lotes, TGrids, TGrids * 10);
         Ordenes++;
        }
      Flag = false;
     }
//Precio inicial
   if(PrecioInicial == 0)
     {
      if(OrderSelect(LastTicketOpen(), SELECT_BY_TICKET))
        {
         PrecioInicial = OrderOpenPrice();
         GridBloqueado = PrecioInicial;
        }
     }
//Control de Grids
   if(GridArrayPrint == 0)
     {
      ObjCreateGrids(PrecioInicial, Grids, TGrids, GridsA, GridsB, ObjetosCerados);
      GridArrayPrint = 1;
     }
//Maximos y minimos
   if(Max == 0)
     {
      Max = GridsA[ArrayMaximum(GridsA)];
      Min = 0;
      for(int i = ArraySize(GridsB) - 1; i > 0; i--)
        {
         if(GridsB[i] != 0)
           {
            if(i == ArraySize(GridsB) - 1)
              {
               Min = GridsB[i];
              }
            if(GridsB[i] < Min)
              {
               Min = GridsB[i];
              }
           }
        }
     }
//Entradas
   if(Ordenes % OrdersTotal() != 0)
     {
      Buy_LMT(Lotes, LastOPOpenPrice() + (TGrids * Point * 10), Min);
      Sell_LMT(Lotes, LastOPOpenPrice() - (TGrids * Point * 10), Max);
      Ordenes = OrdersTotal();
      Ordenes++;
      Sleep(2000);
     }
//Dibujar Grid Bloqueado
   if(GridBloqueado != 0)
     {
      if(GridBloqueadoD != GridBloqueado)
        {
         ObjCreateLine(GridBloqueado, "Grid Bloqueado", clrViolet);
        }
     }
//Dibujar Grid Inicial
   if(PrecioInicial != 0)
     {
      if(PrecioInicialD != PrecioInicial)
        {
         ObjCreateLine(PrecioInicial, "PrecioInicial", clrAqua);
        }
     }
//Informacion en pantalla
   Comment("Ordenes Abiertas: ", OrdersTotal(), ENTER,
           "Ultima Ordern: ", LastTypeClose(), ENTER,
           "Ultimo Resultado: ", LastOPProfitClose(), ENTER,
           "Ultimo ticket : ", LastTicketOpen(), ENTER,
           "Saldo Inicial: ", SaldoInicial, ENTER,
           "Balance: ", AccountBalance(), ENTER,
           "Flotante: ", Flotante(), ENTER,
           "Precio inial: ", PrecioInicial, ENTER,
           "Array A: ", PrintArray(GridsA), ENTER,
           "Array B: ", PrintArray(GridsB), ENTER,
           "Objetos: ", PrintArray(ObjetosCerados), ENTER,
           "Grid Actual ", GridActual, ENTER,
           "GridA ", GridPosA, ENTER,
           "GridB ", GridPosB, ENTER,
           "Contador ", ContadorA, ENTER,
           "Max ", Max, ENTER,
           "Min ", Min, ENTER,
           OrdenesAbiertas(),
           OrdenesCerradas());
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
