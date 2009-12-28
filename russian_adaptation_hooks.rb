class RussianAdaptationHooks < Spree::ThemeSupport::HookListener
  
  insert_after :inside_head do
    %(<link type="text/css" rel="stylesheet" media="screen" href="/stylesheets/screen.ext.css">)
  end
  
end
