//+------------------------------------------------------------------+
//|                                              32-FechaHoraDia.mq4 |
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
   string hora;
   string dia;
   hora = Hora();
   dia = Dia();
   
   Comment("La hora es ",hora,
           "\nEl día es ",dia);
  }
//+------------------------------------------------------------------+
string Hora(){
   
   string horaSeg;
   horaSeg= TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS);
   return horaSeg;
}

string Dia(){
   
   int diaS;
   diaS= DayOfWeek();
   
   string dia;
   
   if(diaS ==1)dia="Lunes";
   if(diaS ==2)dia="Martes";
   if(diaS ==3)dia="Miercoles";
   if(diaS ==4)dia="Jueves";
   if(diaS ==5)dia="Viernes";
   if(diaS ==6)dia="Sabado";
   if(diaS ==0)dia="Domingo";  
       
   return dia;
}