$ ->
	split = (val) ->
		val.split(/,\s*/)
	extractLast = (term) ->
		split(term).pop()
	$("#bookmark_tag_list").bind("keydown", (event) ->
       if event.keyCode is $.ui.keyCode.TAB and 
          $(@).data("autocomplete").menu.active
              event.preventDefault()
              ).autocomplete
				source: (request, response) ->
					$.getJSON "/tags.json", term: extractLast(request.term),
								response
								
	search: ->
		term = extractLast(@value)
		if term.length < 2
			return false
			
	focus: ->
		false
		
	select: (event, ui) ->
		terms = split(@value)
		terms.pop()
		terms.push ui.item.value
		terms.push ""
		@value = terms.join(", ")
		false