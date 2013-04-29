'use strict'

### Filters ###

angular.module('app.global.filters', [])

.filter('flat', ->
  (elements, subarray) ->
    flat = []
    angular.forEach(elements, (v, k) -> flat = flat.concat(v[subarray]))
    return flat
)

.filter('isEmpty', [
  'isEmptyCheck'
  (isEmptyCheck) -> (value) ->
    isEmptyCheck value
])