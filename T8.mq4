//+------------------------------------------------------------------+
//|                                                        Test8.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "..\\Experts\\OrdersExecution.mq4"
#include "..\\Experts\\OrdersInfo.mq4"
#include "..\\Experts\\CONSTANTS.mq4"
#include "..\\Experts\\ExFuntions.mq4"

input double Gestion =-1;
input double Lotes=0.01;
input int TGR =200;
input int STP =1000;

/*El experto abre una compra o venta dependieiendo del resultado antarior
   +Si el resultado es postivo se abre una OP del mismo tipo
   +Si el resultado es negativo se abre una Op contraria con 
    0.01 lote mas que la anterior*/
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
double minFlotante = 0;
string Test="";
bool Flag = true;
int F =1;
void OnTick()
  {   
  
   //Primera entrada
   if(OrdersTotal()==0&&Flag)
     {
      Buy(Lotes,TGR,TGR);
      Flag=false;
     }
   //Condiciones entradas siguientes dependiendo del resultado
   if(F<=0)
     {
      F=1;
     }
   if(OrdersTotal()==0)
     {
      if(LastOPProfitClose()<0&&LastTypeClose()=="OP_BUY")
        {
         Sell(Lotes*F,TGR,TGR);
         Test="BxS";
         F++;
        }
      if(LastOPProfitClose()>0&&LastTypeClose()=="OP_BUY")
        {
         Buy(Lotes*F,TGR,TGR);
         Test="BXB";
         F=1;
        }
      if(LastOPProfitClose()<0&&LastTypeClose()=="OP_SELL")
        {
         Buy(Lotes*F,TGR,TGR);
         Test="SXB";
         F++;
        }
      if(LastOPProfitClose()>0&&LastTypeClose()=="OP_SELL")
        {
         Sell(Lotes*F,TGR,TGR);
         Test="SXS";
         F=1;
        }
     }
  
   
   //Funcion que alimenta el flotante mas alto
   if(Flotante()<minFlotante)
     {
      minFlotante=Flotante();
     }
   //Informacion en pantalla
   Comment("Ordenes Abiertas: ", OrdersTotal(),"/",OrdersHistoryTotal(),ENTER,
           "Compras Abiertas: ",OpenBuys(),ENTER,
           "Ventas Abiertas: ",OpenSells(),ENTER,
           "Max DrawDown: ",minFlotante,ENTER,
           "Ultima Ordern: ",LastTypeClose(),ENTER,
           "Ultimo Resultado: ",LastOPProfitClose(),ENTER,
           "Test: ",Test,ENTER,
           "Factor: ",F,ENTER,
           OrdenesAbiertas(),
           OrdenesCerradas());
           
            
   
  }
//+------------------------------------------------------------------+
