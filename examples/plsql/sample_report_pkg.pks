create or replace package sample_report_pkg
as
 
  /*
 
  Purpose:      Package renders the sample list report
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  JHI     16.02.2017  Created
 
  */
 
  g_object_type          constant varchar2(300) := 'VR_POB_LIST_RPT';
 
  -- render the sample list report
  function render_sample_list_rpt (p_pob_list_rpt_guid in raw) return number;
  
  
end sample_report_pkg;
/
 
