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
bool Flag = true;
int SaldoInicial;
bool Hedge = false;
int Contador = 0;

int BuyOrder=0;

double PrecioInicial = 0;
double GridsA[];
double GridsB[];
string Objetos[];
string Signal="";
int GridArrayPrint = 0;
double GridBloqueado = 0;
double GridBloqueadoD = 0;
double PrecioInicialD = 0;
bool NuevoCiclo = false;
bool Closer =false;



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//Slado inicial
   if(Flag)
     {
      SaldoInicial = AccountBalance();
      Flag = false;
      Closer=false;
     }
   if(OrdersTotal() == 0)
     {
      NuevoCiclo = true;
        Closer=false;
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
   if(OrdersTotal() == 0&&Signal=="Buy")
     {
      BuyOrder=Buy(0.01,100, 100);
     }
   if(LastOPProfitOpen() < -0.5 && OrdersTotal() == 1 && NuevoCiclo)
     {
      Sell(0.01,50, 100);
      if(OrderSelect(BuyOrder,SELECT_BY_TICKET))
        {
         OrderModify(BuyOrder,OrderOpenPrice(),OrderStopLoss(),(OrderOpenPrice()+(1*Point)),0);
        }
      NuevoCiclo = false;
      Closer=true;
     }
   if(Closer&&OrdersTotal()==1)
     {
      Liquidador();
     }
//Informacion en pantalla
   Comment("Ordenes Abiertas: ", OrdersTotal(), "/", OrdersHistoryTotal(), ENTER,
           "Ultima Ordern: ", LastTypeClose(), ENTER,
           "Ultimo Resultado: ", LastOPProfitClose(), ENTER,
           "Resultado actual: ", LastOPProfitOpen(), ENTER,
           "Ultimo ticket : ", LastTicketOpen(), ENTER,
           "Saldo Inicial: ", SaldoInicial, ENTER,
           "Balance: ", AccountBalance(), ENTER,
           "Flotante: ", Flotante(), ENTER,
           "Contador: ", Contador, ENTER,
           OrdenesAbiertas(),
           OrdenesCerradas(2));
  }
//+------------------------------------------------------------------+
