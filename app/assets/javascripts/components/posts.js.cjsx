# @cjsx React.DOM

@Posts = React.createClass(
  propTypes:
    site: React.PropTypes.object.isRequired

  getInitialState: ->
    { loading: false, posts: null }

  fetchPosts: ->
    return if @state.loading
    @setState(loading: true)
    $.get("/api/posts").always(@handleResponse).done(@handleSuccess).fail(@handleError)

  handleResponse: ->
    @setState(loading: false) if @isMounted()

  handleSuccess: (response) ->
    @setState(posts: response.posts) if @isMounted()

  handleError: (error) ->
    $.growl("Could not load posts: #{error.statusText} (#{error.status})", growlError)

  componentWillMount: ->
    @fetchPosts()
    $(document).on("fetchPosts", @fetchPosts)

  componentWillUnmount: ->
    $(document).off("fetchPosts", @fetchPosts)

  render: ->
    <div>
      <NewPostPartial site={@props.site} />

      <Loader loaded={!!@state.posts}>
        {@state.posts?.map(((post) ->
          <PostPartial key={post.identifier} site={@props.site} post={post} />
        ).bind(this))}
      </Loader>

      <footer className="row">
        <div className="col-sm-3">
          <iframe src="http://ghbtns.com/github-btn.html?user=krasnoukhov&repo=octodmin&type=watch&count=true" allowTransparency="true" frameBorder="0" scrolling="no" style={border: "none", overflow: "hidden", width: "170px", height: "20px"}></iframe>
        </div>
        <div className="col-sm-9" style={textAlign: "right"}>
          <a href="https://github.com/krasnoukhov/octodmin" target="_blank">Octodmin</a>, open source project by <a href="http://www.krasnoukhov.com"  target="_blank">Dmitry Krasnoukhov</a>
        </div>
      </footer>
    </div>
)

@NewPostPartial = React.createClass(
  mixins: [ReactRouter.Navigation]

  propTypes:
    site: React.PropTypes.object.isRequired

  getInitialState: ->
    { loading: false }

  form: ->
    $(@refs.form.getDOMNode())

  handleSubmit: (event) ->
    event.preventDefault()
    return if @state.loading

    @setState(loading: true)
    $.post("/api/posts", @form().serialize()).always(@handleResponse).done(@handleSuccess).fail(@handleError)

  handleResponse: ->
    @setState(loading: false)

  handleSuccess: (response) ->
    @form()[0].reset()
    $(document).trigger("fetchPosts")
    @transitionTo("post_edit", post_id: response.posts.identifier)

  handleError: (error) ->
    $.growl(error.responseJSON?.errors.join(", "), growlError)

  render: ->
    <div className="panel panel-default">
      <div className="panel-body">
        <form ref="form" className="form-inline" onSubmit={@handleSubmit}>
          <fieldset className="row" disabled={@state.loading}>
            <div className="col-sm-9 form-group form-group-lg">
              <input className="form-control" style={width: '100%'} name="title" placeholder="Type the title of your new post here" required />
            </div>
            <div className="col-sm-3 buttons">
              <button type="submit" className="btn btn-lg btn-default">Create</button>
            </div>
          </fieldset>
        </form>
      </div>
    </div>
)

@PostPartial = React.createClass(
  mixins: [ReactRouter.Navigation]

  propTypes:
    site: React.PropTypes.object.isRequired
    post: React.PropTypes.object.isRequired

  getInitialState: ->
    { loading: false }

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
    @transitionTo("post_edit", post_id: @props.post.identifier)

  handleRevert: ->
    return if @state.loading
    @setState(loading: true)

    $.ajax(type: "PATCH", url: "/api/posts/#{@props.post.identifier}/revert").
      always(@handleResponse).
      done(@handleSuccess).
      fail(@handleError)

  handleDelete: ->
    if @props.post.added
      return unless confirm("Are you sure? This can't be undone")

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
    $(document).trigger("fetchPosts")

  handleError: (error) ->
    $.growl("Could not load post: #{error.statusText} (#{error.status})", growlError)

  render: ->
    <div className="panel panel-#{@panelClass()}">
      <div className="panel-heading clearfix">
        <h3 className="panel-title pull-left">{@props.post.title}</h3>
        <div className="pull-right">
          {moment((new Date(@props.post.date.replace(/-/g, "/"))).toISOString()).format("LLL")}
        </div>
      </div>
      <div className="panel-body">
        <div className="row">
          <div className="col-sm-9 excerpt" dangerouslySetInnerHTML={{__html: @props.post.excerpt }} />
          <div className="col-sm-3 buttons">
            {if @props.post.deleted
              <div className="btn-group btn-group-sm">
                <button className="btn btn-default #{'disabled' if @state.loading}" onClick={@handleRestore}>Restore</button>
              </div>
            else
              <div className="btn-group btn-group-sm">
                <button className="btn btn-default #{'disabled' if @state.loading}" onClick={@handleEdit}>Edit</button>
                {if @props.post.changed
                  <button className="btn btn-warning #{'disabled' if @state.loading}" onClick={@handleRevert}>Revert</button>
                }
                <button className="btn btn-danger #{'disabled' if @state.loading}" onClick={@handleDelete}>Delete</button>
              </div>
            }
          </div>
        </div>
      </div>
    </div>
)

@PostEdit = React.createClass(
  mixins: [ReactRouter.State, ReactRouter.Navigation]

  propTypes:
    site: React.PropTypes.object.isRequired

  getInitialState: ->
    { loading: false, post: null }

  form: ->
    $(@refs.form.getDOMNode())

  frontMatter: ->
    @props.site.octodmin.front_matter

  fetchPost: ->
    return if @state.loading
    @setState(loading: true)
    $.get("/api/posts/#{@getParams().post_id}").always(@handleResponse).done(@handleSuccess).fail(@handleError)

  handleBack: (event) ->
    event.preventDefault()
    @transitionTo("app")

  handleSubmit: (event) ->
    event.preventDefault()
    return if @state.loading
    @setState(loading: true)

    data = @form().serializeObject()
    $.ajax(type: "PATCH", url: "/api/posts/#{@state.post.identifier}", data: data).
      always(@handleResponse).
      done(@handleFormSuccess).
      fail(@handleError)

  handleResponse: ->
    @setState(loading: false)

  handleSuccess: (response) ->
    @setState(post: response.posts)

  handleFormSuccess: (response) ->
    $.growl("Post is updated", growlSuccess)
    @transitionTo("post_edit", post_id: response.posts.identifier)

  handleError: (error) ->
    $.growl(error.responseJSON?.errors.join(", "), growlError)

  componentWillMount: ->
    @fetchPost()

  componentDidUpdate: ->
    return if !@state.post || !@refs.editor
    return if !/markdown$/.test(@state.post.path) && !/md$/.test(@state.post.path)

    $(@refs.editor.getDOMNode()).markdown(
      autofocus: false
      savable: false
      iconlibrary: "fa"
      resize: "vertical"
      fullscreen:
        enable: false
    )

  render: ->
    <Loader loaded={!!@state.post}>
      {if @state.post
        <form ref="form" className="form-horizontal post-edit" onSubmit={@handleSubmit}>
          <fieldset disabled={@state.loading}>
            <div className="form-group">
              <div className="col-sm-8">
                <input type={@frontMatter().title.type} className="form-control" name="title" placeholder="Title" defaultValue={@state.post.title} required />
              </div>
              <div className="col-sm-4">
                <input type={@frontMatter().date.type} className="form-control" name="date" placeholder="Date" defaultValue={@state.post.date} required />
              </div>
            </div>

            <textarea ref="editor" className="md-content" name="content" rows="15" defaultValue={@state.post.content} placeholder="Post content" required></textarea>

            {Object.keys(@frontMatter()).map(((key) ->
              if key != "title" && key != "date"
                config = @frontMatter()[key]
                title = key.charAt(0).toUpperCase() + key.slice(1)

                <div key={key} className="form-group">
                  <label htmlFor={key} className="col-sm-1 control-label">{title}</label>
                  <div className="col-sm-11">
                    <input type={config.type} className="form-control" name={key} placeholder={title} defaultValue={@state.post[key]} />
                  </div>
                </div>
            ).bind(this))}

            <div className="buttons">
              <button type="submit" className="btn btn-lg btn-success pull-right">Save</button>
              <button className="btn btn-lg btn-default pull-right" onClick={@handleBack}>Back</button>
            </div>
          </fieldset>
        </form>
      }
    </Loader>
)
