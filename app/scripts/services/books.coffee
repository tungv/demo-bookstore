angular.module 'BookStore'
  .factory 'Book', ($resource)->
    $resource "#{window.api_host}/api/books/:id", {
      id: '@id'
    }, {
      update:
        method: 'PUT'
        params: {}
    }


