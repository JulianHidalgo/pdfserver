create or replace package body pdf_report_util_pkg
as
 
  /*
 
  Purpose:      Package generates PDF documents using external tools
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  JHI     14.02.2017  Created
 
  */

function render_pdf_from_template (p_title in varchar2,
                                   p_data in clob,
                                   p_main_template in varchar2,
                                   p_service_url in varchar2,
                                   p_sub_templates in varchar2 := '[]'                                   
                                   ) return blob
as
  l_http_headers            wwv_flow_global.vc_arr2;
  l_http_hdr_values         wwv_flow_global.vc_arr2;
  l_body                    clob;
  l_title                   clob;
  l_main_template           clob;
  l_sub_templates           clob;
  l_data                    clob;
  l_returnvalue             blob;
begin
 
  /*
 
  Purpose:      render a PDF document based on a template
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  JHI     14.02.2017  Created
 
  */
 
  l_http_headers(1) := 'Content-Type';
  l_http_hdr_values(1) := 'application/x-www-form-urlencoded';  
  
  l_title := encode_util_pkg.clob_form_urlencoded(p_title);
  l_main_template := encode_util_pkg.clob_form_urlencoded(p_main_template);
  l_sub_templates := encode_util_pkg.clob_form_urlencoded(p_sub_templates);
  l_data := encode_util_pkg.clob_form_urlencoded(p_data);
  
  l_body := to_clob('title=')||l_title
    ||to_clob('&templateName=')||l_main_template
    ||to_clob('&subTemplateNames=')||l_sub_templates
    ||to_clob('&data=')||l_data;
  
  apex_web_service.g_request_headers(1).name := 'Content-Type';
  apex_web_service.g_request_headers(1).value :=  'application/x-www-form-urlencoded';
  l_returnvalue := apex_web_service.make_rest_request_b(
    p_url               => p_service_url||'build-report',
    p_http_method       => 'POST',
    p_body              => l_body,
    p_parm_name         => apex_util.string_to_table('Content-Type'),
    p_parm_value        => apex_util.string_to_table('application/x-www-form-urlencoded'));
  
  return l_returnvalue;

end render_pdf_from_template;


function escape_string (p_string in clob) return clob
as
  l_returnvalue clob;
begin

  /*
 
  Purpose:      escape a string so it can be used in the JSON template
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  JHI     14.02.2017  Created
 
  */

  l_returnvalue := apex_escape.js_literal(p_string, p_quote => null);
  
  return l_returnvalue;
end;


end pdf_report_util_pkg;
/
 
