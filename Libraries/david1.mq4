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
///Constantes/////////////////
string ENTER = "\n";
double VlrPunto = MarketInfo(NULL,MODE_POINT);



double Flotante(){//Funcionando
   double Flotante =AccountEquity()-AccountBalance();
   return Flotante;
 }

int Buy(double Lots,double Target,double Stop)//Funcionando
  {
   int O =OrderSend(NULL,OP_BUY,Lots,Ask,3,Ask-(Stop*Point),Ask+(Target*Point),NULL,3,0,clrGreen);
   return O;
  }
 

int Sell(double Lots,double Target,double Stop)//Funcionando
  {
   int V =OrderSend(NULL,OP_SELL,Lots,Bid,3,Bid+(Stop*Point),Bid-(Target*Point),NULL,3,0,clrRed);
   return V;
  }


string LastOPType(int OPType)//Funcionando
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
int LastTicketOpen(){//Funcionando
   int last =0;
   for(int i=OrdersTotal()-1;i>0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderTicket()>last)
           {
            last=OrderTicket();
           }
        }
     }
   return last;
}

int LastTicketClose(){//Funcionando
   int last =0;
   
      if(OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY))
        {
         last=OrderTicket();
        }
     
   return last;
}

string LastTypeOpen(){//Funcionando
   string lastOrderType ="";
   int numType=-1;
   OrderSelect(LastTicketOpen(),SELECT_BY_TICKET,MODE_TRADES);
   numType=OrderType();
     
   
   if(numType ==0)lastOrderType="OP_BUY";
   if(numType ==1)lastOrderType="OP_SELL";
   if(numType ==2)lastOrderType="OP_BUYLIMIT"; 
   if(numType ==3)lastOrderType="OP_SELLLIMIT";
   if(numType ==4)lastOrderType="OP_BUYSTOP";
   if(numType ==5)lastOrderType="OP_SELLSTOP";
   
   return lastOrderType;
}

string LastTypeClose(){//Funcionando
   string lastOrderType ="";
   int numType=-1;
   OrderSelect(LastTicketClose(),SELECT_BY_TICKET,MODE_HISTORY);
   numType=OrderType();
     
   
   if(numType ==0)lastOrderType="OP_BUY";
   if(numType ==1)lastOrderType="OP_SELL";
   if(numType ==2)lastOrderType="OP_BUYLIMIT"; 
   if(numType ==3)lastOrderType="OP_SELLLIMIT";
   if(numType ==4)lastOrderType="OP_BUYSTOP";
   if(numType ==5)lastOrderType="OP_SELLSTOP";
   
   return lastOrderType;
}



string OrdenesAbiertas(){//Funcionando
   string Abiertas="\n=====ORDENES ABIERTAS=====\n";
   
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         Abiertas += "||Ticket: "+OrderTicket()+
         "||Profit = "+" $ "+NormalizeDouble(OrderProfit(),2)+" || "+LastOPType(OrderType())+"\n";
        }
     }
    return Abiertas;

}

string OrdenesCerradas(){//Funcionando
   string Cerradas="\n=====ULTIMAS 10 ORDENES CERRADAS=====\n";
   
   for(int i=OrdersHistoryTotal()-1;i>=OrdersHistoryTotal()-10;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         Cerradas += "||Ticket: "+OrderTicket()+"||Profit = "+"$ "+
         NormalizeDouble(OrderProfit(),2)+
         "||Type: "+LastOPType(OrderType())+"\n";
        }
     }
    return Cerradas;

}

string LastOPProfitClose()//Funcionando
   {
   
   string Last="";
       if(OrderSelect(LastTicketClose(),SELECT_BY_TICKET,MODE_HISTORY))
         {
          Last = OrderProfit();
         }
      
      return Last;
   }
string LastOPProfitOpen()//Funcionando
   {
   
   string Last="";
       if(OrderSelect(LastTicketOpen(),SELECT_BY_TICKET,MODE_TRADES))
         {
          Last = OrderProfit();
         }
      
      return Last;
   }

int OpenBuys(){
   int nBuys =0;
   for(int i=OrdersTotal()-1;i>0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==OP_BUY)
           {
            nBuys++;
           }
        }
     }
   return nBuys;
}

int OpenSells(){
   int nSells =0;
   for(int i=OrdersTotal()-1;i>0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==OP_SELL)
           {
            nSells++;
           }
        }
     }
   return nSells;
}
void LiquidadorBuy(){
   for(int i=OrdersTotal()-1;i>0;i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()==OP_BUY)
        {
         OrderClose(OrderTicket(),OrderLots(),Bid,3,clrWhite);
         Print("Liquidador Buy");
        }
      
     }
  }
void LiquidadorSell(){
   for(int i=OrdersTotal()-1;i>0;i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()==OP_SELL)
        {
         OrderClose(OrderTicket(),OrderLots(),Ask,3,clrMaroon);
         Print("Liquidador Sell");
        }
      
     }
  }
void AddArray(int &Array[],int Value){
   int Size = ArraySize(Array);
   ArrayResize(Array,Size+1);
   Array[ArraySize(Array)-1]=Value;
  
}


string PrintArray(int &Array[]){
   string salida ="[";
   for(int i=ArraySize(Array)-1;i>=0;i--)
     {
      salida += i+",";
     }
   salida+="]";
   
   return salida;


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
93-Interesante
   *Case = 1
   STP=2000
93-Interesante inicio 45
   *Case = 4
   STP=2000
93-Interesante inicio 45
   *Case = 2
   STP=2000
   USDJPY
NN-OP de salvamento con lots*2 en contra de negativo

*/