//+------------------------------------------------------------------+
//|                                                33-TimerClose.mq4 |
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
      OrderSend(NULL,OP_SELL,0.01,Bid,3,0,Bid-(300*Point),NULL,3,0,clrRed);
      OrderSend(NULL,OP_BUY,0.01,Ask,3,0,Ask+(300*Point),NULL,3,0,clrGreen);
     }
   
   CloseTimer();   
    
  }
//+------------------------------------------------------------------+
void CloseTimer(){

for(int i=OrdersTotal()-1;i>=0;i--)
  {
   OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
   datetime horalocal =TimeLocal();
   MqlDateTime horaArray;
   
   TimeToStruct(horalocal,horaArray);
   
   int horaActual=horaArray.hour;
   string hora = TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS);
   datetime horaApertura = OrderOpenTime();
   
   MqlDateTime horaOpenArray;
   
   TimeToStruct(OrderOpenTime(),horaOpenArray);
   
   int HApertura = horaOpenArray.hour;
   
   string apertura = TimeToStr(OrderOpenTime(),TIME_DATE|TIME_SECONDS);
   
   int diff =horaActual-HApertura;
   
   Print("### Order Ticket: ",OrderTicket());
   Print("### Order OpenTime: ",OrderOpenTime());
   Print("### Order Profit: ",OrderProfit());
   Print("### Order LocalTime: ",hora);
   Print("### Order Difference: ",diff);
   
   
   if(diff>0)
     {
      if(OrderProfit()<0&&OrderType()==OP_SELL)
        {
         OrderClose(OrderTicket(),OrderLots(),Ask,10,NULL);
        }
      if(OrderProfit()<0&&OrderType()==OP_BUY){
         
         OrderClose(OrderTicket(),OrderLots(),Bid,10,NULL);
      
      }
      
     }
  }
}