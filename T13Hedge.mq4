//+------------------------------------------------------------------+
//|                                                     T13Hedge.mq4 |
//|                                                            David |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "David"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs


#include "..\\Experts\\OrdersExecution.mq4"
#include "..\\Experts\\OrdersInfo.mq4"
#include "..\\Experts\\CONSTANTS.mq4"
#include "..\\Experts\\ExFuntions.mq4"
#include "..\\Experts\\Hedge.mq4"

input double Gestion =-1;
input double Lotes=0.01;
input int TGR =200;
input int STP =200;


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
bool Cierre = false;
bool Hedge = false;
int Cierres=0;
int H=0;
int S=0;

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
//Apertura de ordenes
   if(OrdersTotal()==0)
     {
      Buy(Lotes*2,TGR,STP);
      H=0;

      Hedge=false;
     }

//Cobertura
   if(LastOPProfitOpen()<-1 && OrdersTotal()==1 && !Hedge&&H==0)
     {

      Hedge = OrdenContraria(LastTicketOpen(),0.5,TGR,STP);
      H++;

     }
//Cerrar Op en 0
   if(OrdersTotal()==2&&Cierre)
     {

      if(Flotante()>0)
        {
         Cierres++;
         for(int i=OrdersTotal()-1; i>0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderType()==OP_BUY)
                 {
                  Cierres++;
                  OrderClose(OrderTicket(),OrderLots(),Ask,
                             5,clrBeige);
                  Alert("Alerta B");
                 }
               if(OrderType()==OP_SELL)
                 {
                  Cierres++;
                  OrderClose(OrderTicket(),OrderLots(),Bid,
                             5,clrBeige);
                  Alert("Alerta S");
                 }
              }
           }
        }
      S=0;
     }

//Informacion en pantalla
   Comment("Ordenes Abiertas: ", OrdersTotal(),"/",OrdersHistoryTotal(),ENTER,
           "Ultima Ordern: ",LastTypeClose(),ENTER,
           "Ultimo Resultado: ",LastOPProfitClose(),ENTER,
           "Ultimo Resultado : ",LastOPProfitOpen(),ENTER,
           "Saldo Inicial: ",SaldoInicial,ENTER,
           "Balance: ",AccountBalance(),ENTER,
           "Flotante: ",Flotante(),ENTER,
           "H: ",H,ENTER,
           "S: ",S,ENTER,
           "Cierres: ",Cierres,ENTER,
           "Cierre: ",Cierre,ENTER,

           OrdenesAbiertas(),
           OrdenesCerradas());

  }
//+------------------------------------------------------------------+
