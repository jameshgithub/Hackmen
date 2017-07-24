#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         bii8176

 Script Function:
			Read the hosts.cfg file and return
			which runway is set as override, if any

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <File.au3>
#include<array.au3>

$file = "c:\temp\hosts.txt"
FileOpen($file, 0)

Local Const $runwayDisplayNamesArray[4] = ["RWA", "RWB", "RWC", "RWD"]
Local Const $runwaysListArray[4] = ["Runway A","Runway B","Runway C","Runway D"]

Example()

Func Example()
    ; Create variables in Local scope and enumerate through the variables. Default is to start from 0.
    Local Enum $eCat, $eDog, $eMouse, $eHamster ; $eHamster is equal to the value 3, not 4.

    ; Create an array in Local scope with 4 elements.
    Local $aAnimalNames[4]

    ; Assign each array element with the name of the respective animal. For example the name of the cat is Jasper.
    $aAnimalNames[$eCat] = 'Jasper' ; $eCat is equal to 0, similar to using $aAnimalNames[0]
    $aAnimalNames[$eDog] = 'Beethoven' ; $eDog is equal to 1, similar to using $aAnimalNames[1]
    $aAnimalNames[$eMouse] = 'Pinky' ; $eMouse is equal to 2, similar to using $aAnimalNames[2]
    $aAnimalNames[$eHamster] = 'Fidget' ; $eHamster is equal to 3, similar to using $aAnimalNames[3]

    ; Display the values of the array.
    MsgBox($MB_SYSTEMMODAL, '', '$aAnimalNames[$eCat] = ' & $aAnimalNames[$eCat] & @CRLF & _
            '$aAnimalNames[$eDog] = ' & $aAnimalNames[$eDog] & @CRLF & _
            '$aAnimalNames[$eMouse] = ' & $aAnimalNames[$eMouse] & @CRLF & _
            '$aAnimalNames[$eHamster] = ' & $aAnimalNames[$eHamster] & @CRLF)

    ; Sometimes using this approach for accessing an element is more practical than using a numerical value, due to the fact that changing the index value of
    ; the enum constant has no affect on it's position in the array. Therefore changing the location of $eCat in the array is as simple as changing the order
    ; it appears in the initial declaration e.g.

    ; Local Enum $eDog, $eMouse, $eCat, $eHamster

    ; Now $eCat is the 2nd element in the array. If you were using numerical values, you would have to manually change all references of $aAnimalNames[0] to
    ; $aAnimalNames[2], as well as for the other elements which have now shifted.
EndFunc   ;==>Example



Func isCurrentLineAComment($line)
   $commentLine = StringInStr( $line, "#" , 0 , 1 , 1, 1)

   Return $commentLine
EndFunc

Func getRunwayName($line)
   Local Const $arrayLength = UBound($runwaysListArray)

   ; loop through the possible runways, looking for a match. Return matching runway value if found.
   For $i = 0 To $arrayLength - 1
	  ConsoleWrite(@LF & "looping through array #1: " & $runwaysListArray[$i])
	  ConsoleWrite(@LF & "value of $line: " & $line)
	  If ( StringInStr( $line, $runwaysListArray[$i], 0, 1, 1, 1) == 0) Then
		 $runwayName = $line
		 ExitLoop
	  EndIf
   Next

   ConsoleWrite(@LF & "Runway name extracted from hosts file: " & $runwayName)
   $runwayDisplayName = convertRunwayNameToDisplayValue($runwayName)

   Return $runwayDisplayName
EndFunc

Func convertRunwayNameToDisplayValue($runwayName)
   ConsoleWrite(@LF  & "Inside conversion function. Value of input: " & $runwayName)
   Local $runwayDisplayName

   For $i = 0 To UBound($runwaysListArray) - 1
	  If(isStringPresentInArray($runwaysListArray, $runwayName)) Then
		 ConsoleWrite(@LF & "The If check has passed.")
		 $runwayDisplayName = $runwayDisplayNamesArray[$i]
		 ExitLoop
	  EndIf
   Next

   Return $runwayDisplayName
EndFunc

Func isStringPresentInArray($array, $string)
   $array2 = StringSplit($string,",",2)
   For $i = 0 to UBound($array)-1
	   If _ArraySearch($array2,$array[$i])> -1 Then
			ConsoleWrite(@LF & "The If check has passed.")
		    Return True
		Else
		   	ConsoleWrite(@LF & "The If check has failed")
			Return False
	   EndIf
   Next
EndFunc

Func main()
For $i = 1 to _FileCountLines($file)
   $runwayFound = False
   If ($runwayFound == True) Then
	  ExitLoop
   EndIf

   $line = FileReadLine($file, $i)
   ConsoleWrite("Times through loop: " & $i & @LF)

   ; return 0 if true
   $currentLineIsAComment = isCurrentLineAComment($line)
   ConsoleWrite(@LF & "value of commentLine variable: " & $currentLineIsAComment)
   If( $currentLineIsAComment <> 0 ) Then
	  ConsoleWrite(@LF & "The current line was a comment. Examining contents of line")
	  $runwayName = getRunwayName($line)
	  ConsoleWrite(@LF & "runway name: " & $runwayName)
	  If(_ArraySearch($runwayDisplayNamesArray, $runwayName) == 0) Then
		 ConsoleWrite(@LF  & 'The runway is ' & $runwayName & '.' & @LF)
		 $runwayFound = True
	  EndIf
   EndIf

   If($runwayFound == True) Then
	  ConsoleWrite(@LF  & 'Line #' & $i & ' contains: ' & $line & @LF)
   Else
	  ConsoleWrite(@LF & "No valid Runway value found yet." & @LF)
   EndIf
Next
EndFunc
FileClose($file)