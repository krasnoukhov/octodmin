# @cjsx React.DOM

@Container = React.createClass(
  render: ->
    <div className="container">
      {@props.children}
    </div>
)

@Header = React.createClass(
  propTypes:
    site: React.PropTypes.object.isRequired

  getInitialState: ->
    { alert: null, success: null, loading: false }

  handleSync: ->
    return if @state.loading
    @setState(loading: true)
    $.post("/api/syncs").always(@handleResponse).done(@handleSuccess).fail(@handleError)

  handleResponse: ->
    @setState(loading: false)

  handleSuccess: (response) ->
    @setState(success: response.syncs.join("\n").replace(/\n/g, "<br>"))
    $(document).trigger("fetchPosts")

  handleError: (error) ->
    @setState(alert: error.responseJSON?.errors.join("\n").replace(/\n/g, "<br>"))

  handleBlur: ->
    @setState(alert: null, success: null) if @isMounted()

  render: ->
    <div>
      <nav className="navbar navbar-default">
        <div className="container-fluid">
          <div className="navbar-header">
            <Link to="app" className="navbar-brand"><i className="fa fa-fw fa-cog"></i> {@props.site.title}</Link>
          </div>
          <div className="navbar-right">
            <button className="btn btn-primary navbar-btn #{'disabled' if @state.loading}" onClick={@handleSync} onBlur={@handleBlur}>
              <i className="fa fa-fw fa-refresh #{'fa-spin' if @state.loading}"></i> Sync
            </button>
            <a href={@props.site.url} target="_blank" className="btn btn-primary navbar-btn">
              <i className="fa fa-fw fa-external-link"></i> Site
            </a>
          </div>
        </div>
      </nav>
      {<div className="alert alert-danger"><span dangerouslySetInnerHTML={{__html: @state.alert }}></span></div> if @state.alert}
      {<div className="alert alert-success"><span dangerouslySetInnerHTML={{__html: @state.success }}></span></div> if @state.success}
    </div>
)
