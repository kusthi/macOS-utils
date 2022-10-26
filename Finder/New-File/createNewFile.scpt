set file_name to "untitled"
set file_ext to ".txt"

-- get folder path
if frontmost of application "Finder" then
	tell application "Finder" to set folderLocation to (target of front Finder window) as text
else
	set folderLocation to (path to desktop folder as text)
end if

--get file name (do not override an already existing file)
tell application "System Events"
	set file_list to list folder folderLocation with invisibles
end tell
set new_file to file_name & file_ext
set x to 2
repeat
	if new_file is in file_list then
		set new_file to file_name & "_" & x & file_ext
		set x to x + 1
	else
		exit repeat
	end if
end repeat

-- create and select the new file--
tell application "Finder"
	set the_file to make new file at folderLocation with properties {name:new_file}
	reveal the_file
end tell

-- press enter (rename)
tell application "System Events"
	tell process "Finder"
		delay 0.3
		keystroke return
	end tell
end tell
