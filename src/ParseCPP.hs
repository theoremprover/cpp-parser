{-# LANGUAGE TypeApplications,DataKinds,OverloadedStrings,RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-tabs #-}

{-
stack build
stack exec cpp-parser-exe -- test\src\Notepad_plus.cpp
-}

-- :set -XTypeApplications

module ParseCPP where

import Language.C.Clang
import Language.C.Clang.Cursor
import Language.C.Clang.Token
import Language.C.Clang.File
--import Language.C.Clang.Cursor.Typed
import Control.Lens
import qualified Data.ByteString.Char8 as BS
import Data.Monoid
import Data.Maybe
import Control.Monad
import System.FilePath
import Data.List
import Data.Function
--import Control.Monad.Fix
import System.IO
import Data.Ord
import Data.Char

parseCPP :: FilePath -> [String] -> IO ()
parseCPP filepath options = do
	idx <- createIndex
	tu  <- parseTranslationUnit idx filepath options

	withFile "static_calls.dot" WriteMode $ \ h -> do
--		hPutStrLn h $ "digraph " ++ makeIdentifier (takeFileName filepath) ++ " {"
		static_call_hull <- hull h [translationUnitCursor tu]
{-
		let clusters = groupBy ((==) `on` cursorFileName) (sortBy (comparing cursorFileName) static_call_hull)
		forM_ clusters $ \ nodesdup -> do
			let nodes = nub nodesdup
			let clustername = makeIdentifier $ cursorFileName (head nodes)
			hPutStrLn h $ "subgraph cluster_" ++ clustername ++ " {"
			hPutStrLn h $ "\tstyle=filled;"
			hPutStrLn h $ "\tcolor=lightgrey;"
			hPutStrLn h $ "\tnode [style=filled,color=white];"
			hPutStrLn h $ "\tlabel=\"" ++ clustername ++ "\";"
			forM_ nodes $ \ node -> do
				hPutStrLn h $ "\t\"" ++ nodeName node ++ "\";"
			hPutStrLn h $ "}\n"
-}
		forM_ static_call_hull $ \ c -> do
			hPutStrLn h $ showLoc c
--		hPutStrLn h "}"

makeIdentifier s = map toalphanum s where
	toalphanum c | isAlphaNum c = c
	toalphanum _ = '_'

nodeName cur = makeIdentifier $ BS.unpack (cursorSpelling cur) ++ ":" ++ show (line $ fileLoc cur)

-- The transitive hull of static calls is the least fixpoint of the "calls" relation,
-- and "hull" is the relation transformer.
hull :: Handle -> [Cursor] -> IO [Cursor]
hull h cursors = do
	let
		calls = concatMap (^.. callCursors) cursors
	subcallss <- forM calls $ \ (mb_c,t) -> do
		putStrLn $ showLoc t ++ " --CALLS--> " ++ maybe "<NoRef>" showLoc mb_c
		return mb_c
	let new_cursors = (nub $ catMaybes subcallss) `union` cursors
	case length new_cursors > length cursors of
		True  -> hull h new_cursors
		False -> return new_cursors

callCursors = cursorDescendantsF
	. folding (cursorKindFilter [CallExpr])
	. filtered (isFromMainFile . rangeStart . fromJust . cursorExtent)
	. to (\funDec -> (cursorReferenced funDec, funDec))
	where
	cursorKindFilter kinds cur | cursorKind cur `elem` kinds = Just cur
	cursorKindFilter _ _ = Nothing

showLoc cur = BS.unpack (cursorSpelling cur) ++ " :: " ++ maybe "<NoType>" (BS.unpack . typeSpelling) (cursorType cur) ++ " [" ++ (takeFileName $ BS.unpack $ fileName file) ++ ":" ++ show line ++ "]"
	where
	Location{..} = fileLoc cur

fileLoc = spellingLocation.rangeStart.fromJust.cursorExtent
cursorFileName = takeFileName . BS.unpack . fileName . file . fileLoc

{-
elems = cursorDescendantsF
	. folding (cursorKindFilter [FunctionDecl,CXXMethod])
	. to (\funDec -> cursorSpelling funDec <> " :: " <> typeSpelling (fromJust $ cursorType funDec) <>
		" [ " <> showLoc funDec <> " ]")

-}

{-
--	printTree 0 $ translationUnitCursor tu

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
