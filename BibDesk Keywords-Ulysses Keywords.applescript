set addKeywordsURL to "ulysses://x-callback-url/attach-keywords?id="
set keywordsParameterURL to "&keywords="

(* By Derick Fay, 2017-04-06 

Locates existing BibDesk records with links to Ulysses sheets, and updates those sheets by copying BibDesk keywords to Ulysses keywords

*)

tell application "BibDesk"
	
	-- without document, there is no selection, so nothing to do
	if (count of documents) = 0 then
		beep
		display dialog "No documents found." buttons {"•"} default button 1 giving up after 3
	end if
	set thePublications to the selection of document 1
	
	-- get the keywords
	repeat with thePub in thePublications
		repeat with theURL in linked URLs of thePub
			if theURL contains "ulysses://" then
				
				set tagList to ""
				
				set currentKeywords to get keywords of thePub
				
				set {myTID, AppleScript's text item delimiters} to {AppleScript's text item delimiters, {"id="}}
				
				--				display dialog (theURL as string)
				
				set sheetID to last text item of (theURL as string)
				set AppleScript's text item delimiters to myTID
				
				-- ulysses://x-callback-url/open?id=i_5l3Vm7HiXCIJ3BNdX62Q
				
				set {myTID, AppleScript's text item delimiters} to {AppleScript's text item delimiters, {", "}}
				repeat with k in text items of currentKeywords
					set tagList to (tagList & k & ",")
				end repeat
				set AppleScript's text item delimiters to myTID
				
				set actionURL to addKeywordsURL & sheetID & keywordsParameterURL & tagList
				set theCommand to quoted form of actionURL
				do shell script "open " & theCommand
			end if
		end repeat
	end repeat
end tell
