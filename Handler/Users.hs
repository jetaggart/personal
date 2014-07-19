module Handler.Users where

import Import
import Yesod.Auth

getUsersR :: Handler Html
getUsersR = do
    _ <- requireAuthId
    users <- runDB $ selectList [] []
    defaultLayout $ do
        setTitle "Admin Users"
        $(widgetFile "users")
