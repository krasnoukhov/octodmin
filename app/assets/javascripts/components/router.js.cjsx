# @cjsx React.DOM

@Router = ReactRouter
@Link = Router.Link
@Routes = Router.Routes
@Route = Router.Route
@DefaultRoute = Router.DefaultRoute
@RouteHandler = Router.RouteHandler

@App = React.createClass(
  getInitialState: ->
    { site: null }

  fetchSite: ->
    $.get("/api/site").done(@handleSuccess).fail(@handleError)

  handleSuccess: (response) ->
    @setState(site: response.sites)
    $("title").text("Octodmin – #{response.sites.title}")

  handleError: (error) ->
    alert("Could not load site: #{error.statusText} (#{error.status})")

  componentWillMount: ->
    @fetchSite()
    $(document).on("fetchSite", @fetchSite)

  componentWillUnmount: ->
    $(document).off("fetchSite", @fetchSite)

  render: ->
    <Loader loaded={!!@state.site}>
      <Container>
        <Header site={@state.site} />
        <RouteHandler site={@state.site} />
      </Container>
    </Loader>
)

routes =
  <Route path="/" name="app" handler={@App}>
    <Route path="/posts/:post_id/edit" name="post_edit" handler={@PostEdit} />
    <DefaultRoute handler={@Posts} />
  </Route>


Router.run(routes, Router.HistoryLocation, (Handler) ->
  React.render(<Handler />, document.getElementById("app"))
)
