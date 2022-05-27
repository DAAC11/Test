//+------------------------------------------------------------------+
//|                                                       david1.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| My function                                                      |
//+------------------------------------------------------------------+
// int MyCalculator(int value,int value2) export
//   {
//    return(value+value2);
//   }
//+------------------------------------------------------------------+
int Buy(double Lots,double Target,double Stop)
  {
   int O =OrderSend(NULL,OP_BUY,Lots,Ask,3,Ask-(Stop*Point),Ask+(Target*Point),NULL,3,0,clrGreen);
   return O;
  }
 int Buy(double Lots,double Target,double Stop,color color1)
  {
   int O =OrderSend(NULL,OP_BUY,Lots,Ask,3,Ask-(Stop*Point),Ask+(Target*Point),NULL,3,0,clrGreen);
   return O;
  }

int Sell(double Lots,double Target,double Stop)
  {
   int V =OrderSend(NULL,OP_SELL,Lots,Bid,3,Bid+(Stop*Point),Bid-(Target*Point),NULL,3,0,clrRed);
   return V;
  }


string LastOPType(int OPType)
{
   string StrType="";
   if(OPType ==0)StrType="OP_BUY";
   if(OPType ==1)StrType="OP_SELL";
   if(OPType ==2)StrType="OP_BUYLIMIT"; 
   if(OPType ==3)StrType="OP_SELLLIMIT";
   if(OPType ==4)StrType="OP_BUYSTOP";
   if(OPType ==5)StrType="OP_SELLSTOP";
 
   return StrType;  
}
string OrdenesAbiertas(){
   string Abiertas="\n=====ORDENES ABIERTAS=====\n";
   
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         Abiertas += "||Ticket: "+OrderTicket()+"||Profit = "+OrderProfit()+"||Type: "+LastOPType(OrderType())+"\n";
        }
     }
    return Abiertas;

}

string OrdenesCerradas(){
   string Cerradas="\n=====ULTIMAS 10 ORDENES CERRADAS=====\n";
   
   for(int i=OrdersHistoryTotal()-1;i>=OrdersHistoryTotal()-10;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         Cerradas += "||Ticket: "+OrderTicket()+"||Profit = "+OrderProfit()+"||Type: "+OrderType()+"\n";
        }
     }
    return Cerradas;

}

double LastOPProfit()
   {
   
   double Last =0;
    for(int i=OrdersTotal()-1;i>OrdersTotal()-1;i--)
      {
       if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
         {
          Last = OrderProfit();
         }
      }
   return Last;
   }


/*
26- Crea un objeto segun la hora  con maximos y minimos
28- "WTF BRAH"
36- Se pueden sobrecargar las funciones
38- Static variables interesante
-video 70 usualmente utilizarun un oscilador con un idicador de tendencia
46- El Objeto arrow puede tener muchas formas
- Posibilidad de hacer CSV no funcionó averiguar
78-interesante
85-TRSTP dinamico video 122
86-Interesante escalera video 124 
   *TGR y TRSTP al resto prueba
90-Relativamente positivo 129
93-Modificado ordenes cruzadas Interesante
   *Case =2 
    STP=500
*/