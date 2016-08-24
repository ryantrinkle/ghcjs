{-# LANGUAGE CPP #-}
{-
   GHCJS can generate multiple code variants of a Haskell module
-}
module Compiler.Variants where

import           Data.ByteString       (ByteString)
import           Data.Set              (Set)

import           Compiler.Compat
import           Compiler.Settings

import qualified Gen2.Generator        as Gen2
import qualified Gen2.Linker           as Gen2
import qualified Gen2.Object           as Gen2

import           CostCentre            (CollectedCCs)
import           DynFlags              (DynFlags)
import           Module                (Module (..))
import           StgSyn                (StgBinding)

data Variant = Variant
    { variantRender            :: GhcjsSettings
                               -> DynFlags
                               -> Module
                               -> StgPgm
                               -> CollectedCCs
                               -> ByteString
    , variantLink              :: DynFlags
                               -> GhcjsEnv
                               -> GhcjsSettings
                               -> FilePath                     -- output directory
                               -> [PackageKey]                 -- dependencies
                               -> [LinkedObj]                  -- object files
                               -> [FilePath]                   -- extra JavaScript files
                               -> (Gen2.Fun -> Bool)           -- function to use as roots
                               -> Set Gen2.Fun                 -- extra roots
                               -> IO ()
    }

gen2Variant :: Variant
gen2Variant = Variant Gen2.generate Gen2.link

type StgPgm = [StgBinding]
