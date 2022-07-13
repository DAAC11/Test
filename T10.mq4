//+------------------------------------------------------------------+
//|                                                           T9.mq4 |
//|                                                            David |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "David"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
/*Cada vez que el precio llega a -1 se abre una oden en contra con 
  el lotaje *2 */
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
string Test2="";
string Test3="";
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
         F++;
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
         F++;
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
  //Ordenes de cobertura   
    if(OrdersTotal()==1&&LastOPProfitOpen()<-1)
     {
      if(LastTypeOpen()=="OP_BUY")
        {
         Sell(Lotes*2,TGR/2,TGR/2);
         Test2="2BxS";
        }
      
      if(LastTypeOpen()=="OP_SELL")
        {
         Buy(Lotes*2,TGR/2,TGR/2);
         Test2="2SXB";
        }
     }
     
  /*//Ordenes de cobertura 2  
    if(OrdersTotal()==1&&LastOPProfitOpen()<-2)
     {
      if(LastTypeOpen()=="OP_BUY")
        {
         Sell(Lotes*(F+2),TGR/3,TGR);
         Test3="3BxS";
        }
      
      if(LastTypeOpen()=="OP_SELL")
        {
         Buy(Lotes*(F+2),TGR/3,TGR);
         Test3="3SXB";
        }
     }*/
  
   
   //Funcion que alimenta el flotante mas alto
   if(Flotante()<minFlotante)
     {
      minFlotante=Flotante();
     }
   //Informacion en pantalla
   Comment("Ordenes Abiertas: ", OrdersTotal(),"/",OrdersHistoryTotal(),ENTER,
           "Compras Abiertas: ",OpenBuys(),ENTER,
           "Ventas Abiertas: ",OpenSells(),ENTER,
           "Flotante: ",Flotante(),ENTER,
           "Max DrawDown: ",minFlotante,ENTER,
           "Ultima Ordern: ",LastTypeClose(),ENTER,
           "Ultimo Resultado: ",LastOPProfitClose(),ENTER,
           "Test: ",Test,ENTER,
           "Test2: ",Test2,ENTER,
           "Test3: ",Test3,ENTER,
           "Factor: ",F,ENTER,
           OrdenesAbiertas(),
           OrdenesCerradas());
           
           
  }