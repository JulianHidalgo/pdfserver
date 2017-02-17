create or replace package body sample_report_pkg
as
 
  /*
 
  Purpose:      Package renders the accommodation list report
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  JHI     05.09.2016  Created
 
  */
 
 
function get_pob_list_rpt (p_pob_list_rpt_guid in raw) return vr_pob_list_rpt%rowtype
as
  l_returnvalue         vr_pob_list_rpt%rowtype;
begin
  
  /*
 
  Purpose:      get a pob_list_rpt record
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  JHI     06.09.2016  Created
 
  */
  
  select *
  into l_returnvalue
  from vr_pob_list_rpt
  where pob_list_rpt_guid = p_pob_list_rpt_guid;
  
  return l_returnvalue;

end get_pob_list_rpt;


function save_report_as_attachment (p_pob_list_rpt     vr_pob_list_rpt%rowtype,
                                    p_pdf_report in blob) return number
as
  l_attachment              vr_attachment%rowtype;
  l_existing_attachment     vr_attachment%rowtype;
  l_attachment_category     varchar2(100) := vr_attachment_pkg.g_attachm_cat_pdf_report;
  l_vessel_name             vessel.vessel_name%type;
  l_returnvalue             number;
begin
  
  l_vessel_name := replace(vessel_pkg.get_vessel_name(p_pob_list_rpt.vessel_id), ' ', '-');

  begin 
    select *
    into l_existing_attachment
    from vr_attachment
    where object_type = vr_pob_list_rpt_pkg.g_object_type
      and object_id = p_pob_list_rpt.pob_list_rpt_guid
      and attachment_category = l_attachment_category
      and deleted_date is null;
  exception
    when no_data_found then
      null;
  end;
  
  if (l_existing_attachment.attachment_id is not null) then
    l_attachment := l_existing_attachment;
  end if;
  
  l_attachment.object_type := vr_pob_list_rpt_pkg.g_object_type;
  l_attachment.object_id := p_pob_list_rpt.pob_list_rpt_guid;
  l_attachment.content := p_pdf_report;
  l_attachment.vessel_id := p_pob_list_rpt.vessel_id;
  l_attachment.mime_type := 'application/pdf';
  l_attachment.attachment_category := l_attachment_category;
  l_attachment.user_editable := appl_pkg.g_appl_no;
  l_attachment.filename := l_vessel_name ||'-AccommodationList'
    || '-' || to_char(p_pob_list_rpt.from_date, 'dd_mm_yy')
    || '-' || to_char(p_pob_list_rpt.to_date, 'dd_mm_yy')
    ||'.pdf' ;
  l_attachment.file_size := dbms_lob.getlength(p_pdf_report);
  
  if (l_attachment.attachment_id is null) then
    l_returnvalue := vr_attachment_pkg.new_attachment(l_attachment);
  else
   l_returnvalue := l_attachment.attachment_id;
    vr_attachment_pkg.set_attachment(l_attachment);
  end if;
  
  return l_returnvalue;
  
end save_report_as_attachment;


procedure get_data(p_pob_list_rpt in vr_pob_list_rpt%rowtype)
as
  l_pob_list_approval             pob_list_approval%rowtype;
  l_project                       contract.contract_name%type;
  l_vessel_name                   vessel.vessel_name%type;
  l_contract_number               contract.contract_code%type;
  l_active_contract               contract_pkg.t_contract_period;
  l_cursor sys_refcursor;
begin
  
  l_vessel_name := vessel_pkg.get_vessel_name(p_pob_list_rpt.vessel_id);
  l_pob_list_approval := pob_list_approval_pkg.get_pob_list_approval(p_pob_list_rpt_guid => p_pob_list_rpt.pob_list_rpt_guid);
  l_active_contract := contract_pkg.get_contract_for_period (p_vessel_id => p_pob_list_rpt.vessel_id, 
    p_from_date => p_pob_list_rpt.from_date,
    p_to_date => p_pob_list_rpt.to_date);
  l_project := nvl(l_active_contract.contract_name, 'N/A');
  l_contract_number := nvl(l_active_contract.contract_code, 'N/A');
  
  open l_cursor for
    select 
      to_char(reported_date, 'dd') "date",
      pr.basic_marine_crew "basicMarineCrew",
      pr.additional_marine_crew "additionalMarineCrew",
      pr.additional_marine_crew_client "additionalMarineCrewClient",
      pr.prosafe_contractors "prosafeContractors",
      pr.catering "catering",
      pr.project_crew "projectCrew",
      pr.pjt_medic "pjtMedic",
      pr.client_personnel "clientPersonnel",
      pr.client_non_project "clientNonProject",
      pr.extra_meals_chargeable "extraMeals",
      pr.total "total",
      pdf_report_util_pkg.escape_string(comments) "comments"
    from vr_pob_report_v pr
    where vessel_id = p_pob_list_rpt.vessel_id
      and reported_date between p_pob_list_rpt.from_date and p_pob_list_rpt.to_date
    order by "date";
    
  apex_json.open_object('pobList');
  
  apex_json.write('vessel', l_vessel_name);
  apex_json.write('fromDate', pdf_report_util_pkg.format_date_time(p_pob_list_rpt.from_date));
  apex_json.write('toDate', pdf_report_util_pkg.format_date_time(p_pob_list_rpt.to_date));
  apex_json.write('contractNo', l_contract_number);
  apex_json.write('project', l_project);
  apex_json.write('approvedBy', nvl(appl_user_pkg.get_user_name(p_pob_list_rpt.approved_by), 'N/A'));
  apex_json.write('customerApprovedBy', nvl(appl_user_pkg.get_user_name(p_pob_list_rpt.customer_approved_by), 'N/A'));  
  apex_json.write('accountingApprovedBy', nvl(appl_user_pkg.get_user_name(l_pob_list_approval.approved_by), 'N/A'));    
  apex_json.write('approvedDate', nvl(to_char(p_pob_list_rpt.approved_date, appl_web_pkg.g_report_signat_date_format), 'N/A'));
  apex_json.write('customerApprovedDate', nvl(to_char(p_pob_list_rpt.customer_approved_date, appl_web_pkg.g_report_signat_date_format), 'N/A'));  
  apex_json.write('accountingApprovedDate', nvl(to_char(l_pob_list_approval.approved_date, appl_web_pkg.g_report_signat_date_format), 'N/A'));    
  apex_json.write('rows', l_cursor);
  
  open l_cursor for
    select 
      sum(pr.basic_marine_crew) "basicMarineCrewTotal",
      sum(pr.additional_marine_crew) "additionalMarineCrewTotal",
      sum(pr.additional_marine_crew_client) "additMarineCrewClientTotal",
      sum(pr.prosafe_contractors) "prosafeContractorsTotal",
      sum(pr.catering) "cateringTotal",
      sum(pr.project_crew) "projectCrewTotal",
      sum(pr.pjt_medic) "pjtMedicTotal",
      sum(pr.client_personnel) "clientPersonnelTotal",
      sum(pr.client_non_project) "clientNonProjectTotal",
      sum(pr.extra_meals_chargeable) "extraMealsTotal",
      sum(pr.total) "roundTotal"
    from vr_pob_report_v pr
    where vessel_id = p_pob_list_rpt.vessel_id
      and reported_date between p_pob_list_rpt.from_date and p_pob_list_rpt.to_date;
  apex_json.write('totals', l_cursor);
  
  apex_json.close_object; -- pobList
  
end get_data;

function render_pob_list_rpt (p_pob_list_rpt_guid in raw) return number
as
  l_data                          clob;
  l_pob_list_rpt                  vr_pob_list_rpt%rowtype;
  l_pdf_report                    blob;  
  l_returnvalue                   number;
begin
 
  /*
 
  Purpose:      render the accommodation list report
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  JHI     05.09.2016  Created
 
  */
 
  l_pob_list_rpt := get_pob_list_rpt(p_pob_list_rpt_guid => p_pob_list_rpt_guid);
  
  apex_json.initialize_clob_output;
  
  apex_json.open_object;
  get_data(l_pob_list_rpt);
  apex_json.close_object;
  
  l_data := apex_json.get_clob_output;
  apex_json.free_output;  
  
  --dbms_output.put_line(l_data);
  
  l_pdf_report := pdf_report_util_pkg.render_pdf_from_template(
      p_title => '',
      p_data => l_data,
      p_main_template => 'SampleReport');
    
  l_returnvalue := save_report_as_attachment (l_pob_list_rpt, l_pdf_report);
  
  return l_returnvalue;
 
end render_pob_list_rpt;


function get_pob_category_color (p_pob_category in varchar2) return varchar2
as
  l_returnvalue string_util_pkg.t_max_db_varchar2;
begin
 
  /*
 
  Purpose:      get gangway status color
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  JHI     11.06.2015  Created
 
  */
  
  l_returnvalue := case
    when p_pob_category = vr_pob_pkg.g_pob_cat_additional_crew then '#618ece'
    when p_pob_category = vr_pob_pkg.g_pob_cat_catering then '#b0c4de'
    when p_pob_category = vr_pob_pkg.g_pob_cat_client_pers then '#a8cb68'
    when p_pob_category = vr_pob_pkg.g_pob_cat_client_non_pers then '#8e74b2'
    when p_pob_category = vr_pob_pkg.g_pob_cat_extra_meal then '#66cdaa'
    when p_pob_category = vr_pob_pkg.g_pob_cat_gangway_controllers then '#5dbad7'
    when p_pob_category = vr_pob_pkg.g_pob_cat_pjt_helideck then '#ff9b53'
    when p_pob_category = vr_pob_pkg.g_pob_cat_pjt_medic then '#94acd7'
    when p_pob_category = vr_pob_pkg.g_pob_cat_prosafe_addit_crew then '#d99493'
    when p_pob_category = vr_pob_pkg.g_pob_cat_marine_crew then '#bdd597'
    when p_pob_category = vr_pob_pkg.g_pob_cat_prosafe_contractors then '#48d1cc'
    when p_pob_category = vr_pob_pkg.g_pob_cat_prosafe_management then '#5f9ea0'
    when p_pob_category = vr_pob_pkg.g_pob_cat_visitors_1_day then '#d16260'
    else 'transparent'
  end;
 
  return l_returnvalue;
 
end get_pob_category_color;


end sample_report_pkg;
/
 
