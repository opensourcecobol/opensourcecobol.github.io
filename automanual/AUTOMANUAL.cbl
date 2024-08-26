       IDENTIFICATION              DIVISION.
       PROGRAM-ID.                 AUTOMANUAL.
       AUTHOR.                     M SHIMADA.
       DATE-WRITTEN.               2024-07-26.
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
       01  WRK-STRING              PIC X(250).
       01  MD-CURRENT              PIC X(250).
       01  MD-PREVIOUS             PIC X(250).
       01  MD-NEXT                 PIC X(250).
       01  END-FLG                 PIC 9(01).
      ******************************************************************
       PROCEDURE                   DIVISION.
      ******************************************************************
      *-------------------------------------*
       MAIN-CONTROL                SECTION.
      *-------------------------------------*
       MAIN-000.
      *実行コマンドの引数を受け取る
      *3分割してそれぞれのファイル名を取得する
           ACCEPT WRK-STRING FROM COMMAND-LINE.
           UNSTRING WRK-STRING DELIMITED BY SPACE
                    INTO   MD-CURRENT
                           MD-PREVIOUS
                           MD-NEXT.
      *前へ/次へに該当するファイルがない場合はスペースを代入する
      *リンクは挿入しないで文字だけの表示とする
           IF MD-PREVIOUS = "none"
              MOVE SPACE TO MD-PREVIOUS.
           IF MD-NEXT = "none"
              MOVE SPACE TO MD-NEXT.
      *変換前後のファイルをフォルダ分けするためディレクトリを追加する
           MOVE SPACE TO OLD-FILE-PATH.
           STRING   "old/"      DELIMITED BY SIZE
                    MD-CURRENT DELIMITED BY SPACE
                    INTO   OLD-FILE-PATH.
           MOVE SPACE TO NEW-FILE-PATH.
           STRING   "new/"      DELIMITED BY SIZE
                    MD-CURRENT DELIMITED BY SPACE
                    INTO   NEW-FILE-PATH.

           IF OLD-FILE-PATH = space GO TO MAIN-900.

           OPEN  INPUT OLDFILE
                 OUTPUT NEWFILE.
      *1行目
      *<!--navi start-->を挿入する
           WRITE NEW-REC FROM "<!--navi start-->".
      *2行目
      *前へ/次へを挿入する※文字化け防止のため16進数で挿入
      *前後ファイルのリンクも挿入する
           MOVE SPACE TO NEW-REC.
           IF MD-PREVIOUS NOT = SPACE AND MD-NEXT NOT = SPACE
              STRING  "["             DELIMITED BY SIZE
                      X"E5898DE381B8" DELIMITED BY SIZE
                      "]("            DELIMITED BY SIZE
                      MD-PREVIOUS     DELIMITED BY SPACE
                      ")/["           DELIMITED BY SIZE
                      X"E6ACA1E381B8" DELIMITED BY SIZE
                      "]("            DELIMITED BY SIZE
                      MD-NEXT         DELIMITED BY SPACE
                      ")"             DELIMITED BY SIZE
                      INTO NEW-REC
              WRITE NEW-REC.
           IF MD-PREVIOUS = SPACE
              STRING  X"E5898DE381B8" DELIMITED BY SIZE
                      "/["            DELIMITED BY SIZE
                      X"E6ACA1E381B8" DELIMITED BY SIZE
                      "]("            DELIMITED BY SIZE
                      MD-NEXT         DELIMITED BY SPACE
                      ")"             DELIMITED BY SIZE
                      INTO NEW-REC
              WRITE NEW-REC.
           IF MD-NEXT = SPACE
              STRING  "["             DELIMITED BY SIZE
                      X"E5898DE381B8" DELIMITED BY SIZE
                      "]("            DELIMITED BY SIZE
                      MD-PREVIOUS     DELIMITED BY SPACE
                      ")/"            DELIMITED BY SIZE
                      X"E6ACA1E381B8" DELIMITED BY SIZE
                      INTO NEW-REC
              WRITE NEW-REC.
      *3行目
      *<!--navi end-->を挿入する
           WRITE NEW-REC FROM "<!--navi end-->".
           PERFORM UNTIL (OLD-STS NOT = ZERO)
             MOVE SPACE TO OLD-REC
             READ OLDFILE NEXT
               AT END
                  CONTINUE
               NOT AT END
                  MOVE OLD-REC TO NEW-REC
                  WRITE NEW-REC
             END-READ
           END-PERFORM.
           CLOSE NEWFILE
           CLOSE OLDFILE.
       MAIN-900.
           STOP RUN.
