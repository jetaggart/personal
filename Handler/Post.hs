{-# Language OverloadedStrings #-}

module Handler.Post where

import Import
import Data.Typeable
import Data.Text hiding (replace)


getPostR :: PostId -> Handler Value
getPostR postId = do
  post <- runDB $ get404 postId
  return $ toJSON (Entity postId post)

putPostR :: PostId -> Handler Value
putPostR postId = do
  post <- requireJsonBody :: Handler Post

  runDB $ replace postId post

  sendResponseStatus status200 ("UPDATED" :: Text)

deletePostR :: PostId -> Handler Value
deletePostR postId = error "Not yet implemented: deletePostR"
