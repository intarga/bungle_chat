import backend/web.{type Context}
import gleam/string_builder
import wisp.{type Request, type Response}

const html = "<!doctype html>
<html lang=\"en\">
  <head>
    <meta charset=\"UTF-8\" />
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />

    <title>🚧 bungle_chat</title>

    <!-- Uncomment this if you add the TailwindCSS integration -->
    <!-- <link rel=\"stylesheet\" href=\"/priv/static/bungle_chat.css\"> -->
    <link
      rel=\"stylesheet\"
      href=\"/static/styles.css\"
    />
    <script type=\"module\" src=\"/static/frontend.min.mjs\"></script>
  </head>

  <body>
    <div id=\"app\"></div>
  </body>
</html>
"

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use _req <- web.middleware(req, ctx)
  wisp.html_response(string_builder.from_string(html), 200)
}
