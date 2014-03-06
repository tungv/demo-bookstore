angular.module 'BookStore', ['ngResource', 'ngRoute', 'ngCookies', 'ngSanitize']
.config class AppConfig
    @$inject = ['$routeProvider', '$locationProvider', '$httpProvider']
    constructor: ($routeProvider, $locationProvider, $httpProvider)->
      $routeProvider
      .when('/', {
            controller: 'HomeCtrl as home'
            templateUrl: 'partials/home.html'
          })
      .when('/login', {
            controller: 'LoginCtrl as login'
            templateUrl: 'partials/login.html'
          })
      .when('/books', {
            controller: 'BookIndexCtrl as index'
            templateUrl: 'partials/book-index.html'
          })
      .otherwise({
            redirect: '/'
          })

      $locationProvider.html5Mode on

      $httpProvider.interceptors.push [
        '$q', '$location', '$rootScope'
        ($q, $location, $rootScope)->
          responseError: (resp)->
            if resp.status is 401 or resp.status is 403
              $location.path '/login'

            return $q.reject resp

          request: (config)->
            #console.log('request interceptor', config)
            if $rootScope.user?.email? and config.url.match /^\/api\//
              config.headers['X-AUTH-USERNAME'] = $rootScope.user.email
              config.headers['X-AUTH-TOKEN'] = $rootScope.user.password
              config.headers['X-AUTH-HASHED'] = 'true'
              console.log 'Append header for api request'

            return config
      ]