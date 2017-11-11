{-# OPTIONS_GHC -fno-warn-tabs #-}

{-
stack build
stack exec cpp-parser-exe -- test\src\Notepad_plus.cpp
-}


module Main where

import System.Environment

import ParseCPP

includeDirs = [
	"C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Community\\VC\\Tools\\MSVC\\14.11.25503\\include",
	"test\\src\\scintilla-include",
	"test\\src\\WinControls\\AboutDlg",
	"test\\..\\scintilla\\include",
	"test\\include",
	"test\\src\\WinControls",
	"test\\src\\WinControls\\ImageListSet",
	"test\\src\\WinControls\\OpenSaveFileDialog",
	"test\\src\\WinControls\\SplitterContainer",
	"test\\src\\WinControls\\StaticDialog",
	"test\\src\\WinControls\\TabBar",
	"test\\src\\WinControls\\ToolBar",
	"test\\src\\MISC\\Process",
	"test\\src\\ScitillaComponent",
	"test\\src\\MISC",
	"test\\src\\MISC\\SysMsg",
	"test\\src\\WinControls\\StatusBar",
	"test\\src",
	"test\\src\\WinControls\\StaticDialog\\RunDlg",
	"test\\src\\tinyxml",
	"test\\src\\WinControls\\ColourPicker",
	"test\\src\\Win32Explr",
	"test\\src\\MISC\\RegExt",
	"test\\src\\WinControls\\TrayIcon",
	"test\\src\\WinControls\\shortcut",
	"test\\src\\WinControls\\Grid",
	"test\\src\\WinControls\\ContextMenu",
	"test\\src\\MISC\\PluginsManager",
	"test\\src\\WinControls\\Preference",
	"test\\src\\WinControls\\WindowsDlg",
	"test\\src\\WinControls\\TaskList",
	"test\\src\\WinControls\\DockingWnd",
	"test\\src\\WinControls\\ToolTip",
	"test\\src\\MISC\\Exception",
	"test\\src\\MISC\\Common",
	"test\\src\\tinyxml\\tinyXmlA",
	"test\\src\\WinControls\\AnsiCharPanel",
	"test\\src\\WinControls\\ClipboardHistory",
	"test\\src\\WinControls\\FindCharsInRange",
	"test\\src\\WinControls\\VerticalFileSwitcher",
	"test\\src\\WinControls\\ProjectPanel",
	"test\\src\\WinControls\\DocumentMap",
	"test\\src\\WinControls\\FunctionList",
	"test\\src\\uchardet",
	"test\\src\\WinControls\\FileBrowser",
	"test\\src\\WinControls\\ReadDirectoryChanges",
	"test\\src\\MISC\\md5",
	"test\\src\\WinControls\\PluginsAdmin" ]

defines = [
	"WIN32","_WIN32_WINNT=0x0501","_WINDOWS","_USE_64BIT_TIME_T","TIXML_USE_STL",
	"TIXMLA_USE_STL" ,"_CRT_NONSTDC_NO_DEPRECATE","_CRT_SECURE_NO_WARNINGS",
	"_CRT_NON_CONFORMING_SWPRINTFS=1" ,"_CRT_NON_CONFORMING_WCSTOK","_VC80_UPGRADE=0x0700",
	"_USING_V110_SDK71_","_UNICODE","UNICODE" ]

otherOptions = [
	"-fexceptions",
--	"-std=c++14",
	"-fms-compatibility-version=19",
	"-w","-Xanalyzer","-analyzer-disable-all-checks" ]

options = otherOptions ++ map ("-I"++) includeDirs ++ map ("-D"++) defines

main = do
	[file] <- getArgs
	parseCPP file options
