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