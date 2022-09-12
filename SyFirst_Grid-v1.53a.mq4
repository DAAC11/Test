//+------------------------------------------------------------------+
//|                                           SyFrist_Grid-v1.53.mq4 |
//|                                                       Symphoenix |
//+------------------------------------------------------------------+

#property copyright "Symphoenix"

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+

//--------------------------------------------------------------------  Definition des Parametres Externes

extern string TimeFrames="Define TF Considered";
extern int TimeFrame_1 = 1;
extern int TimeFrame_2 = 5;
extern int TimeFrame_3 = 30;
extern string Lot_Size_Info_1="Define Lot Size By User";
extern double Lot_Size = 0.1;
extern string Lot_Size_Info_2="Define Lot Size By MM";
extern int Money_Management = 0;
extern int FxPro_Money_Management = 1;
extern double Margin_Percent = 2.5;
extern string Capitalizing_Info="Increase Positions";
extern int Capitalizing = 0;
extern string Timing_Info="Define Timing Infos";
extern int Action_Window_Min = 15;
extern int SleepTime_Min = 5;
extern int Always_On = 1;
extern int StartHour = 1;
extern int EndHour = 23;
extern string Email="Send an Email When Opening/Closing";
extern int Send_Email = 1;
extern string Log_Info="Write a CSV File With Today's Results";
extern int Logging = 1;
extern string Alert_Info="Verbose";
extern int Alert_Popping = 0;
extern string Magic_Numbers="Define Magic Numbers";
extern int MN_Sell_Primary_1 = 16400;
extern int MN_Buy_Primary_1 = 16401;
extern int MN_Sell_Protection = 16412;
extern int MN_Buy_Protection = 16413;
extern int MN_Sell_Intermediary_Protection = 16422;
extern int MN_Buy_Intermediary_Protection = 16423;
extern int MN_Sell_Capitalizing = 16432;
extern int MN_Buy_Capitalizing = 16433;
extern int MN_Sell_Ultimate_Protection = 16442;
extern int MN_Buy_Ultimate_Protection = 16443;

//----------------------------------------------------------------------  Fonction Init

int init()
{

return(0);

}

//----------------------------------------------------------------------  Fonction Deinit

int deinit()                                  
{

if(ObjectFind("Framework")>=0)
  ObjectDelete("Framework");
if(ObjectFind("Target_for_Protection_High")>=0)
  ObjectDelete("Target_for_Protection_High");
if(ObjectFind("Target_for_Protection_Low")>=0)
  ObjectDelete("Target_for_Protection_Low");

return(0);                               

}

//----------------------------------------------------------------------  Fonction Start

int start()
{

//------------------------ Mise en place du Cache pour Lisibilite

string label_name="Framework"; 
   if(ObjectFind(label_name)<0) 
     { 
      //--- create Label object 
      ObjectCreate(0,label_name,OBJ_RECTANGLE_LABEL,0,0,0);            
      //--- set X coordinate 
      ObjectSetInteger(0,label_name,OBJPROP_XDISTANCE,1); 
      //--- set Y coordinate 
      ObjectSetInteger(0,label_name,OBJPROP_YDISTANCE,30);
      //--- set X size 
      ObjectSetInteger(0,label_name,OBJPROP_XSIZE,225); 
      //--- set Y size 
      ObjectSetInteger(0,label_name,OBJPROP_YSIZE,535);
      //--- define background color 
      ObjectSetInteger(0,label_name,OBJPROP_BGCOLOR,clrDarkBlue); 
      //--- define text for object Label 
      ObjectSetString(0,label_name,OBJPROP_TEXT,"Cache");    
      //--- disable for mouse selecting 
      ObjectSetInteger(0,label_name,OBJPROP_SELECTABLE,0);
      //--- set the style of rectangle lines 
      ObjectSetInteger(0,label_name,OBJPROP_STYLE,STYLE_SOLID);
      //--- define border type 
      ObjectSetInteger(0,label_name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
      //--- define border width 
      ObjectSetInteger(0,label_name,OBJPROP_WIDTH,1); 
      //--- draw it on the chart 
      ChartRedraw(0);
     }

//----------------------------------------------------------------------  Vérification Crédit

static int Balance_OK;

if(AccountBalance()>100)
  Balance_OK=1;

if(AccountBalance()<100 && Balance_OK==1)
  {
  if(Send_Email==1)
    SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, malheureusement, chez " + TerminalCompany() + ", la pompe était sous l'oreiller." + "\r\n" + "It's been emotionnal !");
  Balance_OK=0;
  }

if(AccountBalance()<100 && Balance_OK==0)
  return(0);
  
//----------------------------------------------------------------------  Protection Solde Négatif

double Equity, Equity_Limit;
int h;
bool OrderSell_Closing=False;
bool OrderBuy_Closing=False;
int Order_Number = 0;
static int Status_EU_M5M30, Strategy_Used, Defcon=5;
static double Lot_Size_Adjusted;

Equity=NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY), 2);
Equity_Limit=NormalizeDouble((AccountBalance()/100*3), 2);

if(Equity<Equity_Limit)
{
  for(h=OrdersTotal()-1;h>=0;h--)
  {

   if(OrderSelect(h,SELECT_BY_POS, MODE_TRADES)==true)
    {
        
    if(OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Sell_Protection || OrderMagicNumber()==MN_Sell_Capitalizing || OrderMagicNumber()==MN_Sell_Intermediary_Protection || OrderMagicNumber()==MN_Sell_Ultimate_Protection)
      {
      Order_Number=OrderTicket();
      while(OrderSell_Closing!=True)
        {  
        RefreshRates();
        OrderSell_Closing=OrderClose(Order_Number,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
        }
      if(OrderSell_Closing==True)
        {
        if(Alert_Popping==1)
          Alert("SyFirst_Grid : Cloture immediate de #", Order_Number);
        Status_EU_M5M30=0;
        Lot_Size_Adjusted=0;
        Strategy_Used=0;
        if(ObjectFind("Target_for_Protection_High")>=0)
          ObjectDelete("Target_for_Protection_High");
        if(ObjectFind("Target_for_Protection_Low")>=0)
          ObjectDelete("Target_for_Protection_Low");
        }
      if(OrderSell_Closing==False && Alert_Popping==1)
        Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
      }
    
    if(OrderMagicNumber()==MN_Buy_Primary_1 || OrderMagicNumber()==MN_Buy_Protection || OrderMagicNumber()==MN_Buy_Capitalizing || OrderMagicNumber()==MN_Buy_Intermediary_Protection || OrderMagicNumber()==MN_Buy_Ultimate_Protection)
      {
      Order_Number=OrderTicket();
      while(OrderBuy_Closing!=True)
        {  
        RefreshRates();
        OrderBuy_Closing=OrderClose(Order_Number,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
        }
      if(OrderBuy_Closing==True)
        {
        if(Alert_Popping==1)
          Alert("SyFirst_Grid : Cloture immediate de #", Order_Number);
        Status_EU_M5M30=0;
        Lot_Size_Adjusted=0;
        Strategy_Used=0;
        if(ObjectFind("Target_for_Protection_High")>=0)
          ObjectDelete("Target_for_Protection_High");
        if(ObjectFind("Target_for_Protection_Low")>=0)
          ObjectDelete("Target_for_Protection_Low");
        }
      if(OrderBuy_Closing==False && Alert_Popping==1)
        Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
      }    
    }

  }

  if(OrderSell_Closing==True || OrderBuy_Closing==True)
    {
    Balance_OK=0;
    Defcon=0;
    if(Send_Email==1)
      SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, malheureusement, chez " + TerminalCompany() + ", la pompe était sous l'oreiller." + "\r\n" + "It's been emotionnal !");
    }

}

//----------------------------------------------------------------------  Definition Variables

double M5_Gravity_1_Positif = iCustom(NULL, TimeFrame_1, "Center_of_Gravity_1", 200, 4, 0, 2.0, 500, 1, 0);
double M5_Gravity_1_Negatif = iCustom(NULL, TimeFrame_1, "Center_of_Gravity_1", 200, 4, 0, 2.0, 500, 2, 0);
double M5_Gravity_2_Positif = iCustom(NULL, TimeFrame_1, "Center_of_Gravity_1", 200, 4, 0, 3.0, 500, 1, 0);
double M5_Gravity_2_Negatif = iCustom(NULL, TimeFrame_1, "Center_of_Gravity_1", 200, 4, 0, 3.0, 500, 2, 0);
double M5_Gravity_3_Positif = iCustom(NULL, TimeFrame_1, "Center_of_Gravity_1", 200, 4, 0, 4.0, 500, 1, 0);
double M5_Gravity_3_Negatif = iCustom(NULL, TimeFrame_1, "Center_of_Gravity_1", 200, 4, 0, 4.0, 500, 2, 0);
double M5_Gravity_0 = iCustom(NULL, TimeFrame_1, "Center_of_Gravity_1", 200, 4, 0, 3.0, 500, 0, 0);
double M5_Gravity_0_T1 = iCustom(NULL, TimeFrame_1, "Center_of_Gravity_1", 200, 4, 0, 3.0, 500, 0, 1);
double M5_Gravity_0_T2 = iCustom(NULL, TimeFrame_1, "Center_of_Gravity_1", 200, 4, 0, 3.0, 500, 0, 4);
double M30_Gravity_1_Positif = iCustom(NULL, TimeFrame_2, "Center_of_Gravity_1", 500, 4, 0, 1.2, 500, 1, 0);
double M30_Gravity_1_Negatif = iCustom(NULL, TimeFrame_2, "Center_of_Gravity_1", 500, 4, 0, 1.2, 500, 2, 0);
double M30_Gravity_2_Positif = iCustom(NULL, TimeFrame_2, "Center_of_Gravity_1", 500, 4, 0, 2.2, 500, 1, 0);
double M30_Gravity_2_Negatif = iCustom(NULL, TimeFrame_2, "Center_of_Gravity_1", 500, 4, 0, 2.2, 500, 2, 0);
double M30_Gravity_3_Positif = iCustom(NULL, TimeFrame_2, "Center_of_Gravity_1", 500, 4, 0, 3.4, 500, 1, 0);
double M30_Gravity_3_Negatif = iCustom(NULL, TimeFrame_2, "Center_of_Gravity_1", 500, 4, 0, 3.4, 500, 2, 0);
double M30_Gravity_0 = iCustom(NULL, TimeFrame_2, "Center_of_Gravity_1", 500, 4, 0, 3.0, 500, 0, 0);
double M30_Gravity_0_T1 = iCustom(NULL, TimeFrame_2, "Center_of_Gravity_1", 500, 4, 0, 3.0, 500, 0, 1);
double M30_Gravity_0_T2 = iCustom(NULL, TimeFrame_2, "Center_of_Gravity_1", 500, 4, 0, 3.0, 500, 0, 4);
double M30Y_Gravity_1_Positif = iCustom(NULL, TimeFrame_3, "Center_of_Gravity_1", 200, 4, 0, 1.0, 500, 1, 0);
double M30Y_Gravity_1_Negatif = iCustom(NULL, TimeFrame_3, "Center_of_Gravity_1", 200, 4, 0, 1.0, 500, 2, 0);
double M30Y_Gravity_2_Positif = iCustom(NULL, TimeFrame_3, "Center_of_Gravity_1", 200, 4, 0, 2.2, 500, 1, 0);
double M30Y_Gravity_2_Negatif = iCustom(NULL, TimeFrame_3, "Center_of_Gravity_1", 200, 4, 0, 2.2, 500, 2, 0);
double M30Y_Gravity_3_Positif = iCustom(NULL, TimeFrame_3, "Center_of_Gravity_1", 200, 4, 0, 3.4, 500, 1, 0);
double M30Y_Gravity_3_Negatif = iCustom(NULL, TimeFrame_3, "Center_of_Gravity_1", 200, 4, 0, 3.4, 500, 2, 0);
double M30Y_Gravity_0 = iCustom(NULL, TimeFrame_3, "Center_of_Gravity_1", 200, 4, 0, 3.0, 500, 0, 0);
double M30Y_Gravity_0_T1 = iCustom(NULL, TimeFrame_3, "Center_of_Gravity_1", 200, 4, 0, 3.0, 500, 0, 1);
double M30Y_Gravity_0_T2 = iCustom(NULL, TimeFrame_3, "Center_of_Gravity_1", 200, 4, 0, 3.0, 500, 0, 4);

double BBflat_sw_M5_T1;
double BBflat_Signal_Plus_M5_T1;
double BBflat_Signal_Minus_M5_T1;
double BBflat_sw_M30_T1;
double BBflat_Signal_Plus_M30_T1;
double BBflat_Signal_Minus_M30_T1;
double BBflat_sw_M30Y_T1;
double BBflat_Signal_Plus_M30Y_T1;
double BBflat_Signal_Minus_M30Y_T1;
double BBflat_sw_M5_T2;
double BBflat_Signal_Plus_M5_T2;
double BBflat_Signal_Minus_M5_T2;
double BBflat_sw_M30_T2;
double BBflat_Signal_Plus_M30_T2;
double BBflat_Signal_Minus_M30_T2;
double BBflat_sw_M30Y_T2;
double BBflat_Signal_Plus_M30Y_T2;
double BBflat_Signal_Minus_M30Y_T2;

double Stochastic_Line_M5, Stochastic_Line_M30Y;

BBflat_sw_M5_T1=iCustom(NULL,TimeFrame_1,"BBflat_sw",15,0,3,1,1.4,3,1);
BBflat_Signal_Plus_M5_T1=iCustom(NULL,TimeFrame_1,"BBflat_sw",15,0,3,1,1.4,1,1);
BBflat_Signal_Minus_M5_T1=iCustom(NULL,TimeFrame_1,"BBflat_sw",15,0,3,1,1.4,2,1);

BBflat_sw_M30_T1=iCustom(NULL,TimeFrame_2,"BBflat_sw",15,0,0,0,1.5,3,1);
BBflat_Signal_Plus_M30_T1=iCustom(NULL,TimeFrame_2,"BBflat_sw",15,0,0,0,1.5,1,1);
BBflat_Signal_Minus_M30_T1=iCustom(NULL,TimeFrame_2,"BBflat_sw",15,0,0,0,1.5,2,1);

BBflat_sw_M30Y_T1=iCustom(NULL,TimeFrame_3,"BBflat_sw",15,0,0,0,1.5,3,1);
BBflat_Signal_Plus_M30Y_T1=iCustom(NULL,TimeFrame_3,"BBflat_sw",15,0,0,0,1.5,1,1);
BBflat_Signal_Minus_M30Y_T1=iCustom(NULL,TimeFrame_3,"BBflat_sw",15,0,0,0,1.5,2,1);

BBflat_sw_M5_T2=iCustom(NULL,TimeFrame_1,"BBflat_sw",15,0,3,1,1.4,3,2);
BBflat_Signal_Plus_M5_T2=iCustom(NULL,TimeFrame_1,"BBflat_sw",15,0,3,1,1.4,1,2);
BBflat_Signal_Minus_M5_T2=iCustom(NULL,TimeFrame_1,"BBflat_sw",15,0,3,1,1.4,2,2);

BBflat_sw_M30_T2=iCustom(NULL,TimeFrame_2,"BBflat_sw",15,0,0,0,1.5,3,2);
BBflat_Signal_Plus_M30_T2=iCustom(NULL,TimeFrame_2,"BBflat_sw",15,0,0,0,1.5,1,2);
BBflat_Signal_Minus_M30_T2=iCustom(NULL,TimeFrame_2,"BBflat_sw",15,0,0,0,1.5,2,2);

BBflat_sw_M30Y_T2=iCustom(NULL,TimeFrame_3,"BBflat_sw",15,0,0,0,1.5,3,2);
BBflat_Signal_Plus_M30Y_T2=iCustom(NULL,TimeFrame_3,"BBflat_sw",15,0,0,0,1.5,1,2);
BBflat_Signal_Minus_M30Y_T2=iCustom(NULL,TimeFrame_3,"BBflat_sw",15,0,0,0,1.5,2,2);

Stochastic_Line_M5=iStochastic(NULL,TimeFrame_1,12,6,6,2,0,0,1);
Stochastic_Line_M30Y=iStochastic(NULL,TimeFrame_3,12,6,6,2,0,0,1);

double Profit = 0;
double SL_SELL = 0;
double SL_BUY = 0;

double ATR_M30;

if(TimeFrame_1>1 && TimeFrame_2>5)
ATR_M30 = iCustom(NULL,TimeFrame_2,"ATR",20,0,0);

if(TimeFrame_1==1 && TimeFrame_2==5)
ATR_M30 = iCustom(NULL,TimeFrame_2,"ATR",10,0,0);

double Price = 0;
int Trend_M5, Trend_M30, Trend_M30Y;
int Trend_Global = 0;
bool TS_1=False;
bool TS_2=False;
bool Hline=False;
datetime ActualTime;
string Power;
string Order_Type = "NONE";
string Comments;
string Strategy_Used_Alternate;
int M5, M30, M30Y, BBflat_Verdict_M1, BBflat_Verdict_M30, BBflat_Verdict_M30Y, BBflat_Verdict_M5_T2, BBflat_Verdict_M30_T2, BBflat_Verdict_M30Y_T2, Countdown_Minutes, Countdown_Seconds;
int OCHP = 0;
static int UpdatedOrderTime_EU_M5M30;
static double TS_Status;
static double ATR_M30_Static;

//---------------------------------------------------------------------  Definition Grille de Lecture

//--------  Reperage des Zones d'Activite

if(Bid>M5_Gravity_0 && Bid<M5_Gravity_1_Positif)
  M5=1;
if(Bid>M30_Gravity_0 && Bid<M30_Gravity_1_Positif)
  M30=1;
if(Bid>M30Y_Gravity_0 && Bid<M30Y_Gravity_1_Positif)
  M30Y=1;  
if(Bid>M5_Gravity_1_Positif && Bid<M5_Gravity_2_Positif)
  M5=2;
if(Bid>M30_Gravity_1_Positif && Bid<M30_Gravity_2_Positif)
  M30=2;
if(Bid>M30Y_Gravity_1_Positif && Bid<M30Y_Gravity_2_Positif)
  M30Y=2;
if(Bid>M5_Gravity_2_Positif && Bid<M5_Gravity_3_Positif)
  M5=3;
if(Bid>M30_Gravity_2_Positif && Bid<M30_Gravity_3_Positif)
  M30=3;
if(Bid>M30Y_Gravity_2_Positif && Bid<M30Y_Gravity_3_Positif)
  M30Y=3;
if(Bid>M5_Gravity_3_Positif)
  M5=4;
if(Bid>M30_Gravity_3_Positif)
  M30=4;
if(Bid>M30Y_Gravity_3_Positif)
  M30Y=4;
if(Bid<M5_Gravity_0 && Bid>M5_Gravity_1_Negatif)
  M5=-1;
if(Bid<M30_Gravity_0 && Bid>M30_Gravity_1_Negatif)
  M30=-1;
if(Bid<M30Y_Gravity_0 && Bid>M30Y_Gravity_1_Negatif)
  M30Y=-1;
if(Bid<M5_Gravity_1_Negatif && Bid>M5_Gravity_2_Negatif)
  M5=-2;
if(Bid<M30_Gravity_1_Negatif && Bid>M30_Gravity_2_Negatif)
  M30=-2;
if(Bid<M30Y_Gravity_1_Negatif && Bid>M30Y_Gravity_2_Negatif)
  M30Y=-2;
if(Bid<M5_Gravity_2_Negatif && Bid>M5_Gravity_3_Negatif)
  M5=-3;
if(Bid<M30_Gravity_2_Negatif && Bid>M30_Gravity_3_Negatif)
  M30=-3;
if(Bid<M30Y_Gravity_2_Negatif && Bid>M30Y_Gravity_3_Negatif)
  M30Y=-3;
if(Bid<M5_Gravity_3_Negatif)
  M5=-4;
if(Bid<M30_Gravity_3_Negatif)
  M30=-4;
if(Bid<M30Y_Gravity_3_Negatif)
  M30Y=-4;

//----------  Analyse de la Volatilite

if(BBflat_sw_M5_T1<=BBflat_Signal_Plus_M5_T1 && BBflat_sw_M5_T1>=BBflat_Signal_Minus_M5_T1)
  BBflat_Verdict_M1=0;
if(BBflat_sw_M5_T1>BBflat_Signal_Plus_M5_T1)
  BBflat_Verdict_M1=1;
if(BBflat_sw_M5_T1<BBflat_Signal_Minus_M5_T1)
  BBflat_Verdict_M1=-1;
  
if(BBflat_sw_M30_T1<=BBflat_Signal_Plus_M30_T1 && BBflat_sw_M30_T1>=BBflat_Signal_Minus_M30_T1)
  BBflat_Verdict_M30=0;
if(BBflat_sw_M30_T1>BBflat_Signal_Plus_M30_T1)
  BBflat_Verdict_M30=1;
if(BBflat_sw_M30_T1<BBflat_Signal_Minus_M30_T1)
  BBflat_Verdict_M30=-1;
  
if(BBflat_sw_M30Y_T1<=BBflat_Signal_Plus_M30Y_T1 && BBflat_sw_M30Y_T1>=BBflat_Signal_Minus_M30Y_T1)
  BBflat_Verdict_M30Y=0;
if(BBflat_sw_M30Y_T1>BBflat_Signal_Plus_M30Y_T1)
  BBflat_Verdict_M30Y=1;
if(BBflat_sw_M30Y_T1<BBflat_Signal_Minus_M30Y_T1)
  BBflat_Verdict_M30Y=-1;
  
if(BBflat_sw_M5_T2<=BBflat_Signal_Plus_M5_T2 && BBflat_sw_M5_T2>=BBflat_Signal_Minus_M5_T2)
  BBflat_Verdict_M5_T2=0;
if(BBflat_sw_M5_T2>BBflat_Signal_Plus_M5_T2)
  BBflat_Verdict_M5_T2=1;
if(BBflat_sw_M5_T2<BBflat_Signal_Minus_M5_T2)
  BBflat_Verdict_M5_T2=-1;
  
if(BBflat_sw_M30_T2<=BBflat_Signal_Plus_M30_T2 && BBflat_sw_M30_T2>=BBflat_Signal_Minus_M30_T2)
  BBflat_Verdict_M30_T2=0;
if(BBflat_sw_M30_T2>BBflat_Signal_Plus_M30_T2)
  BBflat_Verdict_M30_T2=1;
if(BBflat_sw_M30_T2<BBflat_Signal_Minus_M30_T2)
  BBflat_Verdict_M30_T2=-1;
  
if(BBflat_sw_M30Y_T2<=BBflat_Signal_Plus_M30Y_T2 && BBflat_sw_M30Y_T2>=BBflat_Signal_Minus_M30Y_T2)
  BBflat_Verdict_M30Y_T2=0;
if(BBflat_sw_M30Y_T2>BBflat_Signal_Plus_M30Y_T2)
  BBflat_Verdict_M30Y_T2=1;
if(BBflat_sw_M30Y_T2<BBflat_Signal_Minus_M30Y_T2)
  BBflat_Verdict_M30Y_T2=-1;

//-----------  Analyse du Trend M5, M30 et Global

if(M5_Gravity_0_T1>M5_Gravity_0_T2)
  Trend_M5=1;
if(M5_Gravity_0_T1<M5_Gravity_0_T2)
  Trend_M5=-1;
if(M5_Gravity_0_T1==M5_Gravity_0_T2)
  Trend_M5=0;
if(M30_Gravity_0_T1>M30_Gravity_0_T2)
  Trend_M30=1;
if(M30_Gravity_0_T1<M30_Gravity_0_T2)
  Trend_M30=-1;
if(M30_Gravity_0_T1==M30_Gravity_0_T2)
  Trend_M30=0;
if(M30Y_Gravity_0_T1>M30Y_Gravity_0_T2)
  Trend_M30Y=1;
if(M30Y_Gravity_0_T1<M30Y_Gravity_0_T2)
  Trend_M30Y=-1;
if(M30Y_Gravity_0_T1==M30Y_Gravity_0_T2)
  Trend_M30Y=0;
if(Trend_M5==1 && Trend_M30==1 && Trend_M30Y==1)
  Trend_Global=2;
if(Trend_M5==-1 && Trend_M30==-1 && Trend_M30Y==-1)
  Trend_Global=-2;
if(Trend_M5==-1 && Trend_M30==1)
  Trend_Global=1;
if(Trend_M5==1 && Trend_M30==-1)
  Trend_Global=-1;

//----------------------------------------------------------------------  Analyse du Trend selon M30Y

int Trend_M30Y_Verdict;

if(BBflat_sw_M30Y_T1>0)
Trend_M30Y_Verdict=1;
if(BBflat_sw_M30Y_T1<0)
Trend_M30Y_Verdict=-1;

//--------------------------------------------------------------------  ADX

double ADX_Norm=iCustom(NULL,TimeFrame_1,"ADX",18,0,0);
double DI_Plus=iCustom(NULL,TimeFrame_1,"ADX",18,1,0);
double DI_Minus=iCustom(NULL,TimeFrame_1,"ADX",18,2,0);

if(DI_Plus<ADX_Norm && DI_Minus>ADX_Norm && (DI_Minus-DI_Plus)>10)
int ADX_Level=-1; //Buy

if(DI_Plus>ADX_Norm && DI_Minus<ADX_Norm && (DI_Plus-DI_Minus)>10)
ADX_Level=1; //Sell

//--------------------------------------------------------------------  Analyse OCLH

double Close_M5_T1 = iClose(NULL, PERIOD_M5, 1);
double Close_M5_T2 = iClose(NULL, PERIOD_M5, 2);
double Close_M5_T3 = iClose(NULL, PERIOD_M5, 3);
double Close_M30_T1 = iClose(NULL, PERIOD_M30, 1);
double Close_M30_T2 = iClose(NULL, PERIOD_M30, 2);
double Close_M30_T3 = iClose(NULL, PERIOD_M30, 3);
double Close_H4_T1 = iClose(NULL, PERIOD_H4, 1);
double Close_H4_T2 = iClose(NULL, PERIOD_H4, 2);
double Close_H4_T3 = iClose(NULL, PERIOD_H4, 3);
double Open_M5_T1 = iOpen(NULL, PERIOD_M5, 1);
double Open_M5_T2 = iOpen(NULL, PERIOD_M5, 2);
double Open_M5_T3 = iOpen(NULL, PERIOD_M5, 3);
double Open_M30_T1 = iOpen(NULL, PERIOD_M30, 1);
double Open_M30_T2 = iOpen(NULL, PERIOD_M30, 2);
double Open_M30_T3 = iOpen(NULL, PERIOD_M30, 3);
double Open_H4_T1 = iOpen(NULL, PERIOD_H4, 1);
double Open_H4_T2 = iOpen(NULL, PERIOD_H4, 2);
double Open_H4_T3 = iOpen(NULL, PERIOD_H4, 3);
double High_M5_T1 = iHigh(NULL, PERIOD_M5, 1);
double High_M5_T2 = iHigh(NULL, PERIOD_M5, 2);
double High_M5_T3 = iHigh(NULL, PERIOD_M5, 3);
double High_M30_T1 = iHigh(NULL, PERIOD_M30, 1);
double High_M30_T2 = iHigh(NULL, PERIOD_M30, 2);
double High_M30_T3 = iHigh(NULL, PERIOD_M30, 3);
double High_H4_T1 = iHigh(NULL, PERIOD_H4, 1);
double High_H4_T2 = iHigh(NULL, PERIOD_H4, 2);
double High_H4_T3 = iHigh(NULL, PERIOD_H4, 3);
double Low_M5_T1 = iLow(NULL, PERIOD_M5, 1);
double Low_M5_T2 = iLow(NULL, PERIOD_M5, 2);
double Low_M5_T3 = iLow(NULL, PERIOD_M5, 3);
double Low_M30_T1 = iLow(NULL, PERIOD_M30, 1);
double Low_M30_T2 = iLow(NULL, PERIOD_M30, 2);
double Low_M30_T3 = iLow(NULL, PERIOD_M30, 3);
double Low_H4_T1 = iLow(NULL, PERIOD_H4, 1);
double Low_H4_T2 = iLow(NULL, PERIOD_H4, 2);
double Low_H4_T3 = iLow(NULL, PERIOD_H4, 3);

double Index_Iris_1_M5_T1 = (-1+((1+(High_M5_T1-Close_M5_T1))/(1+(Low_M5_T1-Open_M5_T1))))*1000;
double Index_Iris_1_M5_T2 = (-1+((1+(High_M5_T2-Close_M5_T2))/(1+(Low_M5_T2-Open_M5_T2))))*1000;
double Index_Iris_1_M5_T3 = (-1+((1+(High_M5_T3-Close_M5_T3))/(1+(Low_M5_T3-Open_M5_T3))))*1000;

double Index_Iris_2_M5_T1 = (-1+((1+(Close_M5_T1-Low_M5_T1))/(1+(Open_M5_T1-High_M5_T1))))*1000;
double Index_Iris_2_M5_T2 = (-1+((1+(Close_M5_T2-Low_M5_T2))/(1+(Open_M5_T2-High_M5_T2))))*1000;
double Index_Iris_2_M5_T3 = (-1+((1+(Close_M5_T3-Low_M5_T3))/(1+(Open_M5_T3-High_M5_T3))))*1000;

double Index_Iris_1_M30_T1 = (-1+((1+(High_M30_T1-Close_M30_T1))/(1+(Low_M30_T1-Open_M30_T1))))*1000;
double Index_Iris_1_M30_T2 = (-1+((1+(High_M30_T2-Close_M30_T2))/(1+(Low_M30_T2-Open_M30_T2))))*1000;
double Index_Iris_1_M30_T3 = (-1+((1+(High_M30_T3-Close_M30_T3))/(1+(Low_M30_T3-Open_M30_T3))))*1000;

double Index_Iris_2_M30_T1 = (-1+((1+(Close_M30_T1-Low_M30_T1))/(1+(Open_M30_T1-High_M30_T1))))*1000;
double Index_Iris_2_M30_T2 = (-1+((1+(Close_M30_T2-Low_M30_T2))/(1+(Open_M30_T2-High_M30_T2))))*1000;
double Index_Iris_2_M30_T3 = (-1+((1+(Close_M30_T3-Low_M30_T3))/(1+(Open_M30_T3-High_M30_T3))))*1000;

double Index_Iris_1_H4_T1 = (-1+((1+(High_H4_T1-Close_H4_T1))/(1+(Low_H4_T1-Open_H4_T1))))*1000;
double Index_Iris_1_H4_T2 = (-1+((1+(High_H4_T2-Close_H4_T2))/(1+(Low_H4_T2-Open_H4_T2))))*1000;
double Index_Iris_1_H4_T3 = (-1+((1+(High_H4_T3-Close_H4_T3))/(1+(Low_H4_T3-Open_H4_T3))))*1000;

double Index_Iris_2_H4_T1 = (-1+((1+(Close_H4_T1-Low_H4_T1))/(1+(Open_H4_T1-High_H4_T1))))*1000;
double Index_Iris_2_H4_T2 = (-1+((1+(Close_H4_T2-Low_H4_T2))/(1+(Open_H4_T2-High_H4_T2))))*1000;
double Index_Iris_2_H4_T3 = (-1+((1+(Close_H4_T3-Low_H4_T3))/(1+(Open_H4_T3-High_H4_T3))))*1000;

double Index_Iris_M5  = ((Index_Iris_2_M5_T1+Index_Iris_2_M5_T2+Index_Iris_2_M5_T3)/3)    - ((Index_Iris_1_M5_T1+Index_Iris_1_M5_T2+Index_Iris_1_M5_T3)/3);
double Index_Iris_M30 = ((Index_Iris_2_M30_T1+Index_Iris_2_M30_T2+Index_Iris_2_M30_T3)/3) - ((Index_Iris_1_M30_T1+Index_Iris_1_M30_T2+Index_Iris_1_M30_T3)/3);
double Index_Iris_H4  = ((Index_Iris_2_H4_T1+Index_Iris_2_H4_T2+Index_Iris_2_H4_T3)/3)    - ((Index_Iris_1_H4_T1+Index_Iris_1_H4_T2+Index_Iris_1_H4_T3)/3);
double Pivot_Steam;

Index_Iris_M5 = NormalizeDouble(Index_Iris_M5, 2);
Index_Iris_M30 = NormalizeDouble(Index_Iris_M30, 2);
Index_Iris_H4 = NormalizeDouble(Index_Iris_H4, 2);

Pivot_Steam = iCustom(NULL, 0, "Pivot_Steam", 0, 0);

//----------------------------------------------------------------------  Mise en Memoire de l'Heure

ActualTime=TimeCurrent();

//----------------------------------------------------------------------  Verification Fenetre d'Activite

if(Always_On==0 && Balance_OK==1)
{
if(StartHour<EndHour)
{
if(TimeHour(ActualTime)>=StartHour && TimeHour(ActualTime)<EndHour)
  Power="ACTIVE";
if(TimeHour(ActualTime)<StartHour || TimeHour(ActualTime)>=EndHour)
  Power="INACTIVE";
}

if(StartHour>EndHour)
{
if(TimeHour(ActualTime)<=23 && TimeHour(ActualTime)>=12 && TimeHour(ActualTime)>=StartHour)
  Power="ACTIVE";
if(TimeHour(ActualTime)<=23 && TimeHour(ActualTime)>=12 && TimeHour(ActualTime)<StartHour)
  Power="INACTIVE";
if(TimeHour(ActualTime)>=00 && TimeHour(ActualTime)<12 && TimeHour(ActualTime)<EndHour)
  Power="ACTIVE";
if(TimeHour(ActualTime)>=00 && TimeHour(ActualTime)<12 && TimeHour(ActualTime)>=EndHour)
  Power="INACTIVE";
}
}

if(Always_On==1 && Balance_OK==1)
  Power="ACTIVE";

//---------------------------------------------------------------------  Detection et Analyse Position Ouverte

int total=OrdersTotal();
int pos; 
static double Price_Opened_Initial, Price_Opened_Secondary;
static int First_Launch;
static int Protective_Mode;
static int Protective_Mode_Activated;
static int Order_Ticket_1 = -1, Order_Ticket_2 = -1;
bool Hline_High, Hline_Low;

if(Protective_Mode==0)
  {
  for(pos=0; pos<total; pos++)
    {     
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true)
      {
      if(OrderMagicNumber()==MN_Sell_Primary_1)
        {
        Status_EU_M5M30=15;
        Price_Opened_Initial=OrderOpenPrice();
        Order_Ticket_1=OrderTicket();
        Defcon=4;
        }
      if(OrderMagicNumber()==MN_Buy_Primary_1)
        {
        Status_EU_M5M30=16;
        Price_Opened_Initial=OrderOpenPrice();
        Order_Ticket_1=OrderTicket();
        Defcon=4;
        }
      }
    }
  }

if(Protective_Mode==0)
  {  
  for(pos=0; pos<total; pos++)
    {     
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true)
      {
      if(Status_EU_M5M30==15 && (OrderMagicNumber()==MN_Buy_Protection && OrderType()==OP_BUY))
        {
        Order_Ticket_2=OrderTicket();
        Protective_Mode=1;
        Defcon=3;
        if(OrderSelect(Order_Ticket_1, SELECT_BY_TICKET)==True)
          {
          Price=Price_Opened_Initial-(ATR_M30_Static*5);
          }
        Hline_Low=ObjectCreate("Target_for_Protection_Low", OBJ_HLINE, 0, 0, Price);
        if(Hline_Low==true)
          {
          ObjectSet("Target_for_Protection_Low",OBJPROP_COLOR,Cyan);
          ObjectSet("Target_for_Protection_Low",OBJPROP_STYLE,STYLE_DOT);
          }
        }
      if(Status_EU_M5M30==16 && (OrderMagicNumber()==MN_Sell_Protection && OrderType()==OP_SELL))
        {
        Order_Ticket_2=OrderTicket();
        Protective_Mode=1;
        Defcon=3;
        if(OrderSelect(Order_Ticket_1, SELECT_BY_TICKET)==True)
          {
          Price=Price_Opened_Initial+(ATR_M30_Static*5);
          }
        Hline_High=ObjectCreate("Target_for_Protection_High", OBJ_HLINE, 0, 0, Price);
        if(Hline_High==true)
          {
          ObjectSet("Target_for_Protection_High",OBJPROP_COLOR,Cyan);
          ObjectSet("Target_for_Protection_High",OBJPROP_STYLE,STYLE_DOT);
          }
        }
      if(Protective_Mode==1 && Send_Email==1)
        SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", nous sommes en DEFCON 3.");
      }
    }    
  }

//----------------------------------------------------------------------  Protective Mode

int Protective_Order = -2; 
static int Protection_Step_One; 
double Protective_Lots;

if(Protective_Mode==1 && Protective_Mode_Activated>=0)
  {  
  for(pos=0; pos<total; pos++)
    {     
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true)
      {
      if(Status_EU_M5M30==15 && (OrderMagicNumber()==MN_Buy_Protection && OrderType()==OP_BUY))
        {
        Price_Opened_Secondary=OrderOpenPrice();
        }
      if(Status_EU_M5M30==16 && (OrderMagicNumber()==MN_Sell_Protection && OrderType()==OP_SELL))
        {
        Price_Opened_Secondary=OrderOpenPrice();
        }
      }
    }    
  }

if(Protective_Mode==1 && Protective_Mode_Activated==0)
  {
  RefreshRates();
  for(pos=0; pos<total; pos++)
    {     
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && Status_EU_M5M30==15 && (OrderMagicNumber()==MN_Buy_Protection && OrderType()==OP_BUY) && Ask<Price_Opened_Initial-ATR_M30_Static*5)
      {
      Protective_Lots=OrderLots()*2;
      pos=OrdersTotal();
      for(pos=0; pos<total; pos++)
        {     
        if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Sell_Primary_1)
          {
          while(OrderSell_Closing!=True)
            {
            RefreshRates();
            OrderSell_Closing=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
            }
          if(OrderSell_Closing==True)
            Protection_Step_One=1;
          }
        }
      if(Protection_Step_One==1)
        {
        while(Protective_Order<0)
          {
          RefreshRates();
          Protective_Order=OrderSend(Symbol(),OP_SELL,Protective_Lots,NormalizeDouble(MarketInfo(Symbol(),MODE_BID),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Intermediary",MN_Sell_Intermediary_Protection,0,Cyan);
          }
        if(Protective_Order!=-1)
          {  
          Protection_Step_One=0;
          Protective_Mode_Activated=1;
          Protective_Order=-2;
          Defcon=2;
          if(ObjectFind("Target_for_Protection_Low")>=0)
            ObjectDelete("Target_for_Protection_Low");
          if(OrderSelect(Order_Ticket_2, SELECT_BY_TICKET)==True)
            {
            Price=Price_Opened_Secondary+(ATR_M30_Static*2);
            }
          Hline_High=ObjectCreate("Target_for_Protection_High", OBJ_HLINE, 0, 0, Price);
          if(Hline_High==true)
            {
            ObjectSet("Target_for_Protection_High",OBJPROP_COLOR,Gold);
            ObjectSet("Target_for_Protection_High",OBJPROP_STYLE,STYLE_DOT);
            }
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", nous sommes en DEFCON 2.");
          }
        }
      }
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && Status_EU_M5M30==16 && (OrderMagicNumber()==MN_Sell_Protection && OrderType()==OP_SELL) && Ask>Price_Opened_Initial+ATR_M30_Static*5)
      {
      Protective_Lots=OrderLots()*2;
      pos=OrdersTotal();
      for(pos=0; pos<total; pos++)
        {     
        if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Buy_Primary_1)
          {
          while(OrderBuy_Closing!=True)
            {
            RefreshRates();
            OrderBuy_Closing=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
            }
          if(OrderBuy_Closing==True)  
            Protection_Step_One=1;
          }
        }
      if(Protection_Step_One==1)
        {
        while(Protective_Order<0)
          { 
          RefreshRates();
          Protective_Order=OrderSend(Symbol(),OP_BUY,Protective_Lots,NormalizeDouble(MarketInfo(Symbol(),MODE_ASK),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Intermediary",MN_Buy_Intermediary_Protection,0,Cyan);
          }
        if(Protective_Order!=-1)
          {  
          Protection_Step_One=0;
          Protective_Mode_Activated=1;
          Protective_Order=-2;
          Defcon=2;
          if(ObjectFind("Target_for_Protection_High")>=0)
            ObjectDelete("Target_for_Protection_High");
          if(OrderSelect(Order_Ticket_2, SELECT_BY_TICKET)==True)
            {
            Price=Price_Opened_Secondary-(ATR_M30_Static*2);
            }
          Hline_Low=ObjectCreate("Target_for_Protection_Low", OBJ_HLINE, 0, 0, Price);
          if(Hline_Low==true)
            {
            ObjectSet("Target_for_Protection_Low",OBJPROP_COLOR,Gold);
            ObjectSet("Target_for_Protection_Low",OBJPROP_STYLE,STYLE_DOT);
            }
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", nous sommes en DEFCON 2.");
          }
        }
      }
    }
  }

static int Protection_Step_Two, Sell_Ultimate, Buy_Ultimate;
int Specific_Ultimate_Conditions;
total=OrdersTotal();

if(Protective_Mode==1 && Protective_Mode_Activated==1)
  {
  RefreshRates();
  for(pos=0; pos<total; pos++)
    {     
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Buy_Intermediary_Protection && Ask<Price_Opened_Secondary-ATR_M30_Static*2)
      {
      Protective_Lots=OrderLots()*2;
      pos=OrdersTotal();
      for(pos=0; pos<total; pos++)
        {     
        if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Sell_Protection)
          {
          while(OrderSell_Closing!=True)
            {
            RefreshRates();
            OrderSell_Closing=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
            }
          if(OrderSell_Closing==True)  
            Protection_Step_Two=1;
          }
        }
      if(Index_Iris_H4<-1 && Index_Iris_H4>-3 && Index_Iris_M30<-1 && Index_Iris_M30>-3)
        Specific_Ultimate_Conditions=1;
      if(Specific_Ultimate_Conditions==1 && Protection_Step_Two==1)
        {
        while(Protective_Order<0)
          {
          RefreshRates();
          Protective_Order=OrderSend(Symbol(),OP_BUY,Protective_Lots,NormalizeDouble(MarketInfo(Symbol(),MODE_ASK),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Ultimate",MN_Buy_Ultimate_Protection,0,Gold);
          }
        if(Protective_Order!=-1)
          {
          Protection_Step_Two=0;
          Protective_Mode_Activated++;
          Buy_Ultimate=1;
          Defcon=1;
          if(ObjectFind("Target_for_Protection_Low")>=0)
            ObjectDelete("Target_for_Protection_Low");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", nous sommes en DEFCON 1.");
          }
        }
      if(Specific_Ultimate_Conditions==0 && Protection_Step_Two==1)
        {
        while(Protective_Order<0)
          {  
          RefreshRates();
          Protective_Order=OrderSend(Symbol(),OP_SELL,Protective_Lots,NormalizeDouble(MarketInfo(Symbol(),MODE_BID),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Ultimate",MN_Sell_Ultimate_Protection,0,Gold);
          }
        if(Protective_Order!=-1)
          {
          Protection_Step_Two=0;
          Protective_Mode_Activated++;
          Sell_Ultimate=1;
          Defcon=1;
          if(ObjectFind("Target_for_Protection_Low")>=0)
            ObjectDelete("Target_for_Protection_Low");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", nous sommes en DEFCON 1.");
          }
        }
      }
    
    if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Sell_Intermediary_Protection && Ask>Price_Opened_Secondary+ATR_M30_Static*2)
      {
      Protective_Lots=OrderLots()*2;
      pos=OrdersTotal();
      for(pos=0; pos<total; pos++)
        {     
        if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Buy_Protection)
          {
          while(OrderBuy_Closing!=True)
            {
            RefreshRates();
            OrderBuy_Closing=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
            }
          if(OrderBuy_Closing==True)  
            Protection_Step_Two=1;
          }
        }
      if(Index_Iris_H4>1 && Index_Iris_H4<3 && Index_Iris_M30>1 && Index_Iris_M30<3)
        Specific_Ultimate_Conditions=1;
      if(Specific_Ultimate_Conditions==1 && Protection_Step_Two==1)
        {
        while(Protective_Order<0)
          {
          RefreshRates();  
          Protective_Order=OrderSend(Symbol(),OP_SELL,Protective_Lots,NormalizeDouble(MarketInfo(Symbol(),MODE_BID),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Ultimate",MN_Sell_Ultimate_Protection,0,Gold);
          }
        if(Protective_Order!=-1)
          {
          Protection_Step_Two=0;
          Protective_Mode_Activated++;
          Sell_Ultimate=1;
          Defcon=1;
          if(ObjectFind("Target_for_Protection_High")>=0)
            ObjectDelete("Target_for_Protection_High");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", nous sommes en DEFCON 1.");
          }
        }
      if(Specific_Ultimate_Conditions==0 && Protection_Step_Two==1)
        {
        while(Protective_Order<0)
          {
          RefreshRates();
          Protective_Order=OrderSend(Symbol(),OP_BUY,Protective_Lots,NormalizeDouble(MarketInfo(Symbol(),MODE_ASK),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Ultimate",MN_Buy_Ultimate_Protection,0,Gold);
          }
        if(Protective_Order!=-1)
          {
          Protection_Step_Two=0;
          Protective_Mode_Activated++;
          Buy_Ultimate=1;
          Defcon=1;
          if(ObjectFind("Target_for_Protection_High")>=0)
            ObjectDelete("Target_for_Protection_High");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", nous sommes en DEFCON 1.");
          }
        }
      }
    }
  }

//----------------------------------------------------------------------  Detection Profit Nul lors de l'Inversion des Cours + Cloture

total=OrdersTotal();
int Position_Buy, Position_Sell, Position_Buy_Closed, Position_Sell_Closed;
double Profit_Buy, Profit_Sell, Profit_Cumulated;
bool OrderBuy_Closing_2, OrderSell_Closing_2;


for(pos=0; pos<total; pos++)
  {
  if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && (OrderMagicNumber()==MN_Buy_Primary_1 || OrderMagicNumber()==MN_Buy_Protection || OrderMagicNumber()==MN_Buy_Intermediary_Protection || OrderMagicNumber()==MN_Buy_Ultimate_Protection))
    {
    Position_Buy=1;
    Profit_Buy=Profit_Buy+OrderProfit()+OrderCommission()+OrderSwap();
    }
  if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && (OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Sell_Protection || OrderMagicNumber()==MN_Sell_Intermediary_Protection || OrderMagicNumber()==MN_Sell_Ultimate_Protection))
    {
    Position_Sell=1;
    Profit_Sell=Profit_Sell+OrderProfit()+OrderCommission()+OrderSwap();
    }
  }

if((Position_Buy!=0 && Position_Sell!=0 && Profit_Buy!=0 && Profit_Sell!=0) || Protective_Mode_Activated>=1)
  {
  Profit_Cumulated=Profit_Buy+Profit_Sell;
  if(Profit_Cumulated>=0)
    {
    for(h=OrdersTotal()-1;h>=0;h--)
    {
    if(OrderSelect(h,SELECT_BY_POS, MODE_TRADES)==true)
      {
    if(OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Sell_Protection || OrderMagicNumber()==MN_Sell_Intermediary_Protection || OrderMagicNumber()==MN_Sell_Ultimate_Protection)
      {
      Order_Number=OrderTicket();
      while(OrderSell_Closing_2!=True)
        {
        RefreshRates();
        OrderSell_Closing_2=OrderClose(Order_Number,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
        }
      if(OrderSell_Closing_2==True)
        {
        if(Alert_Popping==1)
          Alert("SyFirst_Grid : Cloture immediate de #", Order_Number);
        Status_EU_M5M30=0;
        Lot_Size_Adjusted=0;
        Strategy_Used=0;
        Position_Sell_Closed=1;
        }
      if(OrderSell_Closing_2==False && Alert_Popping==1)
        Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
      OrderSell_Closing_2=False;
      }
    if(OrderMagicNumber()==MN_Buy_Primary_1 || OrderMagicNumber()==MN_Buy_Protection || OrderMagicNumber()==MN_Buy_Intermediary_Protection || OrderMagicNumber()==MN_Buy_Ultimate_Protection)
      {
      Order_Number=OrderTicket();
      while(OrderBuy_Closing_2!=True)
        {
        RefreshRates();  
        OrderBuy_Closing_2=OrderClose(Order_Number,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
        }
      if(OrderBuy_Closing_2==True)
        {
        if(Alert_Popping==1)
          Alert("SyFirst_Grid : Cloture immediate de #", Order_Number);
        Status_EU_M5M30=0;
        Lot_Size_Adjusted=0;
        Strategy_Used=0;
        Position_Buy_Closed=1;
        }
      if(OrderBuy_Closing_2==False && Alert_Popping==1)
        Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
      OrderBuy_Closing_2=False;
      }
      }
    }
    }
    if(Position_Buy_Closed==1 || Position_Sell_Closed==1)
      {
      if(Alert_Popping==1)
        Alert("Mise en veille de ", SleepTime_Min, " min");
      if(Send_Email==1)
        SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, vous avez eu chaud sur " + Symbol() + " chez " + TerminalCompany() + " !" + "\r\n" + "La balance du compte #" + AccountNumber() + " est de " + AccountBalance() + " €.");
      Protective_Mode=0;
      Protective_Mode_Activated=0;
      Buy_Ultimate=0;
      Sell_Ultimate=0;
      Position_Buy_Closed=0;
      Position_Sell_Closed=0;
      ATR_M30_Static=0;
      Order_Ticket_1=-1;
      Order_Ticket_1=-2;
      if(ObjectFind("Target_for_Protection_High")>=0)
        ObjectDelete("Target_for_Protection_High");
      if(ObjectFind("Target_for_Protection_Low")>=0)
        ObjectDelete("Target_for_Protection_Low");
      Defcon=5;
      Sleep(SleepTime_Min*60000);
      }
  }

//----------------------------------------------------------------------  Point de Depart du Module 'Analyse du Cours'

if(Status_EU_M5M30==0 && Power=="ACTIVE" && ADX_Level!=0 && Trend_M30Y_Verdict!=0 && (ATR_M30*5<(40*10*Point) && ATR_M30*5>(10*10*Point)))
{

if(M5==1 && M30==1 && M30Y>-1)
{
Status_EU_M5M30=1; 
UpdatedOrderTime_EU_M5M30=TimeCurrent();
if(Alert_Popping==1) 
  Alert("SyFirst_Grid : Observation de BBflat. Status = ", Status_EU_M5M30, " et ADX = ", ADX_Level);
}

if(M5==2 && M30==2 && M30Y>-1)
{
Status_EU_M5M30=2; 
UpdatedOrderTime_EU_M5M30=TimeCurrent(); 
if(Alert_Popping==1)
  Alert("SyFirst_Grid : Observation de BBflat. Status = ", Status_EU_M5M30, " et ADX = ", ADX_Level);
}

if(M5==3 && M30==3 && M30Y>-1)
{
Status_EU_M5M30=3; 
UpdatedOrderTime_EU_M5M30=TimeCurrent();
if(Alert_Popping==1)
  Alert("SyFirst_Grid : Observation de BBflat. Status = ", Status_EU_M5M30, " et ADX = ", ADX_Level);
}

if((M5==4 && M30==4) || M30Y==4)
{
Status_EU_M5M30=4; 
UpdatedOrderTime_EU_M5M30=TimeCurrent();
if(Alert_Popping==1)
  Alert("SyFirst_Grid : Observation de BBflat. Status = ", Status_EU_M5M30, " et ADX = ", ADX_Level);
}

if(M5==-1 && M30==-1 && M30Y<-1)
{
Status_EU_M5M30=5; 
UpdatedOrderTime_EU_M5M30=TimeCurrent();
if(Alert_Popping==1) 
  Alert("SyFirst_Grid : Observation de BBflat. Status = ", Status_EU_M5M30, " et ADX = ", ADX_Level);
}

if(M5==-2 && M30==-2 && M30Y<-1)
{
Status_EU_M5M30=6; 
UpdatedOrderTime_EU_M5M30=TimeCurrent();
if(Alert_Popping==1)
  Alert("SyFirst_Grid : Observation de BBflat. Status = ", Status_EU_M5M30, " et ADX = ", ADX_Level);
}

if(M5==-3 && M30==-3 && M30Y<-1)
{
Status_EU_M5M30=7; 
UpdatedOrderTime_EU_M5M30=TimeCurrent();
if(Alert_Popping==1)
  Alert("SyFirst_Grid : Observation de BBflat. Status = ", Status_EU_M5M30, " et ADX = ", ADX_Level);
}

if((M5==-4 && M30==-4)  || M30Y==-4)
{
Status_EU_M5M30=8; 
UpdatedOrderTime_EU_M5M30=TimeCurrent();
if(Alert_Popping==1)
  Alert("SyFirst_Grid : Observation de BBflat. Status = ", Status_EU_M5M30, " et ADX = ", ADX_Level);
}

if(Bid==M5_Gravity_0 || Bid==M5_Gravity_1_Positif || Bid==M5_Gravity_2_Positif || Bid==M5_Gravity_3_Positif || Bid==M30_Gravity_0 || Bid==M30_Gravity_1_Positif || Bid==M30_Gravity_2_Positif || Bid==M30_Gravity_3_Positif)
Status_EU_M5M30=9;

if(Bid==M5_Gravity_0 || Bid==M5_Gravity_1_Negatif || Bid==M5_Gravity_2_Negatif || Bid==M5_Gravity_3_Negatif || Bid==M30_Gravity_0 || Bid==M30_Gravity_1_Negatif || Bid==M30_Gravity_2_Negatif || Bid==M30_Gravity_3_Negatif)
Status_EU_M5M30=10;

}

//--------------------------------------------------------------------  Prépa Ascenceur Filtrant

if(Status_EU_M5M30==9 || Status_EU_M5M30==10)
  Status_EU_M5M30=0;

//--------------------------------------------------------------------  Calcul du Compteur 'Elapsed_Time'

if(UpdatedOrderTime_EU_M5M30>0)
  {
  Countdown_Minutes=TimeMinute(ActualTime-UpdatedOrderTime_EU_M5M30);
  Countdown_Seconds=TimeSeconds(ActualTime-UpdatedOrderTime_EU_M5M30);
  }

//--------------------------------------------------------------------  Mise en place 'Open-Close Hit Prevention'

int Position;

total=OrdersTotal();

for(pos=0; pos<total; pos++)
  {
  if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && (OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Buy_Primary_1 || OrderMagicNumber()==MN_Sell_Capitalizing || OrderMagicNumber()==MN_Buy_Capitalizing || OrderMagicNumber()==MN_Sell_Ultimate_Protection || OrderMagicNumber()==MN_Buy_Ultimate_Protection))
    Position=1;
  }

if(Position==0)
{
  if(BBflat_Verdict_M30Y_T2==-1 && BBflat_Verdict_M30Y==0)
    OCHP=-1;
  if(BBflat_Verdict_M30Y_T2==1 && BBflat_Verdict_M30Y==0)
    OCHP=1;
}

//-------------------------------------------------------------------- Calculs Temporels

int Today_Seconds=(Hour()*3600)+(Minute()*60)+Seconds();
int Yesterday_End=TimeCurrent()-Today_Seconds;
int Yesterday_Start=Yesterday_End-86400;

int Day_Of_Week=DayOfWeek();
int Weekly_Seconds=(Day_Of_Week-1)*86400+(Hour()*3600)+(Minute()*60)+Seconds();
int Week_Start=TimeCurrent()-Weekly_Seconds;
int Week_End=Week_Start+(86400*5)-(5*60);

//-------------------------------------------------------------------- Analyse Proprietes des Ordres Clotures

double Profit_Today=0,Profit_Yesterday=0;
int Yesterday_Trades=0,Today_Trades=0;
 
int Friday_End=TimeCurrent()-Today_Seconds-(86400*2);
int Friday_Start=TimeCurrent()-Today_Seconds-(86400*3);
 
for(h=OrdersHistoryTotal()-1;h>=0;h--)
  {
    if(OrderSelect(h,SELECT_BY_POS,MODE_HISTORY)==true)
      {
        if(OrderCloseTime()>Friday_Start && (OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Buy_Primary_1 || OrderMagicNumber()==MN_Sell_Protection || OrderMagicNumber()==MN_Buy_Protection || OrderMagicNumber()==MN_Sell_Capitalizing || OrderMagicNumber()==MN_Buy_Capitalizing || OrderMagicNumber()==MN_Sell_Intermediary_Protection || OrderMagicNumber()==MN_Buy_Intermediary_Protection || OrderMagicNumber()==MN_Sell_Ultimate_Protection || OrderMagicNumber()==MN_Buy_Ultimate_Protection))
         {      
           if(OrderCloseTime()>Yesterday_End)
           { 
           Profit_Today=Profit_Today+OrderProfit()+OrderCommission()+OrderSwap(); 
           Today_Trades++;
           } 
           
           if(DayOfWeek()!=1 && OrderCloseTime()<Yesterday_End && OrderCloseTime()>Yesterday_Start)
           {
           Profit_Yesterday=Profit_Yesterday+OrderProfit()+OrderCommission()+OrderSwap(); 
           Yesterday_Trades++;
           }
           
           if(DayOfWeek()==1 && OrderCloseTime()<Friday_End && OrderCloseTime()>Friday_Start)
           {
           Profit_Yesterday=Profit_Yesterday+OrderProfit()+OrderCommission()+OrderSwap(); 
           Yesterday_Trades++;
           }
         }
      }
  }

//--------------------------------------------------------------------  Ecriture Ordres dans Fichier CSV

int Write_Results;
int Write_Results_WeekEnd;
int FileHandle;
int Week_End_Adjusted;
static int Day_Of_Week_Static;
static int Yesterday_Update_Operation;
static int Today_Update_Operation;
string Subfolder;

if(Day_Of_Week==5)
  Week_End_Adjusted=Week_Start+(86400*5)-(3*60);

if(Day_Of_Week!=5)
  Today_Update_Operation=0;

if(First_Launch==0)
  {
  Day_Of_Week_Static=DayOfWeek();
  First_Launch=1;
  if(Alert_Popping==1)  
    Alert("SyFirst_Grid : First Launch Detected");
  }

if(Day_Of_Week==2 || Day_Of_Week==3 || Day_Of_Week==4 || Day_Of_Week==5)
  {
  if(Day_Of_Week_Static!=DayOfWeek() && Yesterday_Update_Operation==0)
    {
    Day_Of_Week_Static=DayOfWeek();
    Yesterday_Update_Operation=1;
    Write_Results=1;
    }
  }

if(Day_Of_Week==5)
  {
  if(TimeCurrent()>Week_End_Adjusted && Today_Update_Operation==0)
    {
    Today_Update_Operation=1;
    Write_Results_WeekEnd=1;
    }
  }

if(Logging==1 && Write_Results==1)
  {
  Subfolder="SyFirst_Grid-EA";
  FileHandle=FileOpen(Subfolder+"\\Results_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
  if(FileHandle!=INVALID_HANDLE)
    {
    FileSeek(FileHandle, 0, SEEK_END);
    FileWrite(FileHandle, Symbol(), TimeToStr(ActualTime, TIME_DATE), TimeToStr(ActualTime, TIME_SECONDS), Profit_Yesterday, Yesterday_Trades);
    FileClose(FileHandle);
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Writing Results OK");
    }
  if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
    Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
  Yesterday_Update_Operation=0;
  Write_Results=0;
  }

if(Logging==1 && Write_Results_WeekEnd==1)
  {
  Subfolder="SyFirst_Grid-EA";
  FileHandle=FileOpen(Subfolder+"\\Results_SyFirst_Grid.csv", FILE_READ|FILE_WRITE|FILE_CSV);
  if(FileHandle!=INVALID_HANDLE)
    {
    FileSeek(FileHandle, 0, SEEK_END);
    FileWrite(FileHandle, Symbol(), TimeToStr(ActualTime, TIME_DATE), TimeToStr(ActualTime, TIME_SECONDS), Profit_Today, Today_Trades);
    FileClose(FileHandle);
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Writing Results OK - Have A Nice WeekEnd");
    }
  if(FileHandle==INVALID_HANDLE && Alert_Popping==1)
    Alert("SyFirst_Grid : Writing Results FAILED - Invalid Handle");
  Write_Results_WeekEnd=0;
  }

//--------------------------------------------------------------------  Analyse Profit Positions Ouvertes

total=OrdersTotal();

for(pos=0; pos<total; pos++)
  {
  if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && (OrderMagicNumber()==MN_Sell_Primary_1 || OrderMagicNumber()==MN_Buy_Primary_1 || OrderMagicNumber()==MN_Sell_Protection || OrderMagicNumber()==MN_Buy_Protection || OrderMagicNumber()==MN_Sell_Capitalizing || OrderMagicNumber()==MN_Buy_Capitalizing || OrderMagicNumber()==MN_Sell_Intermediary_Protection || OrderMagicNumber()==MN_Buy_Intermediary_Protection || OrderMagicNumber()==MN_Sell_Ultimate_Protection || OrderMagicNumber()==MN_Buy_Ultimate_Protection))
    {
    Profit=Profit+OrderProfit()+OrderCommission()+OrderSwap();
    }
  }

//--------------------------------------------------------------------  Calcul Lots 

int LotsDigit;
double MinLots, MaxLots, AcFrMar, Step, One_Lot;

if(Money_Management==0)
   Lot_Size_Adjusted=Lot_Size;

if(Money_Management==1 && FxPro_Money_Management==0)
   {
   if(MarketInfo(Symbol(),MODE_MINLOT) == 0.1)
     LotsDigit=1;
   else if(MarketInfo(Symbol(),MODE_MINLOT) == 0.01)
     LotsDigit=2;
     
   One_Lot=MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   
   Step=MarketInfo(Symbol(),MODE_LOTSTEP);
   
   MinLots=NormalizeDouble(MarketInfo(Symbol(),MODE_MINLOT),LotsDigit);
   MaxLots=NormalizeDouble(MarketInfo(Symbol(),MODE_MAXLOT),LotsDigit);
   
   AcFrMar=NormalizeDouble(AccountFreeMargin(),2);
   
   Lot_Size_Adjusted=MathFloor(AcFrMar*Margin_Percent/100/One_Lot/Step)*Step;

   if(Lot_Size_Adjusted>MaxLots)
     Lot_Size_Adjusted=MaxLots;
   if(Lot_Size_Adjusted<MinLots)
     Lot_Size_Adjusted=MinLots; 
   }

if(FxPro_Money_Management==1)
   {
   if(MarketInfo(Symbol(),MODE_MINLOT) == 0.1)
     LotsDigit=1;
   else if(MarketInfo(Symbol(),MODE_MINLOT) == 0.01)
     LotsDigit=2;
     
   One_Lot=MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   
   Step=MarketInfo(Symbol(),MODE_LOTSTEP);
   
   MinLots=NormalizeDouble(MarketInfo(Symbol(),MODE_MINLOT),LotsDigit);
   MaxLots=NormalizeDouble(MarketInfo(Symbol(),MODE_MAXLOT),LotsDigit);
   
   AcFrMar=NormalizeDouble(AccountFreeMargin(),2);
   
   if(AccountBalance()<45000)
     {
     Lot_Size_Adjusted=MathFloor(AcFrMar*Margin_Percent/100/200/Step)*Step;
     if(Lot_Size_Adjusted<MinLots)
       Lot_Size_Adjusted=MinLots;
     if(Lot_Size_Adjusted>5.5)
       Lot_Size_Adjusted=5.5;
     }
     
   if(AccountBalance()>=45000 && AccountBalance()<225000)
     {
     Lot_Size_Adjusted=MathFloor(AcFrMar*Margin_Percent/100/500/Step)*Step;
     if(Lot_Size_Adjusted<5.5)
       Lot_Size_Adjusted=5.5;
     if(Lot_Size_Adjusted>11.1)
       Lot_Size_Adjusted=11.1;
     }
     
   if(AccountBalance()>=225000 && AccountBalance()<670000)
     {
     Lot_Size_Adjusted=MathFloor(AcFrMar*Margin_Percent/100/1000/Step)*Step;
     if(Lot_Size_Adjusted<11.1)
       Lot_Size_Adjusted=11.1;
     if(Lot_Size_Adjusted>16.6)
       Lot_Size_Adjusted=16.6;
     }
   
   if(AccountBalance()>=670000 && AccountBalance()<2250000)
     {
     Lot_Size_Adjusted=MathFloor(AcFrMar*Margin_Percent/100/2000/Step)*Step;
     if(Lot_Size_Adjusted<16.6)
       Lot_Size_Adjusted=16.6;
     if(Lot_Size_Adjusted>27.7)
       Lot_Size_Adjusted=27.7;
     }
     
   if(AccountBalance()>=2250000)
     {
     Lot_Size_Adjusted=MathFloor(AcFrMar*Margin_Percent/100/3030/Step)*Step;
     if(Lot_Size_Adjusted<27.7)
       Lot_Size_Adjusted=27.7;
     if(Lot_Size_Adjusted>MaxLots)
       Lot_Size_Adjusted=MaxLots;
     } 
   }

//--------------------------------------------------------------------  Rapports d'Activite

string sComment   = "";
string sp         = "------------------------------------------------\n";
string NL         = "\n";
   
   sComment = NL + NL;
   sComment = sComment + "SyFirst_Grid Version_1.53" + NL;
   sComment = sComment + sp;
   sComment = sComment + Symbol() + NL;
   sComment = sComment + "Status = " + Power + NL;
   sComment = sComment + sp;
   sComment = sComment + "Screening Zones :" + NL;
   sComment = sComment + "EU_M1  = " + M5 + NL;  
   sComment = sComment + "EU_M5 = " + M30 + NL;
   sComment = sComment + "EU_M30 = " + M30Y + NL;
   sComment = sComment + sp;
   sComment = sComment + "BBflat Verdict :" + NL;
   sComment = sComment + "EU M1  = " + BBflat_Verdict_M1 + NL;
   sComment = sComment + "EU M5 = " + BBflat_Verdict_M30 + NL;
   sComment = sComment + "EU M30 = " + BBflat_Verdict_M30Y + NL;
   sComment = sComment + "OCHP   = " + OCHP + NL;
   sComment = sComment + sp;
   sComment = sComment + "Index Iris M5   = " + Index_Iris_M5 + NL;
   sComment = sComment + "Index Iris M30  = " + Index_Iris_M30 + NL;
   sComment = sComment + "Index Iris H4   = " + Index_Iris_H4 + NL;
   sComment = sComment + "Pivot Steam  = " + Pivot_Steam + NL;
   sComment = sComment + sp;
   sComment = sComment + "Trend M1   = " + Trend_M5 + NL; 
   sComment = sComment + "Trend M5  = " + Trend_M30 + NL;
   sComment = sComment + "Trend M30  = " + Trend_M30Y_Verdict + NL;
   sComment = sComment + "Trend Global  = " + Trend_Global + NL;
   sComment = sComment + sp;
   sComment = sComment + "          --> ETAPE " + Status_EU_M5M30 + " <--" + NL;
   sComment = sComment + sp;
   if(Balance_OK==1)
     sComment = sComment + "Account Balance OK" + NL;
   sComment = sComment + "Opening Lot Size = " + Lot_Size_Adjusted + NL;
   sComment = sComment + "Equity = " + Equity + NL;
   sComment = sComment + "Equity Limit = " + Equity_Limit + NL;
   sComment = sComment + sp;
   sComment = sComment + "DEFCON " + Defcon + NL;
   sComment = sComment + sp;
   if(Day_Of_Week==1)
     sComment = sComment + "Actual Time = MONDAY " + TimeToStr(ActualTime, TIME_DATE|TIME_SECONDS) + NL;
   if(Day_Of_Week==2)
     sComment = sComment + "Actual Time = TUESDAY " + TimeToStr(ActualTime, TIME_DATE|TIME_SECONDS) + NL;
   if(Day_Of_Week==3)
     sComment = sComment + "Actual Time = WEDNESDAY " + TimeToStr(ActualTime, TIME_DATE|TIME_SECONDS) + NL;
   if(Day_Of_Week==4)
     sComment = sComment + "Actual Time = THURSDAY " + TimeToStr(ActualTime, TIME_DATE|TIME_SECONDS) + NL;
   if(Day_Of_Week==5)
     sComment = sComment + "Actual Time = FRIDAY " + TimeToStr(ActualTime, TIME_DATE|TIME_SECONDS) + NL;
   sComment = sComment + "Window Starting Time = " + TimeToStr(UpdatedOrderTime_EU_M5M30, TIME_SECONDS) + NL;
   sComment = sComment + "Elapsed Time = " + Countdown_Minutes + ":" + Countdown_Seconds + NL;
   sComment = sComment + sp;
   sComment = sComment + "Gain = " + NormalizeDouble(Profit, 2) + NL;
   sComment = sComment + sp;
   sComment = sComment + "Profit Yesterday = " + NormalizeDouble(Profit_Yesterday, 2) + NL;
   sComment = sComment + "Profit Today = " + NormalizeDouble(Profit_Today, 2);
       
   Comment(sComment);

//--------------------------------------------------------------------  Verification de la validite de la Fenetre d'Action + Prépa Ascenceur Filtrant

if((ActualTime>(UpdatedOrderTime_EU_M5M30+(Action_Window_Min*60))) && UpdatedOrderTime_EU_M5M30>0)
  {
  Status_EU_M5M30=0;
  UpdatedOrderTime_EU_M5M30=0;
  if(Alert_Popping==1)
    Alert("SyFirst_Grid : Arret Surveillance de BBflat apres ", Action_Window_Min, " min... Status EU M5M30 & UpdateOrderTime EU M5M30 re-initialise.");
  }

//--------------------------------------------------------------------  Ascenceur Filtrant

if(Status_EU_M5M30==0)
return(0);

//--------------------------------------------------------------------  Pivot Steam

if(Pivot_Steam>0.3)
int PS_Index=1;

if(Pivot_Steam<0.3)
PS_Index=-1;

//--------------------------------------------------------------------  Point de Depart du Module 'Prise de position'

if(Status_EU_M5M30>0 && Status_EU_M5M30<=14)
{

    if(Status_EU_M5M30==1 && Trend_Global==-1 && BBflat_Verdict_M1==1)          //---R
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=101;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=102;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==2 && Trend_Global==-1 && BBflat_Verdict_M1==1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=201;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1)                           //---A
      {
      Status_EU_M5M30=12;
      Strategy_Used=202;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==3 && Trend_Global==-1 && BBflat_Verdict_M1==1 && BBflat_Verdict_M30==1 && OCHP!=1 && ADX_Level==-1)          //---RRR
    {
    Status_EU_M5M30=12;
    Strategy_Used=3;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==4 && Trend_Global==-1 && BBflat_Verdict_M1==1 && BBflat_Verdict_M30==1 && OCHP!=-1 && ADX_Level==1)          //---RRR
    {
    Status_EU_M5M30=11;
    Strategy_Used=4;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==5 && Trend_Global==-1 && BBflat_Verdict_M1==-1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && OCHP!=1 && Stochastic_Line_M5<18)
      {
      Status_EU_M5M30=12;
      Strategy_Used=501;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      //if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && OCHP!=1 && Stochastic_Line_M5>25)
      //{
      //Status_EU_M5M30=12;
      //Strategy_Used=503;
      //if(Alert_Popping==1)
        //Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      //}
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && OCHP!=-1 && (Stochastic_Line_M5>18 && Stochastic_Line_M5<25))
      {
      Status_EU_M5M30=11;
      Strategy_Used=504;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && OCHP!=-1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=502;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==6 && Trend_Global==-1 && BBflat_Verdict_M1==-1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=601;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=602;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==7 && Trend_Global==-1 && BBflat_Verdict_M1==-1 && BBflat_Verdict_M1==-1 && OCHP!=-1 && ADX_Level==1)          //---RR
    {
    Status_EU_M5M30=11;
    Strategy_Used=7;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==8 && Trend_Global==-1 && BBflat_Verdict_M1==-1 && BBflat_Verdict_M30==-1)          //---RRR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=801;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=802;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==1 && Trend_Global==-1 && BBflat_Verdict_M1==1 && OCHP!=-1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=901;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=902;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==2 && Trend_Global==-1 && BBflat_Verdict_M1==1)          //---A
    {
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && OCHP!=1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=1001;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && Stochastic_Line_M5<80 && OCHP!=1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=1002;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==1 && Stochastic_Line_M5>80 && OCHP!=-1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=1003;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==3 && Trend_Global==-1 && BBflat_Verdict_M1==1 && BBflat_Verdict_M1==1)          //---A
    {
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && OCHP!=-1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=1101;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && OCHP!=1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=1103;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==-1 && OCHP!=1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=1102;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && Stochastic_Line_M5<90 && OCHP!=-1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=1104;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && Stochastic_Line_M5>90 && OCHP!=1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=1105;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==4 && Trend_Global==-1 && BBflat_Verdict_M1==1)          //---RR
    {
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=1201;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=1202;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==5 && Trend_Global==-1 && BBflat_Verdict_M1==1)           //---A
    {
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==-1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=1301;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==1 && Stochastic_Line_M5>80 && OCHP!=-1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=1303;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==1 && OCHP!=-1 && (Stochastic_Line_M5<80 && Stochastic_Line_M30Y>25))
      {
      Status_EU_M5M30=11;
      Strategy_Used=1302;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==1 && (Stochastic_Line_M5<80 && Stochastic_Line_M30Y<25) && OCHP!=-1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=1304;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==6 && Trend_Global==-1 && BBflat_Verdict_M1==1 && OCHP!=1 && ADX_Level==-1)
    {
    Status_EU_M5M30=12;
    Strategy_Used=14;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==7 && Trend_Global==-1 && BBflat_Verdict_M1==-1 && OCHP!=-1 && ADX_Level==1)          //---RR
    {
    Status_EU_M5M30=11;
    Strategy_Used=15;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==8 && Trend_Global==-1 && BBflat_Verdict_M1==-1)          //---RR
    {
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && OCHP!=-1)
     {
      Status_EU_M5M30=11;
      Strategy_Used=1601;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==1 && OCHP!=-1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=1602;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
   }
    
    if(Status_EU_M5M30==1 && Trend_Global==2 && BBflat_Verdict_M1==1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=1701;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=1702;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==2 && Trend_Global==2 && BBflat_Verdict_M1==1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=1801;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=1802;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==3 && Trend_Global==1 && BBflat_Verdict_M1==1 && BBflat_Verdict_M30==1 && OCHP!=1 && ADX_Level==-1)          //---RR
    {
    Status_EU_M5M30=12;
    Strategy_Used=19;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==4 && Trend_Global==1 && BBflat_Verdict_M1==1 && BBflat_Verdict_M30==1 && OCHP!=1 && ADX_Level==-1)          //---RR
    {
    Status_EU_M5M30=12;
    Strategy_Used=20;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==5 && Trend_Global==1 && BBflat_Verdict_M1==-1)          //---RR
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=2101;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=2102;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==6 && Trend_Global==1 && BBflat_Verdict_M1==-1)          //---A
    {
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==-1 && Stochastic_Line_M30Y>50 && OCHP!=1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=2201;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=1 && ADX_Level==-1 && Stochastic_Line_M30Y<50)
      {
      Status_EU_M5M30=12;
      Strategy_Used=2204;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=2203;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=2202;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==7 && Trend_Global==1 && BBflat_Verdict_M1==-1 && BBflat_Verdict_M30==-1 && OCHP!=1 && ADX_Level==-1)          //---RRR
    {
    Status_EU_M5M30=12;
    Strategy_Used=23;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==8 && Trend_Global==1 && BBflat_Verdict_M1==-1 && BBflat_Verdict_M30==-1 && OCHP!=1 && ADX_Level==-1)          //---RRR
    {
    Status_EU_M5M30=12;
    Strategy_Used=24;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
    }
     
    if(Status_EU_M5M30==1 && Trend_Global==1 && BBflat_Verdict_M1==1)                  //----A
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=2501;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=2503;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=-1 && ADX_Level==1 && (Stochastic_Line_M5>35 && Stochastic_Line_M5<74) && Stochastic_Line_M30Y>50)
      {
      Status_EU_M5M30=11;
      Strategy_Used=2502;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && (Stochastic_Line_M5>35 && Stochastic_Line_M5<74) && Stochastic_Line_M30Y<50 && OCHP!=1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=2507;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && Stochastic_Line_M5<35 && OCHP!=1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=2505;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && ADX_Level==1 && Stochastic_Line_M5>74 && OCHP!=1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=2506;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && ADX_Level==1 && OCHP!=-1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=2504;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==2 && Trend_Global==1 && BBflat_Verdict_M1==1 && OCHP!=1 && ADX_Level==-1)
    {
    Status_EU_M5M30=12;
    Strategy_Used=26;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==3 && Trend_Global==1 && BBflat_Verdict_M1==1 && OCHP!=1 && ADX_Level==-1)          //---R
    {
    Status_EU_M5M30=12;
    Strategy_Used=27;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==4 && Trend_Global==1 && BBflat_Verdict_M1==1)          //---RR
    {
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=2801;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=2802;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
    }
    
    if(Status_EU_M5M30==5 && Trend_Global==1 && BBflat_Verdict_M1==-1 && OCHP!=-1 && ADX_Level==1)          //---R
    {
    Status_EU_M5M30=11;
    Strategy_Used=29;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==6 && Trend_Global==1 && BBflat_Verdict_M1==-1 && OCHP!=-1 && ADX_Level==1)          //---R
    {
    Status_EU_M5M30=11;
    Strategy_Used=30;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==7 && Trend_Global==1 && BBflat_Verdict_M1==-1 && BBflat_Verdict_M30==-1 && OCHP!=-1 && ADX_Level==1)          //---R
    {
    Status_EU_M5M30=11;
    Strategy_Used=31;
    if(Alert_Popping==1)
      Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
    }
    
    if(Status_EU_M5M30==8 && Trend_Global==1 && BBflat_Verdict_M1==-1) //&& BBflat_Verdict_M30==-1)          //---R
    {
      if(BBflat_sw_M30_T1<0.0005 && OCHP!=-1 && ADX_Level==1)
      {
      Status_EU_M5M30=11;
      Strategy_Used=3201;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position SELL en ", Strategy_Used);
      }
      if(BBflat_sw_M30_T1>0.0005 && OCHP!=1 && ADX_Level==-1)
      {
      Status_EU_M5M30=12;
      Strategy_Used=3202;
      if(Alert_Popping==1)
        Alert("SyFirst_Grid : Clearance pour Prise de position BUY en ", Strategy_Used);
      }
    }
    
    Comments=NormalizeDouble(Strategy_Used, 0);  //----------------------------  Definition Comments
     
    long current_chart_id=ChartID();
    string Name_Hline="Target_for_BE";

//--------------------------------------------------------------------  Passage d'ordre

int Order_Number_1 = -2;
int Order_Number_2 = -2;

    switch(Status_EU_M5M30)
    {
      case 11 : RefreshRates();
        while(Order_Number_1<0)
          {
          RefreshRates();
          Order_Number_1=OrderSend(Symbol(),OP_SELL,Lot_Size_Adjusted,NormalizeDouble(MarketInfo(Symbol(),MODE_BID),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,Comments,MN_Sell_Primary_1,0,Green);
          }
        while(Order_Number_2<0)
          {
          RefreshRates();
          Order_Number_2=OrderSend(Symbol(),OP_BUYSTOP,Lot_Size_Adjusted*3,NormalizeDouble((MarketInfo(Symbol(),MODE_ASK)+(ATR_M30*5)),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Protection",MN_Buy_Protection,0,Blue);
          }
        if(Order_Number_1>=0 && Order_Number_2>=0)
          {
          Status_EU_M5M30=15;
          UpdatedOrderTime_EU_M5M30=0;
          Countdown_Minutes=0;
          Countdown_Seconds=0;
          ATR_M30_Static=ATR_M30;
          if(Alert_Popping==1)
            Alert("SyFirst_Grid : Positions #", Order_Number_1, " SELL ", "et #", Order_Number_2, " BUYSTOP ", Symbol(), " valides. Compteur re-initialise.");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", une position SELL a été prise en utilisant la stratégie " + Strategy_Used + ".");
          Defcon=4;
          }
        if((Order_Number_1==-1 || Order_Number_2==-1) && Alert_Popping==1)
          {
          Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
          }
        break;
     
      case 12 : RefreshRates();
        while(Order_Number_1<0)
          {
          RefreshRates();
          Order_Number_1=OrderSend(Symbol(),OP_BUY,Lot_Size_Adjusted,NormalizeDouble(MarketInfo(Symbol(),MODE_ASK),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,Comments,MN_Buy_Primary_1,0,Green);
          }
        while(Order_Number_2<0)
          {
          RefreshRates();
          Order_Number_2=OrderSend(Symbol(),OP_SELLSTOP,Lot_Size_Adjusted*3,NormalizeDouble((MarketInfo(Symbol(),MODE_BID)-(ATR_M30*5)),MarketInfo(Symbol(),MODE_DIGITS)),3,0,0,"Protection",MN_Sell_Protection,0,Blue);
          }
        if(Order_Number_1>=0 && Order_Number_2>=0)
          {
          Status_EU_M5M30=16;
          UpdatedOrderTime_EU_M5M30=0;
          Countdown_Minutes=0;
          Countdown_Seconds=0;
          ATR_M30_Static=ATR_M30;        
          if(Alert_Popping==1)
            Alert("SyFirst_Grid : Position #", Order_Number_1, " BUY ", "et #", Order_Number_2, " SELLSTOP ", Symbol(), " valides. Compteur re-initialise.");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", une position BUY a été prise en utilisant la stratégie " + Strategy_Used + ".");
          Defcon=4;
          }
        if((Order_Number_1<0 || Order_Number_2<0) && Alert_Popping==1)
          {
          Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
          }
        break;
    
    default : break;
    
    }

return(0);
}

//-----------------------------------------------------------------------  Point de Depart du Module 'Suivi de Position'

bool Order_Closing=False;

if(Protective_Mode==0 && Profit>0)
{

for(pos=0; pos<total; pos++)
{
  
  if(OrderSelect(pos,SELECT_BY_POS, MODE_TRADES)==true)
  {
    if((OrderMagicNumber()==MN_Sell_Primary_1) && (BBflat_Verdict_M30Y_T2==-1 && BBflat_Verdict_M30Y==0))
      {
      RefreshRates();
      Profit=OrderProfit();
      Order_Number=OrderTicket();
      while(OrderSell_Closing!=True)
        {
        RefreshRates();
        OrderSell_Closing=OrderClose(Order_Number,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
        }
      if(OrderSell_Closing==True)
        {
        if(Alert_Popping==1)
          Alert("SyFirst_Grid : Cloture immediate de #", Order_Number);
        Status_EU_M5M30=0;
        Lot_Size_Adjusted=0;
        Strategy_Used=0;
        TS_Status=0;
        for(pos=0; pos<total; pos++)
          {
          if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Buy_Protection)
            {
            Order_Number=OrderTicket();
            while(Order_Closing!=True)
              Order_Closing=OrderDelete(Order_Number,Red);
            }
          } 
        if(Profit>=0)
          {
          if(Alert_Popping==1)
            Alert("SyFirst_Grid : Position SELL cloturee. Gain = ", Profit, " Mise en veille de ", SleepTime_Min, " min");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", vous avez gagné " + Profit + " €." + "\r\n" + "La balance du compte #" + AccountNumber() + " est de " + AccountBalance() + " €.");
          }
        if(Profit<0)
          {
          if(Alert_Popping==1)
            Alert("SyFirst_Grid : Position SELL cloturee. Perte = ", MathAbs(Profit), " Mise en veille de ", SleepTime_Min, " min");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", vous avez perdu " + Profit + " €." + "\r\n" + "La balance du compte #" + AccountNumber() + " est de " + AccountBalance() + " €.");
          }
        Defcon=5;
        Sleep(SleepTime_Min*60000);
        }
      if(OrderSell_Closing==False && Alert_Popping==1)
        Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
    
      return(0);
      }

    if(OrderMagicNumber()==MN_Buy_Primary_1 && (BBflat_Verdict_M30Y_T2==1 && BBflat_Verdict_M30Y==0))
      {
      RefreshRates();
      Profit=OrderProfit();
      Order_Number=OrderTicket();
      while(OrderBuy_Closing!=True)
        {
        RefreshRates();
        OrderBuy_Closing=OrderClose(Order_Number,OrderLots(),NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),MarketInfo(OrderSymbol(),MODE_DIGITS)),3,Red);
        }
      if(OrderBuy_Closing==True)
        {
        if(Alert_Popping==1)
          Alert("SyFirst_Grid : Cloture immediate de #", Order_Number);
        Status_EU_M5M30=0;
        Lot_Size_Adjusted=0;
        Strategy_Used=0;
        TS_Status=0;
        for(pos=0; pos<total; pos++)
          {
          if(OrderSelect(pos, SELECT_BY_POS, MODE_TRADES)==true && OrderMagicNumber()==MN_Sell_Protection)
            {
            Order_Number=OrderTicket();
            while(Order_Closing!=True)  
              Order_Closing=OrderDelete(Order_Number,Red);
            }
          }
        if(Profit>=0)
          {
          if(Alert_Popping==1)
            Alert("SyFirst_Grid : Position BUY cloturee. Gain = ", Profit, " Mise en veille de ", SleepTime_Min, " min");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", vous avez gagné " + Profit + " €." + "\r\n" + "La balance du compte #" + AccountNumber() + " est de " + AccountBalance() + " €.");
          }
        if(Profit<0)
          {
          if(Alert_Popping==1)
            Alert("SyFirst_Grid : Position BUY cloturee. Perte = ", MathAbs(Profit), " Mise en veille de ", SleepTime_Min, " min");
          if(Send_Email==1)
            SendMail("SyFirst_Grid : Rapport d'activité", "Bonjour, sur " + Symbol() + " chez " + TerminalCompany() + ", vous avez perdu " + Profit + " €." + "\r\n" + "La balance du compte #" + AccountNumber() + " est de " + AccountBalance() + " €.");
          }
        Defcon=5;
        Sleep(SleepTime_Min*60000);
        }
      if(OrderBuy_Closing==False && Alert_Popping==1)
        Alert("SyFirst_Grid : OrderSend failed with error #",GetLastError());
    
      return(0);
      }
      
  }

}

}

//---------------------------------------------------------------------  Fin du Code

return(0);
}