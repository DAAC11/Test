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
bool NuevoCiclo = true;
bool LevelsBS2 = false;
bool Hedge = false;
int HedgeBuyTicket = 0;
int HedgeSellTicket = 0;
int HedgeBuyTicket2 = 0;
int HedgeSellTicket2 = 0;
double SupLevel = 0;
double InfLevel = 0;

string Etapa = "";

string Signal = "";
string Objetos[2];
string Recovery = "";
string Aviso = "";
int Test = 0;
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
      HedgeBuyTicket = 0;
      HedgeSellTicket = 0;
      Etapa = "Etapa1";
      HedgeBuyTicket = Buy(Lotes, Puntos * 2, Puntos * 2);
      HedgeSellTicket = Sell(Lotes, Puntos * 2, Puntos * 2);
      //Alimentar SupLevel
      SupLevel = InfoByTicket(HedgeBuyTicket, "OrderTakeProfit");
      InfLevel = InfoByTicket(HedgeBuyTicket, "OrderStopLoss");
     }
//Orden Contrairia1
   if(ProfitOpByTicket(HedgeBuyTicket) > 1 && OrdersTotal() == 2)
     {
      Etapa = "Etapa2Buy";
      BE(HedgeBuyTicket, 1);
      HedgeBuyTicket2 = BuyAtPrice(Lotes, SupLevel, InfLevel, "Etapa2Buy");
     }
   if(ProfitOpByTicket(HedgeSellTicket) > 1 && OrdersTotal() == 2)
     {
      Etapa = "Etapa2Sell";
      BE(HedgeSellTicket, 1);
      HedgeSellTicket2 = SellAtPrice(Lotes, InfLevel, SupLevel, "Etapa2Sell");
     }
//Orden Contrairia2
   if(ProfitOpByTicket(HedgeBuyTicket2) < -1 
      && OrdersTotal() == 2 )
     {
      BE(HedgeSellTicket, 1);
      Sell(Lotes, Puntos, Puntos * 2);
     }
   if(ProfitOpByTicket(HedgeSellTicket2) < -1
    && OrdersTotal() == 2 )
     {
      BE(HedgeBuyTicket, 1);
      Buy(Lotes, Puntos, Puntos * 2);
     }
//Informacion en pantalla
   Comment(
      "Ordenes Abiertas: ", OrdersTotal(), ENTER,
      "Ultima Orden: ", LastTypeClose(), ENTER,
      "Saldo Inicial: ", SaldoInicial, ENTER,
      "Balance: ", AccountBalance(), ENTER,
      "Flotante: ", Flotante(), ENTER,
      "Etapa: ", Etapa, ENTER,
      Recovery,
      OrdenesAbiertas(2),
      OrdenesCerradasSinPendientes(2));
  }
//+------------------------------------------------------------------+
/*Apuntes
   +Los siguientes codigos buscaran limitar la cantidad de ordenes
    que se pueden tomar
   +Paso a un nuevo archivo para respaldar el codigo


    */
