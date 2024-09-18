       IDENTIFICATION              DIVISION.
       PROGRAM-ID.                 AUTODELETE_2.
       AUTHOR.                     M SHIMADA.
       DATE-WRITTEN.               2024-09-04.
      ******************************************************************
       ENVIRONMENT                 DIVISION.
      ******************************************************************
      *-------------------------------------*
       INPUT-OUTPUT                SECTION.
      *-------------------------------------*
       FILE-CONTROL.
           SELECT    OLDFILE       ASSIGN         TO   DYNAMIC
                                                       OLD-FILE-PATH
                                   ORGANIZATION   IS   LINE SEQUENTIAL
                                   FILE STATUS    IS   OLD-STS.
           SELECT    NEWFILE       ASSIGN         TO   DYNAMIC
                                                       NEW-FILE-PATH
                                   ORGANIZATION   IS   LINE SEQUENTIAL
                                   FILE STATUS    IS   NEW-STS.
      ******************************************************************
       DATA                        DIVISION.
      ******************************************************************
      *-------------------------------------*
       FILE                        SECTION.
      *-------------------------------------*
       FD  OLDFILE.
       01  OLD-REC                 PIC X(50000).
       FD  NEWFILE.
       01  NEW-REC                 PIC X(50000).
      *-------------------------------------*
       WORKING-STORAGE             SECTION.
      *-------------------------------------*
       01  OLD-STS                 PIC X(02).
       01  NEW-STS                 PIC X(02).
       01  OLD-FILE-PATH           PIC X(256).
       01  NEW-FILE-PATH           PIC X(256).
       01  MD-NAME                 PIC X(250).
       01  WS-END-OF-FILE          PIC X VALUE 'N'.
       01  WS-IN-NAVI-SECTION      PIC X VALUE 'N'.
       01  F-SKIP                  PIC 9(03).
       01  END-FLG                 PIC 9(01).
      ******************************************************************
       PROCEDURE                   DIVISION.
      ******************************************************************
      *-------------------------------------*
       MAIN-CONTROL                SECTION.
      *-------------------------------------*
       MAIN-000.
      *実行コマンドの引数からファイル名を取得する
           ACCEPT MD-NAME FROM COMMAND-LINE.
      *変換前後のファイルをフォルダ分けするためディレクトリを追加する
           MOVE SPACE TO OLD-FILE-PATH.
           STRING   "old_delete/"      DELIMITED BY SIZE
                    MD-NAME      DELIMITED BY SPACE
                    INTO   OLD-FILE-PATH.
           MOVE SPACE TO NEW-FILE-PATH.
           STRING   "new_delete/"      DELIMITED BY SIZE
                    MD-NAME      DELIMITED BY SPACE
                    INTO   NEW-FILE-PATH.

           IF OLD-FILE-PATH = SPACE GO TO MAIN-900.

           OPEN  INPUT OLDFILE
                 OUTPUT NEWFILE.
       MAIN-100.
      *<!--navi start-->から<!--navi end-->の記述を削除する
           PERFORM UNTIL WS-END-OF-FILE = 'Y'
               READ OLDFILE INTO OLD-REC
                   AT END
                       MOVE 'Y' TO WS-END-OF-FILE
                   NOT AT END
                       IF OLD-REC = "<!--navi start-->"
                           MOVE 'Y' TO WS-IN-NAVI-SECTION
                       ELSE IF OLD-REC = "<!--navi end-->"
                           MOVE 'N' TO WS-IN-NAVI-SECTION
                       ELSE IF WS-IN-NAVI-SECTION = 'N'
      *「ページトップへ」を削除
                            IF F-SKIP = 0
                            INSPECT OLD-REC TALLYING F-SKIP FOR 
                       ALL X"E3839AE383BCE382B8E38388E38383E38397E381B8"
                               IF F-SKIP > 0
                                   MOVE 'Y' TO WS-IN-NAVI-SECTION
                               ELSE
                                   WRITE NEW-REC FROM OLD-REC
                               END-IF
                            END-IF
                       END-IF
               END-READ
           END-PERFORM. 

           CLOSE NEWFILE.
           CLOSE OLDFILE.

       MAIN-900.
           STOP RUN.
