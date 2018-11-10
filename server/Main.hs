{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeApplications           #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE DeriveGeneric #-}


module Main where

import qualified Lib
import           Data.Proxy
import qualified Lucid                                as L
import qualified Lucid.Base                           as L
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Network.Wai.Middleware.Gzip
import           Network.Wai.Middleware.RequestLogger
import qualified Servant
import           Servant ( (:>), (:<|>)(..) )
import qualified System.IO                            as IO

import           Miso
import           GHC.Generics
import           Data.Aeson
import           System.Environment (getArgs)
import           Safe (readMay, headMay)

main :: IO ()
main = do
  args <- getArgs
  let port = maybe 3003 id (headMay args >>= readMay) :: Port
      compress = gzip def { gzipFiles = GzipCompress } :: Middleware
  (IO.hPutStrLn IO.stderr ("Running on port: " ++ show port))
  (run port $ logStdout (compress app))

app :: Application
app = Servant.serve (Proxy @ServerAPI) (static :<|> fibHandler)
  where
    static :: Servant.Server StaticAPI
    static = Servant.serveDirectoryFileServer "static"

    fibHandler :: Int -> Servant.Handler FibResult
    fibHandler i = return $ FibResult $ Lib.fibs !! i

    --serverHandlers :: Servant.Server ServerRoutes
    --serverHandlers = pure $ HtmlPage $ Common.homeView Common.initialModel


-- | Represents the top level Html code. Its value represents the body of the
-- page.
--newtype HtmlPage a = HtmlPage a
--  deriving (Show, Eq)
--
--instance L.ToHtml a => L.ToHtml (HtmlPage a) where
--  toHtmlRaw = L.toHtml
--  toHtml (HtmlPage x) =
--      L.doctypehtml_ $ do
--        L.head_ $ do
--          L.title_ "Miso isomorphic example"
--          L.meta_ [L.charset_ "utf-8"]
--
--          L.with (L.script_ mempty)
--            [ L.makeAttribute "src" "static/all.js"
--            , L.makeAttribute "async" mempty
--            , L.makeAttribute "defer" mempty
--            ]
--
--        L.body_ (L.toHtml x)
--
---- Converts the ClientRoutes (which are a servant tree of routes leading to
---- some `View action`) to lead to `Get '[Html] (HtmlPage (View Common.Action))`
--type ServerRoutes
--   = ToServerRoutes Common.ClientRoutes HtmlPage Common.Action
--
type ServerAPI = StaticAPI :<|> FibAPI

data FibResult = FibResult { result  :: Int } deriving (Generic, Show)

instance ToJSON FibResult where
  toEncoding = genericToEncoding Data.Aeson.defaultOptions

instance FromJSON FibResult

type FibAPI = "fib" :> Servant.Capture "int" Int :> Servant.Get '[Servant.JSON] FibResult
--  :<|> ServerRoutes

-- type StaticAPI = "static" :> Servant.Raw
type StaticAPI = Servant.Raw
