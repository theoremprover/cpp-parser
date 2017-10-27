module Main where

import System.Environment

import ParseCPP

main = do
	[file] <- getArgs
	parseCPP file
