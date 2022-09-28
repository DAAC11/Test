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
bool HedgeBuy = false;
bool HedgeSell = false;

int Ciclos = 0;
int InitialHedgeTicket = 0;
int LastTicketHedge = 0;
int MLots = 0;
int HedgeArray[];
int ArrayOrderClosed[];

double LevelBuy = -1;
double LevelSell = -1;
double LastOPOrderPrice = 0;

string Objetos[2];
int Test = 0;
void OnTick()
  {
//Balance inicial
   if(Flag)
     {
      SaldoInicial = AccountBalance();
      Flag = false;
     }
//Permiso para entrar si hay 0 ordenes
   if(OrdersTotal() == 0)
     {
      NuevoCiclo = true;
     }
//Entrada inicial
   if(OrdersTotal() == 0 && NuevoCiclo)
     {
      ObjDelete(Objetos);
      Ciclos++;
      LevelsBS = true;
      NuevoCiclo = false;
      if(MathRand() % 2 == 0)
        {
         InitialHedgeTicket = Buy(Lotes, Puntos, Puntos * 5);
         HedgeSell = true;
         MLots++;
        }
      else
        {
         InitialHedgeTicket = Sell(Lotes, Puntos, Puntos * 5);
         HedgeBuy = true;
         MLots++;
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
      LastTicketHedge = Sell_STP(LastOPOpenLots() * 2,
                                 LastOPOpenPrice() - (Puntos * Point),
                                 LastOPOpenPrice() - ((Puntos * Point) * 2),
                                 LastOPOpenPrice() + ((Puntos * Point) * 5),
                                 LastOPOpenPrice() - (Puntos * Point));
      HedgeSell = false;
      LevelsBS2 = true;
      //Linea de venta
      if(LevelsBS2)
        {
         LevelsBS2 = false;
         ObjCreateLine(LastOPOpenPrice(), "SellLine", clrRed);
         Objetos[1] = "SellLine";
        }
     }
   if(HedgeBuy)
     {
      LastTicketHedge = Buy_STP(LastOPOpenLots() * 2,
                                LastOPOpenPrice() + (Puntos * Point),
                                LastOPOpenPrice() + ((Puntos * Point) * 2),
                                LastOPOpenPrice() - ((Puntos * Point) * 5),
                                LastOPOpenPrice() + (Puntos * Point));
      HedgeBuy = false;
      LevelsBS2 = true;
      //Linea de compra
      if(LevelsBS2)
        {
         LevelsBS2 = false;
         ObjCreateLine(LastOPOpenPrice(), "BuyLine", clrGreen);
         Objetos[1] = "BuyLine";
        }
     }
//Autorizar Ordende cobertura nueva
   if(IsOpen(LastTicketHedge))
     {
      if(LastTypeOpen() == "OP_BUY")
        {
         HedgeSell = true;
        }
      if(LastTypeOpen() == "OP_SELL")
        {
         HedgeBuy = true;
        }
     }
//Cerrar Ordenes pendientes
   if(OrdersTotal() == ContadorDePendientes())
     {
      LiquidadorPendientes();
     }
//Determinar si La orden inical esta cerrada
   if(IsClose(InitialHedgeTicket)
      || IsClose(LastTicketHedge)
      )
     {
      Liquidador();
      NuevoCiclo = true;
      ArrayFree(HedgeArray);
     }
//Llenar array de ordenes cerradas
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
           "Ticket inicial: ", InitialHedgeTicket, " ", IsClose(InitialHedgeTicket), ENTER,
           "Last Ticket Hedge: ", LastTicketHedge, ENTER,
           "Last Ticket Hedge Open?: ", IsOpen(LastTicketHedge), ENTER,
           "Lineas : ", PrintArray(Objetos), ENTER,
           "Ciclos : ", Ciclos, ENTER,
           "Ultimas 10 cerradas: ", PrintArray(ArrayOrderClosed), ENTER,
           "Ultimas 10 cerradas: ", PrintArray(HedgeArray), ENTER,
          
           OrdenesAbiertas(2),
           OrdenesCerradasSinPendientes(2));
  }
//+------------------------------------------------------------------+
/*Comenzar con un nuevo codigo que:
   +Alimente una Array de compras
      -y esta array se resuma con una funcion
       que traiga ticket, profit y lotes
       y una sumas de lotes y profit 
   +Alimente una Array de Ventas
      -y esta array se resuma con una funcion
       que traiga ticket, profit y lotes
       y una sumas de lotes y profit */