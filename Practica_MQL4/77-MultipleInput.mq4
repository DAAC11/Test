//+------------------------------------------------------------------+
//|                                             77-MultipleInput.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
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
enum Datos // lista
  {
   RANDOM=0,
   EMA=1,
   TRIX=2,
   ADX=3,
   MOM=4,
   TREND=5,
  };
  
input Datos Choice=RANDOM;

string Entry;
void OnTick()
  {
   if(Choice==0)Entry="RANDOM";
   if(Choice==1)Entry="EMA";
   if(Choice==2)Entry="TRIX";  
   if(Choice==3)Entry="ADX";   
   if(Choice==4)Entry="MOM"; 
   if(Choice==5)Entry="TREND";
   
   
   Comment("Entry: ",Entry,"\n",
           "Choice: ",Choice);
  }
//+------------------------------------------------------------------+
