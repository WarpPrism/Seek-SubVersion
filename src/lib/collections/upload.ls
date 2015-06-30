root = exports ? @

root.UploadForActivity = {
	collection: new FS.Collection("uploadForActivity", {
		stores: [new FS.Store.FileSystem("uploadForActivity")]
		filter:
			maxSize: 5122880 #5m
			allow:
				contentTypes: ['image/*']
				extensions: ['png', 'jpg', 'jpeg', 'bmp']
			onInvalid: (message)!->
				if Meteor.isClient
					alert message
				else
					console.log message
		})

	insert: (files, ActivityName, PeopleNumber, Deadeline, ActivityPlace, ActivityStartTime, ActivityEndTime, open-or-not-information, ActivityCategory, ActivityDescription)->
		for file in files
			return this.collection.insert file, (err, fileObj)!->
				if err
					console.log 'insert picture error'
				else
					currentUser = User.current-user!
					currentUserUsername = currentUser.username
					Activity.insert  ActivityName, PeopleNumber, Deadeline, ActivityPlace, fileObj._id, ActivityStartTime, ActivityEndTime, open-or-not-information, ActivityCategory, currentUserUsername, ActivityDescription


					
	update: (id, ori-id, files, ActivityName, PeopleNumber, Deadeline, ActivityPlace, ActivityStartTime, ActivityEndTime, open-or-not-information, ActivityCategory, ActivityDescription)->
		if files.length == 0
			currentUser = User.current-user!
			currentUserUsername = currentUser.username
			Activity.update  id, ActivityName, PeopleNumber, Deadeline, ActivityPlace, ori-id, ActivityStartTime, ActivityEndTime, open-or-not-information, ActivityCategory, currentUserUsername, ActivityDescription
		else
			UploadForActivity.delete ori-id
			for file in files
				return this.collection.insert file, (err, fileObj)!->
					if err
						console.log 'insert picture error'
					else
						currentUser = User.current-user!
						currentUserUsername = currentUser.username
						Activity.update  id, ActivityName, PeopleNumber, Deadeline, ActivityPlace, fileObj._id, ActivityStartTime, ActivityEndTime, open-or-not-information, ActivityCategory, currentUserUsername, ActivityDescription

	delete: (activityId)->
		this.collection.remove {
			"_id": activityId
		}


	find: ->
		this.collection.find!
	#you should careful about here, because the CollectionFS does not offer the findone,
	#so i use find which return an array when you use findbyid, so that you iterate the result
	#such as
	#				each images			(the array result that returned by the findbyid)
	#						img(src="{{this.url}}")
	findbyid: (activityId)->
		this.collection.find {"_id": activityId}


}