# @cjsx React.DOM

@Header = React.createClass(
  propTypes:
    site: React.PropTypes.object.isRequired

  getInitialState: ->
    { loading: false }

  handleSync: ->
    return if @state.loading
    @setState(loading: true)
    $.postq("default", "/api/syncs").always(@handleResponse).done(@handleSyncSuccess).fail(@handleError)

  handleDeploy: ->
    return if @state.loading
    @setState(loading: true)
    $.postq("default", "/api/deploys").always(@handleResponse).done(@handleDeploySuccess).fail(@handleError)

  handleResponse: ->
    @setState(loading: false)

  handleSyncSuccess: (response) ->
    $.growl(response.syncs.join("\n").replace(/\n/g, "<br>"), growlSuccess)
    $(document).trigger("fetchPosts")

  handleDeploySuccess: (response) ->
    $.growl(response.deploys.join("\n"), growlSuccess)
    $(document).trigger("fetchPosts")

  handleError: (error) ->
    $.growl(error.responseJSON?.errors.join("\n").replace(/\n/g, "<br>"), growlError)

  render: ->
    <div>
      <nav className="navbar navbar-default">
        <div className="container-fluid">
          <div className="navbar-header">
            <Link to="app" className="navbar-brand"><i className="fa fa-fw fa-cog"></i> {@props.site.title}</Link>
          </div>
          <div className="navbar-right">
            <button className="btn btn-primary navbar-btn #{'disabled' if @state.loading}" onClick={@handleSync}>
              <i className="fa fa-fw fa-refresh"></i> Sync
            </button>
            {if @props.site.octodmin.deploys
              deploy = @props.site.octodmin.deploys[0]

              <button className="btn btn-primary navbar-btn #{'disabled' if @state.loading}" onClick={@handleDeploy}>
                <i className="fa fa-fw fa-ship"></i> Deploy
              </button>
            }
            <a href={@props.site.url} target="_blank" className="btn btn-primary navbar-btn">
              <i className="fa fa-fw fa-external-link"></i> Site
            </a>
          </div>
        </div>
      </nav>
    </div>
)
