{-# LANGUAGE TypeApplications,DataKinds,OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-tabs #-}

{-
stack build
stack exec cpp-parser-exe -- test\src\Notepad_plus.cpp
-}

-- :set -XTypeApplications

module ParseCPP where

import Language.C.Clang
--import Language.C.Clang.Cursor
import Language.C.Clang.Token
import Language.C.Clang.Cursor.Typed
import Control.Lens
import qualified Data.ByteString.Char8 as BS
import Data.Monoid
import Data.Maybe
import Control.Monad
import System.FilePath

parseCPP :: FilePath -> [String] -> IO ()
parseCPP filepath options = do
	idx <- createIndex
	tu  <- parseTranslationUnit idx filepath options

	BS.putStrLn $ BS.unlines (translationUnitCursor tu ^.. elems)
--	printTree 0 $ translationUnitCursor tu

{-
allsrcs = False

printTree i cur = case cursorExtent cur of
	Just sourcerange | allsrcs || isFromMainFile (rangeStart sourcerange) -> do
		let tokens = case cursorExtent cur of
			Nothing -> []
			Just srcrange -> map (BS.unpack . tokenSpelling) $ tokenSetTokens $ tokenize srcrange
		putStrLn $ ind i ++ show (cursorKind cur) ++ {-" :: " ++ show (cursorType cur) ++ -} " " ++
			BS.unpack (cursorSpelling cur) ++ " " ++ show tokens
		forM_ (cursorChildren cur) $ printTree (i+1)
	_ -> return ()
	where
	ind i = concat $ take i (repeat "|   ")

elems = cursorDescendantsF
	. folding (matchKind @'CXXMethod)
--	. filtered (isFromMainFile . rangeStart . cursorExtent)
	. to (\funDec -> cursorSpelling funDec <> " :: " <> typeSpelling (cursorType funDec))
-}

elems = cursorDescendantsF
	. folding (matchKind @'CXXMethod)
	. to (\funDec -> cursorSpelling funDec <> " :: " <> typeSpelling (cursorType funDec) <>
		" [ " <> showLoc funDec <> " ]")

showLoc cur = BS.pack (takeFileName file) <> ":" <> BS.pack (show line)
	where
	Location{..} = (spellingLocation.rangeStart.cursorExtent) cur
{-

elems :: Getting (Endo [BS.ByteString]) (CursorK 'TranslationUnit) BS.ByteString
elems :: Getting (Endo [a]            ) s                          a

folding (matchKind @'CXXMethod) :: (CursorK 'CXXMethod -> f (CursorK 'CXXMethod)) -> Cursor -> f Cursor

filtered (..) :: Optic' p f (CursorK kind) (CursorK kind)

to (..)       :: Optic' p f (CursorK kind) BS.ByteString

--------

type Fold s a = forall f. (Contravariant f, Applicative f) => (a -> f a) -> s -> f s

folding :: Foldable f => (s -> f a) -> Fold s a

cursorDescendantsF :: Fold (CursorK kind) Cursor
cursorDescendantsF :: (Cursor -> f Cursor) -> ( CursorK kind -> f (CursorK kind) )

translationUnitCursor :: TranslationUnit -> CursorK TranslationUnit

matchKind :: forall kind. SingI kind => Cursor -> Maybe (CursorK kind)

filtered :: (Choice p, Applicative f) => (a -> Bool) -> Optic' p f a a

to :: (Profunctor p, Contravariant f) => (s -> a) -> Optic' p f s a

(^..)    :: s -> Getting (Endo [a]) s a -> [a]
toListOf :: Getting (Endo [a]) s a -> s -> [a]

type Getting r s a = (a -> Const r a) -> s -> Const r s

type Optic' p f s a = Optic p f s s a a

type Optic p f s t a b = p a (f b) -> p s (f t)

-}
