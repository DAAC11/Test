//+------------------------------------------------------------------+
//|                                                      TestBVC.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Experts\\david1.mq4"
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
double MinFlotante =0;
int Tickets[1];
int Coberturas[1];
bool flag = True;
string Accion = "";
void OnTick()
  {
   int Ordenes =0;

   string BorS="";
   if(flag)
     {
      Buy(Lotes,TGR,STP);
      flag=False;

     }
   if(OrdersTotal()<=1)
     {
      if(LastTypeOpen()=="OP_BUY"&& LastOPProfitOpen()<-1)
        {
         Sell(Lotes,TGR,STP);
         Accion="BXS";
         
        }
      if(LastTypeOpen()=="OP_BUY"&& LastOPProfitOpen()<-1)
        {
         Buy(Lotes,TGR,STP);
         Accion="BXB";
        }
      
      if(LastTypeOpen()=="OP_SELL"&& LastOPProfitOpen()<-1)
        {
         Buy(Lotes,TGR,STP);
         Accion="SXB";
        }
      if(LastTypeOpen()=="OP_SELL"&& LastOPProfitOpen()<-1)
        {
         Sell(Lotes,TGR,STP);
         Accion="SXS";
        }
        
     }
    if(OrdersTotal()<=3)
     {
      if(LastTypeOpen()=="OP_BUY"&& LastOPProfitOpen()<-5)
        {
         Sell(Lotes*2,TGR,STP);
         Accion="BXS2";
         
        }
      
      
      if(LastTypeOpen()=="OP_SELL"&& LastOPProfitOpen()<-5)
        {
         Buy(Lotes*2,TGR,STP);
         Accion="SXB2";
        }
     
     }
   



   if(Flotante()<MinFlotante)
     {
      MinFlotante=NormalizeDouble(Flotante(),2);
     }

   Comment("Min Flotante: ",MinFlotante,ENTER,
           "Flotante: ",Flotante(),ENTER,
           "Ordenes: ",Ordenes,ENTER,
           "Ultimo tipo de Orden: ",LastTypeClose(),ENTER,
           "Ordenes Cerradas: ",OrdersHistoryTotal(),ENTER,
           "Ultimo Resultado: ",LastOPProfitClose(),ENTER,
           "Ultimo Accion: ",Accion,ENTER,
           OrdenesAbiertas(),
           OrdenesCerradas()

          );
  }

//+------------------------------------------------------------------+
