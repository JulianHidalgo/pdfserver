create or replace package sample_report_pkg
as
 
  /*
 
  Purpose:      Package renders the accommodation list report
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  JHI     16.02.2017  Created
 
  */
 
  g_object_type          constant varchar2(300) := 'VR_POB_LIST_RPT';
 
  -- render the accommodation list report
  function render_pob_list_rpt (p_pob_list_rpt_guid in raw) return number;
  
  function get_pob_category_color (p_pob_category in varchar2) return varchar2;
  
  
end sample_report_pkg;
/
 
