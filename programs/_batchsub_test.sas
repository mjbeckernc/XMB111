%*** Example batch submission program ***;
%global prog;

%include "/nfsshare/sashls2/mattb/GlobalMacros/batchsub.sas";

%batchsub(prog=x_d0_dm);
%batchsub(prog=x_d1_ae);
%batchsub(prog=rldemo);
%batchsub(prog=rlae);
%batchsub(prog=rtdemog);
%batchsub(prog=rtae);

quit;