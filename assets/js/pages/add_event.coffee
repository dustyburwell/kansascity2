class AddEventPage

   initialize: () ->
      $("input[rel=tipsy]").tipsy({fade: true, gravity: 'w'})
      phase = $("form select[name='event[phase]']")
      day = $("form select[name='event[day]']")
      $("form select[name='event[frequency]']").change () ->
         switch $(this).val()
            when "Monthly", "Bi-Monthly"
               phase.css 'visibility', 'visible'
               day.css 'visibility', 'visible'
            when "Weekly"
               phase.css 'visibility', 'hidden'
               day.css 'visibility', 'visible'
            when "Irregular"
               phase.css 'visibility', 'hidden'
               day.css 'visibility', 'hidden'

$(document).ready () ->
   new AddEventPage().initialize() if $("body").hasClass("event")