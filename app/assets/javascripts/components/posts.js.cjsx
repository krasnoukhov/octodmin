# @cjsx React.DOM

@Posts = React.createClass(
  propTypes:
    site: React.PropTypes.object.isRequired

  getInitialState: ->
    { alert: null, loading: false, posts: [] }

  fetchPosts: ->
    return if @state.loading
    @setState(loading: true)
    $.get("/api/posts").always(@handleResponse).done(@handleSuccess).fail(@handleError)

  handleResponse: ->
    @setState(loading: false)

  handleSuccess: (response) ->
    @setState(alert: null, posts: response.posts)

  handleError: (error) ->
    @setState(alert: "Could not load posts: #{error.statusText} (#{error.status})")

  componentWillMount: ->
    @fetchPosts()
    $(document).on("fetchPosts", @fetchPosts)
    @timer = setInterval(@fetchPosts, 5000)

  componentWillUnmount: ->
    $(document).off("fetchPosts", @fetchPosts)
    clearInterval(@timer)

  render: ->
    <div>
      {<div className="alert alert-danger">{@state.alert}</div> if @state.alert}
      {@state.posts.map(((post) ->
        <PostPartial key={post.identifier} site={@props.site} post={post} />
      ).bind(this))}
    </div>
)

@PostPartial = React.createClass(
  propTypes:
    site: React.PropTypes.object.isRequired
    post: React.PropTypes.object.isRequired

  getInitialState: ->
    { alert: null, loading: false }

  panelClass: ->
    if @props.post.added
      "success"
    else if @props.post.changed
      "warning"
    else if @props.post.deleted
      "danger"
    else
      "default"

  handleEdit: ->
    # Transition here

  handleDelete: ->
    return if @state.loading
    @setState(loading: true)

    $.ajax(type: "DELETE", url: "/api/posts/#{@props.post.identifier}").
      always(@handleResponse).
      done(@handleSuccess).
      fail(@handleError)

  handleRestore: ->
    return if @state.loading
    @setState(loading: true)

    $.ajax(type: "PATCH", url: "/api/posts/#{@props.post.identifier}/restore").
      always(@handleResponse).
      done(@handleSuccess).
      fail(@handleError)

  handleResponse: ->
    @setState(loading: false)

  handleSuccess: (response) ->
    @setState(alert: null)
    $(document).trigger("fetchPosts")

  handleError: (error) ->
    @setState(alert: "Could not load post: #{error.statusText} (#{error.status})")

  render: ->
    <div className="panel panel-#{@panelClass()}" key={@props.post.id}>
      <div className="panel-heading clearfix">
        <h3 className="panel-title pull-left">{@props.post.title}</h3>
        <div className="pull-right">
          {moment((new Date(@props.post.date)).toISOString()).format("LLL")}
        </div>
      </div>
      <div className="panel-body">
        <div className="row">
          <div className="col-sm-10 excerpt" dangerouslySetInnerHTML={{__html: @props.post.excerpt }} />
          <div className="col-sm-2 buttons">
            {if @props.post.deleted
              <div className="btn-group btn-group-sm">
                <button className="btn btn-primary #{'disabled' if @state.loading}" onClick={@handleRestore}>Restore</button>
              </div>
            else
              <div className="btn-group btn-group-sm">
                <button className="btn btn-primary #{'disabled' if @state.loading}" onClick={@handleEdit}>Edit</button>
                <button className="btn btn-danger #{'disabled' if @state.loading}" onClick={@handleDelete}>Delete</button>
              </div>
            }
          </div>
        </div>
      </div>
    </div>
)
