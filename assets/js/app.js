// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

import { Presence } from "phoenix"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"

function renderAnnotation(msgContainer, {user, body, at}) {
  let template = document.createElement("div")
  template.innerHTML = `
  <a href="#" data-seek="${esc(at)}">
    <b>${esc(user.username)}</b>: ${esc(body)}
  </a>
  `
  msgContainer.appendChild(template)
  msgContainer.scrollTop = msgContainer.scrollheight
}

function esc(str){
  let div = document.createElement("div")
  div.appendChild(document.createTextNode(str))
  return div.innerHTML
}

let doc = document.getElementById("doc")
if (doc) {
  let data_id = doc.getAttribute("data-id")
  console.log("document found! : ", data_id)
  socket.connect()

  let msgContainer = document.getElementById("msg-container")
  let msgInput = document.getElementById("msg-input")
  let postButton = document.getElementById("msg-submit")
  let userList = document.getElementById("user-list")
  let lastSeenId = 0

  let doc_channel = socket.channel("documents:" + data_id, () => {
    return {last_seen_id: lastSeenId}
  })

  let presence = new Presence(doc_channel)

  presence.onSync(() => {
    console.log("presence.onSync")
    userList.innerHTML = presence.list((id, 
      {user: user, metas: [first, ...rest]}) => {
      let count = rest.length + 1
      return `<li>${user.username}: (${count})</li>`
    }).join("")
  })

  postButton.addEventListener("click", e => {
    let payload = {body: msgInput.value, at: new Date().toISOString()}
    doc_channel.push("new_annotation", payload)
      .receive("error", e => console.log(e))
    msgInput.value = ""
  })

  doc_channel.on("new_annotation", (resp) => {
    lastSeenId = resp.id
    renderAnnotation(msgContainer, resp)
  })

  doc_channel.on("ping", ({count}) => console.log("PING", count))

  doc_channel.join()
    .receive("ok", ({annotations}) => {
      let ids = annotations.map(ann => ann.id)
      if (ids.length > 0) { lastSeenId = Math.max(...ids) }
      annotations.forEach( ann => renderAnnotation(msgContainer, ann))
    })
    .receive("error", reason => console.log("join failed", reason))
}