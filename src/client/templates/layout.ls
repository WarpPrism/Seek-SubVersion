Template.layout.helpers {
	userinformation: ->
		avatar = null
		if User.current-user!
			currentUser = User.current-user!
			avatar = UploadAvatar.findbyid currentUser.profile.avatarId
		return avatar
		
	currentUserNickName: ->
		currentUserNickName = User.current-user! .profile.nickname
		currentUserNickName

	/*userNickname: ->
		if User.current-user!
			currentUser = User.current-user!
			return currentUser.profile.nickname*/


	isLoginRegister: ->
		Session.get("is-login-register")

	isLogin: ->
		Session.get("is-login")

}


Template.layout.events {
	'click .logout-btn': !->
		User.logout!
		Router.go "/"

	'click .login-btn': !->	
		Router.go "/login"

	"click .createActivity-btn": !->
		$ ".homeMenuItem" .remove-class "active"
		$ ".centerMenuItem" .remove-class "active"
		if User.current-user!
			Router.go "/createActivity"
		else
			Router.go "/login"

	"click .home-btn": !->
		$ ".homeMenuItem" .add-class "active"
		$ ".centerMenuItem" .remove-class "active"
		Router.go "/"

	"click .profile-btn": !->
		$ ".homeMenuItem" .remove-class "active"
		$ ".centerMenuItem" .add-class "active"
		Router.go "/profile"

	"click .changeProfile-btn": !->
		$ ".homeMenuItem" .remove-class "active"
		$ ".centerMenuItem" .remove-class "active"
		Router.go "/changeProfile"

	"click .theme": !->
		if $ ".toptheme" .has-class "inverted"
			$ ".toptheme" .remove-class "inverted"
			$ ".foottheme" .remove-class "inverted"
		else
			$ ".toptheme" .add-class "inverted"
			$ ".foottheme" .add-class "inverted"

}

Template.layout.onRendered !->
	


