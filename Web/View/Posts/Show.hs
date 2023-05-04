module Web.View.Posts.Show where
import Web.View.Prelude

import qualified Text.MMark as MMark

data ShowView = ShowView { post :: Include "comments" Post }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>{post.title}</h1>
        <div>{post.createdAt |> dateTime} ({post.createdAt |> timeAgo})</div>
        <div>{post.body |> renderMarkdown}</div>
        <div><a href={NewCommentAction post.id}>New Comment</a></div>
        <div>{forEach post.comments renderComment}</div>
    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Posts" PostsAction
                            , breadcrumbText "Show Post"
                            ]

renderMarkdown text = 
    case text |> MMark.parse "" of
        Left a -> "Something went wrong. Could not parse Markdown."
        Right markdown -> MMark.render markdown |> tshow |> preEscapedToHtml

renderComment comment = 
    [hsx|
        <div>
            <div><b>{comment.author}</b></div>
            <div>{comment.body}</div>
            <div>{comment.createdAt |> timeAgo}</div>
        </div>
    |]