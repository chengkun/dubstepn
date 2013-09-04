# set a resize handler on an element, but debounced
debounced_resize = (element, callback) ->
  timeout = null
  $(element).resize(() ->
    if timeout?
      clearInterval(timeout)
    timeout = setTimeout((() ->
      callback()
      timeout = null
    ), 300)
  )

# called every time a new page is loaded (see https://github.com/rails/turbolinks/)
page_init = (first_time) ->
  # make all images, iframes, etc. full-width
  make_full_width = (e) ->
    # get the aspect ratio
    aspect_ratio = 4 / 3
    if $(e).attr("width")? and $(e).attr("height")?
      aspect_ratio = Number($(e).attr("width")) / Number($(e).attr("height"))
    else if e.naturalWidth? and e.naturalWidth?
      aspect_ratio = e.naturalWidth / e.naturalHeight
    else
      aspect_ratio = $(e).innerWidth() / $(e).innerHeight()
    on_resize = () ->
      inner_width = $(e).parent().innerWidth()
      inner_height = Math.round(inner_width / aspect_ratio)
      $(e).width(inner_width)
      $(e).height(inner_height)
    debounced_resize(window, on_resize)
    on_resize()
  $("article > p > iframe").load(() -> make_full_width(this))
  $("article > p > video").load(() -> make_full_width(this))
  $("article > p > embed").load(() -> make_full_width(this))
  $("article > p > img").load(() -> make_full_width(this))

  # load MathJax
  if !first_time
    MathJax.Hub.Queue(["Typeset", MathJax.Hub])

# called once when the DOM is ready
$(document).ready () ->
  page_init(true)
  document.addEventListener("page:change", (() -> page_init(false)))
  document.addEventListener("page:fetch", (() ->
    $(".loading-cover").css("visibility", "visible")
  ))