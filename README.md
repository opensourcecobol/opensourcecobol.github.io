
COBOL文法の完全日本語マニュアル『opensource COBOL Programmer's Guide』を公開しています。

- [PDF版](/guides/opensourceCOBOLProgrammersGuide.pdf)
- [HTML版](/markdown/TOC.md)

2021年より始動した本プロジェクトは、OSSコンソーシアム オープンCOBOLソリューション部会が活動の一環として、マニュアルの翻訳・執筆を進めています（プロジェクトリーダー：東京システムハウス 島田桃花）。

初版は原著をそのまま翻訳した内容です。第二版では、opensource COBOL で追加実装した日本語機能や新機能の説明を追加しました。
第三版以降で、新製品である opensource COBOL 4J についての説明を追加していく予定です。

| PDF版 | HTML版 |
| --- | --- |
| [<img width="300" src="https://github.com/opensourcecobol/opensourcecobol.github.io/assets/5810740/d8108368-9a9d-4df8-8cd9-9873d0f5d01d">](/guides/opensourceCOBOLProgrammersGuide.pdf) | [<img width="300" src="HTML_TOC.png">](/markdown/TOC.md) |



原著はGary Cultlerさんの[『OpenCOBOL Programmer's Guide』](https://gnucobol.sourceforge.io/guides/OpenCOBOL%20Programmers%20Guide.pdf)です。私たちの opensource COBOLのフォーク元である OpenCOBOLのCOBOL文法や使い方のマニュアルです。

ライセンスは、GNU Free Documentation License(FDL)です。日本語のCOBOLマニュアルがオープンソースのライセンスで公開されるのは業界初です。COBOL開発の現場での利用はもちろん、レガシー対策で一層需要が高まるCOBOLスキルの学習教材としても、自由にご利用いただけます。



## 改訂履歴

|版|発行日|改訂詳細|
|---|---|---|
|初版 v1.0.0|2023/8/31|原文”OpenCOBOL 1.1 Programmer’s Guide”を参考に日本語翻訳マニュアルを作成。|
|v1.1.0|2023/9/21|誤字や翻訳漏れを修正。|
|v1.2.0|2023/10/16|条件名の訳語を一部修正。|
|v2.0.0|2024/2/29|通貨記号の既定値を「＄」から「￥」に変更。|
|||「1.4. ソースコードの形式」に$IF、$ELSE、$ENDに関する記述を追加。|
|||「1.6. COPY文の使い方」にREPLACING句のLEADING/TRAILING指定、JOINING句のPREFIX/SUFFIX指定、PREFIXING/SUFFIXING句に関する記述を追加。|
|||「1.7. 定数の使い方 」に「1.7.3. 日本語定数」を追加。|
|||「4.2.1. ファイル管理段落 図4-10-ファイル管理段落構文」を一部修正。|
|||「4.2.1.3. 索引編成ファイル」に分割キーに関する記述を追加。|
|||「5.3 データ記述の形式」にASCENDING KEY/DESCENDING KEY句とINDEXED BY句の記述順の許容に関する記述を追加。|
|||「6.1.4.2.5. 比較条件 図6-12-比較条件構文」を一部修正。|
|||「6.8. CANCEL」に「6.8.2. CANCEL文の書き方2 ― CANCEL ALL」を追加。|
|||「6.13. DELETE」に「6.13.2. DELETE文の書き方2 ― DELETE FILE」を追加。|
|||新しい章として「7. 日本語対応」を追加。|
|||「8.1.2. コンパイルオプション」に「-assign_external」と「-free_1col_aster」の項目を追加。|
|||「8.1.7. 重要な環境変数 表8-4-環境変数コンパイラ」に環境変数「COB_DATE」「COB_IO_ASSUME_REWRITE」「COB_NIBBLE_C_UNSIGNED」「COB_VERBOSE」「OC_EXTEND_CREATES」「OC_IO_CREATES」「OC_USERFH」の項目を追加。|
|||「8.3.1. 「名前による呼び出し」ルーチン 」に「8.3.1.1. CALL “C$CALLEDBY” USING program-name GIVING status」「8.3.1.7. CALL “C$LIST-DIRECTORY” USING item-1, item-2, item-3」「8.3.1.32. CALL “CBL_OC_KEISEN” USING item-1」を追加。|

以上
