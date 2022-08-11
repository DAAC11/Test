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
int breakeven=0;
int LastTicketOpen=0;
double LastProfitOpen=0;
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
         Sell(Lotes,TGR,STP/F);
         Test="BxS";
        }
      if(LastOPProfitClose()>0&&LastTypeClose()=="OP_BUY")
        {
         F=1;
         Buy(Lotes,TGR,STP);
         Test="BXB";
        }
      if(LastOPProfitClose()<0&&LastTypeClose()=="OP_SELL")
        {
         F++;
         Buy(Lotes,TGR,STP/F);
         Test="SXB";
        }
      if(LastOPProfitClose()>0&&LastTypeClose()=="OP_SELL")
        {
         F=1;
         Sell(Lotes,TGR,STP);
         Test="SXS";
        }
     }
 /* //Ordenes de cobertura   
    if(OrdersTotal()==0&&LastOPProfitOpen()<-1.5)
     {
      if(LastTypeOpen()=="OP_BUY")
        {
         Sell(Lotes,TGR,TGR);
         Test2="2BxS";
        }
      
      if(LastTypeOpen()=="OP_SELL")
        {
         Buy(Lotes,TGR,TGR);
         Test2="2SXB";
        }
     }*/
  //Ordenes de BE
  if(LastOPProfitOpen()>1.5)
    {
     BE(LastTicketOpen(),75);
     breakeven++;
    }
    
  LastTicketOpen=LastTicketOpen();
  LastProfitOpen=LastOPProfitOpen();

  
   
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
           "BE activado: ",breakeven,ENTER,
           "LastOPProfitOpen(): ",LastProfitOpen,ENTER,
           "LastTicketOpen(): ",LastTicketOpen,ENTER,
           "Factor: ",F,ENTER,
           "StopLevel = ", (int)MarketInfo(Symbol(), MODE_STOPLEVEL),
           OrdenesAbiertas(),
           OrdenesCerradas());
           
           
  }
  
