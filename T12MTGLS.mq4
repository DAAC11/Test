//+------------------------------------------------------------------+
//|                                                           T9.mq4 |
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

input double Gestion =-1;
input double Lotes=0.01;
input int TGR =200;
input int STP =200;
enum Tipo_Martingala
  {
   Clasica,
   DAlembert,
   Fibo,
  };
input Tipo_Martingala Martingala=0;
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
int K = 0;
int SaldoInicial=0;
void OnTick()
  {
//Saldo inicial
   if(Flag)
     {
      SaldoInicial=AccountBalance();
     }
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
   switch(Martingala)
     {
      case 0:
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
         break;

      case 1:
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
         break;
      case 2:
         if(K==0)
           {
            K=1;
           }
         if(OrdersTotal()==0)
           {
           
            if(LastOPProfitClose()<0&&LastTypeClose()=="OP_BUY")
              {
               F++;
               K=fibo(F);
               Sell(Lotes*K,TGR,TGR);
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
               F=F++;
               K=fibo(F);
               Buy(Lotes*K,TGR,TGR);
               Test="SXB";
              }
            if(LastOPProfitClose()>0&&LastTypeClose()=="OP_SELL")
              {
               F=1;
               Sell(Lotes*F,TGR,TGR);
               Test="SXS";
              }
           }
         break;

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
           "Saldo Inicial: ",SaldoInicial,ENTER,
           "Balance: ",AccountBalance(),ENTER,
           "Factor: ",F,ENTER,
           "Factor Fibo: ",K,ENTER,
           "MTGL: ", EnumToString(Martingala),ENTER,ENTER,
           OrdenesAbiertas(),
           OrdenesCerradas());



  }
//+------------------------------------------------------------------+
int fibo(int n){
   int inicio=0;
   if(n !=0)
     {
      for(int i=0;i<n;i++)
        {
         inicio=inicio+i;
        }
      if(inicio==0||inicio==1)
        {
         return 2;
        }else
           {
            return inicio;
           }
        
     }else
        {
         return 1;
        }
  

}

