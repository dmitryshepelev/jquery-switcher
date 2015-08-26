###
Inspired by https://github.com/tannerlinsley/nz-toggle
Require:
     JQuery. The latest.
 *
Usage:
     Html: <switcher name="name_of_the_hidden_input" titles="[left state title, center state title, right state title]"></switcher>
     JavaScript: new Switcher(jqueryElement)
 *
Params:
     @name: hidden input element name
     @value: state of the switcher: 0 - left; 1 - center; 2 - right
     @titles: array of titles for each state
 *
Public methods:
     @toogle(): change state of the switcher from left to right
 *
TODO:
     new features
###
Switcher = (() ->
	Switcher = (element) ->
		@_element = $(element)
		@_params =
			name: ''
			value: 0
			titles: []
		_hiddenElementTemplate = '<input type="hidden" class="pseudo-hidden" name="{0}" value="{1}" />'
		_template = '<div class="switcher-container"><div class="switcher"></div></div>'
		_labelTemplate = '<span class="switcher-label"></span>'

		@_params[element.attributes[i].name] = element.attributes[i].value for attr, i in element.attributes

		@_element.after(_hiddenElementTemplate.format(@_params.name, @_params.value))
		@_element.append(_template)
		@_element.parent().append(_labelTemplate)
		@_element.on('click', @toggle.bind(@))

		@toggle()
		return

	Switcher.prototype =
		constructor: Switcher
		_setValue: ->
			@_params.value = if this._params.value < 2 then this._params.value + 1 else 0
			@_element.attr('value', @_params.value)
			@_element.next().val(@_params.value)
			return
		_changeColor: ->
			switch @_params.value
				when 0 then bgColor = '#60BD68'
				when 1 then bgColor = '#DDDDDD'
				when 2 then bgColor = '#F15854'
				else throw 'Unexpected value {0}'.format(@_params.value);
			$(@_element).css('background-color', bgColor);
			return
		_move: ->
			@_element.find('.switcher').css('left', ((@_params.value / 4) * 100) + '%')
			return
		_updateLabel: ->
			try
				labels = eval(@_params.title)
			catch e
				throw 'Switcher labels error: {0}'.format(@_params.titles);
			label = if labels instanceof Array then labels[@_params.value] else if 'string' is typeof labels then labels else 'Label error'
			@_element.sibling('.switcher-label').text(label)
			return
		toggle: ->
			@_setValue()
			@_changeColor()
			@_move()
			@_updateLabel()
			return
	Switcher
)()

###
Extends String prototype with format function. Template: {number}
@returns {string}
###
String.prototype.format = () ->
	@replace(/{(\d+)}/g, (match, number) ->
		if typeof arguments[number] isnt 'undefined' then arguments[number] else match)