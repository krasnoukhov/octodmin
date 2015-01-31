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

  handleError: ->
    alert("Could not load site")

  componentWillMount: ->
    @fetchSite()

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
    <DefaultRoute handler={@Posts} />
  </Route>


Router.run(routes, Router.HistoryLocation, (Handler) ->
  React.render(<Handler />, document.getElementById("app"))
)
