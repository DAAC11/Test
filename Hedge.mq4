//+------------------------------------------------------------------+
//|                                                        Hedge.mq4 |
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
bool OrdenContraria(int Orden, int MLots, int TGR, int STP)
  {
   bool Activo = false;
   if(OrderSelect(Orden, SELECT_BY_TICKET))
     {
      if(OrderType() == OP_BUY)
        {
         OrderSend(OrderSymbol(), OP_SELL, OrderLots()*MLots, Bid, 5, Bid + (STP * Point)
                   , Bid - (TGR * Point), NULL, 0, 0, clrAqua);
         Activo = true;
        }
      if(OrderType() == OP_SELL)
        {
         OrderSend(OrderSymbol(), OP_BUY, OrderLots()*MLots, Ask, 5,
                   Ask - (STP * Point), Ask + (TGR * Point), NULL, 0, 0, clrAqua);
         Activo = true;
        }
     }
   return Activo;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int HedgeRecoveryZoneBuy(int LastTicket, double LevelBuy,  int Puntos,
                         double MaxLots = 10, double STP = 5)
  {
   int Ticket = -1;
   double Lotaje = -1;
   if(OrderSelect(LastTicket, SELECT_BY_TICKET))
     {
      Lotaje = OrderLots();
     }
   if(Lotaje < MaxLots)
     {
      Ticket = OrderSend(Symbol(), OP_BUYSTOP, Lotaje * 2, LevelBuy, 5,
                         LevelBuy - (Puntos * Point * STP), LevelBuy + (Puntos * Point),
                         NULL, 0, 0, clrAqua);
      Alert("Hedge Buy");
     }
   else
     {
      Alert("Exede el maximo de lotes");
     }
   return Ticket;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int HedgeRecoveryZoneSell(int LastTicket, double LevelSell,
                          int Puntos, double MaxLots = 10, double STP = 5)
  {
   int Ticket = -1;
   double Lotaje = -1;
   if(OrderSelect(LastTicket, SELECT_BY_TICKET))
     {
      Lotaje = OrderLots();
     }
   if(Lotaje < MaxLots)
     {
      Ticket = OrderSend(Symbol(), OP_SELLSTOP, Lotaje * 2, LevelSell, 5,
                         LevelSell + (Puntos * Point * STP), LevelSell - (Puntos * Point),
                         NULL, 0, 0, clrAqua);
      Alert("Hedge Sell");
     }
   else
     {
      Alert("Exede el maximo de lotes");
     }
   return Ticket;
  }


//+------------------------------------------------------------------+
