class FinitemInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    #template.content_tag do  #(:div, class: 'chosen_input')
    #  template.concat @builder.text_field(attribute_name, input_html_options)
    #  template.concat new_link
    #end
    unless options[:hide_new_link]
      @builder.select(attribute_name, [[options["initial-text"], options["initial-id"]]], input_html_options, input_html_options) + new_link
    else
      @builder.select(attribute_name, [[options["initial-text"], options["initial-id"]]], input_html_options, input_html_options)
    end
  end

  def input_html_options
    { class: "form-control finitem_select", "data-url" => "/finitems.json" }
  end

  def new_link
    template.content_tag(:a, href: "/finitems/new", class: "new_company_link btn btn-sm blue hidden-xs hidden-sm", "data-remote" => true) do
      template.concat icon_plus
    end
  end

  def icon_plus
    "<i class='fa fa-plus'></i>".html_safe
  end

end