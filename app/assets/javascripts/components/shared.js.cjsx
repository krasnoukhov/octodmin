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
      </div>
    </nav>
)
