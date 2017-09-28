      REM>smed_parseCmd
      REM Required : LIBRARY "smed_strlib"
      REM ==============================
      REM  Parse the commands entered
      REM  on the command line
      REM ==============================
      :
      REM ==============================
      REM  Parses commands with
      REM  number list up to the first
      REM  letter and then the rest
      REM  in the same way as others
      REM ==============================
      DEF PROCparseCmd(a$, cl%, nl%, RETURN cmd$, RETURN j%, RETURN k%, RETURN m%, RETURN n%, RETURN s$)
      LOCAL spstr$()
      LOCAL x%: LOCAL y%: LOCAL z% : LOCAL i%
      DIM spstr$(10)
      cmd$ ="" : j% =0 : k% =0 : m% =0 : n% =0 : s$ =""
      REM PRINT "DEBUG:",a$,INSTR(a$, ",")
      IF INSTR(a$, ",")>0 THEN
        x% = FNfirstLetter(a$)
        PROCsplitStr(LEFT$(a$,x%-1),",", y%, spstr$())
        FOR i% =1 TO 4
          IF spstr$(i%)="." THEN spstr$(i%) =STR$(cl%)
          IF spstr$(i%)="#" THEN spstr$(i%) =STR$(nl%)
        NEXT
        j% =FNlimitNum(VAL(spstr$(1)),0,nl%) : k% =FNlimitNum(VAL(spstr$(2)),0,nl%)
        m% =FNlimitNum(VAL(spstr$(3)),0,nl%) : n% =FNlimitNum(VAL(spstr$(4)),0,nl%)
        PROCpSimple(MID$(a$,x%), cl%, nl%, cmd$, z%, s$)
      ELSE
        PROCpSimple(a$, cl%, nl%, cmd$, j%, s$)
      ENDIF
      ENDPROC
      :
      REM ==============================
      REM  Parses commands with no
      REM  number list
      REM ==============================
      DEF PROCpSimple(a$, cl%, nl%, RETURN b$, RETURN x%, RETURN c$)
      IF FNfirstLetter(a$)<1 THEN
        IF LEFT$(a$,1)="+" AND FNisInt(MID$(a$,2)) THEN b$ ="EDLN" :
        x%=FNlimitNum(cl%+VAL(MID$(a$,2)),0,nl%)
        IF LEFT$(a$,1)="-" AND FNisInt(MID$(a$,2)) THEN b$ ="EDLN" :
        x%=FNlimitNum(cl%-VAL(MID$(a$,2)),0,nl%)
        IF FNisInt(a$) THEN b$ ="EDLN" : x% =FNlimitNum(VAL(a$),0,nl%)
        IF LEFT$(a$,1)="." THEN b$ ="EDLN" : x% =cl%
        IF LEFT$(a$,1)="#" THEN b$ ="EDLN" : x% =nl%
      ELSE
        IF FNfirstLetter(a$)=1 THEN
          IF LEN(a$)=1 THEN
            b$ =a$
          ELSE
            b$ =LEFT$(a$,1) : c$ =MID$(a$,2)
          ENDIF
        ELSE
          loc%=FNfirstLetter(a$)
          IF FNisInt(LEFT$(a$,loc%-1)) THEN
            x% =FNlimitNum(VAL(LEFT$(a$,loc%-1)),0,nl%)
          ELSE
            IF LEFT$(a$,1)="." THEN x% =cl%
            IF LEFT$(a$,1)="#" THEN x% =nl%
          ENDIF
          b$ =MID$(a$,loc%,1)
          c$ =MID$(a$,loc%+1)
        ENDIF
      ENDIF
      ENDPROC
      :
      DEF FNlimitNum(n%, nMin%, nMax%)
      IF n%>nMax% THEN =nMax%
      IF n%<nMin% THEN =nMin%
      =n%



