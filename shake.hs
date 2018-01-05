#!/usr/bin/env stack
{- stack --install-ghc
    runghc
    --package shake
    --package directory
    --stack-yaml stack-shake.yaml
-}

import           Data.Maybe
import           Data.Monoid
import           Development.Shake
import           Development.Shake.Command
import           Development.Shake.FilePath
import           Development.Shake.Util
import           System.Directory
--
import           Data.Version
import           Distribution.Package
import           Distribution.Version (showVersion)
import           Distribution.PackageDescription
import           Distribution.PackageDescription.Parse
import           Distribution.Verbosity

version :: IO String
version = do
    generic <- readGenericPackageDescription normal "starter.cabal"
    pure . Distribution.Version.showVersion . pkgVersion . package . packageDescription $ generic

main :: IO ()
main = version >>= \v -> shakeArgs shakeOptions { shakeFiles = ".shake", shakeLint = Just LintBasic, shakeVersion = v } $ do
    want [ "target/index.html" ]

    "build" %> \_ -> do
        need ["shake.hs"]
        cmd_ ["cp", "shake.hs", ".shake/shake.hs"]
        command_ [Cwd ".shake"] "ghc-8.2.2" ["-O", "shake.hs", "-o", "build"]
        cmd ["cp", ".shake/build", "."]

    "clean" ~> do
        putNormal "cleaning files..."
        cmd ["stack", "clean"]

    "purge" ~> do
        putNormal "purging local files..."
        removeFilesAfter ".stack-work" ["//*"]
        removeFilesAfter ".shake" ["//*"]

    ".stack-work/dist/x86_64-osx/Cabal-1.24.2.0_ghcjs/build/starter/starter.jsexe/all.js" %> \out -> do
        need ["src/Lib.hs","starter.cabal","stack.yaml"]
        cmd ["stack", "build", "--stack-yaml", "stack.yaml", "--install-ghc"]

    ".stack-work/dist/x86_64-osx/Cabal-1.24.2.0_ghcjs/build/starter/starter.jsexe/all.min.js" %> \out -> do
        need [".stack-work/dist/x86_64-osx/Cabal-1.24.2.0_ghcjs/build/starter/starter.jsexe/all.js"]
        cmd (Cwd ".stack-work/dist/x86_64-osx/Cabal-1.24.2.0_ghcjs/build/starter/starter.jsexe/") Shell "ccjs all.js --externs=node --externs=all.js.externs > all.min.js"

    "target/all.min.js" %> \out -> do
        need [".stack-work/dist/x86_64-osx/Cabal-1.24.2.0_ghcjs/build/starter/starter.jsexe/all.min.js"]
        cmd Shell "cp .stack-work/dist/x86_64-osx/Cabal-1.24.2.0_ghcjs/build/starter/starter.jsexe/all.min.js target/all.min.js"

    "target/index.html" %> \out -> do
        liftIO $ createDirectoryIfMissing True "target"
        need ["target/all.min.js"]
        cmd ["cp","web-src/index.html", "target/index.html"]
