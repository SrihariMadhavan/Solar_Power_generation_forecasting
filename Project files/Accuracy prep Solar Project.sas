%let nhold=384;
%include "D:\\Hari\\Srihari Offi\\BAPM\\Data Mining and BI\\Forecasting-datasets-OPIM5671\\Macros2.sas" / source2;
%accuracy_prep(indsn=stsm.SOLARPROJPREP, series=AC_POWER, timeid=DATE_TIME, 
    numholdback=&nhold);


/* STSM03s04d.sas */
ods select none;

proc arima data=WORK._TEMP plots=none;
    identify var=_y_fit(96) crosscorr=(AMBIENT_TEMPERATURE(96) 
		MODULE_TEMPERATURE(96) IRRADIATION(96) 'Humidity(%)'n(96) 'Wind Speed(mph)'n(96) 
		);
    estimate p=(1 2 3 4 5 6 7) q=(1 2 3) input=( AMBIENT_TEMPERATURE 1 $ AMBIENT_TEMPERATURE MODULE_TEMPERATURE 1 $ MODULE_TEMPERATURE
		IRRADIATION 'Humidity(%)'n 'Wind Speed(mph)'n 1 $ 'Wind Speed(mph)'n 2 $ 'Wind Speed(mph)'n) method=ML;
    forecast lead=&nhold id=DATE_TIME interval=minute15 out=WORK.ARIMAX7_3_forecast nooutall;
    run;
    estimate p=(1 2 3 4 5 6 7) q=(1 2 3 4) input=( AMBIENT_TEMPERATURE 1 $ AMBIENT_TEMPERATURE MODULE_TEMPERATURE 1 $ MODULE_TEMPERATURE
		IRRADIATION 'Humidity(%)'n 'Wind Speed(mph)'n 1 $ 'Wind Speed(mph)'n 2 $ 'Wind Speed(mph)'n) method=ML;
    forecast lead=&nhold id=DATE_TIME interval=minute15 out=WORK.ARIMAX7_4_forecast nooutall;
    run;
    estimate p=(1 2 3 4 5 6 7 8) q=(1 2 3) input=( AMBIENT_TEMPERATURE 1 $ AMBIENT_TEMPERATURE MODULE_TEMPERATURE 1 $ MODULE_TEMPERATURE
		IRRADIATION 'Humidity(%)'n 'Wind Speed(mph)'n 1 $ 'Wind Speed(mph)'n 2 $ 'Wind Speed(mph)'n) method=ML;
    forecast lead=&nhold id=DATE_TIME interval=minute15 out=WORK.ARIMAX8_3_forecast nooutall;
    run;
    estimate p=(1 2 3 4 5 6 7 8 9) q=(1 2 3) input=( AMBIENT_TEMPERATURE 1 $ AMBIENT_TEMPERATURE MODULE_TEMPERATURE 1 $ MODULE_TEMPERATURE
		IRRADIATION 'Humidity(%)'n 'Wind Speed(mph)'n 1 $ 'Wind Speed(mph)'n 2 $ 'Wind Speed(mph)'n) method=ML;
    forecast lead=&nhold id=DATE_TIME interval=minute15 out=WORK.ARIMAX9_3_forecast nooutall;
    run;
quit;

ods select all;

/* STSM03s04e.sas */


%accuracy(indsn=WORK.ARIMAX7_3_forecast, timeid=DATE_TIME, series=AC_POWER, 
    numholdback=&nhold);
%accuracy(indsn=WORK.ARIMAX7_4_forecast, timeid=DATE_TIME, series=AC_POWER, 
    numholdback=&nhold);
%accuracy(indsn=WORK.ARIMAX8_3_forecast, timeid=DATE_TIME, series=AC_POWER, 
    numholdback=&nhold); 
%accuracy(indsn=WORK.ARIMAX9_3_forecast, timeid=DATE_TIME, series=AC_POWER, 
    numholdback=&nhold);
    