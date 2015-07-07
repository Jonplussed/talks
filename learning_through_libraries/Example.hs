{-# LANGUAGE OverloadedStrings #-}

module Example (main) where

import Data.List (foldl')

import qualified Data.ByteString.Char8    as C8
import qualified Data.ByteString.Lazy     as LazyBS
import qualified Data.Map                 as Map
import qualified Data.Text                as Text
import qualified Network.HTTP.Types       as Http
import qualified Network.URI              as Uri
import qualified Network.Wai              as Wai
import qualified Network.Wai.Parse        as Wai
import qualified Network.Wai.Handler.Warp as Warp

type Params = Map.Map C8.ByteString C8.ByteString

main :: IO ()
main = Warp.run 1337 myApp

-- the main application

myApp :: Wai.Application
myApp request responder =
    case method of
      Right m -> do
        params <- requestParams request
        responder $ router m path params
      Left _  -> error "unknown request method"
  where
    path = Wai.pathInfo request
    method = Http.parseMethod $ Wai.requestMethod request

router :: Http.StdMethod -> [Text.Text] -> Params -> Wai.Response
router Http.GET    ["resources"]      = indexAction
router Http.POST   ["resources"]      = createAction
router Http.GET    ["resources", rid] = showAction (fromText rid)
router Http.PUT    ["resources", rid] = updateAction (fromText rid)
router Http.DELETE ["resources", rid] = deleteAction (fromText rid)

-- "controller" actions

indexAction :: Params -> Wai.Response
indexAction params = undefined

createAction :: Params -> Wai.Response
createAction params = undefined

showAction :: Int -> Params -> Wai.Response
showAction rid params = htmlResponse $
    "<h1>found resource with ID of " `mappend`
    (C8.pack $ show rid)             `mappend`
    "</h1>"

updateAction :: Int -> Params -> Wai.Response
updateAction rid params = undefined

deleteAction :: Int -> Params -> Wai.Response
deleteAction rid params = undefined

-- composing HTTP responses

htmlResponse :: C8.ByteString -> Wai.Response
htmlResponse content = Wai.responseLBS status headers body
  where
    status  = Http.status200
    headers = [(Http.hContentType, "text/html")]
    body    = LazyBS.fromStrict content

-- HTTP request parameter parsing

requestParams :: Wai.Request -> IO Params
requestParams request = do
    (params, _) <- Wai.parseRequestBody Wai.lbsBackEnd request
    return $ paramListToMap params

paramListToMap :: [Wai.Param] -> Params
paramListToMap = foldl' insert Map.empty
  where
    insert params (name, val) = Map.insert name val params

-- helper functions

fromText :: Text.Text -> Int
fromText = read . Text.unpack
