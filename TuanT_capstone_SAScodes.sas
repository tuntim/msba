*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset 1 Name] btcusd16

[Dataset Description] Historical data for Bitcoin BTC from April 7, 2015 to 
April 6, 2016

[Experimental Unit Description] Details of historical data for Bitcoin BTC from 
April 7, 2015 to April 6, 2016 such as open, close, high, low prices, plus some 
basic calculations to measure the differences and percentage changes in a day.

[Number of Observations] 367
                    
[Number of Features] 13

[Data Source] https://coinmarketcap.com/currencies/bitcoin/historical-data/
?start=20150407&end=20160406 was downloaded and edited to produce file btcusd16

[Data Dictionary] https://coinmarketcap.com/currencies/bitcoin/historical-data/

[Unique ID Schema] The column Date_ID is the primary, unique ID.
;


*
[Dataset 2 Name] btcusd17

[Dataset Description] Historical data for Bitcoin BTC from April 7, 2016 to 
April 6, 2017

[Experimental Unit Description] Details of historical data for Bitcoin BTC from 
April 7, 2015 to April 6, 2016 such as open, close, high, low prices, plus some 
basic calculations to measure the differences and percentage changes in a day.

[Number of Observations] 367
                    
[Number of Features] 13

[Data Source] https://coinmarketcap.com/currencies/bitcoin/historical-data/
?start=20160407&end=20170406 was downloaded and edited to produce file btcusd17

[Data Dictionary] https://coinmarketcap.com/currencies/bitcoin/historical-data/

[Unique ID Schema] The column Date_ID is the primary, unique ID.
;


*
[Dataset 3 Name] btcusd18

[Dataset Description] Historical data for Bitcoin BTC from April 7, 2017 to April 6, 2018

[Experimental Unit Description] Details of historical data for Bitcoin BTC from 
April 7, 2015 to April 6, 2016 such as open, close, high, low prices, plus some 
basic calculations to measure the differences and percentage changes in a day.

[Number of Observations] 367
                    
[Number of Features] 13

[Data Source] https://coinmarketcap.com/currencies/bitcoin/historical-data/
?start=20170407&end=20180406 was downloaded and edited to produce file btcusd18

[Data Dictionary] https://coinmarketcap.com/currencies/bitcoin/historical-data/

[Unique ID Schema] The column Date_ID is the primary, unique ID.
;


* STEP 1: create a macro to load remote Excel files from a Github server;
* STEP 1.1: direct the URL path and create raw data;
%let inputDataset1DSN = btcusd16_raw;
%let inputDataset1URL =
https://github.com/tuntim/msba/blob/master/data/btcusd16.xlsx?raw=true
;
%let inputDataset1Type = XLSX;

%let inputDataset2DSN = btcusd17_raw;
%let inputDataset2URL =
https://github.com/tuntim/msba/blob/master/data/btcusd17.xlsx?raw=true
;
%let inputDataset2Type = XLSX;

%let inputDataset3DSN = btcusd18_raw;
%let inputDataset3URL =
https://github.com/tuntim/msba/blob/master/data/btcusd18.xlsx?raw=true
;
%let inputDataset3Type = XLSX;



* STEP 1.2: load raw datasets over the wire again if they don't exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename 
                tempfile 
                "%sysfunc(getoption(work))/tempfile.xlsx"
            ;
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%macro loadDatasets;
    %do i = 1 %to 3;
        %loadDataIfNotAlreadyAvailable(
            &&inputDataset&i.DSN.,
            &&inputDataset&i.URL.,
            &&inputDataset&i.Type.
        )
    %end;
%mend;
%loadDatasets


* STEP 2: cleanse data and remove any rows with bad ID values;

* STEP 2.1: check btcusd16_raw for bad unique id values;
proc sql;
    /* check for duplicate unique id values; after executing this query, we
       see that btcusd16_raw_dups only has zero duplicated row */
    create table btcusd16_raw_dups as
        select
             Date_ID
            ,Open
            ,High
            ,Low
            ,Close
            ,Volume
            ,MarketCap
            ,count(*) as row_count_for_unique_id_value
        from
            btcusd16_raw
        group by
             Date_ID
        having
            row_count_for_unique_id_value > 1
    ;
    /* remove rows with missing unique id components, or with unique ids that
       do not correspond; after executing this query, the new
       dataset btcusd16 will have no duplicate/repeated unique id values */
    create table btcusd16 as
        select
            *
        from
            btcusd16_raw
        where
            /* remove rows with missing unique id value components */
            not(missing(Date_ID))
            and
            not(missing(MarketCap))
        order by 
            Date_ID
    ;
quit;


* STEP 2.2: check btcusd17_raw for bad unique id values;
proc sql;
    /* check for duplicate unique id values; after executing this query, we
       see that btcusd17_raw_dups only has zero duplicated row */
    create table btcusd17_raw_dups as
        select
             Date_ID
            ,Open
            ,High
            ,Low
            ,Close
            ,Volume
            ,MarketCap
            ,count(*) as row_count_for_unique_id_value
        from
            btcusd17_raw
        group by
            Date_ID
        having
            row_count_for_unique_id_value > 1
    ;
    /* remove rows with missing unique id components, or with unique ids that
       do not correspond; after executing this query, the new
       dataset btcusd17 will have no duplicate/repeated unique id values */
    create table btcusd17 as
        select
            *
        from
            btcusd17_raw
        where
            /* remove rows with missing unique id value components */
            not(missing(Date_ID))
            and
            not(missing(MarketCap))
        order by 
            Date_ID
    ;
quit;


* STEP 2.3: check btcusd18_raw for bad unique id values;
proc sql;
    /* check for duplicate unique id values; after executing this query, we
       see that btcusd18_raw_dups only has zero duplicated row */
    create table btcusd18_raw_dups as
        select
             Date_ID
            ,Open
            ,High
            ,Low
            ,Close
            ,Volume
            ,MarketCap
            ,count(*) as row_count_for_unique_id_value
        from
            btcusd18_raw
        group by
            Date_ID
        having
            row_count_for_unique_id_value > 1
    ;
    /* remove rows with missing unique id components, or with unique ids that
       do not correspond; after executing this query, the new
       dataset btcusd18 will have no duplicate/repeated unique id values */
    create table btcusd18 as
        select
            *
        from
            btcusd18_raw
        where
            /* remove rows with missing unique id value components */
            not(missing(Date_ID))
            and
            not(missing(MarketCap))
        order by 
            Date_ID
    ;
quit;


* STEP 3: build analytic dataset

* STEP 3.1: build a raw analytic dataset btc_analytic_file_raw by combining 
  3 raw datasets imported above, including only the columns and formatting 
  variables needed to address research questions;
proc sql;
    create table btc_analytic_file_raw as
        select
             coalesce(A.Date_ID,B.Date_ID,C.Date_ID)
             AS Date 
            ,coalesce(A.Open,B.Open,C.Open)
             AS Open format=dollar12.2
            ,coalesce(A.High,B.High,C.High)
             AS High format=dollar12.2
            ,coalesce(A.Low,B.Low,C.Low)
             AS Low format=dollar12.2
            ,coalesce(A.Close,B.Close,C.Close)
             AS Close format=dollar12.2
            ,coalesce(A.Volume,B.Volume,C.Volume)
             AS Volumn
            ,coalesce(A.MarketCap,B.MarketCap,C.MarketCap)
             AS MarketCap format=dollar20.2
        from
            btcusd16 as A
                full join
            btcusd17 as B
                on A.Date_ID=B.Date_ID
            
                full join
            btcusd18 as C
                on B.Date_ID=C.Date_ID
        order by
            Date
    ;
quit;


* STEP 3.2: check btc_analytic_file_raw for rows whose unique id values are
  repeated, missing where the column Date is intended to be a primary key.
  After executing this data step, we see that the full joins used above
  introduced duplicates in btc_analytic_file_raw, which need to be mitigated
  before proceeding;
data btc_analytic_file_raw_bad_ids;
    set btc_analytic_file_raw;
    by 
        Date;
    if
        first.Date*last.Date = 0
        or
        missing(Date)
    then
        do;
            output;
        end;
run;


* STEP 3.3: after inspecting the rows in btc_analytic_file_raw_bad_ids, we see
  that either of the rows in duplicate-row pairs can be removed without losing
  values for analysis, so we use proc sort to indiscriminately remove
  duplicates, after which column Date is guaranteed to form a primary key;
proc sort
        nodupkey
        data=btc_analytic_file_raw
        out=btc_analytic_file
    ;
    by
        Date
    ;
run;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Research Question 1: What is a rate of return (ROR) of Bitcoin BTC if one decided to invest one U.S. dollar in April 2015?'
;

title2 justify=left
'Rationale: This should help identify the gain or loss on an investment over a specified time period.'
;

*
Methodology: 
(1) use proc sort to create a temporary sorted table.
(2) then use proc report to print the minimum, maximum of the sorted dataset.
(3) also compute a difference price between the min and max value, and 
a rate or return.

Follow-up Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data...
;

* summarize the data distribution of High variable;
proc univariate data=btc_analytic_file;
    var High;
    histogram High;
run;
quit;

* create a temporary sorted table analytic_file1;
proc sort data=btc_analytic_file out=analytic_file1;
    by Date;
run;

* summarize values for a High variable, plus compute a rate of return;
proc report data=btc_analytic_file out=analytic_file1;
    columns
        High = High_Min
        High = High_Median
        High = High_Max
        Diff
        ROR
    ;  
    define High_Min / min "Minimum Price";
    define High_Median / mean "Median Price";
    define High_Max / max "Maximum Price";

    /* define and compute a price difference between max and min value */ 
    define Diff / display format=dollar12.2;
    define Diff / computed "Min-Max Difference";
    compute Diff;
        Diff = High_Max - High_Min;
    endcomp;
   
    /* define and compute a rate of return, 
       formula = (Current value - original value) / original value) */ 
    define ROR / display format=percent10.2;
    define ROR / computed "Rate of Return";
    compute ROR;
        ROR = ((High_Max - High_Min)/High_Min);
    endcomp;
run;

* clear titles/footnotes;
title;
footnote;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1 justify=left
'Research Question 2: What are the top 10 highest prices and top 10 lowest prices during these years?'
;

title2 justify=left
'Rationale: This would provide more BTC behaviors, movements and how importance of High and Low price affect a rate of return.'
;


*
Methodology: 
(1) use proc sql to create 2 temporary sorted table and output with 10 obs only:
one table is ordered by High descending, and another is ordered by Low variable.
(2) use proc sql to combine 2 sorted tables above as an analytic_file2 and 
analyze benefits of 'buy low, sell high'.
(3) use proc print to display the first twenty rows of the analytic_file2
dataset. This dataset has 100 rows in total. 

Follow-up Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data...
;

* sort by descending High with 10 obs only and sort by Low with 10 obs only;
proc sql outobs=10;
    create table high_top10 as
        select
             Date
            ,High format=dollar12.2
        from
            btc_analytic_file
        order by
            High descending;
    create table low_bottom10 as
        select
             Date
            ,Low format=dollar12.2
        from
            btc_analytic_file
        order by
            Low;
quit;

* create analytic_file2 to analyze 'buy low, sell high' for research question 2;
proc sql;
    create table analytic_file2 as
        select
            Low AS Buy_Low
            label "Buying at Low Price"
           ,High AS Sell_High
            label "Selling at High Price" 
           ,High - Low AS Difference format=dollar12.2
            label "Price Difference"
           ,(High - Low)/Low AS RateOfReturn format=percent12.2
            label "Rate of Return"
        from
            high_top10
           ,low_bottom10;
quit;


* print out analytic_file2 to address 'buy low, sell high' for research question;
proc print data=analytic_file2(obs=20)
    style(header)={just=c};
run;

* clear titles/footnotes;
title;
footnote;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Research Question 3: From the analysis above, it is very important to determine or predict the low price to buy-in, as lowest as possible.
Can we use Fibonacci Retracement ratios of 38.2% (support level) and 61.8% (resistant level) to predict Bitcoin Low prices?'
;

title2 justify=left
'Rationale: This would provide more true understanding of Bitcoin behaviors and movements to forecast or predict the BTC price for the year of 2018.'
;

*
Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on Fibonacci Retracement ratios of
38.2% and 61.8%. Fibonacci retracement is a method of technical analysis for 
determining support and resistance levels. These ratios often used by stock 
analysts approximates to the "golden ratio". 

Methodology: 
(1) use proc sql to create a sorted table analytic_file3 and compute
support levels and resistant levels based on Fibonacci Retracement ratios.
(2) use proc corr to compute coefficients and perform a correlation analysis.
(3) use proc sgplot to display stats graphics.
(4) use proc reg to develop and formulate a linear regression model for 
predicted prices based on resistant level and support level. 
Predicted equation of Y = a + bX, where Y is a dependent variable (High 
variable) and X is an indenpendent variable (ResistantLevel variable or
SupportLevel variable). 

Follow-up Steps: A possible follow-up to this approach is to monitor real-time
Bitcoin price in a few days and use other formal inferential techniques or
possibly use a sine function y=sinx (a sine wave that oscillates, moves up, down 
or side-to-side periodically) to determine and formulate a new formula.
;

* create analytic_file3 that uses to predict BTC High from Low price for
  research question 3;
proc sql;
    create table analytic_file3 as
        select
            Date
           ,High
           ,Low
           ,High - Low AS HighvsLow format=dollar12.2
            label "Difference between High and Low"
           ,(High - Low) * 0.618 + Low AS ResistantLevel format=dollar12.2
            label "Price at Resistant Level"
           ,(High - Low) * 0.382 + Low AS SupportLevel format=dollar12.2
            label "Price at Support Level"
        from
            btc_analytic_file
        order by
            Date descending
        ;
quit;


* use proc corr to compute coefficients;
proc corr 
    data=analytic_file3 nosimple;
    var Low;
    with ResistantLevel;
    with SupportLevel;
run;


* use proc sgplot to display stats graphics;
proc sgplot data=analytic_file3;
    series x=Date y=High / legendlabel="High";
    series x=Date y=Low / legendlabel="Low";
    series x=Date y=ResistantLevel / legendlabel="Resistant Level";
    series x=Date y=SupportLevel / legendlabel="Support Level";
    yaxis label="BTC Movements";
    where Date > 20180400;
    title "Price Prediction based on Resistant and Support Level From April 2018";
run;
footnote;


title 
"Develop a predicted regression model for Low based on Resistant Levels"
;

* RESISTANT LEVEL - develop a predicted regression model for Low based on
  Resistant Levels;
* use proc reg to develop regression model (low = resistantlevel) that has an 
  equation of Y = a + bX, where Y is a dependent variable (High variable) and
  X is an indenpendent variable (ResistantLevel variable);
proc reg
    data=analytic_file3 noprint;
    /* remove simple stats table with noprint option*/
    model Low = ResistantLevel;
run;

* display the slope and intercept of a regression line - resistant level;
proc sgplot
    data=analytic_file3 noautolegend;
    title "Regression Line with Slope and Intercept - Resistant Level";
    reg y=Low x=ResistantLevel;
    
    /* intercept and slope value are computed from proc reg */
    inset "Intercept = 34.89092" "Slope = 0.93681" /
        border title="Parameter Estimates" position=topleft;
run;

* clear titles/footnotes;
title;
footnote;                                                                                                                


title 
"Develop a predicted regression model for Low based on Support Levels"
;

* SUPPORT LEVEL -develop a predicted regression model for Low based on
  Support Levels;
* use proc reg to develop regression model (low = supportlevel) that has an 
  equation of Y = a + bX, where Y is dependent variable (Low Variable) and
  X is indenpendent variable (SuppportLevel Variable);
proc reg
    data=analytic_file3 noprint;
    /* remove simple stats table with noprint option*/
    model Low = SupportLevel;
run;

* display the slope and intercept of a regression line - support level;
proc sgplot
    data=analytic_file3 noautolegend;
    title "Regression Line with Slope and Intercept - Support Level";
    reg y=Low x=SupportLevel;
    
    /* intercept and slope value are computed from proc reg */
    inset "Intercept = 21.16265" "Slope = 0.96036" /
        border title="Parameter Estimates" position=topleft;
run;

* clear titles/footnotes;
title;
footnote;



* please input x1 and x2 as a known or estimated resistant and support level;
data low_prediction;
  
    x1 = 10000;
    x2 = 9000;

    /* Low = 34.89092 + 0.93681 * (ResistantLevel)
       Low = 21.16265 + 0.96036 * (SupportLevel) */
    y1 = 34.89092 + 0.93681 * (x1);
    y2 = 21.16265 + 0.96036 * (x2);
     
    put "The predicted low is in the range of : " y1 y2;
run;

title "Buy Low Prediction";
proc report data=low_prediction;
    columns
        x1
        x2
        y1
        y2
    ;  
    define x1 / "Estimated Price at Resistant Level";
    define x1 / display format=dollar12.2;

    define x2 / "Estimated Price at Support Level";
    define x2 / display format=dollar12.2;

    define y1 / "Predicted Low Price at Resistant Level";
    define y1 / display format=dollar12.2;

    define y2 / "Predicted Low Price at Support Level";
    define y2 / display format=dollar12.2;
run;
title;

* clear titles/footnotes;
title;
footnote;


