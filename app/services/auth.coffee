angular.module 'BookStore'
  .service 'Auth', class Auth
    @$inject = ['$location', '$rootScope', '$cookieStore', '$http']
    constructor: ($location, $rootScope, $cookieStore, $http)->

      $rootScope.user = $cookieStore.get('user') or {}
      $cookieStore.remove 'user'

      @login = (email, password, callback=angular.noop)->
        $http.post '/api/login?hashed=true', {email, password}
          .then (resp)->
            data = resp.data
            $rootScope.user = data
            callback null, data
          , (err)->
            callback err

      @logout = (callback=angular.noop)->
        $http.post '/api/logout'
          , {}
          , ()->
            $rootScope.user = {}
            callback()

