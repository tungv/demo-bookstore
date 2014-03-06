angular.module 'BookStore'
  .factory 'Book', ($resource)->
    $resource '/api/books/:id', {
      id: '@id'
    }, {
      update:
        method: 'PUT'
        params: {}
    }