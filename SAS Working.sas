options mtrace symbolgen mprint;
options fullstimer;
options pagesize=80 linesize=80;

libname here ("\\tsclient\D\Yashu\Schulich\Study Material\Econometrics 6310\Assignment 3\Working");
data AMGN; set here.health; if ticker="AMGN";
         AMGN=100*ret;
         proc sort; by date;
       data LLY; set here.health; if ticker="LLY";
         LLY=100*ret;
         proc sort; by date;
       data BDX; set here.health; if ticker="BDX";
         BDX=100*ret;
         proc sort; by date;
       data GSK; set here.health; if ticker="GSK" or ticker="GLX";
         GSK=100*ret;
         proc sort; by date;
       data COO; set here.health; if ticker="COO";
         COO=100*ret;
         proc sort; by date;
       data CVS; set here.health; if ticker="CVS";
         CVS=100*ret;
         proc sort; by date;

       data allt; merge GSK COO CVS BDX LLY AMGN ;

       data ff; set here.ff;
        date=dateff;
         HML=100*HML;
         SMB=100*SMB;
         UMD=100*UMD;
         mktrf=100*mktrf;
       proc sort; by date;
       data all; merge allt (in=a) ff; by date;
         if a;
         year=year(date);
         AMGN=AMGN-100*rf;
         BDX=BDX-100*rf;
         LLY=LLY-100*rf;
         COO=COO-100*rf;
         CVS=CVS-100*rf;
         GSK=GSK-100*rf;
       proc means;

       proc model data=all;
         where year<2010;
       
         GSK=  a1 +b_mktrf1*mktrf +b_SMB1*SMB +b_HML1*HML;
         COO= a2 +b_mktrf2*mktrf +b_SMB2*SMB +b_HML2*HML;
         CVS= a3 +b_mktrf3*mktrf +b_SMB3*SMB +b_HML3*HML;
         BDX= a4 +b_mktrf4*mktrf +b_SMB4*SMB +b_HML4*HML;
         AMGN= a5 +b_mktrf5*mktrf +b_SMB5*SMB +b_HML5*HML;
         LLY= a6 +b_mktrf6*mktrf +b_SMB6*SMB +b_HML6*HML;
         fit GSK COO CVS BDX AMGN LLY/outest=neutral1 gmm kernel=(bart,2,0);
         test a1, a2, a3 ,a4 ,a5 ,a6, /out=p;  

       data mktneutral; set all; if _n_=1 then set neutral1;
         mhedge1=(COO*b_mktrf1/b_mktrf2)-GSK;
         mhedge2=(CVS*b_mktrf4/b_mktrf3)-BDX;
         mhedge3=(AMGN*b_mktrf6/b_mktrf5)-LLY;
         hedge=(0.2*mhedge1)+(0.3*mhedge2)+(0.5*mhedge3);
       proc means; 
       var hedge mhedge1 mhedge2 mhedge3 GSK COO CVS BDX LLY AMGN; 
       where year<2010; 

       proc corr data=mktneutral;
       var hedge GSK COO CVS BDX LLY AMGN ;

       proc model data=mktneutral;
         where year<2010;

         hedge= alpha +b_mktrf*mktrf +b_SMB*SMB +b_HML*HML;
         fit hedge/gmm kernel=(bart,2,0); 
       title "Simple Market-Neutral Hedge, In-Sample"; run;

       proc model data=mktneutral;
         where 2009<year;

         hedge= alpha +b_mktrf*mktrf +b_SMB*SMB +b_HML*HML;
         fit hedge/gmm kernel=(bart,2,0); 
       title "Simple Market-Neutral Hedge, Out-of-Sample"; run;

       proc model data=mktneutral;
         where 2009<year;

         hedge= alpha +b_mktrf*mktrf +b_SMB*SMB +b_HML*HML + b_UMD*UMD;
         fit hedge/gmm kernel=(bart,2,0); 
       title "Simple Market-Neutral Hedge, Out-of-Sample"; run;
      