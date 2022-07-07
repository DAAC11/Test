//+------------------------------------------------------------------+
//|                                        54-SimpleColorChanger.mq4 |
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
   if(Close[2]<Close[1])
     {
      ChartSetInteger(NULL,CHART_COLOR_CANDLE_BULL,clrGreen);// color del cuerpo de la vela
      ChartSetInteger(NULL,CHART_COLOR_CANDLE_BEAR,clrGreen);// 
      ChartSetInteger(NULL,CHART_COLOR_CHART_UP,clrGreen);// 
      ChartSetInteger(NULL,CHART_COLOR_CHART_DOWN,clrGreen);//
      ChartSetInteger(NULL,CHART_MODE,CHART_BARS);// 
      ChartSetInteger(NULL,CHART_SHOW_GRID,true);
      ChartSetInteger(NULL,CHART_COLOR_FOREGROUND,clrYellow);
      ChartSetInteger(NULL,CHART_COLOR_BACKGROUND,clrBlack);
     }
     
    if(Close[2]>Close[1])
     {
      ChartSetInteger(NULL,CHART_COLOR_CANDLE_BULL,clrRed);// color del cuerpo de la vela
      ChartSetInteger(NULL,CHART_COLOR_CANDLE_BEAR,clrRed);// 
      ChartSetInteger(NULL,CHART_COLOR_CHART_UP,clrRed);// 
      ChartSetInteger(NULL,CHART_COLOR_CHART_DOWN,clrRed);//
      ChartSetInteger(NULL,CHART_MODE,CHART_CANDLES);// 
      ChartSetInteger(NULL,CHART_SHOW_GRID,false);
      ChartSetInteger(NULL,CHART_COLOR_FOREGROUND,clrMagenta);
      ChartSetInteger(NULL,CHART_COLOR_BACKGROUND,clrWhite);
     }
   
   
   double MaxPrice = ChartGetDouble(NULL,CHART_PRICE_MAX,0);
   double MinPrice = ChartGetDouble(NULL,CHART_PRICE_MIN,0);
   
   Comment("max ", MaxPrice,
           "\nmin ",MinPrice);
  }
//+------------------------------------------------------------------+
