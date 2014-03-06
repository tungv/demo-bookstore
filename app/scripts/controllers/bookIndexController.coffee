angular.module 'BookStore'
  .controller 'BookIndexCtrl', class BookIndexCtrl
    constructor: (Book)->
      @books = Book.query({limit:10})