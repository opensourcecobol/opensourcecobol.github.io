       IDENTIFICATION              DIVISION.
       PROGRAM-ID.                 AUTODELETE.
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
       77  OLD-STS                 PIC X(02).
       77  NEW-STS                 PIC X(02).
       77  OLD-FILE-PATH           PIC X(256).
       77  NEW-FILE-PATH           PIC X(256).
       77  MD-NAME                 PIC X(250).
      *ファイルの終端を示すフラグ
       77  WS-END-OF-FILE          PIC X VALUE 'N'.
       77  WS-IN-NAVI-SECTION      PIC X VALUE 'N'.
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
                    MD-NAME            DELIMITED BY SPACE
                    INTO   OLD-FILE-PATH.
           MOVE SPACE TO NEW-FILE-PATH.
           STRING   "new_delete/"      DELIMITED BY SIZE
                    MD-NAME            DELIMITED BY SPACE
                    INTO   NEW-FILE-PATH.

           IF OLD-FILE-PATH = SPACE GO TO MAIN-900.

           OPEN  INPUT OLDFILE
                 OUTPUT NEWFILE.
       MAIN-100.
           PERFORM UNTIL WS-END-OF-FILE = 'Y'
      *1行ずつ読み込む
               READ OLDFILE INTO OLD-REC
      *終わったら、ファイルの終端を示すフラグを'Y'にする
                   AT END
                       MOVE 'Y' TO WS-END-OF-FILE
                   NOT AT END
      *<!--navi start1and2-->から<!--navi end1and2-->の記述を削除する
                       IF OLD-REC = "<!--navi start1-->"
                          OR "<!--navi start2-->"
                          MOVE 'Y' TO WS-IN-NAVI-SECTION
                          EXIT PERFORM CYCLE
                       END-IF
                       IF OLD-REC = "<!--navi end1-->"
                          OR "<!--navi end2-->"
                          MOVE 'N' TO WS-IN-NAVI-SECTION
                          EXIT PERFORM CYCLE
                       END-IF
      *書き込み
                       IF WS-IN-NAVI-SECTION = 'N'
                           WRITE NEW-REC FROM OLD-REC
                       END-IF
               END-READ
           END-PERFORM. 

           CLOSE NEWFILE.
           CLOSE OLDFILE.

       MAIN-900.
           STOP RUN.
