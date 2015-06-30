root = exports ? @

root.User = {
    register: (username, password, profile, callback)!->
        options = {
            username:  username
            password: password
            profile: profile
        }
        Accounts.create-user options, callback

    login: (username, password, callback)->
        Meteor.login-with-password username, password, callback

    logout: (callback)->
        Meteor.logout!

    current-user: ->
        Meteor.user!

    change-password: (old-password, new-password, callback)->
        Accounts.changePassword old-password, new-password, callback

    change-information: (profile, callback)->
        user = this.current-user!
        if not user
            callback 1
        else
            id = Meteor.user-id!
            # if passwd is ""
            Meteor.users.update id, {$set: {profile: profile}}, callback
            # else
            #     Meteor.users.update id, {$set: {password: passwd, profile: profile}}, callback
    find-username: (username)->
        is-found = Meteor.users.find {"username" : username}
        if is-found.count() >= 1
            return true
        else
            return false
    find-user: (username)->
        Meteor.users.findOne {'username': username}

    find-all-users: ->
        Meteor.users.find!
}
