Template.login.events {
	"submit form": (e) ->
		e.prevent-default!
		username = $(e.target).find '[name=username]' .val!
		password = $(e.target).find '[name=password]' .val!

		User.login(username, password, (error) ->
			if not error
				Router.go '/'
			else
				$('.login-log .segment') .addClass 'error'
				if User.find-username username
					message = "<li>Please input the correct password"
				else
					message = "<li>Please input the correct username or register a new account"
				$('.login-log .segment .list') .append message
			)

	"click .login-register-btn": !->
		Session.set('is-login', false)
		Router.go '/register'

	"click .login-back-home": !->
		Session.set('is-login-register', true)
		Router.go '/index'
}
