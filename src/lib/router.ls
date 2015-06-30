root = exports ? @

get-local-time = (time)->
        time-string = time.get-full-year! + '/'
        time-string += '0' if (time.get-month! + 1) < 10
        time-string += (time.get-month! + 1) + '/'
        time-string += '0' if time.get-date! < 10
        time-string += time.get-date! + ' '
        time-string += '0' if time.get-hours! < 10
        time-string += time.get-hours! + ':'
        time-string += '0' if time.get-minutes! < 10
        time-string += time.get-minutes!
        return time-string

Meteor.methods {
  'userInCurrentWindow': -> Meteor.user!
}


Router.configure {
    notFoundTemplate: 'notFound'
    layoutTemplate: 'layout'
    wait-on: ->
        Meteor.subscribe 'uploadAvatar'

}

# Router.plugin 'dataNotFound', {notFoundTemplate: 'notFound'}

Router.route '/', -> 
    Router.go '/index'

Router.route 'index/:activityLimit?', {
    name: 'index',
    wait-on: ->
        Session.set('is-login-register', true)
        activity-limit = parse-int(this.params.activity-limit) || 5
        find-options = {sort: {starting-time: -1}, limit: activity-limit}
        Meteor.subscribe 'activities', find-options
        Meteor.subscribe 'uploadForActivity'
        Meteor.subscribe 'userAccount'
        Meteor.subscribe 'uploadAvatar'

    data: ->
        more = (parse-int(this.params.activity-limit) || 5) is Activity.all!.count!
        next = null
        if more
            next = this.route.path({activity-limit: (parse-int(this.params.activity-limit) || 5) + 5})
        now-time = new Date!
        now-time = get-local-time now-time
        console.log  "zhuye"
        
        return {
            activities: Activity.collection.find {deadline: {$gt: now-time}}
            next-path: next
        }
}

Router.route 'type/:typename/:activityLimit?', {
    name: 'type',
    wait-on: ->
        Session.set('is-login-register', true)
        activity-limit = parse-int(this.params.activity-limit) || 5
        find-options = {sort: {starting-time: -1}, limit: activity-limit}
        find-options.type = this.params.typename
        now-time = new Date!
        now-time = get-local-time now-time
        find-options.time = now-time
        Meteor.subscribe 'ActivityForType', find-options
        Meteor.subscribe 'uploadForActivity'
        Meteor.subscribe 'uploadAvatar'
        Meteor.subscribe 'userAccount'

    data: ->
        more = (parse-int(this.params.activity-limit) || 5) is Activity.all!.count!
        next = null
        if more
            next = this.route.path({activity-limit: (parse-int(this.params.activity-limit) || 5) + 5})
        return {
            activities: Activity.collection.find {}
            next-path: next
        }
}

Router.route '/login', {
    name: 'login',
    wait-on: ->
        Session.set('is-login-register', false)
        Session.set('is-login', true)
}

Router.route '/register', {
    name: 'register',
    wait-on: ->
        Session.set('is-login-register', false)
        Session.set('is-login', false)
        Meteor.subscribe 'userAccount'
}

Router.route '/createActivity', {
    name: 'createActivity',
    waitOn: ->
        if not User.current-user!
            this.redirect "/login"
        return Meteor.subscribe 'Activity' and Meteor.subscribe 'uploadForActivity'
}

Router.route '/profile/:activityLimit?', {
    name : 'profile',
    wait-on: ->
        if not User.current-user!
            this.redirect "/login"
        Session.set('is-login-register', true)
        activity-limit = parse-int(this.params.activity-limit) || 6
        find-options = {sort: {createAt: -1}, limit: activity-limit}
        find-options.userinfo = User.current-user!
        Meteor.subscribe 'acvitityForProfile', find-options
        # Meteor.subscribe 'acvitityForProfile', {sort: {createAt: -1}, limit: activity-limit}
        Meteor.subscribe 'uploadForActivity'
        Meteor.subscribe 'userAccount'
    data: ->
        name = User.current-user!
        if name isnt null
            more = (parse-int(this.params.activity-limit) || 6) is Activity.find-by-username-as-sponor(name.username).count!
            next = null
            console.log "here are me"
            if more
                next = this.route.path({activity-limit: (parse-int(this.params.activity-limit) || 6) + 6})
            
            return {
                activities: Activity.find-by-username-as-sponor(name.username)
                next-path: next
            }
        else
            return null 
}

Router.route '/profileParticipated/:activityLimit?', {
    name : 'profileParticipated',
    wait-on: ->
        Session.set('is-login-register', true)
        if not User.current-user!
            this.redirect "/login"
        activity-limit = parse-int(this.params.activity-limit) || 6
        find-options = {sort: {createAt: -1}, limit: activity-limit}
        find-options.userinfo = User.current-user!
        Meteor.subscribe 'acvitityForprofileParticipated', find-options
        # Meteor.subscribe 'acvitityForProfile', {sort: {createAt: -1}, limit: activity-limit}
        Meteor.subscribe 'uploadForActivity'
        Meteor.subscribe 'userAccount'
    data: ->
        name = User.current-user!
        if name isnt null
            more = (parse-int(this.params.activity-limit) || 6) is Activity.find-by-username(name.username).count!
            console.log "参与成功："+Activity.find-by-username-has-participated(name.username).count!
            console.log "未参与成功："+Activity.find-by-username-has-not-participated(name.username).count!
            console.log "参与成功和未参与成功："+Activity.find-by-username(name.username).count!
            next = null
            if more
                next = this.route.path({activity-limit: (parse-int(this.params.activity-limit) || 6) + 6})
            return {
                activities: Activity.find-as-participator(User.current-user!.username)
                next-path: next
            }
}

Router.route '/changeProfile', {
    name: 'changeProfile',
    wait-on: ->
        if not User.current-user!
            this.redirect "/login"
        Meteor.subscribe 'userAccount'
        Meteor.subscribe 'uploadForActivity'
        Meteor.subscribe 'uploadAvatar'
    data: ->
        user = User.current-user!
        if user is null
            user = {
                profile: null
            }
        avatar = null
        if user.profile isnt null
            avatar = UploadAvatar.findbyid user.profile.avatarId    

        return {
            profile: user.profile,
            avatar: avatar
            Currentuser: User.current-user!
        }
}

Router.route '/activity/:activityId', {
    name: 'activity',
    waitOn: ->
        Meteor.subscribe 'Activity'
        Meteor.subscribe 'uploadAvatar'
        Meteor.subscribe 'uploadForActivity'
        Meteor.subscribe 'userAccount'
        Session.set "activityId", this.params.activityId
}

Router.route '/modifyActivity/:activityId', {
    name: 'modifyActivity',
    wait-on: ->
        if not User.current-user!
            this.redirect "/login"
        Session.set "activityId", this.params.activityId
        return Meteor.subscribe 'Activity' and Meteor.subscribe 'uploadForActivity'
        
}

require-login = !->
    if not Meteor.user-id()
        this.redirect '/login'
    else
        this.next!

# Router.on-before-action require-login, {only:}



