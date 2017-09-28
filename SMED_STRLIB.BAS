      REM>SMED_STRLIB
      REM ===========================================
      REM  STRLIB Library of string manipulation
      REM  rachel8973@gmail.com
      REM ===========================================
      :
      DEF FNleftTrim(s$)
      WHILE LEN(s$) > 0 AND FNisBlank(LEFT$(s$,1))
        s$ =MID$(s$,2)
      ENDWHILE
      = s$
      :
      DEF FNrightTrim(s$)
      WHILE LEN(s$) > 0 AND FNisBlank(RIGHT$(s$,1))
        s$ =LEFT$(s$,LEN(s$)-1)
      ENDWHILE
      =s$
      :
      DEF FNtrim(s$)
      =FNleftTrim(FNrightTrim(s$))
      :
      DEF FNisBlank(a$)
      LOCAL n%
      n%=ASC(LEFT$(a$,1))
      IF n%<=&20 OR n%=&7F OR n%=&A0 THEN
        =TRUE
      ELSE
        =FALSE
      ENDIF
      :
      DEF FNisInt(s$)
      LOCAL i%,x%
      IF s$="" THEN =FALSE
      FOR i%=1 TO LEN s$
        x% =ASC(MID$(s$,i%,1))
        IF x%<&30 OR x%>&39 THEN =FALSE
      NEXT
      =TRUE
      :
      DEF FNisLetter(s$)
      LOCAL x%
      IF s$="" THEN =FALSE
      x% =ASC(LEFT$(s$,1))
      IF (x%>=&41 AND x%<=&5A) OR (x%>=&61 AND x%<=&7A) THEN =TRUE
      =FALSE
      :
      DEF FNfirstLetter(s$)
      LOCAL i%
      IF s$="" THEN =0
      FOR i% =1 TO LEN(s$)
        IF FNisLetter(MID$(s$,i%)) THEN =i%
      NEXT
      =0
      :
      DEF FNcountChar(s$,c$)
      LOCAL i%, j% : i%=0 : j%=0
      IF LEN(c$)>1 OR LEN(s$)<1 THEN =0
      FOR i% =1 TO LEN(s$)
        IF MID$(s$,i%,1)=c$ THEN j% +=1
      NEXT
      =j%
      :
      DEF PROCsplitStr(s$, c$, RETURN n%, RETURN o$())
      LOCAL loc%
      n%=0
      o$() =""
      IF LEN(s$)=0 OR LEN(c$)<>1 THEN ENDPROC
      WHILE TRUE
        n% +=1
        loc% =INSTR(s$,c$)
        IF loc%<1 THEN
          o$(n%) =s$
          ENDPROC
        ELSE
          o$(n%) =LEFT$(s$,loc%-1)
          s$ =MID$(s$,loc%+1)
        ENDIF
      ENDWHILE
      ENDPROC
      :
      DEF FNlPad(s$, n%)
      LOCAL i% : i% =LEN(s$)
      IF n%>i% THEN
        =STRING$(n%-i%," ")+s$
      ELSE
        =s$
        :
        DEF FNrPad(s$, n%)
        LOCAL i% : i% =LEN(s$)
        IF n%>i% THEN
          =s$+STRING$(n%-i%," ")
        ELSE
          =s$
    
    
    
