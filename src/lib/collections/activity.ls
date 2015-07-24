root = exports ? @

root.Activity = {
    collection: new Mongo.Collection('Activity')

    temporary-container: []

    all: ->
        return this.collection.find!

    allInAarray: ->
        return this.collection.find!.fetch!

    insert: (name, num-of-people,  deadline, place, cover, startingTime, endingTime, open-or-not, type, sponsor, description)->
        return this.collection.insert {
            name: name,
            sponsor: sponsor,
            num-of-people: num-of-people,
            starting-time: startingTime,
            ending-time: startingTime,
            deadline: deadline,
            place: place,
            open-or-not: open-or-not,
            type: type,
            cover: cover,
            applyList: [],
            description: description
            createAt: new Date()
            # aver-sponsor-score: undefined
        }

    update: (id, name, num-of-people,  deadline, place, cover, startingTime, endingTime, open-or-not, type, sponsor, description)->
        return this.collection.update {_id: id},
            {$set:
                {
                    name: name,
                    sponsor: sponsor,
                    num-of-people: num-of-people,
                    starting-time: startingTime,
                    ending-time: startingTime,
                    deadline: deadline,
                    place: place,
                    open-or-not: open-or-not,
                    type: type,
                    cover: cover,
                    description: description
                }

            }


    delete: (id)->
        if not this.find-by-id id
            return 'error'
        else
            this.collection.remove id
            return 'success'
    # zuo wei fa qi ren de ji he
    find-by-username-has-not-participated: (username)->
        this.collection.find {
            $or: [
                {"sponsor": username},
                {
                    "applyList": {
                        $elemMatch: {
                            "applierName": username,
                            "success": false
                                    }
                                }
                }
            ]
        }
    find-by-username-as-sponor: (sponsor)->
        this.collection.find {
            "sponsor": sponsor
        }
    find-by-username-has-participated: (username)->
        this.collection.find {
            $or: [
                {"sponsor": username},
                {
                    "applyList": {
                        $elemMatch: {
                            "applierName": username,
                            "success": true
                                    }
                                }
                }
            ]
        }

    find-by-username: (username)->
        this.collection.find {
            $or: [
                {
                    "applyList.applierName": username
                }
                {
                    "sponsor": username
                }
            ]
           
        }

    find-as-participator: (username)->
        this.collection.find {
            "applyList.applierName": username
        }


    find-by-id: (id)->
        return this.collection.find-one {_id: id}

    find-by-type: (type)->
        return this.collection.find {type: type}

    add-application: (id, applier-id, credit, phone)->
        applications = this.get-applications id
        if applications
            for application in applications
                if application.applier is applier-id
                    return 'already applied'
        applications.push {
            applier-name: Meteor.users.find-one {_id: applier-id} .username
            applier: applier-id,
            success: false,
            score-of-participator: 0,
            comment: '',
            comment-date: new Date(),
            createAt: new Date(),
            score-of-sponsor: 0,
            credit: credit,
            phone: phone
        }
        this.collection.update {_id: id}, {$set: {applyList: applications}}
        return 'success'

    get-applications: (id)->
        activity = this.find-by-id id
        if not activity
            return null
        return activity.applyList

    get-participate-applications: (id)->
        applications = this.get-applications id
        if not applications
            return null
        result = []
        for application in applications
            result.push application if application.success
        return result

    choose-participator: (id, applier-id, select-or-cancle)->
        applications = this.get-applications id
        return 'error' if not applications
        for application in applications
            if application.applier is applier-id
                application.success = select-or-cancle
        this.collection.update id, {$set: {applyList: applications}}
        return 'success'

    calculate-score: (id)->
        participators = this.get-participate-applications id
        scores = 0
        num = 0
        for participator in participators
            if participator.score-of-sponsor
                scores += participator.score-of-sponsor
                ++num
        return scores * 1.0 / num
 
    comment-activity: (id, applier-id, comment, date)->
        participators = this.get-applications id
        for item in participators
            if item.success and item.applier is applier-id
                item.comment = comment
                item.comment-date = date
                this.collection.update id, {$set: {applyList: participators}}
                return 'success'
        return 'error'

    give-marks-to-participator: (activity-id, applier-id, grade)->
        participators = this.get-applications activity-id
        for item in participators
            if item.success and item.applier is applier-id
                if item.score-of-participator isnt 0
                    return 'error'
                else
                    item.score-of-participator = grade
                    this.collection.update activity-id, {$set: {applyList: participators}}
                    return 'success'
        return 'error'
}
