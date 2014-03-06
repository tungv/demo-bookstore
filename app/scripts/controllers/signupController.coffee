angular.module 'BookStore'
  .controller 'SignUpCtrl', class SignUpCtrl
    constructor: (@Auth, @User)->

    submit: (form)->
      return unless form.$valid

      user = new @User {
        email: @email
        password: md5 @password
        displayName: @displayName
      }

      user.$register (resp)-> console.log 'save cb', resp