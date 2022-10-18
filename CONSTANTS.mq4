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
string ENTER = "\n";
double VlrPunto = MarketInfo(NULL,MODE_POINT);
string SignalAlert = "   /\    "+"\n"+
                     "  /  \   "+"\n"+
                     " /___\  "+"\n";
