//+------------------------------------------------------------------+
//|                                                           T1.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input double stp = 100;
input double tgr = 200;
input double lots = 0.01;

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



  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int ticket=0;
int buy[];
int v=0;
int accStp=0;
string last = "";
int ticket_anterior = 0;
int last_type=0;
bool  cambio = false;
int acc = 1;
void OnTick()
  {
   string comentario;

   int ot = OrdersTotal();
   double resultado = AccountProfit();

//entrada inicial
   if(ot==0 && last =="")
     {
      ticket = compra(lots*acc,stp,tgr);

     }

// si TGR
   if(ot==0 && last =="TGR"&& last_type==0)
     {
      acc=1;
      ticket = compra(lots*acc,stp,tgr);

    
     }

   if(ot==0 && last =="TGR"&& last_type==1)
     {
      acc=1;

      ticket = venta(lots*acc,stp,tgr);
     }

//entrada si STP
   if(ot==0 && last =="STP"&& last_type==0)
     {
      acc++;
      ticket = venta(lots*acc,stp,tgr);
     }
   if(ot==0 && last =="STP"&& last_type==1)
     {
      acc++;
      ticket = compra(lots*acc,stp,tgr);
     }




// alimenta al ant inicial
   if(ot!=0)
     {
      last = anterior(ticket-1);
      last_type = anterior_type(ticket-1);
      ticket_anterior = ticket-1;
     }

   if(ot==0 && last=="TGR")
     {
      acc=1;
     }

   comentario += "Orders total = "+ot +
                 "\nOrders profit = "+ resultado+
                 "\nCompra = "+ ticket+
                 "\nVenta = "+ v+
                 "\nAnterior = "+ last+
                 "\nAcumulador = "+acc+
                 "\nContador Stp = "+accStp+
                 "\nLasType = "+last_type+
                 "\nTicket anterior = "+ticket_anterior;

   Comment(comentario);


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int compra(double lotes,double stop, double target)
  {
   int O =OrderSend(NULL,OP_BUY,lotes,Ask,3,Ask-(stop*Point),Ask+(target*Point),NULL,3,0,clrGreen);
   return O;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int venta(double lotes,double stop, double target)
  {
   int V =OrderSend(NULL,OP_SELL,lotes,Bid,3,Bid+(stop*Point),Bid-(target*Point),NULL,3,0,clrRed);
   return V;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string anterior(int index)
  {
   string salida = "";
   if(OrderSelect(index,SELECT_BY_TICKET,MODE_HISTORY)== true)
     {
      if(OrderProfit()>0)
        {
         salida = "TGR";
        }
      else
        {
         salida = "STP";
        }
     }
   return salida;
   ;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int anterior_type(int index)
  {
   int salida;
   if(OrderSelect(index,SELECT_BY_TICKET,MODE_HISTORY)== true)
     {
      salida =OrderType();

     }
   return salida;
   ;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int contador_stp(int index)
  {
   int contador = 0;
   for(int i=index; i<0; i--)
     {
      if(OrderSelect(index,SELECT_BY_TICKET,MODE_HISTORY)== true)
        {
         if(OrderProfit()>0)
           {
            break;
           }
         else
           {
            contador++;

           }
        }
     }

   return contador;


  }


//+------------------------------------------------------------------+
