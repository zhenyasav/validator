Template.registerHelper 'hasErrorClass', -> if Session.get 'error' then 'has-error' else ''

emailRX = /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/


class @Validator

	@matches: (s1,s2) ->
		select: s1
		test: (v) -> v.val() is $(s2).val()

	@newpass: (s1, s2) ->
		select: s1
		test: (v) -> v.val() and v.val().length >= 4 and v.val() isnt $(s2).val()

	@password: (s) ->
		select: s
		test: (v) -> v.val() and v.val().length >= 4

	@something: (s) ->
		select: s
		test: (v) -> v.val()?.trim()

	@email: (s) ->
		select: s
		test: (v) -> emailRX.test v.val()
	
	@date: (s) ->
		select: s
		test: (v) -> moment(v.val()).isValid()
		transform: (s) -> new Date s
	
	@cardNumber: (s) ->
		select: s
		test: (v) -> Packages['mrgalaxy:stripe']?.Stripe?.card?.validateCardNumber? v.val()
	
	@cardDate: (s) ->
		select: s
		test: (v) -> 
			d = v.val().split '/'
			Packages['mrgalaxy:stripe']?.Stripe?.card?.validateExpiry? d?[0], d?[1]
	
	@cardCVC: (s) ->
		select: s
		test: (v) -> Packages['mrgalaxy:stripe']?.Stripe?.card?.validateCVC? v.val()
	
	@checked: (s) ->
		select: s
		test: (v) -> v.prop 'checked'

	@optional: (validator) ->
		select: validator.select
		test: (v) -> if v.val() then validator.test v else true

	constructor: (root, o...) ->
		###
			o is an array like [
				select: '#form input'
				test: (jquery) -> true / false
			,
				select: '#form input 2'
				test: (jquery) -> jquery.doStuff()
			]
		###

		@root = if root instanceof $ then root else $ root

		o = _.compact o 

		_.extend @, o, 
			length: o?.length


	error: (msg, error) ->
		msg = msg + (if error then " : " + error else "")
		@root.find('.error').html msg
		@root.addClass 'has-error'

	validate: (success) ->
		@root.removeClass 'has-error'
		@root.find('.field').removeClass 'invalid'
		@root.find('.error').empty()
		
		valid = true

		for v in @
			field = $ v.select
			if not v.test field
				field.closest('.field').addClass 'invalid'
				field.focus()
				valid = false
				break

		if valid
			d = {}
			for v in @
				input = $ v.select
				value = null
				if input.is '[type="checkbox"],[type="radio"]'
					value = input.prop 'checked'
				else
					value = input.val()
				d[input.attr 'id'] = (v.transform ? (s) -> s) value

			success? d
			true
		else
			false

