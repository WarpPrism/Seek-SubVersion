Template.profileParticipated.helpers ({
	images: ->
		cover = this.cover
		return UploadForActivity.findbyid cover

})
