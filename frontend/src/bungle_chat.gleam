import gleam/list
import lustre
import lustre/attribute as attr
import lustre/effect
import lustre/element
import lustre/element/html
import lustre/event

pub type Dm {
  Dm(content: String, author: String)
}

pub type Model {
  Model(dms: List(Dm), composer_text: String)
}

pub type Msg {
  UserUpdatedComposer(value: String)
  UserSentDm
}

fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  #(Model([Dm("message2", "me"), Dm("message1", "other")], ""), effect.none())
}

pub fn update(model: Model, msg: Msg) -> #(Model, effect.Effect(Msg)) {
  case msg {
    UserUpdatedComposer(composer_text) -> #(
      Model(..model, composer_text: composer_text),
      effect.none(),
    )
    UserSentDm -> #(
      Model([Dm(model.composer_text, "me"), ..model.dms], ""),
      effect.none(),
    )
  }
}

pub fn view(model: Model) -> element.Element(Msg) {
  html.div([attr.id("message-pane")], [
    html.div(
      [attr.id("message-log")],
      list.map(model.dms, fn(dm) {
        case dm.author {
          "me" ->
            html.div([attr.class("self-message")], [element.text(dm.content)])
          _ ->
            html.div([attr.class("other-message")], [element.text(dm.content)])
        }
      }),
    ),
    html.div([attr.id("composer")], [
      html.div(
        [
          attr.class("grow-wrap"),
          attr.attribute("data-replicated-value", model.composer_text),
        ],
        [
          html.textarea(
            [
              // TODO: link with button in a form?
              attr.autofocus(True),
              attr.placeholder("-- Type a message: --"),
              attr.id("composer-input"),
              attr.value(model.composer_text),
              attr.rows(1),
              event.on_input(UserUpdatedComposer),
            ],
            "",
          ),
        ],
      ),
      html.button([attr.id("send-button"), event.on_click(UserSentDm)], [
        element.text(">"),
      ]),
    ]),
  ])
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
