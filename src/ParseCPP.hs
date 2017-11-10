{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}

module ParseCPP where

import Language.C.Clang
import Language.C.Clang.Cursor.Typed
import Control.Lens
import qualified Data.ByteString.Char8 as BS
import Data.Monoid
import Data.Maybe

parseCPP :: FilePath -> [String] -> IO ()
parseCPP filepath options = do
	idx <- createIndex
	tu <- parseTranslationUnit idx filepath options

	let
		elements = cursorDescendantsF
			. folding ( \ c -> case catMaybes [matchKind @'CXXMethod c,matchKind @'FunctionDecl c] of
				[] -> Nothing
				mb_c:_ -> mb_c )
			. filtered (isFromMainFile . rangeStart . cursorExtent)
			. to (\funDec -> cursorSpelling funDec <> " :: " <> typeSpelling (cursorType funDec))
{-
	let funDecs = cursorDescendantsF
		. folding (matchKind @'CXXMethod)
		. filtered (isFromMainFile . rangeStart . cursorExtent) -- ...that are actually in the given file
		. to (\funDec -> cursorSpelling funDec <> " :: " <> typeSpelling (cursorType funDec))
-}

	BS.putStrLn $ BS.unlines (translationUnitCursor tu ^.. elements)

{-

type Fold s a = forall f. (Contravariant f, Applicative f) => (a -> f a) -> s -> f s

folding :: Foldable f => (s -> f a) -> Fold s a

cursorDescendantsF :: Fold (CursorK kind) Cursor

translationUnitCursor :: TranslationUnit -> CursorK TranslationUnit

matchKind :: forall kind. SingI kind => Cursor -> Maybe (CursorK kind)

filtered :: (Choice p, Applicative f) => (a -> Bool) -> Optic' p f a a

to :: (Profunctor p, Contravariant f) => (s -> a) -> Optic' p f s a

(^..) :: s -> Getting (Endo [a]) s a -> [a]

toListOf :: Getting (Endo [a]) s a -> s -> [a]

type Getting r s a = (a -> Const r a) -> s -> Const r s

type Optic' p f s a = Optic p f s s a a

type Optic p f s t a b = p a (f b) -> p s (f t)

-}
