//+------------------------------------------------------------------+
//|                                                93-CloseAllEA.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "..\\Libraries\\david1.mq4"
input int Case;
input int STP=1000;
input double MaxFlotante = 20;
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
 
   if(OrdersTotal()<5&&Case==1)
     {
      Buy(0.01,200,STP);
      Sell(0.01,300,STP);
      Buy(0.01,400,STP);
      Sell(0.01,500,STP);
      Buy(0.01,600,STP);
 
     }
   if(OrdersTotal()<5&&Case==2)
     {
       
      Buy(0.01,100,STP);
      Sell(0.02,100,STP);
      Buy(0.03,100,STP);
      Sell(0.04,100,STP);
      Buy(0.05,100,STP);
 
     }
     
   if(OrdersTotal()<10&&Case==3)
     {
       
      Buy(0.01,100,STP);
      Sell(0.01,100,STP);
      Buy(0.01,100,STP);
      Sell(0.01,100,STP);
      Buy(0.01,100,STP);
      Sell(0.01,100,STP);
      Buy(0.01,100,STP);
      Sell(0.01,100,STP);
      Buy(0.01,100,STP);
      Sell(0.01,100,STP);
 
     }
     
   if(OrdersTotal()<5&&Case==4)
     {
       
      Buy(0.06,500,STP);
      Sell(0.05,400,STP);
      Buy(0.04,300,STP);
      Sell(0.03,200,STP);
      Buy(0.02,100,STP);
 
     }
 
   string simbolo ="";
   if(AccountEquity()>AccountBalance())
     {
      CloseAll();
      simbolo= "(+)";
     }else
     {
      simbolo="(-)";
     }
   Comment("AccountEquity =",AccountEquity()-AccountBalance(),simbolo,
   "\nEquity= ",AccountEquity(),
   "\nBalance= ",AccountBalance(),
   "\nOrders= ",OrdersTotal());
  }
//+------------------------------------------------------------------+
void CloseAll(){
for(int i=OrdersTotal();i>=0;i--)
  {
   if(OrderSelect(i,SELECT_BY_POS))
     {
      OrderClose(
      OrderTicket(),
      OrderLots(),
      MarketInfo(OrderSymbol(),MODE_BID),
      5,
      Red
      );
     }
  }

}