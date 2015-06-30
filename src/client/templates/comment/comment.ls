
#Activity.insert '一起跑吧' 100 '2015-06-13' '内环' '/public/images/11.jpg' '2015-06-14' '2015-06-15' true 'sex' 'wangqing'
activities = Activity.allInAarray!
user-id = Meteor.user-id!
is-participator = true
if activities[0].sponsor is user-id
    is-participator = false

id = activities[0]._id
#Activity.add-application id,123456,4,18819451156
#Activity.choose-participator id, 123456
participator = Activity.get-participate-applications id
commented-participator = []
for par in participator
    commented-participator.push par if par.comment isnt undefined
nobody-commented = false
if commented-participator is []
    nobody-commented = true
Template['comment'].events {
    
}

Template['comment'].helpers {
    nobody-commenteds : nobody-commented
    is-participators : is-participator
    participators : participator
    commented-participators : commented-participator
}



Template['comment'].events {
    'submit form': (e)->
        e.preventDefault!
        ActivityName = $(e.target).find('[name=comment]').val()
        #Activity.commentActivity
}

Template['comment'].onRendered !->
    $ '.ui.radio.checkbox' .checkbox!