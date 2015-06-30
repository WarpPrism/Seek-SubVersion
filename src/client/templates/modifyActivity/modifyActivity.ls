Template['modifyActivity'].events {
	'submit form': (e)->
		e.preventDefault!

		ActivityName = $(e.target).find('[name=ActivityName]').val()

		ActivityPlace = $(e.target).find('[name=ActivityPlace]').val()

		Deadeline = $(e.target).find('[name=ActivityDeadline]').val()

		files = $(e.target).find('[name=ActivityCover]')[0].files

		open-or-not = $('input:radio[name="PublicInfo"]:checked').val()
		open-or-not-information = false
		if open-or-not is "yes"
			open-or-not-information = true

		ActivityStartTime = $(e.target).find('[name=ActivityStartTime]').val()

		ActivityEndTime = $(e.target).find('[name=ActivityEndTime]').val()

		# here i comment with english because messy code: 
		#ActivityCategory has following types(we can more later, it is example here 
			#and you refer to the Template for detail):
		#  1->sports
		#  2->study
		#  3->eating
		#  4->others
		#so i store 1 or 2 or 3 or 4 to the database instead of sports or study or eating or others
		ActivityCategory = $(e.target).find('[name=ActivityCategory]').val()

		PeopleNumber = $(e.target).find('[name=PeopleNumber]').val()

		ActivityDescription = $(e.target).find('[name=ActivityDescription]').val()



		ori-id = Activity.find-by-id Session.get "activityId" .cover
		UploadForActivity.update (Session.get "activityId"), ori-id, files, ActivityName, PeopleNumber, Deadeline, ActivityPlace, ActivityStartTime, ActivityEndTime, open-or-not-information, ActivityCategory, ActivityDescription


		Router.go('/activity/' + Session.get "activityId")


	# display the uploading file
	'change .ActivityCover': (e)!->

		e.preventDefault!

		if typeof FileReader is undefined
			alert '抱歉，你的浏览器不支持预览功能'

		reader = new FileReader()
		file = e.target.files[0]
		reader.readAsDataURL file
		reader.onload = (e)!->
			$ '#cover' .attr 'src', reader.result
}


Template['modifyActivity'].helpers {
	images: ->
		image-id = Activity.find-by-id Session.get "activityId" .cover
		console.log image-id
		UploadForActivity.findbyid image-id
	activity : ->
		Activity.find-by-id Session.get "activityId"
	option: ->
		return {
			type0: ->
				if Activity.find-by-id Session.get "activityId" .type == '0'
					return 'selected'
			type1: ->
				if Activity.find-by-id Session.get "activityId" .type == '1'
					return 'selected'
			type2: ->
				if Activity.find-by-id Session.get "activityId" .type == '2'
					return 'selected'
			type3: ->
				if Activity.find-by-id Session.get "activityId" .type == '3'
					return 'selected'
			type4: ->
				if Activity.find-by-id Session.get "activityId" .type == '4'
					return 'selected'
			type5: ->
				if Activity.find-by-id Session.get "activityId" .type == '5'
					return 'selected'
			type6: ->
				if Activity.find-by-id Session.get "activityId" .type == '6'
					return 'selected'
		}
	radio-check: ->
		return {
			no: ->
				if Activity.find-by-id Session.get "activityId" .open-or-not == false
					return 'checked'
			yes: ->
				if Activity.find-by-id Session.get "activityId" .open-or-not == true
					return 'checked'
		}

}

Template['modifyActivity'].onRendered !->
	ActivityInformation = Activity.find-by-id Session.get "activityId"
	$('#descriptionForActivity').text(ActivityInformation.description)
	$ '.datetimepicker' .datetimepicker!
	$ 'select.dropdown' .dropdown!
	$ '.ui.radio.checkbox' .checkbox!