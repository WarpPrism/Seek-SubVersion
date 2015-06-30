Template.commentoritem.helpers ({
	day: ->
		now = new Date()
		#for testing
		#now.setDate(now.getDate()+5)
		daypast = Math.floor((now - this.comment-date) / 86400000)
		if daypast is 0
			return "今天"
		else
			return daypast.toString()+"天前"
	headphoto: ->
		id = User.find-user(this.applier-name).profile.avatarId
		avatar = UploadAvatar.findbyid id
		return avatar
	has-headphoto: ->
		id = User.find-user(this.applier-name).profile.avatarId
		return id !== null
})
