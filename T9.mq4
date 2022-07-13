//+------------------------------------------------------------------+
//|                                                           T9.mq4 |
//|                                                            David |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "David"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
/*Martingala clasica:
   + Cada vez que pierde dobla
   + Cada vez que gana vuelve a entrar con una unidad*/
#include "..\\Experts\\OrdersExecution.mq4"
#include "..\\Experts\\OrdersInfo.mq4"
#include "..\\Experts\\CONSTANTS.mq4"
#include "..\\Experts\\ExFuntions.mq4"

input double Gestion =-1;
input double Lotes=0.01;
input int TGR =200;
input int STP =1000;
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
         F=F*2;
         Sell(Lotes*F,TGR,TGR);
         Test="BxS";
        }
      if(LastOPProfitClose()>0&&LastTypeClose()=="OP_BUY")
        {
         F=1;
         Buy(Lotes*F,TGR,TGR);
         Test="BXB";
        }
      if(LastOPProfitClose()<0&&LastTypeClose()=="OP_SELL")
        {
         F=F*2;
         Buy(Lotes*F,TGR,TGR);
         Test="SXB";
        }
      if(LastOPProfitClose()>0&&LastTypeClose()=="OP_SELL")
        {
         F=1;
         Sell(Lotes*F,TGR,TGR);
         Test="SXS";
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