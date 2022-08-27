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
input int Grids =10;// Numero de Grids
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
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
bool Flag= true;
int SaldoInicial;
bool Hedge = false;
int Contador =0;
int Contador2 =0;


double PrecioInicial=0;
double GridsA[];
double GridsB[];
string Objetos[];
int GridArrayPrint =0;
double GridBloqueado =0;
double GridBloqueadoD =0;
double PrecioInicialD =0;
int GridPosA =0;
int GridPosB =0;
int GridActual =GridPosA+GridPosB;



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//Slado inicial
   if(Flag)
     {
      SaldoInicial=AccountBalance();
      Flag=false;
     }
   if(OrdersTotal()==0)
     {
      Buy(0.01,100,100);
     }
   if(PrecioInicial==0)
     {
      if(OrderSelect(LastTicketOpen(),SELECT_BY_TICKET))
        {
         PrecioInicial= OrderOpenPrice();
         GridBloqueado=PrecioInicial;
        }
     }


   if(GridArrayPrint==0)
     {
      ObjCreateGrids(PrecioInicial,Grids,Puntos,GridsA,GridsB,Objetos);

      GridArrayPrint++;
     }


//Informacion en pantalla
   Comment("Ordenes Abiertas: ", OrdersTotal(),"/",OrdersHistoryTotal(),ENTER,
           "Ultima Ordern: ",LastTypeClose(),ENTER,
           "Ultimo Resultado: ",LastOPProfitClose(),ENTER,
           "Ultimo ticket : ",LastTicketOpen(),ENTER,
           "Saldo Inicial: ",SaldoInicial,ENTER,
           "Balance: ",AccountBalance(),ENTER,
           "Flotante: ",Flotante(),ENTER,
           "Contador: ",Contador,ENTER,
           "GridsA: ",PrintArray(GridsA),ENTER,
           "GridsB: ",PrintArray(GridsB),ENTER,
           "Objetos: ",PrintArray(Objetos),ENTER,
           



           OrdenesAbiertas(),
           OrdenesCerradas());
  }
//+------------------------------------------------------------------+
