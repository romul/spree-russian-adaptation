class RussianAdaptationHooks < Spree::ThemeSupport::HookListener
  
  insert_after :inside_head do
    %(<link type="text/css" rel="stylesheet" media="screen" href="/stylesheets/screen.ext.css">)
  end
  
  insert_after :admin_inside_head do
    %(<%= javascript_include_tag :ckeditor %>) if defined?(Ckeditor)
  end
end
