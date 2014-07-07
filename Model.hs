{-# LANGUAGE FlexibleInstances #-}
module Model where

import Yesod
import Data.Text (Text)
import Database.Persist.Quasi
import Data.Typeable (Typeable)
import Control.Applicative
import Control.Monad
import Prelude (($), Show)

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlOnlySettings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")

instance ToJSON (Entity Post) where
    toJSON (Entity pid p) = object
        [ "id"      .= (String $ toPathPiece pid)
        , "title"   .= postTitle p
        , "content" .= postContent p
        ]

instance FromJSON Post where
    parseJSON (Object o) = Post
        <$> o .: "title"
        <*> o .: "content"

    parseJSON _ = mzero

-- { "id": 1, "post_id": 1, "content": "The comment content" }
instance ToJSON (Entity Comment) where
    toJSON (Entity cid c) = object
        [ "id"      .= (String $ toPathPiece cid)
        , "post_id" .= (String $ toPathPiece $ commentPost c)
        , "content" .= commentContent c
        ]
