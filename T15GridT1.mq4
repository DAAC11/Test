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

input double Lotes=0.01;
input int TGR =400;
input int STP =200;
input int Grids =20;// Numero de Grids
input int TGrids = 50;//Distancia entre Grids
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
double PrecioInicial=0;
double GridsA[];
double GridsB[];
string ObjetosCerados[];
int GridArrayPrint =0;
double GridBloqueado =0;
double GridBloqueadoD =0;
double PrecioInicialD =0;
int GridPosA =0;
int GridPosB =0;
int GridActual =GridPosA+GridPosB;
int Contador=0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//Slado inicial
   if(Flag)
     {
      SaldoInicial=AccountBalance();

      //entrada inicial
      if(OrdersTotal()==0)
        {
         Buy(Lotes,TGrids,TGrids*10);
         Sell(Lotes,TGrids,TGrids*10);
        }

      Flag=false;
     }


//Precio inicial
   if(PrecioInicial==0)
     {
      if(OrderSelect(LastTicketOpen(),SELECT_BY_TICKET))
        {
         PrecioInicial= OrderOpenPrice();
         GridBloqueado=PrecioInicial;
        }
     }

//Control de Grids

   if(GridArrayPrint ==0)
     {
     ObjCreateGrids(PrecioInicial,Grids,TGrids,GridsA,GridsB,ObjetosCerados);
     
   
      GridArrayPrint=1;
      Contador++;

     }


//Entradas


//Dibujar Grid Bloqueado

   if(GridBloqueado!=0)
     {
      if(GridBloqueadoD!=GridBloqueado)
        {
         ObjCreateLine(GridBloqueado,"Grid Bloqueado",clrViolet);
        }
     }
//Dibujar Grid Inicial

   if(PrecioInicial!=0)
     {
      if(PrecioInicialD!=PrecioInicial)
        {
         ObjCreateLine(PrecioInicial,"PrecioInicial",clrAqua);
        }
     }
//Informacion en pantalla
   Comment("Ordenes Abiertas: ", OrdersTotal(),ENTER,
           "Ultima Ordern: ",LastTypeClose(),ENTER,
           "Ultimo Resultado: ",LastOPProfitClose(),ENTER,
           "Ultimo ticket : ",LastTicketOpen(),ENTER,
           "Saldo Inicial: ",SaldoInicial,ENTER,
           "Balance: ",AccountBalance(),ENTER,
           "Flotante: ",Flotante(),ENTER,
           "Precio inial: ",PrecioInicial,ENTER,
           "Array A: ",PrintArray(GridsA),ENTER,
           "Array B: ",PrintArray(GridsB),ENTER,
           "Objetos: ",PrintArray(ObjetosCerados),ENTER,
           "Grid Actual ",GridActual,ENTER,
           "GridA ",GridPosA,ENTER,
           "GridB ",GridPosB,ENTER,
           "Contador ",Contador,ENTER,

           OrdenesAbiertas(),
           OrdenesCerradas());
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
