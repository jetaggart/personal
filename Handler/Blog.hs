module Handler.Blog where

import Import
import Yesod.Form.Nic (YesodNic, nicHtmlField)
instance YesodNic App

entryForm :: Form Entry
entryForm = renderDivs $ Entry
    <$> areq textField (fieldSettingsLabel MsgNewEntryTitle) Nothing
    <*> lift (liftIO getCurrentTime)
    <*> areq nicHtmlField (fieldSettingsLabel MsgNewEntryContent) Nothing

getBlogR :: Handler Html
getBlogR = do
    entries <- runDB $ selectList [] []
    defaultLayout $ do
        $(widgetFile "blog")
