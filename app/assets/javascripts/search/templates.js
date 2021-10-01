function questionTemplate(question) {
  return `<div className="item"><p className="link"><a href="/questions/${question.id}">Link</a></p><p className="title">${question.title}</p><p className="body">${question.body}</p><br></div>`
}

function answerTemplate(answer) {
  return `<div className="item"><p className="link"><a href="/questions/${answer.question_id}">Question Link</a></p><p className="body">${answer.body}</p><br></div>`
}

function commentTemplate(comment) {
  return `<div className="item"><p className="text">${comment.text}</p><br></div>`
}

function userTemplate(user) {
  return `<div className="item"><p className="email">${user.email}</p><br></div>`
}