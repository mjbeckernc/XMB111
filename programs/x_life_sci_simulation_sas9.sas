options fullstimer;

libname temp "/nfsshare/sashls2/mattb/XMB111/data/temp";

/* Parameters for the simulation */
%let numPatients = 1000000;         /* Number of patients */
%let numWeeks = 12;              /* Number of weeks in the trial */
%let responseRate = 0.6;         /* Weekly probability of patient response */
%let adverseEventRate = 0.1;     /* Weekly probability of adverse event */

/* Generate the simulation data */
data trial_simulation;
   do patientID = 1 to &numPatients;
      response_observed = 0;      /* Initialize response observation */
      adverse_event_occurred = 0; /* Initialize adverse event occurrence */
      do week = 1 to &numWeeks;
         /* Simulate patient response based on probability */
         response = rand('BERNOULLI', &responseRate);
         if response = 1 then response_observed + 1;
         
         /* Simulate adverse event based on probability */
         adverse_event = rand('BERNOULLI', &adverseEventRate);
         if adverse_event = 1 then adverse_event_occurred + 1;

         output;
      end;
   end;
run;

/* Summarize the response and adverse event results */
proc means data=trial_simulation noprint;
   class patientID;
   var response_observed adverse_event_occurred;
   output out=trial_summary(drop=_:) 
      sum(response_observed adverse_event_occurred)=sum_resp_obs sum_ae_occur
      mean(response_observed adverse_event_occurred)=mean_resp_obs mean_ae_occur;
run;

data trial_summary;
  set trial_summary;
  where patientID ne .;
run;

/* Visualize the response distribution */
proc sgplot data=trial_summary;
   histogram sum_resp_obs / nbins=12;
   title "Distribution of Patient Responses over the Trial Period";
run;

/* Visualize the adverse event distribution */
proc sgplot data=trial_summary;
   histogram sum_ae_occur / nbins=12;
   title "Distribution of Adverse Events per Patient over the Trial Period";
run;

/* Calculate probability of high responders and frequent adverse events */
%let highResponseThreshold = 6; /* Define high response as 6 or more responses */
%let highAdverseThreshold = 3;  /* Define high adverse event occurrence as 3 or more */

data high_resp_freq_adv_prob;
   set trial_summary;
   highResponder = (sum_resp_obs >= &highResponseThreshold);
   frequentAdverse = (sum_ae_occur >= &highAdverseThreshold);
run;

proc freq data=high_resp_freq_adv_prob;
   tables highResponder frequentAdverse / out=probability_summary;
run;

proc print data=probability_summary;
   title "Probability of High Responders and Frequent Adverse Events";
run;