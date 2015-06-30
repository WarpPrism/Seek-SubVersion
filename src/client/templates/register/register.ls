Template.register.events {
	'change .avatar-input': (e)!->

		e.preventDefault!

		if typeof FileReader is undefined
			alert '抱歉，你的浏览器不支持预览功能'

		reader = new FileReader()
		file = e.target.files[0]
		reader.readAsDataURL file
		reader.onload = (e)!->
			$ '#cover' .attr 'src', reader.result

	"click .register-back-login": !->
		Session.set('is-login-register', false)
		Session.set('is-login', true)
		Router.go '/login'

	"click .confirm": (e) !->
		count = 8

		test1 = '<ul class="list"></ul>'
		$(".login-register .segment") .addClass "error"
		
		$('.message').empty!

		$(".message").append test1

		# $(".ui.form").form {
		# 	username: {
		# 		identifier : 'usernameForRegister'
		# 		rules: [
		# 			{
		# 				type : 'empty'
		# 				prompt: 'Please enter your username'
		# 			}
		# 		]
		# 	}
		# 	password: {
		# 		identifier : 'passwordForRegister'
		# 		rules: [
		# 			{
		# 				type : 'empty'
		# 				prompt: 'Please enter your password'
		# 			}
		# 			{
		# 				type : 'length[6]'
		# 				prompt: 'Your password must be at least 6 characters'
		# 			}
		# 		]
		# 	}
		# 	passwordConfirm: {
		# 		identifier : 'passwordForRegisterConfirm'
		# 		rules: [
		# 			{
		# 				type : 'match[passwordForRegister]'
		# 				prompt: 'Please check out your password'
		# 			}
		# 		]
		# 	}
		# 	nickname: {
		# 		identifier : 'nickname'
		# 		rules: [
		# 			{
		# 				type : 'empty'
		# 				prompt : 'Please enter your nickname'
		# 			}
		# 		]
		# 	}
		# 	#没有解决正则表达式如何去匹配
		# 	tel: {
		# 		identifier : 'tel'
		# 		rules: [
		# 			{
		# 				type : 'empty'
		# 				prompt : 'Please enter your phone number'
		# 			}
		# 		]
		# 	}
		# 	qq: {
		# 		identifier : 'qq'
		# 		rules: [
		# 			{
		# 				type : 'empty'
		# 				prompt : 'Please enter your qq number'
		# 			}
		# 		]
		# 	}
		# 	mail: {
		# 		identifier : 'mail'
		# 		rules: [
		# 			{
		# 				type : 'email'
		# 				prompt : 'Please enter a valid email address'
		# 			}
		# 		]
		# 	}
		# 	avatar: {
		# 		identifier : 'avatar'
		# 		rules: [
		# 			{
		# 				type : 'empty'
		# 				prompt : 'Please upload your avatar'
		# 			}
		# 		]
		# 	}
		# }

		# if $('.segment').hasClass 'error'
		re_username = /[a-zA-Z0-9]+/
		username = $('.username').find '[name=usernameForRegister]' .val!
		msg1 = '<li class="li-username">Please input your username</li>'
		if !re_username.test(username)
			$('.username').addClass 'error'
			$('.message').find('ul') .append msg1
			count -= 1
		else
			if $('.username').hasClass 'error'
				$('.username').removeClass 'error'
				count += 1
			$('.message').find('.li-username') .remove!

		re_password = /[a-zA-Z0-9]+/
		password = $('.password').find '[name=passwordForRegister]' .val!
		msg2 = '<li class="li-password">Please input your password</li>'
		if !re_password.test(password)
			$('.password').addClass 'error'
			$('.message').find('ul') .append msg2
			count -= 1
		else
			if $('.password').hasClass 'error'
				$('.password').removeClass 'error'
				count += 1
			$('.message').find('.li-password') .remove!

		passwordConfirm = $('.passwordConfirm').find '[name=passwordForRegisterConfirm]' .val!
		msg3 = '<li class="li-confirm">Please check out your password</li>'
		if passwordConfirm != password
			$('.passwordConfirm').addClass 'error'
			$('.message').find('ul') .append msg3
			$('.passwordConfirm').find '[name=passwordForRegisterConfirm]' .val('')
			count -= 1
		else
			if $('.passwordConfirm').hasClass 'error'
				$('.passwordConfirm').removeClass 'error'
				count += 1
			$('.message').find('.li-confirm') .remove!

		re_nickname = /[a-zA-Z0-9]+/
		nickname = $('.nickname').find '[name=nickname]' .val!
		msg4 = '<li class="li-nickname">Please input your nickname</li>'
		if !re_nickname.test(nickname)
			$('.nickname').addClass 'error'
			$('.message').find('ul') .append msg4
			count -= 1
		else
			if $('.nickname').hasClass 'error'
				$('.nickname').removeClass 'error'
				count += 1
			$('.message').find('.li-nickname') .remove!

		re_tel = /^1\d{10}$/
		tel = $('.tel').find '[name=tel]' .val!
		msg5 = '<li class="li-tel">Your phone number must be 11 characters only in number</li>'
		if !re_tel.test(tel)
			$('.tel') .addClass 'error'
			$('.message').find('ul') .append msg5
			count -= 1
		else
			if $('.tel').hasClass 'error'
				$('.tel').removeClass 'error'
				count += 1
			$('.message').find('.li-tel') .remove!

		re_qq = /\d{5}[0-9]+/
		qq = $('.qq').find '[name=qq]' .val!
		msg6 = '<li class="li-qq">Your qq number must be only number more than six</li>'
		if !re_qq.test(qq)
			$('.qq') .addClass 'error'
			$('.message').find('ul') .append msg6
			count -= 1
		else
			if $('.qq').hasClass 'error'
				$('.qq').removeClass 'error'
				count += 1
			$('.message').find('.li-qq') .remove!


		re_mail = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/
		mail = $('.mail').find '[name=mail]' .val!
		msg7 = '<li class="li-mail">Your email must be valid</li>'
		if !re_mail.test(mail)
			$('.mail').addClass 'error'
			$('.message').find('ul') .append msg7
			count -= 1
		else
			if $('.mail').hasClass 'error'
				$('.mail').removeClass 'error'
				count += 1
			$('.message').find('.li-mail') .remove!

		avatar = $('.avatar').find '[name=avatar]' .val!
		msg8 = '<li class="li-avatar">Please upload your avatar</li>'
		if avatar == ""
			$('.avatar').addClass 'error'
			$('.message').find('ul') .append msg8
			count -= 1
		else
			if $('.avatar').hasClass 'error'
				$('.avatar').removeClass 'error'
				count += 1
			$('.message').find('.li-avatar') .remove!

		if count >= 8
			$(".login-register .segment") .removeClass "error" .addClass "success"

	"submit form": (e) ->
		e.prevent-default!

		username = $(e.target).find '[name=usernameForRegister]' .val!
		password = $(e.target).find '[name=passwordForRegister]' .val!
		avatar = $(e.target).find('[name=avatar]')[0].files

		profile = {
			nickname: $(e.target).find '[name=nickname]' .val!
			sex: $(e.target).find '[name=sex]' .val!
			tel: $(e.target).find '[name=tel]' .val!
			qq: $(e.target).find '[name=qq]' .val!
			mail: $(e.target).find '[name=mail]' .val!
			avatarId: null
		}
		is-found = User.find-username username
		if is-found
			Session.set("register-username-error": "用户名已存在")
			return
		else
			$('.username-existed').hide!

		if $('.segment').hasClass 'success'
			User.register(username, password, profile, (error) ->
				if not error
					UploadAvatar.insert avatar
					Router.go '/'
				)
}


Template.register.helpers {
	registerUsernameError: ->
		Session.get "register-username-error"
}