//+------------------------------------------------------------------+
//|                                                  16-KeyEvent.mq4 |
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
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+
void OnChartEvent(
   const int EventID,
   const long& lparam,
   const double& dparam,
   const string& sparam
)
{
if(EventID == CHARTEVENT_KEYDOWN)
  {
   short LetraPresionada= TranslateKey((int)lparam);
   MessageBox("La tecla "+ShortToString(LetraPresionada),"  fue presionada",MB_OK );
  }
}
//+------------------------------------------------------------------+
