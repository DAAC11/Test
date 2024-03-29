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
int ContadorCierres = 0;
double BuyLevel = 0;
double SellLevel = 0;
double LastOPOrderPrice = 0;
int LiquidadorAnticipado = 0;
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
//Permiso para entrar si hay 0 ordenes
   if(OrdersTotal() == 0 || OrdersTotal() == ContadorDePendientes())
     {
      LiquidadorPendientes();
      NuevoCiclo = true;
      ArrayFree(HedgeOrdersArray);
     }
//Señal de entrada
   double Ma15a = iMA(NULL, 0, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
   double Ma15d = iMA(NULL, 0, 20, 0, MODE_SMA, PRICE_CLOSE, 0);
   double Ma50a = iMA(NULL, 0, 50, 0, MODE_SMA, PRICE_CLOSE, 1);
   double Ma50d = iMA(NULL, 0, 50, 0, MODE_SMA, PRICE_CLOSE, 0);
   if(Ma15a < Ma50a && Ma15d > Ma50d)
     {
      Signal = "Buy";
     }
   else
      if(Ma15a > Ma50a && Ma15d < Ma50d)
        {
         Signal = "Sell";
        }
      else
        {
         Signal = "";
        }
//Entrada inicial depende de Signal
   if(NuevoCiclo && OrdersTotal() == 0)
     {
      if(Signal == "Buy")
        {
         InitialHedgeTicket = Buy(Lotes, Puntos, Puntos * 5);
         NuevoCiclo = false;
         Hedge = true;
         LevelsBS = true;
         Ciclos++;
        }
      if(Signal == "Sell")
        {
         InitialHedgeTicket = Sell(Lotes, Puntos, Puntos * 5);
         NuevoCiclo = false;
         Hedge = true;
         LevelsBS = true;
         Ciclos++;
        }
     }
//Dibujar Lines de compra y venta
   if(LevelsBS)
     {
      if(TypeOpByTicket(InitialHedgeTicket) == OP_BUY)
        {
         LevelsBS = false;
         BuyLevel = LastOPOpenPrice();
         SellLevel = BuyLevel - ((Puntos) * Point);
         ObjCreateLine(BuyLevel, "BuyLevel", clrGreen);
         ObjCreateLine(SellLevel, "SellLevel", clrRed);
        }
      else
         if(TypeOpByTicket(InitialHedgeTicket) == OP_SELL)
           {
            LevelsBS = false;
            SellLevel  = LastOPOpenPrice();
            BuyLevel = SellLevel + ((Puntos) * Point);
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
//Cierre de Operaciones encadenado
   if(IsCloseArray(HedgeOrdersArray) ||
      IsClose(InitialHedgeTicket))
     {
      Liquidador();
      LiquidadorPendientes();
      Aviso = SignalAlert;
      ContadorCierres++;
      HedgeBuy = false;
      HedgeSell = false;
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
//Salida anticipada
   if(OrdersTotal() >= 2 && Flotante() > 0.1)
     {
      LiquidadorPendientes();
      Liquidador();
      LiquidadorAnticipado++;
     }
//Informacion en pantalla
   Comment(
      "Ordenes Abiertas: ", OrdersTotal(), ENTER,
      "Ultima Orden: ", LastTypeClose(), ENTER,
      "Saldo Inicial: ", SaldoInicial, ENTER,
      "Balance: ", AccountBalance(), ENTER,
      "Flotante: ", Flotante(), ENTER,
      "Ordenen Inicial: ", InitialHedgeTicket, ENTER,
      "BuyLevel: ", BuyLevel, ENTER,
      "SellLevel: ", SellLevel, ENTER,
      "Ordenes Abiertas: ", PrintArray(OpenOrdersArray), ENTER,
      "Ordenes de Cobertura: ", PrintArray(HedgeOrdersArray), ENTER,
      "Cierres : ", ContadorCierres, ENTER,
      "Bool Initial : ", IsClose(InitialHedgeTicket), ENTER,
      "Bool Coberturas : ", IsCloseArray(HedgeOrdersArray), ENTER,
      "Liquidaor Anticipado: ", LiquidadorAnticipado, ENTER,
      "Ciclos: ", Ciclos, ENTER,
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
