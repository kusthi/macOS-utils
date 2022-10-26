global terminalApp
global clrCmd
set terminalApp to "Terminal"
set escCmd to "\\e[3J"
set clrCmd to "clear && printf " & (quoted form of escCmd)

on isTerminalAppRunning()
	tell application "System Events" to (name of processes) contains terminalApp
end isTerminalAppRunning

on activateTerminalApp()
	tell application terminalApp to activate
end activateTerminalApp

on activateAndClrScr(iSNewWindow)
	activateTerminalApp()
	tell application "System Events" to tell process terminalApp
		if iSNewWindow then
			keystroke "n" using command down
		end if
		keystroke clrCmd
		keystroke return
	end tell
end activateAndClrScr

on getPath()
	tell application "Finder" to set selectedItems to (selection as alias list)
	if (count of selectedItems) = 0 then
		tell application "Finder" to set folderPath to (POSIX path of (target of front window as text))
	else if (kind of (info for (item 1 of selectedItems)) is not "folder") then
		tell application "System Events" to set folderPath to POSIX path of (container of (item 1 of selectedItems))
	else
		set folderPath to (POSIX path of (item 1 of selectedItems))
	end if
	return folderPath
end getPath

if frontmost of application "Finder" then
	set folderLocation to getPath()
	if isTerminalAppRunning() then
		activateTerminalApp()
		tell application "System Events" to tell process terminalApp to keystroke "t" using command down
	else
		activateTerminalApp()
	end if
	set cdCmd to "cd " & (quoted form of folderLocation) & " && "
	set fullCmd to cdCmd & clrCmd
	tell application "System Events" to tell process terminalApp
		keystroke fullCmd
		keystroke return
	end tell
else
	if isTerminalAppRunning() then
		tell application "System Events" to tell process terminalApp to set terminalAppWindowCount to count of windows
		if terminalAppWindowCount is not 0 then
			activateTerminalApp()
		else
			activateAndClrScr(true)
		end if
	else
		activateAndClrScr(false)
	end if
end if
