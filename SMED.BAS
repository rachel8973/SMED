      REM >SMED
      REM MODE 32 : COLOUR 125               : REM #RISCOS#
      REM LIBRARY "<smed$dir>.smed_strlib"   : REM #RISCOS#
      REM LIBRARY "<smed$dir>.smed_parseCmd" : REM #RISCOS#
      INSTALL "SMED_STRLIB.BAS"     : REM #BBCWIN#
      INSTALL "SMED_PARSECMD.BAS"   : REM #BBCWIN#
      REM ==============================
      REM  SMED - A Small Line Editor
      REM  rachel8973@gmail.com
      REM ==============================
      VERSION$="0.2.1"
      DIM temp$(10)
      MAXLINES% =9999
      DIM fileData$(MAXLINES%)
      currentLine% =1
      lineCount% =0
      PAGESIZE% =60
      REM ==============================
      REM  Extract the name of the file
      REM  to be edited from the command
      REM  and read it into fileData$
      REM  =============================
      REM = FOR Testing
      REM SYS "OS_GetEnv" TO cmdLine$               : REM #RISCOS#
      REM PROCsplitStr(cmdLine$, " ", n%, temp$())  : REM #RISCOS#
      REM fileName$=temp$(n%)                       : REM #RISCOS#
      REM = FOR Testing                             : REM #RISCOS#
      fileName$ = ""                                : REM #BBCWIN#
      IF LEN(fileName$)<1 THEN INPUT"Enter File Name", fileName$
      f1% = OPENIN(fileName$)
      IF f1%<1 THEN
        PRINT "Creating new file"
        REM When you create an empty file you need at
        REM least one empty line
        currentLine% =1
        lineCount% =1
        fileData$(1)=""
      ELSE
        WHILE NOT EOF#f1%
          lineCount% +=1
          fileData$(lineCount%) =GET$#f1%
        ENDWHILE
      ENDIF
      CLOSE#f1%
      IF NOT FNsaveFile(fileName$+"_BCK", fileData$(), lineCount%) THEN
        PRINT "Failed to write backup file" : PROCexitSmed
        PRINT "End of input file : "+fileName$+" : "+STR$(lineCount%)+" lines"
      ENDIF
      :
      REM Initial load of lines into file
      :
      REM - Main Loop
      WHILE TRUE
        INPUT LINE "SMED>"cmdText$
        PROCparseCmd(cmdText$, currentLine%, lineCount%, cmd$, n1%, n2%, n3%, n4%, s1$)
        REM PRINT "DEBUG:"+cmd$
        IF (cmd$="EDLN") THEN PROCeditLine(fileData$(), currentLine%, n1%)
        IF (cmd$="a" OR cmd$="A") THEN PROCappendLine(fileData$(), lineCount%, currentLine%)
        IF (cmd$="c" OR cmd$="C") THEN PROCcopyLine(fileData$(), n1%, n2%, n3%, n4%)
        IF (cmd$="d" OR cmd$="D") THEN PROCdeleteLine(fileData$(), lineCount%, currentLine%, n1%, n2%)
        IF (cmd$="e" OR cmd$="E") THEN PROCsaveExit(fileData$(), s1$)
        IF (cmd$="i" OR cmd$="I") THEN PROCinsertLine(fileData$(), lineCount%, currentLine%, n1%)
        IF (cmd$="l" OR cmd$="L") THEN PROClistLine(fileData$(), n1%, lineCount%, currentLine%)
        IF (cmd$="m" OR cmd$="M") THEN PROCmoveLine(fileData$(), n1%, n2%, n3%)
        IF (cmd$="p" OR cmd$="P") THEN PROCprintLine(fileData$(), n1%, n2%, lineCount%, currentLine%)
        IF (cmd$="q" OR cmd$="Q") THEN PROCexitSmed
        IF (cmd$="r" OR cmd$="R") THEN PROCreplaceLine(fileData$(), n1%, n2%)
        IF (cmd$="s" OR cmd$="S") THEN PROCsearchLine(fileData$(), n1%, n2%)
        IF (cmd$="t" OR cmd$="T") THEN PROCtransferLine(fileData$(), n1%, s1$)
        IF (cmd$="w" OR cmd$="W") THEN PROCwriteFile(fileData$(), fileName$, lineCount%, s1$)
        IF (cmd$="h" OR cmd$="h") THEN PROChelp
      ENDWHILE
      :
      END
      :
      DEF FNsaveFile(filename$, fdata$(), nl%)
      LOCAL i% : LOCAL f%
      f%=OPENOUT(filename$)
      IF f%<1 THEN =FALSE
      FOR i% =1 TO nl%
        REM PRINT "DEBUG:" fdata$(i%)
        BPUT#f%,fdata$(i%)
      NEXT
      CLOSE#f%
      REM OSCLI "SETTYPE "+filename$+" TEXT"
      =TRUE
      :
      DEF PROCeditLine(RETURN f$(), RETURN currentLine%, lineNum%)
      PRINT "    * "f$(lineNum%)
      INPUT LINE "    * "a$
      IF a$<>"." THEN f$(lineNum%) =a$ : currentLine% =lineNum%
      ENDPROC
      :
      DEF PROCaddLine(RETURN f$(), nLines%, text$)
      ENDPROC
      :
      DEF PROCcopyLine(RETURN f$(), fromLine%, toLine%, beforeLine%, nCopies%)
      ENDPROC
      :
      DEF PROCsaveExit(RETURN f$(), saveFile$)
      PROCwriteFile(f$(), fileName$, lineCount%, saveFile$)
      PROCexitSmed
      ENDPROC
      :
      DEF PROCinsert(RETURN f$(), RETURN nLines%, a$(), iLines%, insLine%)
      REM First starting at the bottom shift all the
      REM lines down by iLines% as far as and including insLine%
      LOCAL i%
      FOR i% =nLines% TO insLine% STEP -1
        f$(i%+iLines%) =f$(i%)
      NEXT
      REM Then add the insert lines into the gap
      FOR i% =1 TO iLines%
        f$(insLine%+i%-1) =a$(i%)
      NEXT
      nLines% +=iLines%
      ENDPROC
      :
      DEF PROCdelete(RETURN f$(), RETURN nLines%, dLines%, delLine%)
      REM Shift lines from line after last line to delete to
      REM the firstline to delete
      LOCAL i%
      FOR i% =delLine% TO nLines%
        f$(i%) = f$(i%+dLines%)
      NEXT
      nLines% -=dLines%
      ENDPROC
      :
      DEF PROCappendLine(RETURN f$(), RETURN nLines%, RETURN currLine%)
      LOCAL a$, lineBuffer$(), lineCount%
      lineCount%=0
      LOCAL flg : flg =FALSE
      DIM lineBuffer$(100)
      WHILE flg=FALSE
        INPUT"    * "a$
        IF a$="." THEN
          flg = TRUE
        ELSE
          lineCount% +=1
          lineBuffer$(lineCount%) =a$
        ENDIF
      ENDWHILE
      IF lineCount%>0 THEN
        PROCinsert(f$(), nLines%, lineBuffer$(), lineCount%, nLines%+1)
      ENDIF
      currLine% =nLines%
      ENDPROC
      :
      DEF PROCinsertLine(RETURN f$(), RETURN nLines%, RETURN currLine%, beforeLine%)
      LOCAL a$, lineBuffer$(), lineCount%
      lineCount% =0
      LOCAL flg : flg =FALSE
      DIM lineBuffer$(100)
      IF beforeLine%=0 THEN
        beforeLine% =currLine%
      ELSE
        currLine% =beforeLine%
      ENDIF
      WHILE flg=FALSE
        INPUT"    * "a$
        IF a$="." THEN
          flg = TRUE
        ELSE
          lineCount% +=1
          lineBuffer$(lineCount%) =a$
        ENDIF
      ENDWHILE
      IF lineCount%>0 THEN
        PROCinsert(f$(), nLines%, lineBuffer$(), lineCount%, beforeLine%)
      ENDIF
      ENDPROC
      :
      DEF PROCdeleteLine(RETURN f$(), RETURN nLines%, RETURN currLine%,
      startLine%, endLine%)
      IF startLine%=0 THEN startLine%=currLine%
      IF endLine%=0 THEN endLine% =startLine%
      IF startLine%>endLine% THEN ENDPROC
      PROCdelete(f$(), nLines%, endLine%-startLine%+1, startLine%)
      ENDPROC
      :
      DEF PROClistLine(RETURN f$(), atLine%, nLines%, currLine%)
      LOCAL sl%, el%
      IF atLine%=0 THEN atLine%=currLine%
      sl% =atLine%-11
      IF sl%<1 THEN sl%=1
      el% =sl%+22
      IF el%>nLines% THEN el% =nLines% : sl% =el%-23
      IF sl%<=0 THEN sl% =1 : el% = nLines%
      PROCprintLine(f$(), sl%, el%, nLines%, currLine%)
      ENDPROC
      :
      DEF PROCmoveLine(RETURN f$(), fromLine%, toLine%, beforeLine%)
      ENDPROC
      :
      DEF PROCprintLine(RETURN f$(), fromLine%, toLine%, nLines%, currLine%)
      IF nLines%>0 THEN
        LOCAL x%, pcount%, i$, c$
        REM PRINT "DEBUG:",fromLine%, toLine%, nLines%
        pcount% =0
        IF fromLine%=0 THEN fromLine% =1
        IF toLine%=0 THEN toLine% =nLines%
        x% =fromLine%
        IF toLine%>=fromLine% THEN
          WHILE x%<=toLine%
            IF x%=currLine% THEN c$ ="*" ELSE c$ = " "
            REM PRINT "DEBUG: Line Length:";LENf$(x%)
            PRINT FNlPad(STR$(x%),4)+c$+": "+ LEFT$(f$(x%),80)
            pcount% +=1
            x% +=1
            IF pcount%>PAGESIZE% THEN
              pcount% =0
              INPUT"Next Page [y]",i$
              IF (i$<> "y" AND i$<>"") THEN ENDPROC
            ENDIF
          ENDWHILE
        ENDIF
      ENDIF
      ENDPROC
      :
      DEF PROCreplaceLine(RETURN f$(), fromLine%, toLine%)
      ENDPROC
      :
      DEF PROCsearchLine(RETURN f$(), fromLine%, toLine%)
      ENDPROC
      :
      DEF PROCtransferLine(RETURN f$(), beforeLine%, filename$)
      ENDPROC
      :
      DEF PROCwriteFile(f$(), RETURN fileName$, lineCount%, a$)
      IF a$<>"" THEN fileName$ = a$
      IF NOT FNsaveFile(fileName$, fileData$(), lineCount%) THEN PRINT "Failed to write file"
      ENDPROC
      :
      DEF PROChelp
      PRINT "------------------------------------------------------------"
      PRINT "  SMED - A Small Text Editor - rachel8973@gmail.com"
      PRINT "  Version : "+VERSION$
      PRINT "------------------------------------------------------------"
      PRINT "n        - Edit Line n - finish editing using ."
      PRINT "A        - Append Line to end of file"
      PRINT "x,y,a,nC - Copy Lines x to y to a n times"
      PRINT "a,bD     - Delete Lines a to b"
      PRINT "E        - Save and Exit"
      PRINT "nI       - Insert Line at n"
      PRINT "nL       - List Line centered around n"
      PRINT "M        - Move Line x to y to after a"
      PRINT "Q        - Quit without save"
      PRINT "S        - Search"
      PRINT "R        - Replace"
      PRINT "T        - Transfer"
      PRINT "W        - Write File"
      PRINT "H        - Help"
      PRINT "------------------------------------------------------------"
      ENDPROC
      :
      DEF PROCexitSmed
      REM COLOUR 63 : END   : REM #RISCOS#
      QUIT                  : REM #BBC#
      ENDPROC


