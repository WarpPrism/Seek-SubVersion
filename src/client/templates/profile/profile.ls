Template.profile.helpers ({
	images: ->
		cover = this.cover
		console.log cover
		return UploadForActivity.findbyid cover

})

Template.profile.events {
	"click .asparticipator": ->
		Router.go "/profileParticipated/"
}

