{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}

module ParseCPP where

import Language.C.Clang
import Language.C.Clang.Cursor.Typed
import Control.Lens
import qualified Data.ByteString.Char8 as BS
import Data.Monoid

clangOptions :: [String]
clangOptions = [
	"-IC:/LLVM/lib/clang/3.8.1/include" ]

parseCPP filepath = do
	idx <- createIndex
	tu <- parseTranslationUnit idx filepath clangOptions

	let funDecs = cursorDescendantsF
		. folding (matchKind @'FunctionDecl)
		. filtered (isFromMainFile . rangeStart . cursorExtent) -- ...that are actually in the given file
		. to (\funDec -> cursorSpelling funDec <> " :: " <> typeSpelling (cursorType funDec))

	BS.putStrLn $ BS.unlines (translationUnitCursor tu ^.. funDecs)
