title 'REGRESSION';

proc import datafile = 'D:\Users\hyadaval\Downloads\Votes.xls' DMBS=xls out=votes replace;

proc print data=votes;
run;

proc univariate data=votes normal plot;
var savings poverty;
run;

data outliers;
set votes;
if (savings < 165608.5) then output;
run;


data outliers;
set outliers;
if (poverty < 32.575) then output;
run;

/*proc univariate data=outliers normal plot; var savings poverty; run;*/

proc univariate data = outliers normal plot ;  var votes ; run; 


data outliers;
set outliers;
LINCOME = log(income);
run;


proc print data=outliers; run;

/*proc surveyselect data=outliers out=outliers SAMPSIZE=500 method=PPS_seq; run;*/
/**/
/*data train;*/
/*set outliers;*/
/*if (obs <=500) then output;*/
/*run;*/
/**/
/**/
/*data test;*/
/*set outliers;*/
/*if (obs >500) then output;*/
/*run;*/
/**/

/*proc print data=train;*/
/*run;*/

proc surveyselect data=outliers (firstobs = 1 obs =500)

n = 500
out=VOTETRAIN
method=seq;
run;


proc print data= VOTETRAIN;
run;

proc surveyselect data=outliers (firstobs = 501 obs =703)

n = 203
out=VOTETEST
method=seq;
run;

proc print data=VOTETEST;
run;


proc reg data= VOTETRAIN;
model votes = female density poverty veterans / tol vif collin ;
plot r.*p.;
run;

data VOTETEST; set VOTETEST; y_bar = -49.64338 + (1.35214*female) + (0.00273*density) + (0.84358*poverty) +(0.70283*veterans);
Predicted_err = ((votes -y_bar)**2); run;

proc print data=VOTETEST; run;

proc means data=VOTETEST;
var predicted_err;
run;
