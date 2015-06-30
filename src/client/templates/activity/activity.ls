Template.activity.helpers {
	activity : ->
		Activity.find-by-id Session.get "activityId"
	is-agree : ->
		# Activity.find-by-id Session.get "activityId" .open-or-not
		if Activity.find-as-participator User.current-user!.username
			return User.current-user!.profile.qq
		else
			return false
	is-sponsor: ->
		Meteor.user! .username == Activity.find-by-id Session.get "activityId" .sponsor
	sponsor-phone: ->
		User.find-user (Activity.find-by-id Session.get "activityId" .sponsor) .profile.tel
	username: ->
		Activity.find-by-id Session.get "activityId" .applyList
	is-sponsor-or-participant: ->
		return true if Meteor.user! .username == Activity.find-by-id Session.get "activityId" .sponsor
		for participant in Activity.find-by-id Session.get "activityId" .applyList
			if participant.applier is Meteor.user!._id
				return participant.success
		false
	images: ->
		image-id = Activity.find-by-id Session.get "activityId" .cover
		console.log image-id
		UploadForActivity.findbyid image-id

	commentors: ->
		all-participators = Activity.get-participate-applications Session.get "activityId"
		commentor = []
		for participator in all-participators
			if participator.comment isnt ''
				commentor.push participator
		commentor.sort (a,b) -> if a.comment-date > b.comment-date then 1 else -1
		return commentor
	none-comment: ->
		all-participators = Activity.get-participate-applications Session.get "activityId"
		commentor = []
		for participator in all-participators
			if participator.comment isnt ''
				commentor.push participator
		return commentor.length === 0
	is-participant-success: ->
		return false if Meteor.user! .username == Activity.find-by-id Session.get "activityId" .sponsor
		for participant in Activity.find-by-id Session.get "activityId" .applyList
			if participant.applier is Meteor.user!._id
				return participant.success
		false
	is-commented: ->
		return false if Meteor.user! .username == Activity.find-by-id Session.get "activityId" .sponsor
		for participant in Activity.find-by-id Session.get "activityId" .applyList
			if  participant.applier is Meteor.user!._id and participant.comment isnt ''
				return true
		false
	comment-context: ->
		for participant in Activity.find-by-id Session.get "activityId" .applyList
			if  participant.applier is Meteor.user!._id
				return participant.comment
		return ""
}

Template.activity.events {
	"click .apply" : !->
		if not User.current-user!
			Router.go "/login"
		else
			console.log(Session.get("activityId"), Meteor.user()._id)
			result = Activity.add-application (Session.get "activityId"), (Meteor.user! ._id), 2, (Meteor.user! .profile.tel)
			alert(result)
	"click .select" : (event)!->
		if Meteor.user! .username == Activity.find-by-id Session.get "activityId" .sponsor
			parent = event.target.parentNode
			console.log(this)
			if (parent.class-list.contains("checked"))
				for id,i in Activity.temporary-container
					if id is this.applier then Activity.temporary-container.splice(i, 1); break
				parent.class-list.remove("checked")
			else
				Activity.temporary-container.push this.applier
				parent.class-list.add("checked")
	"click .ensure-select" : (event)!->
		activity-id = Session.get "activityId"
		for id in Activity.temporary-container
			console.log(activity-id, id)
			Activity.choose-participator(activity-id, id, true)
		while Activity.temporary-container.length is not 0
			Activity.temporary-container.pop!
	"click .cancel_select": (event)!->
		Activity.choose-participator(Session.get("activityId"), this.applier, false)

	"click .modify": ->
		Router.go('/modifyActivity/' + Session.get("activityId"))

	"submit form" : (e) !->
		e.prevent-default!
		comment = $(e.target).find '[name=comment]' .val!
		current-time = new Date!
		console.log current-time
		if comment === ''
			alert '你的评论还没有写哦！'
		else
			flag = Activity.commentActivity Session.get("activityId") , Meteor.user-id! , comment, current-time
			if flag is "success"
				alert '评论成功!'
			else
				alert '评论失败!'

	"click .ui.rating": (e)!->
		points = $(e.target.parentNode).rating("getRating")
		activity-id = Session.get "activityId"
		applier-id = $(e.target.parentNode).attr("id")
		flag = Activity.give-marks-to-participator activity-id, applier-id, points
		if flag is "success"
			$(e.target.parentNode).rating("disable")
			alert "谢谢你的评分！（评分后不能更改了）"

}


Template.activity.onRendered !->
	all-participators = Activity.get-participate-applications Session.get "activityId"
	all-rating = $('.ui.rating')
	for participator in all-participators
		for item in all-rating
			if $(item).attr("id") is participator.applier
				if participator.scoreOfParticipator is 0
					$(item).rating("enable")
				else
					for i from 0 to (participator.scoreOfParticipator-1)
						$($("#"+participator.applier+">i")[i]).addClass("active")
					$(item).rating("disable")

	current-date = new Date!
	if current-date > new Date (Activity.find-by-id Session.get "activityId" .startingTime)
		console.log 'hi'
		$ '.modify' .attr 'disabled', 'disabled'

