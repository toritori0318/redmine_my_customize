module RedmineMyCustomize
  module Patches
    module MyHelper
      def sort_activity_events(events)
        events_by_group = events.group_by(&:event_group)
        sorted_events = []
        events.sort {|x, y| y.event_datetime <=> x.event_datetime}.each do |event|
          if group_events = events_by_group.delete(event.event_group)
            group_events.sort {|x, y| y.event_datetime <=> x.event_datetime}.each_with_index do |e, i|
              sorted_events << [e, i > 0]
            end
          end
        end
        sorted_events
      end

      def my_render_project_jump_box
        @default_project = "all"
        @tmp_project = nil
        @param_project = ""
        @param_project_id = ""
        @tmp_project = @default_project ;
        @tmp_project = params[:project] if params[:project] ;
        if @tmp_project != "all"
          @param_project = (params[:project]) ? params[:project] : @default_project.name 
          @param_project_id = (params[:project_id]) ? params[:project_id] : @default_project.id 
          @select_project = Project.find(@param_project_id) 
        end

        # Retrieve them now to avoid a COUNT query
        projects = User.current.projects.all
        if projects.any?
          s = '<select onchange="if (this.value != \'\') { window.location = this.value; }">' +
                "<option value=''>#{ l(:label_jump_to_a_project) }</option>" +
                '<option value="" disabled="disabled">---</option>' +
                "<option value='#{url_for(:controller => 'my', :action => 'page', :project => 'all', :project_id => "")}'>#{ l(:label_all) }</option>" +
                '<option value="" disabled="disabled">---</option>'
          s << project_tree_options_for_select(projects, :selected => @select_project) do |p|
              { :value => url_for(:controller => 'my', :action => 'page', :project => p, :project_id => p.id ) }
          end
          s << '</select>'
          s.html_safe
        end
      end

      def project_tree_options_for_select(projects, options = {})
        s = ''
        project_tree(projects) do |project, level|
          name_prefix = (level > 0 ? ('&nbsp;' * 2 * level + '&#187; ') : '').html_safe
          tag_options = {:value => project.id}
          # add options[:selected] nil check
          if project == options[:selected] || (options[:selected] && options[:selected].respond_to?(:include?) && options[:selected].include?(project))
            tag_options[:selected] = 'selected'
          else
            tag_options[:selected] = nil
          end
          tag_options.merge!(yield(project)) if block_given?
          s << content_tag('option', name_prefix + h(project), tag_options)
        end
        s.html_safe
      end

      def get_title
         if @param_project_id == ""
           return l(:label_all)
         else
           pj = Project.find(@param_project_id)
           return pj.name
         end
      end

      def get_formaction
         if @param_project_id == ""
           return {:controller => 'search', :action => 'index'}
         else
           return {:controller => 'search', :action => 'index', :id => @param_project_id}
         end
      end


      def my_render_project_issue_link
        if @param_project_id == ""
              s =  "<h4 class='issue'>#{ l(:label_issue_sc)} </h4>"
              s << "<table border='0' style='border:1px solid #BBBBBB'>"
              s << "<tr>"
              s << "<td><s>#{ l(:label_issue_new)} </s></td>"
              s << "<td>-"
              s << "</td>"
              s << "</tr>"
              s << "<tr>"
              s << "<td>#{ link_to(l(:label_issue_activity), :controller => 'activities', :show_issues => '1', :user_id => User.current.id) }</td>"
              s << "<td>-"
              s << "</td>"
              s << "</tr>"
              s << "<tr>"
              s << "<td>#{ l(:label_issue_list_default) } </td>"
              s << "<td>"
              s << '<select onchange="if (this.value != \'\') { window.location = this.value; }">' +
                    '<option value="">---</option>' +
                    "<option value='#{url_for(:controller => 'issues', :action => 'index', :set_filter => 1)}'>#{ link_to(l(:label_issue_list)) }</option>" +
                    "<option value='#{url_for(:controller => 'gantts', :action => 'show', :set_filter => 1)}'>#{ link_to(l(:label_gantt)) }</option>" +
                    "<option value='#{url_for(:controller => 'calendars', :action => 'show', :set_filter => 1)}'>#{ link_to(l(:label_calendar)) }</option>" 
              s << '</select>'
              s << "</td>"
              s << "</tr>"
              s << "<tr>"
              s << "<td>#{ l(:label_issue_list_assign) } </td>"
              s << "<td>"
              s << '<select onchange="if (this.value != \'\') { window.location = this.value; }">' +
                    '<option value="">---</option>' +
                    "<option value='#{url_for(:controller => 'issues', :action => 'index', :set_filter => 1)}'>#{ link_to(l(:label_issue_list)) }</option>" +
                    "<option value='#{url_for(:controller => 'gantts', :action => 'show', :set_filter => 1)}'>#{ link_to(l(:label_gantt)) }</option>" +
                    "<option value='#{url_for(:controller => 'calendars', :action => 'show', :set_filter => 1)}'>#{ link_to(l(:label_calendar)) }</option>" 
              s << '</select>'
              s << "</td>"
              s << "</tr>"
              s << "</table>"
          else
              s =  "<h4 class='issue'>#{ l(:label_issue_sc)} </h4>"
              s << "<table border='0' style='border:1px solid #BBBBBB'>"
              s << "<tr>"
              s << "<td>#{ link_to(l(:label_issue_new), :controller => 'issues', :action => 'new', :project_id => @param_project_id)} </td>"
              s << "<td>-"
              s << "</td>"
              s << "</tr>"
              s << "<tr>"
              s << "<td>#{ link_to(l(:label_issue_activity), :controller => 'activities', :id => @param_project_id, :show_issues => '1', :user_id => User.current.id) }</td>"
              s << "<td>-"
              s << "</td>"
              s << "</tr>"
              s << "<tr>"
              s << "<td>#{ l(:label_issue_list_default) } </td>"
              s << "<td>"
              s << '<select onchange="if (this.value != \'\') { window.location = this.value; }">' +
                    '<option value="">---</option>' +
                    "<option value='#{url_for(:controller => 'issues', :action => 'index', :project_id => @param_project_id, :set_filter => 1)}'>#{ link_to(l(:label_issue_list)) }</option>" +
                    "<option value='#{url_for(:controller => 'gantts', :action => 'show', :project_id => @param_project_id, :set_filter => 1)}'>#{ link_to(l(:label_gantt)) }</option>" +
                    "<option value='#{url_for(:controller => 'calendars', :action => 'show', :project_id => @param_project_id, :set_filter => 1)}'>#{ link_to(l(:label_calendar)) }</option>" 
              s << '</select>'
              s << "</td>"
              s << "</tr>"
              s << "<tr>"
              s << "<td>#{ l(:label_issue_list_assign) } </td>"
              s << "<td>"
              s << '<select onchange="if (this.value != \'\') { window.location = this.value; }">' +
                    '<option value="">---</option>' +
                    "<option value='#{url_for(:controller => 'issues', :action => 'index', :project_id => @param_project_id, :set_filter => 1)}'>#{ link_to(l(:label_issue_list)) }</option>" +
                    "<option value='#{url_for(:controller => 'gantts', :action => 'show', :project_id => @param_project_id, :set_filter => 1)}'>#{ link_to(l(:label_gantt)) }</option>" +
                    "<option value='#{url_for(:controller => 'calendars', :action => 'show', :project_id => @param_project_id, :set_filter => 1)}'>#{ link_to(l(:label_calendar)) }</option>" 
              s << '</select>'
              s << "</td>"
              s << "</tr>"
              s << "</table>"
          end
          s.html_safe
      end
    end
  end
end

