# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def breadcrumbs
    @breadcrumbs = "<div id=\"breadcrumbs\">"
    
    if not @project.nil?
      @breadcrumbs << link_to( 'PROJECT LISTING', '/')
      if params[:project_id]
        @breadcrumbs << '&nbsp; > &nbsp;' + link_to(@project.title, project_path(@project))
        if params[:phase_id].nil? and params[:id]
          @breadcrumbs << '&nbsp; > &nbsp;' + @project.phases.find(params[:id]).title
        elsif params[:phase_id]
          @breadcrumbs << '&nbsp; > &nbsp;' + link_to(@project.phases.find(params[:phase_id]),:controller => 'phases', :action => 'show', :id => params[:phase_id], :project_id => @project.id)
        else
          @breadcrumbs << '&nbsp; > &nbsp;ADD PHASE'
        end
      else
        unless @project.new_record?
          @breadcrumbs << '&nbsp; > &nbsp;' + @project.title 
        else
          @breadcrumbs << '&nbsp; > &nbsp;ADD PROJECT'
        end
      end
    elsif params[:controller] == 'clients'
      if @client.nil?
        @breadcrumbs << "CLIENT LISTING"
      else
        @breadcrumbs << link_to('CLIENT LISTING', clients_path)
        unless @client.new_record?
          @breadcrumbs << '&nbsp; > &nbsp;' + @client.display_name
        else
          @breadcrumbs << '&nbsp; > &nbsp;ADD CLIENT'
        end
      end;
          
    elsif params[:controller] == 'users'
      if @user.nil?
        @breadcrumbs << "USER LISTING"
      else
        @breadcrumbs << link_to('USER LISTING', users_path)
        unless @user.new_record?
          @breadcrumbs << '&nbsp; > &nbsp;' + @user.display_name
        else
          @breadcrumbs << '&nbsp; > &nbsp;ADD USER' 
        end
      end
    else
      @breadcrumbs << "PROJECT LISTING"
    end
    @breadcrumbs << '</div>'
    #@breadcrumbs
  end
  
  def content_head(title, &block)
    concat '<div id="content_head">' + capture(&block) + %^
        <div id="content_head_title">#{title}<br class="clearboth"></div>
        <br class="clearboth">
      </div>
    ^
  end
  
  def content_head_button(&block)
    concat '<div id="content_head_button">'+ capture(&block)+"</div>"
  end
  
  def content_head_form_button(buttons=[])
    '<div id="content_head_form_button">'+ buttons.join('<br class="clearboth"/>') +"</div>"
  end
  
  def return_home
    unless @project.nil?
      return %^
        <div id="return_home">
          #{link_to('Return to Project Listing', '/')}
        </div>
      ^
    else
      if((params[:controller] == 'users') && params[:id])
        return %^
          <div id="return_home">
            #{link_to('Return to User Listing',users_path)}
          </div>
        ^
      elsif((params[:controller] == 'clients') && params[:id])
        return %^
          <div id="return_home">
            #{link_to('Return to Client Listing',clients_path )}
          </div>
        ^
      end
    end
  end
  
  def section_head title, style=""
    %^
      <div class="section_head" style="#{style}">
        <div>#{title}</div>
      </div>
    ^
  end
  
  def button_link(text,add_class ="", options = {}, html_options = {})
    %^
      <span id="" class="button #{add_class}">
        #{link_to text, options, html_options}
      </span>

    ^ 
  end
  def submit_link( text, add_class = "", options = {})
    %^
      <span class="button #{add_class}">
        #{submit_tag text, options}
      </span>
    ^
  end
  def form_element(label,add_class = "text",&block)
    concat "<div class=\"form_element #{add_class}\" >"+"<div>#{label}</div>" + capture(&block) + '</div>'
  end
  def form_section_title text=""
    %^<div class="form_section_title"><span style="font-weight:bold; font-size:12px">#{text}</span></div>^
		
    
  end
	
  
end
