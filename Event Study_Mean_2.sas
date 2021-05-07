libname file "\\tsclient\D\Yashu\Schulich\Study Material\Econometrics 6310\Assignment 2\Event Study SAS Files Complete";

%macro scaar;
	
	data firm; set f;
	time=_n_-52-1;

	proc means data=firm; where time<-2;
	var RET;
	output out=o mean=m std=sd;
	
	data event; set firm;
	if _n_=1 then set o;

	if time>=-2; 
	abnormal=RET-m;

	proc means;
	var abnormal;
	output out=ab
	mean=CAAR
	stderr=STDERROR n=n;

	data save; merge o ab;
	EST_STDERROR=sd/sqrt(n);
	SCAAR=CAAR/STDERROR;
	SCAAR_EST=CAAR/(EST_STDERROR);
	proc print; var m CAAR EST_STDERROR STDERROR SCAAR SCAAR_EST;

%mend;

data f; set file.Event1 ;
%scaar
data all; set save;

data f; set file.Event2 ;
%scaar
data all; set all save;	

data f; set file.Event3 ;
%scaar
data all; set all save;

data f; set file.Event4 ;
%scaar
data all; set all save;	

data f; set file.Event5 ;
%scaar
data all; set all save;	

data f; set file.Event6 ;
%scaar
data all; set all save;	

data f; set file.Event7 ;
%scaar
data all; set all save;	

data f; set file.Event8 ;
%scaar
data all; set all save;	

data f; set file.Event9 ;
%scaar
data all; set all save;	

data f; set file.Event10 ;
%scaar
data all; set all save;	

data f; set file.Event11 ;
%scaar
data all; set all save;	

data f; set file.Event12 ;
%scaar
data all; set all save;	

data f; set file.Event13 ;
%scaar
data all; set all save;	

data f; set file.Event14 ;
%scaar
data all; set all save;	

data f; set file.Event15 ;
%scaar
data all; set all save;	

data f; set file.Event16 ;
%scaar
data all; set all save;	

data f; set file.Event17 ;
%scaar
data all; set all save;	

data f; set file.Event18 ;
%scaar
data all; set all save;	

data f; set file.Event19 ;
%scaar
data all; set all save;	

data f; set file.Event20 ;
%scaar
data all; set all save;	

data f; set file.Event21 ;
%scaar
data all; set all save;

data f; set file.Event22 ;
%scaar
data all; set all save;	

data f; set file.Event23 ;
%scaar
data all; set all save;	

data f; set file.Event24 ;
%scaar
data all; set all save;	

proc means data=all;
var SCAAR SCAAR_EST;
output out=ttest
t=ttest_Event ttest_Est;

proc print; var ttest_Event ttest_Est;
proc print data=all;