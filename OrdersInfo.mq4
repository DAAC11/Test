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
   if(OrderSelect(LastTicketOpen(), SELECT_BY_TICKET, MODE_TRADES))
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
   if(OrderSelect(LastTicketClose(), SELECT_BY_TICKET, MODE_HISTORY))
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
string OrdenesAbiertas(int Mode = 1) //Funcionando
  {
   string Abiertas = "\n=====ORDENES ABIERTAS=====\n";
   if(Mode == 1)
     {
      for(int i = OrdersTotal() - 1; i >= 0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
           {
            Abiertas += "||Ticket: " + IntegerToString(OrderTicket()) +
                        "||Profit = " + " $ " + DoubleToString(NormalizeDouble(OrderProfit(), 2)) + 
                        " || " + LastOPType(OrderType()) + "\n";
           }
        }
     }
   else
     {
      for(int i = OrdersTotal() - 1; i >= 0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
           {
            Abiertas += "||Ticket: " + IntegerToString(OrderTicket() )+
                        "||Profit = " + " $ " + NormalizeDouble(OrderProfit(), 2) +
                        "||Lotes = " + OrderLots() +
                        " || " + LastOPType(OrderType()) + "\n";
           }
        }
     }
   return Abiertas;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string OrdenesCerradas(int Mode = 1) //Funcionando
  {
   string Cerradas = "\n=====ULTIMAS 10 ORDENES CERRADAS=====\n";
   if(Mode == 1)
     {
      for(int i = OrdersHistoryTotal() - 1; i >= OrdersHistoryTotal() - 10; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
           {
            Cerradas += "||Ticket: " + IntegerToString(OrderTicket()) + "||Profit = " + "$ " +
                        NormalizeDouble(OrderProfit(), 2) +
                        "||Type: " + LastOPType(OrderType()) + "\n";
           }
        }
     }
   else
     {
      for(int i = OrdersHistoryTotal() - 1; i >= OrdersHistoryTotal() - 10; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
           {
            Cerradas += "||Ticket: " + OrderTicket() + "||Profit = " + "$ " +
                        NormalizeDouble(OrderProfit(), 2) +
                        "||Lotes = " + OrderLots() +
                        "||Type: " + LastOPType(OrderType()) + "\n";
           }
        }
     }
   return Cerradas;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string OrdenesCerradasSinPendientes(int Mode = 1) //Funcionando
  {
   string Cerradas = "\n=====ULTIMAS ORDENES CERRADAS=====\n";
   if(Mode == 1)
     {
      for(int i = OrdersHistoryTotal() - 1; i >= OrdersHistoryTotal() - 10; i--)
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
     }
   else
     {
      for(int i = OrdersHistoryTotal() - 1; i >= OrdersHistoryTotal() - 10; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
           {
            if(OrderType() == OP_BUY || OrderType() == OP_SELL)
              {
               Cerradas += "||Ticket: " + OrderTicket() + "||Profit = " + "$ " +
                           NormalizeDouble(OrderProfit(), 2) +
                           "||Lotes = " + OrderLots() +
                           "||Type: " + LastOPType(OrderType()) + "\n";
              }
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
//|                                                                  |
//+------------------------------------------------------------------+
bool IsOpen(int Ticket)
  {
   bool Control = false;
   if(OrderSelect(Ticket, SELECT_BY_TICKET))
     {
      if(OrderType() == OP_BUY || OrderType() == OP_SELL)
        {
         return Control = true;
        }
     }
   return Control;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsClose(int Ticket)
  {
   bool Control = false;
   for(int i = OrdersHistoryTotal() - 1; i > 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
        {
         if(OrderTicket() == Ticket)
           {
            return Control = true;
           }
        }
     }
   return Control;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsCloseArray(int &ArrayTickets[])
  {
   for(int i = ArraySize(ArrayTickets) - 1; i >= 0; i--)
     {
      if(IsClose(ArrayTickets[i]))
        {
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToArrayLastTenClosed(int &Closed[])
  {
   ArrayFree(Closed);
   for(int i = OrdersHistoryTotal() - 1; i > OrdersHistoryTotal() - 10; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
        {
         if(OrderType() != OP_BUYSTOP || OrderType() != OP_BUYLIMIT ||
            OrderType() != OP_SELLSTOP || OrderType() != OP_SELLSTOP)
           {
            ArrayResize(Closed, ArraySize(Closed) + 1);
            Closed[ArraySize(Closed) - 1] = OrderTicket();
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToArrayOpenOrders(int &ArrayOpenOrders[])
  {
   ArrayFree(ArrayOpenOrders);
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         ArrayResize(ArrayOpenOrders, ArraySize(ArrayOpenOrders) + 1);
         ArrayOpenOrders[ArraySize(ArrayOpenOrders) - 1] = OrderTicket();
        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
string TypeOpByTicket(int Ticket)
  {
   string Type = "";
   if(OrderSelect(Ticket, SELECT_BY_TICKET))
     {
      Type = OrderType();
     }
   return Type;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LotsOpByTicket(int Ticket)
  {
   double Lots = 0;
   if(OrderSelect(Ticket, SELECT_BY_TICKET))
     {
      Lots = OrderLots();
     }
   return Lots;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ProfitOpByTicket(int Ticket)
  {
   double Profit = 0;
   if(OrderSelect(Ticket, SELECT_BY_TICKET))
     {
      Profit = OrderProfit();
     }
   return Profit;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double InfoByTicket(int Ticket, string Option)
  {
   double Salida = 0;
   if(Option == "OrderProfit")
     {
      if(OrderSelect(Ticket, SELECT_BY_TICKET))
        {
         return Salida = OrderProfit();
        }
     }
   if(Option == "OrderLots")
     {
      if(OrderSelect(Ticket, SELECT_BY_TICKET))
        {
         return Salida = OrderLots();
        }
     }
   if(Option == "OrderOpenPrice")
     {
      if(OrderSelect(Ticket, SELECT_BY_TICKET))
        {
         return Salida = OrderOpenPrice();
        }
     }
   if(Option == "OrderClosePrice")
     {
      if(OrderSelect(Ticket, SELECT_BY_TICKET))
        {
         return Salida = OrderClosePrice();
        }
     }
   if(Option == "OrderTakeProfit")
     {
      if(OrderSelect(Ticket, SELECT_BY_TICKET))
        {
         return Salida = OrderTakeProfit();
        }
     }
   if(Option == "OrderStopLoss")
     {
      if(OrderSelect(Ticket, SELECT_BY_TICKET))
        {
         return Salida = OrderStopLoss();
        }
     }
   return -1;
  }
//+------------------------------------------------------------------+
string RecoveryInfo(int TicketInicial, int &ArrayHedgeTicket[])
  {
//Acumuladores
   string Inicial = "";
   string Info = "";
   string Buys = "";
   string Sells = "";
   int CountBuys = 0;
   int CountSells = 0;
   string Pendientes = "";
   double TotalProfit = 0;
   double TotalLots = 0;
   double BuyLots = 0;
   double BuyProfits = 0;
   double SellLots = 0;
   double SellProfits = 0;
   string E = "\n";
   string S = " || ";
   string B = "       ";
   string Dibujo = "";
//InFo Ticket Inicial
   if(TypeOpByTicket(TicketInicial) == OP_BUY)
     {
      if(OrderSelect(TicketInicial, SELECT_BY_TICKET))
        {
         Inicial += "Ticcket " + OrderTicket() + "||" + LastOPType(OrderTicket()) + "||" +
                    "$" + NormalizeDouble(OrderProfit(), Digits);
         Buys = OrderTicket() + "||" +
                "$" + NormalizeDouble(OrderProfit(), Digits) + "\n";
         TotalProfit += NormalizeDouble(OrderProfit(), Digits);
         BuyProfits += NormalizeDouble(OrderProfit(), Digits);
         TotalLots += OrderLots();
         BuyLots += OrderLots();
         CountBuys++;
        }
     }
   else
      if(TypeOpByTicket(TicketInicial) == OP_SELL)
        {
         if(OrderSelect(TicketInicial, SELECT_BY_TICKET))
           {
            Inicial += "Ticcket " + OrderTicket() + "||" + LastOPType(OrderTicket()) + "||" +
                       "$" + NormalizeDouble(OrderProfit(), Digits) + "||";
            Sells = OrderTicket() + "||" +
                    "$" + NormalizeDouble(OrderProfit(), Digits) + "\n";
            TotalProfit += NormalizeDouble(OrderProfit(), Digits);
            SellProfits += NormalizeDouble(OrderProfit(), Digits);
            TotalLots += OrderLots();
            SellLots += OrderLots();
            CountSells++;
           }
        }
//Info Array
   for(int i = ArraySize(ArrayHedgeTicket) - 1; i >= 0; i--)
     {
      if(OrderSelect(ArrayHedgeTicket[i], SELECT_BY_TICKET))
        {
         if(OrderType() == OP_BUY)
           {
            Buys += OrderTicket() + "||" +
                    "$" + NormalizeDouble(OrderProfit(), Digits) + "\n" + B;
            TotalProfit += NormalizeDouble(OrderProfit(), Digits);
            BuyProfits += NormalizeDouble(OrderProfit(), Digits);
            TotalLots += OrderLots();
            BuyLots += OrderLots();
            CountBuys++;
           }
         else
            if(OrderType() == OP_SELL)
              {
               Sells += OrderTicket() + "||" +
                        "$" + NormalizeDouble(OrderProfit(), Digits) + "\n" + B;
               TotalProfit += NormalizeDouble(OrderProfit(), Digits);
               SellProfits += NormalizeDouble(OrderProfit(), Digits);
               TotalLots += OrderLots();
               SellLots += OrderLots();
               CountSells++;
              }
            else
               if(OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT ||
                  OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP)
                 {
                  Pendientes = LastOPType(OrderTicket()) + "||" +
                               "$" + NormalizeDouble(OrderProfit(), Digits);
                 }
        }
     }
//Dibujo
   if(TotalProfit > 0)
     {
      Dibujo = B + B + B + "  /\  " + E +
               B + B + B + " /||\ " + E +
               B + B + B + "  || " + E +
               B + B + B + "  || ";
     }
   else
     {
      Dibujo = B + B + B + "  || " + E +
               B + B + B + "  || " + E +
               B + B + B + " \||/ " + E +
               B + B + B + "  \/   ";
     }
//Salida de datos
   string Salida = B + "=====Recovery=====" + E +
                   B + "Orden Inical= " + Inicial + E +
                   B + "========Buys=======" + E +
                   B + "OpenBuys = " + CountBuys + S +
                   " Profit = $" + NormalizeDouble(BuyProfits, Digits) + S +
                   " Lots = " + BuyLots + E +
                   B + Buys +
                   B + "=======Sells=======" + E +
                   B + "OpenSells = " + CountSells + S +
                   " Profit = $" + NormalizeDouble(SellProfits, Digits) + S +
                   " Lots = " + DoubleToString(SellLots) + E +
                   B + Sells +
                   B + "=====Resumen====" + E +
                   B + "Lots = " + NormalizeDouble(TotalLots, Digits) +
                   B + "Profit = $" + NormalizeDouble(TotalProfit, Digits) + E +
                   Dibujo ;
   return Salida;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
