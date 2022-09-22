//+------------------------------------------------------------------+
//|                                                   Constantes.mq4 |
//|                                                            David |
//|                                                                  |
//+------------------------------------------------------------------+
#property library
#property copyright "David"
#property link      ""
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
double Flotante() //Funcionando
  {
   double Flotante = AccountEquity() - AccountBalance();
   return NormalizeDouble(Flotante, 2);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string LastOPType(int OPType)//Funcionando
  {
   string StrType = "";
   if(OPType == 0)
      StrType = "OP_BUY";
   if(OPType == 1)
      StrType = "OP_SELL";
   if(OPType == 2)
      StrType = "OP_BUYLIMIT";
   if(OPType == 3)
      StrType = "OP_SELLLIMIT";
   if(OPType == 4)
      StrType = "OP_BUYSTOP";
   if(OPType == 5)
      StrType = "OP_SELLSTOP";
   return StrType;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int LastTicketOpen() //Funcionando
  {
   int last = 0;
   if(OrderSelect(OrdersTotal() - 1, SELECT_BY_POS, MODE_TRADES))
     {
      last = OrderTicket();
     }
   return last;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int LastTicketClose() //Funcionando
  {
   int last = 0;
   if(OrderSelect(OrdersHistoryTotal() - 1, SELECT_BY_POS, MODE_HISTORY))
     {
      last = OrderTicket();
     }
   return last;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string LastTypeOpen() //Funcionando
  {
   string lastOrderType = "";
   int numType = -1;
   OrderSelect(LastTicketOpen(), SELECT_BY_TICKET, MODE_TRADES);
   numType = OrderType();
   if(numType == 0)
      lastOrderType = "OP_BUY";
   if(numType == 1)
      lastOrderType = "OP_SELL";
   if(numType == 2)
      lastOrderType = "OP_BUYLIMIT";
   if(numType == 3)
      lastOrderType = "OP_SELLLIMIT";
   if(numType == 4)
      lastOrderType = "OP_BUYSTOP";
   if(numType == 5)
      lastOrderType = "OP_SELLSTOP";
   return lastOrderType;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string LastTypeClose() //Funcionando
  {
   string lastOrderType = "";
   int numType = -1;
   OrderSelect(LastTicketClose(), SELECT_BY_TICKET, MODE_HISTORY);
   numType = OrderType();
   if(numType == 0)
      lastOrderType = "OP_BUY";
   if(numType == 1)
      lastOrderType = "OP_SELL";
   if(numType == 2)
      lastOrderType = "OP_BUYLIMIT";
   if(numType == 3)
      lastOrderType = "OP_SELLLIMIT";
   if(numType == 4)
      lastOrderType = "OP_BUYSTOP";
   if(numType == 5)
      lastOrderType = "OP_SELLSTOP";
   return lastOrderType;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string OrdenesAbiertas() //Funcionando
  {
   string Abiertas = "\n=====ORDENES ABIERTAS=====\n";
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         Abiertas += "||Ticket: " + OrderTicket() +
                     "||Profit = " + " $ " + NormalizeDouble(OrderProfit(), 2) + " || " + LastOPType(OrderType()) + "\n";
        }
     }
   return Abiertas;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string OrdenesCerradas() //Funcionando
  {
   string Cerradas = "\n=====ULTIMAS 10 ORDENES CERRADAS=====\n";
   for(int i = OrdersHistoryTotal() - 1; i >= OrdersHistoryTotal() - 10; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
        {
         Cerradas += "||Ticket: " + OrderTicket() + "||Profit = " + "$ " +
                     NormalizeDouble(OrderProfit(), 2) +
                     "||Type: " + LastOPType(OrderType()) + "\n";
        }
     }
   return Cerradas;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string OrdenesCerradasSinPendientes() //Funcionando
  {
   string Cerradas = "\n=====ULTIMAS ORDENES CERRADAS=====\n";
   for(int i = OrdersHistoryTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
        {
         if(OrderType() == OP_BUY || OrderType() == OP_SELL)
           {
            Cerradas += "||Ticket: " + OrderTicket() + "||Profit = " + "$ " +
                        NormalizeDouble(OrderProfit(), 2) +
                        "||Type: " + LastOPType(OrderType()) + "\n";
           }
        }
     }
   return Cerradas;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LastOPProfitClose()//Funcionando
  {
   double Last = 0;
   if(OrderSelect(LastTicketClose(), SELECT_BY_TICKET, MODE_HISTORY))
     {
      Last = OrderProfit();
     }
   return Last;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LastOPProfitOpen()//Funcionando
  {
   double Last = 0;
   if(OrderSelect(LastTicketOpen(), SELECT_BY_TICKET, MODE_TRADES))
     {
      Last = OrderProfit();
     }
   return Last;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OpenBuys()
  {
   int nBuys = 0;
   for(int i = OrdersTotal() - 1; i > 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderType() == OP_BUY)
           {
            nBuys++;
           }
        }
     }
   return nBuys;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OpenSells()
  {
   int nSells = 0;
   for(int i = OrdersTotal() - 1; i > 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderType() == OP_SELL)
           {
            nSells++;
           }
        }
     }
   return nSells;
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
double LastOPOpenPrice()//Funcionando
  {
   double Last = 0;
   if(OrderSelect(LastTicketOpen(), SELECT_BY_TICKET, MODE_TRADES))
     {
      Last = NormalizeDouble(OrderOpenPrice(), Digits);
     }
   return Last;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LastOPOpenPriceBS()//Funcionando
  {
   double Last = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderType() == OP_BUY || OrderType() == OP_SELL)
           {
            return Last = OrderOpenPrice();
           }
        }
     }
   return Last;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string LastOPOpenComment()//Funcionando
  {
   string Last = "";
   if(OrderSelect(LastTicketOpen(), SELECT_BY_TICKET, MODE_TRADES))
     {
      if(OrderCloseTime() != 0)
        {
         Last = OrderComment();
        }
     }
   return Last;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ContadorDePendientes()
  {
   int Contador = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP ||
            OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP)
           {
            Contador++;
           }
        }
     }
   return Contador;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LastOPOpenLots()//Funcionando
  {
   double Lots = 0;
   if(OrderSelect(LastTicketOpen(), SELECT_BY_TICKET, MODE_TRADES))
     {
      Lots = NormalizeDouble(OrderLots(), Digits);
     }
   return Lots;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ContadorBS()
  {
   int Contador = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderType() == OP_BUY || OrderType() == OP_SELL)
           {
            Contador++;
           }
        }
     }
   return Contador;
  }
//+------------------------------------------------------------------+
