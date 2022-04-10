* This is a do-file for STATA programming. In order to use it correctly,
* You should type 'do "ECLS_data.do" nostop' in command line
* after you launch the STATA application.
infile using "ECLS_data.dct"
#delimit ;
keep if  (X1PUBPRI == 1 | 
       X1PUBPRI == 2 | 
       X1PUBPRI == -1 | 
       X1PUBPRI == -9 | 
       X1PUBPRI == .); 
   keep if (X2PUBPRI == 1 | 
       X2PUBPRI == 2 | 
       X2PUBPRI == -1 | 
       X2PUBPRI == -9); 
   keep if (X3PUBPRI == 1 | 
       X3PUBPRI == 2 | 
       X3PUBPRI == -1 | 
       X3PUBPRI == -9 | 
       X3PUBPRI == .); 
   keep if (X4PUBPRI == 1 | 
       X4PUBPRI == 2 | 
       X4PUBPRI == -1 | 
       X4PUBPRI == -9 | 
       X4PUBPRI == .); 
   keep if (X5PUBPRI == 1 | 
       X5PUBPRI == 2 | 
       X5PUBPRI == -1 | 
       X5PUBPRI == -9 | 
       X5PUBPRI == .); 
   keep if (X6PUBPRI == 1 | 
       X6PUBPRI == 2 | 
       X6PUBPRI == -1 | 
       X6PUBPRI == -9 | 
       X6PUBPRI == .); 
   keep if (X7PUBPRI == 1 | 
       X7PUBPRI == 2 | 
       X7PUBPRI == -1 | 
       X7PUBPRI == -9 | 
       X7PUBPRI == .); 
   keep if (X8PUBPRI == 1 | 
       X8PUBPRI == 2 | 
       X8PUBPRI == -1 | 
       X8PUBPRI == -9 | 
       X8PUBPRI == .); 
   keep if (X9PUBPRI == 1 | 
       X9PUBPRI == 2 | 
       X9PUBPRI == -1 | 
       X9PUBPRI == -9 | 
       X9PUBPRI == .); 
   keep if (X1KSCTYP == 1 | 
       X1KSCTYP == 2 | 
       X1KSCTYP == 3 | 
       X1KSCTYP == 4 | 
       X1KSCTYP == -1 | 
       X1KSCTYP == -9 | 
       X1KSCTYP == .); 
   keep if (X2KSCTYP == 1 | 
       X2KSCTYP == 2 | 
       X2KSCTYP == 3 | 
       X2KSCTYP == 4 | 
       X2KSCTYP == -1 | 
       X2KSCTYP == -9); 
   keep if (X4SCTYP == 1 | 
       X4SCTYP == 2 | 
       X4SCTYP == 3 | 
       X4SCTYP == 4 | 
       X4SCTYP == -1 | 
       X4SCTYP == -9 | 
       X4SCTYP == .); 
   keep if (X6SCTYP == 1 | 
       X6SCTYP == 2 | 
       X6SCTYP == 3 | 
       X6SCTYP == 4 | 
       X6SCTYP == -1 | 
       X6SCTYP == -9 | 
       X6SCTYP == .); 
   keep if (X7SCTYP == 1 | 
       X7SCTYP == 2 | 
       X7SCTYP == 3 | 
       X7SCTYP == 4 | 
       X7SCTYP == -1 | 
       X7SCTYP == -9 | 
       X7SCTYP == .); 
   keep if (X8SCTYP == 1 | 
       X8SCTYP == 2 | 
       X8SCTYP == 3 | 
       X8SCTYP == 4 | 
       X8SCTYP == -1 | 
       X8SCTYP == -9 | 
       X8SCTYP == .); 
   keep if (X9SCTYP == 1 | 
       X9SCTYP == 2 | 
       X9SCTYP == 3 | 
       X9SCTYP == 4 | 
       X9SCTYP == -1 | 
       X9SCTYP == -9 | 
       X9SCTYP == .);
   label define X12RACTH
      1  "1: WHITE, NON-HISPANIC"  
      2  "2: BLACK/AFRICAN AMERICAN, NON-HISPANIC"  
      3  "3: HISPANIC, RACE SPECIFIED"  
      4  "4: HISPANIC, NO RACE SPECIFIED"  
      5  "5: ASIAN, NON-HISPANIC"  
      6  "6: NATIVE HAWAIIAN/PACIFIC ISLANDER, NON-HISPANIC"  
      7  "7: AMERICAN INDIAN/ALASKA NATIVE, NON-HISPANIC"  
      8  "8: TWO OR MORE RACES, NON-HISPANIC"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define X1KSCTYP
      1  "1: CATHOLIC"  
      2  "2: OTHER RELIGIOUS"  
      3  "3: OTHER PRIVATE"  
      4  "4: PUBLIC"  
      -1  "-1: NOT APPLICABLE"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define X1PUBPRI
      1  "1: PUBLIC"  
      2  "2: PRIVATE"  
      -1  "-1: NOT APPLICABLE"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define X2KSCTYP
      1  "1: CATHOLIC"  
      2  "2: OTHER RELIGIOUS"  
      3  "3: OTHER PRIVATE"  
      4  "4: PUBLIC"  
      -1  "-1: NOT APPLICABLE"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define X2PUBPRI
      1  "1: PUBLIC"  
      2  "2: PRIVATE"  
      -1  "-1: NOT APPLICABLE"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define X4PUBPRI
      1  "1: PUBLIC"  
      2  "2: PRIVATE"  
      -1  "-1: NOT APPLICABLE"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define X_CHSEX
      1  "1: MALE"  
      2  "2: FEMALE"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define X_DOBMM
      1  "1: JANUARY"  
      2  "2: FEBRUARY"  
      3  "3: MARCH"  
      4  "4: APRIL"  
      5  "5: MAY"  
      6  "6: JUNE"  
      7  "7: JULY"  
      8  "8: AUGUST"  
      9  "9: SEPTEMBER"  
      10  "10: OCTOBER"  
      11  "11: NOVEMBER"  
      12  "12: DECEMBER"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define _9F
      -9  "-9: NOT ASCERTAINED"  
;
   label define PUF129F
      1  "1: 2003/2004"  
      2  "2: 2005/2006"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define PUF130F
      1  "1: CITY(11, 12, 13)"  
      2  "2: SUBURB (21, 22, 23)"  
      3  "3: TOWN (31, 32, 33)"  
      4  "4: RURAL (41, 42, 43)"  
      -1  "-1: NOT APPLICABLE"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define PUF132F
      1  "1: CITY(11, 12, 13)"  
      2  "2: SUBURB (21, 22, 23)"  
      3  "3: TOWN (31, 32, 33)"  
      4  "4: RURAL (41, 42, 43)"  
      -1  "-1: NOT APPLICABLE"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define PUF134F
      1  "1: CITY(11, 12, 13)"  
      2  "2: SUBURB (21, 22, 23)"  
      3  "3: TOWN (31, 32, 33)"  
      4  "4: RURAL (41, 42, 43)"  
      -1  "-1: NOT APPLICABLE"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define PUF137F
      1  "1: CITY (11, 12, 13)"  
      2  "2: SUBURB (21, 22, 23)"  
      3  "3: TOWN (31, 32, 33)"  
      4  "4: RURAL (41, 42, 43)"  
      -1  "-1: NOT APPLICABLE"  
      -9  "-9: NOT ASCERTAINED"  
;
   label define PUF146F
      -2  "-2: DATA SUPPRESSED"  
;
   label values X1MSCALK5 _9F;
   label values X1MSETHK5 _9F;
   label values X1MTHETK5 _9F;
   label values X2MSCALK5 _9F;
   label values X2MSETHK5 _9F;
   label values X2MTHETK5 _9F;
   label values X3MSCALK5 _9F;
   label values X3MSETHK5 _9F;
   label values X3MTHETK5 _9F;
   label values X4MSCALK5 _9F;
   label values X4MSETHK5 _9F;
   label values X4MTHETK5 _9F;
   label values X5MSCALK5 _9F;
   label values X5MSETHK5 _9F;
   label values X5MTHETK5 _9F;
   label values X6MSCALK5 _9F;
   label values X6MSETHK5 _9F;
   label values X6MTHETK5 _9F;
   label values X7MSCALK5 _9F;
   label values X7MSETHK5 _9F;
   label values X7MTHETK5 _9F;
   label values X8MSCALK5 _9F;
   label values X8MSETHK5 _9F;
   label values X8MTHETK5 _9F;
   label values X9MSCALK5 _9F;
   label values X9MSETHK5 _9F;
   label values X9MTHETK5 _9F;
   label values X_DOBYY_R PUF129F;
   label values X1LOCALE PUF130F;
   label values X2LOCALE PUF132F;
   label values X3LOCALE PUF134F;
   label values X4LOCALE PUF137F;
   label values X5LOCALE PUF137F;
   label values X6LOCALE PUF137F;
   label values X7LOCALE PUF137F;
   label values X8LOCALE PUF137F;
   label values X9LOCALE PUF137F;
   label values D6T_ID PUF146F;
   label values D7T_ID PUF146F;
   label values D8T_ID PUF146F;
   label values D9T_ID PUF146F;
   label values T5_ID PUF146F;
   label values T6_ID PUF146F;
   label values T7_ID PUF146F;
   label values T8M_ID PUF146F;
   label values T8R_ID PUF146F;
   label values T8S_ID PUF146F;
   label values T9M_ID PUF146F;
   label values T9R_ID PUF146F;
   label values T9S_ID PUF146F;
   label values X1REGION PUF146F;
   label values X2REGION PUF146F;
   label values X3REGION PUF146F;
   label values X4REGION PUF146F;
   label values X5REGION PUF146F;
   label values X6REGION PUF146F;
   label values X7REGION PUF146F;
   label values X8REGION PUF146F;
   label values X9REGION PUF146F;
   label values X_CHSEX_R X_CHSEX;
   label values X_DOBMM_R X_DOBMM;
   label values X_RACETH_R X12RACTH;
   label values X1KSCTYP X1KSCTYP;
   label values X4SCTYP X1KSCTYP;
   label values X6SCTYP X1KSCTYP;
   label values X7SCTYP X1KSCTYP;
   label values X8SCTYP X1KSCTYP;
   label values X9SCTYP X1KSCTYP;
   label values X1PUBPRI X1PUBPRI;
   label values X2KSCTYP X2KSCTYP;
   label values X2PUBPRI X2PUBPRI;
   label values X3PUBPRI X2PUBPRI;
   label values X5PUBPRI X2PUBPRI;
   label values X4PUBPRI X4PUBPRI;
   label values X6PUBPRI X4PUBPRI;
   label values X7PUBPRI X4PUBPRI;
   label values X8PUBPRI X4PUBPRI;
   label values X9PUBPRI X4PUBPRI;
save "ECLS_data.dta", replace;
use "ECLS_data.dta";
tabulate PSUID;
tabulate T1_ID;
tabulate T2_ID;
tabulate T3_ID;
tabulate T4_ID;
tabulate T5_ID;
tabulate T6_ID;
tabulate T7_ID;
tabulate T8R_ID;
tabulate T8RCLASS;
tabulate T8M_ID;
tabulate T8MCLASS;
tabulate T8S_ID;
tabulate T8SCLASS;
tabulate T9R_ID;
tabulate T9RCLASS;
tabulate T9M_ID;
tabulate T9MCLASS;
tabulate T9S_ID;
tabulate T9SCLASS;
tabulate D2T_ID;
tabulate D4T_ID;
tabulate D6T_ID;
tabulate D7T_ID;
tabulate D8T_ID;
tabulate D9T_ID;
tabulate X_CHSEX_R;
tabulate X_DOBMM_R;
tabulate X_DOBYY_R;
tabulate X_RACETH_R;
tabulate X1LOCALE;
tabulate X2LOCALE;
tabulate X3LOCALE;
tabulate X4LOCALE;
tabulate X5LOCALE;
tabulate X6LOCALE;
tabulate X7LOCALE;
tabulate X8LOCALE;
tabulate X9LOCALE;
tabulate X1REGION;
tabulate X2REGION;
tabulate X3REGION;
tabulate X4REGION;
tabulate X5REGION;
tabulate X6REGION;
tabulate X7REGION;
tabulate X8REGION;
tabulate X9REGION;
tabulate X1PUBPRI;
tabulate X2PUBPRI;
tabulate X3PUBPRI;
tabulate X4PUBPRI;
tabulate X5PUBPRI;
tabulate X6PUBPRI;
tabulate X7PUBPRI;
tabulate X8PUBPRI;
tabulate X9PUBPRI;
tabulate X1KSCTYP;
tabulate X2KSCTYP;
tabulate X4SCTYP;
tabulate X6SCTYP;
tabulate X7SCTYP;
tabulate X8SCTYP;
tabulate X9SCTYP;
summarize X1MTHETK5 X2MTHETK5 X3MTHETK5 X4MTHETK5 X5MTHETK5 X6MTHETK5 X7MTHETK5 X8MTHETK5 X9MTHETK5 X1MSETHK5 X2MSETHK5 X3MSETHK5 X4MSETHK5 X5MSETHK5 X6MSETHK5 X7MSETHK5 X8MSETHK5 X9MSETHK5 X1MSCALK5 X2MSCALK5 X3MSCALK5 X4MSCALK5 X5MSCALK5 X6MSCALK5 X7MSCALK5 X8MSCALK5 X9MSCALK5;
