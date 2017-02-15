create or replace package pdf_report_util_pkg
as
 
  /*
 
  Purpose:      Package generates PDF documents using external tools
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  JHI     14.02.2017  Created
 
  */
 
  g_nls_numeric_characters            constant varchar2(100) :=  'NLS_NUMERIC_CHARACTERS = ''.,''';
  
  -- escape a string so it can be used in the JSON template
  function escape_string (p_string in clob) return clob;
                       
  -- render a PDF document based on a template
  function render_pdf_from_template (p_title in varchar2,
                                     p_data in clob,
                                     p_main_template in varchar2,
                                     p_sub_templates in varchar2 := '[]'
                                     ) return blob;
 
 
end pdf_report_util_pkg;
/
 
