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
      .otherwise({
        redirect: '/'
      })

      $locationProvider.html5Mode on

      $httpProvider.interceptors.push ['$q', '$location', ($q, $location)->
        responseError: (resp)->
          if resp.status is 401 or resp.status is 403
            $location.path '/login'

          return $q.reject resp
      ]