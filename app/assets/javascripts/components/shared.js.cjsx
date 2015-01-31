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

  render: ->
    <nav className="navbar navbar-default">
      <div className="container-fluid">
        <div className="navbar-header">
          <Link to="app" className="navbar-brand">{@props.site.title}</Link>
        </div>
        <ul className="nav navbar-nav navbar-right">
          <li><a href={@props.site.url} target="_blank"><i className="fa fa-external-link"></i></a></li>
        </ul>
      </div>
    </nav>
)
