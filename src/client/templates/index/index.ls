Template.index.helpers({
    images: ->
        user = Meteor.user!
        profile = user.profile
        avatar = UploadAvatar.findbyid profile.avatarId
        avatar
})

Template.index.events({
    'click .filter-title': (e)->
        $ '.filter-title' .toggle-class 'active'
        $ '.filter-content' .toggle-class 'active'

    'click .filter': ->
        activity-blocks = $ '.activity-item'
        lower-time = $ "[name=lowerTime]" .val!
        upper-time = $ "[name=upperTime]" .val!
        for block in activity-blocks
            time = $(block) .find('.starting-time')[0].innerHTML
            if time >= upper-time or time <= lower-time
                $(block) .add-class 'to-hide'
            else
                $(block) .remove-class 'to-hide'
})

Template.type.helpers({
    images: ->
        user = Meteor.user!
        profile = user.profile
        avatar = UploadAvatar.findbyid profile.avatarId
        avatar
})

Template.type.onRendered !->
    $ '.datetimepicker' .datetimepicker!

Template.type.events({
    'click .filter-title': (e)->
        $ '.filter-title' .toggle-class 'active'
        $ '.filter-content' .toggle-class 'active'

    'click .filter': ->
        activity-blocks = $ '.activity-item'
        lower-time = $ "[name=lowerTime]" .val!
        upper-time = $ "[name=upperTime]" .val!
        for block in activity-blocks
            time = $(block) .find('.starting-time')[0].innerHTML
            if time >= upper-time or time <= lower-time
                $(block) .add-class 'to-hide'
            else
                $(block) .remove-class 'to-hide'
})

Template.index.onRendered !->
    $ '.datetimepicker' .datetimepicker!