{-# Language OverloadedStrings #-}

module Handler.Post where

import Import

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
deletePostR postId = do
   runDB $ delete postId
   sendResponseStatus status200 ("DELETED" :: Text)
