# @cjsx React.DOM

@Router = ReactRouter
@Link = Router.Link
@Routes = Router.Routes
@Route = Router.Route
@DefaultRoute = Router.DefaultRoute
@RouteHandler = Router.RouteHandler

@growlSuccess =
  type: "success"
  delay: 10000

@growlError =
  type: "danger"
  delay: 60000

@Container = React.createClass(
  render: ->
    <div className="container">
      {@props.children}
    </div>
)

@App = React.createClass(
  getInitialState: ->
    { site: null }

  fetchSite: ->
    $.get("/api/site").done(@handleSuccess).fail(@handleError)

  handleSuccess: (response) ->
    @setState(site: response.sites)
    $("title").text("Octodmin – #{response.sites.title}")

  handleError: (error) ->
    $.growl("Could not load site: #{error.statusText} (#{error.status})", growlError)

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
