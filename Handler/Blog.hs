module Handler.Blog where

import Import

getBlogR :: Handler Html
getBlogR = do
    entries <- runDB $ selectList [] [Desc EntryPosted]
    defaultLayout $ do
        $(widgetFile "blog")
