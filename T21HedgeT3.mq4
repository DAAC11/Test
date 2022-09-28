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
bool HedgeBuy = false;
bool HedgeSell = false;

int Ciclos = 0;
int InitialHedgeTicket = 0;
int LastTicketHedge = 0;
int MLots = 0;
int OpenOrdersArray[];
int HedgeOrdersArray[];

double BuyLevel = 0;
double SellLevel = 0;
double LastOPOrderPrice = 0;

string Signal = "";
string Objetos[2];
string Recovery = "";
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
   if(OrdersTotal() == 0 || OrdersTotal() == ContadorDePendientes())
     {
      LiquidadorPendientes();
      NuevoCiclo = true;
      ArrayFree(HedgeOrdersArray);
     }
//Señal de entrada
   double Ma15a = iMA(NULL, 0, 15, 0, MODE_SMA, PRICE_CLOSE, 1);
   double Ma15d = iMA(NULL, 0, 15, 0, MODE_SMA, PRICE_CLOSE, 0);
   double Ma50a = iMA(NULL, 0, 50, 0, MODE_SMA, PRICE_CLOSE, 1);
   double Ma50d = iMA(NULL, 0, 50, 0, MODE_SMA, PRICE_CLOSE, 0);
   if(Ma15a < Ma50a && Ma15d > Ma50d)
     {
      Signal = "Buy";
     }
   if(Ma15a > Ma50a && Ma15d < Ma50d)
     {
      Signal = "Sell";
     }
//Entrada inicial depende de Signal
   if(NuevoCiclo && OrdersTotal() == 0)
     {
      if(Signal == "Buy")
        {
         InitialHedgeTicket = Buy(Lotes, Puntos, Puntos * 2.1);
         NuevoCiclo = false;
         Hedge = true;
         LevelsBS = true;
        }
      if(Signal == "Sell")
        {
         InitialHedgeTicket = Sell(Lotes, Puntos, Puntos * 2.1);
         NuevoCiclo = false;
         Hedge = true;
         LevelsBS = true;
        }
     }
//Dibujar Lines de compra y venta
   if(LevelsBS)
     {
      if(TypeOpByTicket(InitialHedgeTicket) == OP_BUY)
        {
         LevelsBS = false;
         BuyLevel = LastOPOpenPrice();
         SellLevel = BuyLevel - (Puntos * Point);
         ObjCreateLine(BuyLevel, "BuyLevel", clrGreen);
         ObjCreateLine(SellLevel, "SellLevel", clrRed);
        }
      else
         if(TypeOpByTicket(InitialHedgeTicket) == OP_SELL)
           {
            LevelsBS = false;
            SellLevel  = LastOPOpenPrice();
            BuyLevel = SellLevel + (Puntos * Point);
            ObjCreateLine(BuyLevel, "BuyLevel", clrGreen);
            ObjCreateLine(SellLevel, "SellLevel", clrRed);
           }
     }
//Operaciones de cobertura
   if(Hedge)
     {
      if(TypeOpByTicket(LastTicketOpen()) == OP_BUY)
        {
         ArrayResize(HedgeOrdersArray, ArraySize(HedgeOrdersArray) + 1);
         HedgeOrdersArray[ArraySize(HedgeOrdersArray) - 1] =
            HedgeRecoveryZoneSell(LastTicketOpen(), SellLevel, Puntos);
        }
      else
         if(TypeOpByTicket(LastTicketOpen()) == OP_SELL)
           {
            ArrayResize(HedgeOrdersArray, ArraySize(HedgeOrdersArray) + 1);
            HedgeOrdersArray[ArraySize(HedgeOrdersArray) - 1] =
               HedgeRecoveryZoneBuy(LastTicketOpen(), BuyLevel, Puntos);
           }
     }
//Recovery String
   if(OrdersTotal() > 2)
     {
      Recovery = RecoveryInfo(InitialHedgeTicket, HedgeOrdersArray);
     }
   else
     {
      Recovery = "";
     }
//Informacion en pantalla
   Comment("Ultima Ordern: ", LastTypeClose(), ENTER,
           "Saldo Inicial: ", SaldoInicial, ENTER,
           "Balance: ", AccountBalance(), ENTER,
           "Flotante: ", Flotante(), ENTER,
           "Ordenen Inicial: ", InitialHedgeTicket, ENTER,
           "BuyLevel: ", BuyLevel, ENTER,
           "SellLevel: ", SellLevel, ENTER,
           "Ordenes Abiertas: ", PrintArray(OpenOrdersArray), ENTER,
           "Ordenes de Cobertura: ", PrintArray(HedgeOrdersArray), ENTER,
           Recovery,
           OrdenesAbiertas(2),
           OrdenesCerradasSinPendientes(2));
  }
//+------------------------------------------------------------------+
/*Apuntes
   +Ya hay crecimiento pero hay errores al encadenar las operaciones
    de cobertura hay que encadenarlas para poder ver un crecimiento
    mas constante
    
    
    
    */
