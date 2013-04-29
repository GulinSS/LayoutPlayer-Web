angular.module('app.membership.services.viewModels.screen', [])

# ### LayoutLink
# Link to another layout from current
  .factory('LinkArea', [
    ->
      class LinkArea

      # Dto is represent server response. It has some properties:
      # First is a ID of current link.
      # Second is a tuple with two properties:
      # >*    *x* - X-coord
      # >*    *y* - Y-coord
      # others:
      # >*    *width* - width of link
      # >*    *height* - height of link
      # >*    *targetLayoutId* - ID of layout which linked with current
        constructor: (dto) ->
          @id = null
          @point = null
          @width = null
          @height = null
          @targetLayoutId = null
          angular.extend this, dto

        # Move to linked layout
        activate: () ->
        update: (changeset) ->
  ])