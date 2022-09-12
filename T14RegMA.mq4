//+------------------------------------------------------------------+
//|                                                      14RegMA.mq4 |
//|                                                            David |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "David"
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include "..\\Experts\\OrdersExecution.mq4"
#include "..\\Experts\\OrdersInfo.mq4"
#include "..\\Experts\\CONSTANTS.mq4"
#include "..\\Experts\\ExFuntions.mq4"
#include "..\\Experts\\Hedge.mq4"

input double Gestion = -1;
input double Lotes = 0.01;
input int TGR = 200;
input int STP = 200;


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
bool Signal = false;
double sumaP = 0;
double AVG = 0;
int H = 0;
int S = 0;
int periodos = 199;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
{
//Slado inicial
   if(Flag) {
      SaldoInicial = AccountBalance();
      Flag = false;
   }
//Comparador de media y Precio
   double array[1];
   ArrayResize(array, periodos + 1);
   for(int i = periodos; i > 0; i--) {
      array[i] = MathAbs(iMA(NULL, 0, 50, 0, MODE_SMA, PRICE_MEDIAN, i) - Close[i]);
   }
   sumaP = SumaArray(array);
   AVG = sumaP / periodos;
   double media = iMA(NULL, 0, 50, 0, MODE_SMA, PRICE_MEDIAN, 0);
//Apertura de ordenes
   if(OrdersTotal() == 0 ) {
      if(media > Open[0]) {
         if(MathAbs(media - Close[0]) > AVG) {
            Buy(Lotes, TGR, STP);
         }
      }
      if(media < Close[0]) {
         if(MathAbs(media - Close[0]) > AVG) {
            Sell(Lotes, TGR, STP);
         }
      }
   }
//Informacion en pantalla
   Comment("Ordenes Abiertas: ", OrdersTotal(), "/", OrdersHistoryTotal(), ENTER,
           "Ultima Ordern: ", LastTypeClose(), ENTER,
           "Ultimo Resultado: ", LastOPProfitClose(), ENTER,
           "Ultimo Resultado : ", LastOPProfitOpen(), ENTER,
           "Saldo Inicial: ", SaldoInicial, ENTER,
           "Balance: ", AccountBalance(), ENTER,
           "Flotante: ", Flotante(), ENTER,
           "Suma MA: ", sumaP, ENTER,
           "AVG: ", AVG, ENTER,
           OrdenesAbiertas(),
           OrdenesCerradas());
}
//+------------------------------------------------------------------+
