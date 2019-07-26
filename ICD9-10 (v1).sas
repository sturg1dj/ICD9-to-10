%macro ICD9to10(data=,code=,type=,out=,debug=no);

libname ICD 'F:\DataCuts\Dan\Extra Work';
libname Code 'F:\Code Library\SAS\ICD_expander';
libname Codes 'F:\Code Library\SAS\Code Lists';

%let type = %upcase(&type);
	proc sql;
	create table &out as
	select distinct *
	  from (
	select distinct
           a.&code as ICD9,
		   d.description as ICD9_Desc,
	       b.icd10cm as ICD10,
		   c.Description as ICD10_Desc
	  from &data a,
	       icd.icd9to10 b,
		   codes.icd_all c,
		   icd.icd9_descriptions d
	 where a.&code = b.icd9cm = d.code
	   and b.icd10cm = c.code 
	   and b.type = "&type"
	   and b.type = c.type = d.type
	   and c.'ICD Version'n = 0
	 UNION ALL
	select distinct
           a.&code as ICD9,
		   d.description as ICD9_Desc,
	       b.icd10cm as ICD10,
		   c.Description as ICD10_Desc
	  from &data a,
	       icd.icd10to9 b,
		   codes.icd_all c,
		   icd.icd9_descriptions d
	 where a.&code = b.icd9cm = d.code
	   and b.icd10cm = c.code
	   and b.type = "&type"
	   and b.type = c.type = d.type
	   and c.'ICD Version'n = 0
            );
	 quit;

     proc sql;
	 create table missing as
	 select *
	   from &data
	  where &code not in (select distinct &code from &out);
	quit;
%mend;



*%ICD9to10(data=codes.EGS_LISTICD9,code=code,type=PR,out=OutDat,debug=YES);

/*Data codes.EGS_LISTICD10_Beta;*/
/*set OutDat;*/
/*run;*/

/*proc sql;*/
/*create table codes.EGS_LISTICD10_Beta as*/
/*select distinct */
/*       a.ICD10 as code,*/
/*       a.ICD10_Desc as Description,*/
/*	   b.burden*/
/*  from codes.EGS_LISTICD9 b,*/
/*       outdat a*/
/* where compress(b.code) = compress(a.ICD9)*/
/*order by 3;*/
/*quit;*/
/**/
/**/
/*proc sql;*/
/*create table chk as*/
/*select distinct */
/*       ICD10,*/
/*	   ICD10_Desc*/
/*  from outdat;*/
/*quit;*/