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
    (entryWidget, enctype) <- generateFormPost entryForm
    defaultLayout $ do
        $(widgetFile "blog")

postBlogR :: Handler Html
postBlogR = do
   ((res,entryWidget),enctype) <- runFormPost entryForm
   case res of
        FormSuccess entry -> do
           _ <- runDB $ insert entry
           setMessage $ toHtml $ (entryTitle entry) <> " created"
           redirect BlogR
        _ -> defaultLayout $ do
               setTitle "Please correct your entry form"
               $(widgetFile "entryAddError")