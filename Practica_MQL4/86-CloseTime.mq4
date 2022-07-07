//+------------------------------------------------------------------+
//|                                                 86-CloseTime.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Libraries\\david1.mq4"
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
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(OrdersTotal()==0)
     {
      Buy(0.01,200,100);
      Sell(0.01,200,100);
     }
   CheckCloseTime();
  }
//+------------------------------------------------------------------+
void CheckCloseTime()
{
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      datetime MyTime=TimeLocal();
      MqlDateTime MyTimeStruct;
      
      TimeToStruct(MyTime,MyTimeStruct);
      int CurrentHour = MyTimeStruct.hour;
      string TimeWithSeconds = TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS);
      datetime OpenTime = OrderOpenTime();
      datetime CloseTime = OrderCloseTime();
      MqlDateTime MyTimeStructOpen;
      MqlDateTime MyTimeStructClose;
      TimeToStruct(OrderOpenTime(),MyTimeStructOpen);
      TimeToStruct(OrderCloseTime(),MyTimeStructClose);
      string OpenTimeWithSeconds = TimeToString(OrderOpenTime(),TIME_DATE|TIME_SECONDS);
      string CloseTimeWithSeconds = TimeToString(OrderCloseTime(),TIME_DATE|TIME_SECONDS);
      
      Print("### Order Ticket: ",OrderTicket());
      Print("### Order OpenTime: ",OpenTimeWithSeconds);
      Print("### Order CloseTime: ",CloseTimeWithSeconds);
      Print("### Order Profit: ",OrderProfit());
      Print("### Order LocalTime: ",TimeWithSeconds);
     }

}