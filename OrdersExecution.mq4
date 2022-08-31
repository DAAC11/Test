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
//|                                                                  |
//+------------------------------------------------------------------+
int Buy(double Lots, double Target, double Stop) //Funcionando
  {
   int O = OrderSend(NULL, OP_BUY, Lots, Ask, 3, Ask - (Stop * Point), Ask + (Target * Point), NULL, 3, 0, clrGreen);
   return O;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Sell_STP(double Lots, double OpenPrice, double Target, double Stop,  string Comentario) //Funcionando
  {
   int V = OrderSend(NULL, OP_SELLSTOP, Lots, OpenPrice, 3, Stop, Target, Comentario, 3, 0, clrRed);
   return V;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Buy_STP(double Lots, double OpenPrice, double Target, double Stop,  string Comentario) //Funcionando
  {
   int O = OrderSend(NULL, OP_BUYSTOP, Lots, OpenPrice, 3, Stop, Target, Comentario, 3, 0, clrGreen);
   return O;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Sell_LMT(double Lots, double OpenPrice, double Target, double Stop, string Comentario) //Funcionando
  {
   int V = OrderSend(NULL, OP_SELLLIMIT, Lots, OpenPrice, 3, Stop, Target, Comentario, 3, 0, clrRed);
   return V;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Buy_LMT(double Lots, double OpenPrice, double Target, double Stop, string Comentario) //Funcionando
  {
   int O = OrderSend(NULL, OP_BUYLIMIT, Lots, OpenPrice, 3, Stop, Target, Comentario, 3, 0, clrGreen);
   return O;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Sell(double Lots, double Target, double Stop) //Funcionando
  {
   int V = OrderSend(NULL, OP_SELL, Lots, Bid, 3, Bid + (Stop * Point), Bid - (Target * Point), NULL, 3, 0, clrRed);
   return V;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BE(int Ticket, double puntos)
  {
   if(OrderSelect(Ticket, SELECT_BY_TICKET))
     {
      if(OrderType() == OP_BUY)
        {
         if(OrderStopLoss() < OrderOpenPrice())
           {
            OrderModify(OrderTicket(),
                        OrderOpenPrice(),
                        (OrderOpenPrice() + (puntos * Point())),
                        OrderTakeProfit(),
                        0,
                        clrAquamarine);
           }
        }
      /*else
        {
         Print(GetLastError());
        }*/
      if(OrderType() == OP_SELL)
        {
         if(OrderStopLoss() > OrderOpenPrice())
           {
            OrderModify(OrderTicket(),
                        OrderOpenPrice(),
                        (OrderOpenPrice() - (puntos * Point())),
                        OrderTakeProfit(),
                        0,
                        clrAquamarine);
           }
        }
      /*else
        {
         Print(GetLastError());
        }*/
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TRSTP(int Ticket, double puntos)
  {
   if(OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES))
     {
      if(OrderSymbol() == Symbol())
        {
         if(OrderType() == OP_BUY)
           {
            if(OrderStopLoss() < Ask - (puntos * Point))
              {
               OrderModify(
                  OrderTicket(),
                  OrderOpenPrice(),
                  Ask - (puntos * Point),
                  OrderTakeProfit(),
                  0, Blue);
              }
           }
        }
     }
   if(OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES))
     {
      if(OrderSymbol() == Symbol())
        {
         if(OrderType() == OP_SELL)
           {
            if(OrderStopLoss() > Bid + (puntos * Point))
              {
               OrderModify(
                  OrderTicket(),
                  OrderOpenPrice(),
                  Bid + (puntos * Point),
                  OrderTakeProfit(),
                  0, Blue);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LiquidadorBuy()
  {
   for(int i = OrdersTotal() - 1; i > 0; i--)
     {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderType() == OP_BUY)
        {
         OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrWhite);
         Print("Liquidador Buy");
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LiquidadorSell()
  {
   for(int i = OrdersTotal() - 1; i > 0; i--)
     {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderType() == OP_SELL)
        {
         OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrMaroon);
         Print("Liquidador Sell");
        }
     }
  }
//+------------------------------------------------------------------+
