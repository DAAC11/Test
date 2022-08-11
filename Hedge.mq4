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
//| My function                                                      |
//+------------------------------------------------------------------+
// int MyCalculator(int value,int value2) export
//   {
//    return(value+value2);
//   }
//+------------------------------------------------------------------+
bool OrdenContraria(int Orden, int MLots,int TGR,int STP){
   bool Activo = false;
   if(OrderSelect(Orden,SELECT_BY_TICKET))
     {
      if(OrderType()==OP_BUY)
        {
         OrderSend(OrderSymbol(),OP_SELL,OrderLots()*MLots,Bid,5,Bid+(STP*Point)
                   ,Bid-(TGR*Point),NULL,0,0,clrAqua);
         Activo = true;
        }
      if(OrderType()==OP_SELL)
        {
         OrderSend(OrderSymbol(),OP_BUY,OrderLots()*MLots,Ask,5,
                   Ask-(STP*Point),Ask+(TGR*Point),NULL,0,0,clrAqua);
         Activo = true;
        }
      
     }
   return Activo;

}



