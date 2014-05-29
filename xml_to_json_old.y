%{
  import java.io.*;
%}
      
%token NL          /* newline , in realtà questo non so se serve */

%token<sval> ATT_EDITION ATT_ID ATT_TITLE AUTHORNOTES_CLOSE AUTHORNOTES_OPEN BOOK_CLOSE BOOK_OPEN CELL_CLOSE CELL_OPEN CHAPTER_CLOSE CHAPTER_OPEN CLOSE_TAG DEDICATION_CLOSE DEDICATION_OPEN END_TAG FIGURE_CLOSE FIGURE_OPEN ITEM_CLOSE ITEM_OPEN LOF_CLOSE LOF_OPEN LOT_CLOSE LOT_OPEN NOTE_CLOSE NOTE_OPEN PART_CLOSE PART_OPEN PREFACE_CLOSE PREFACE_OPEN ROW_CLOSE ROW_OPEN SECTION_CLOSE SECTION_OPEN STRING TABLE_CLOSE TABLE_OPEN TEXT TOC_CLOSE TOC_OPEN ATT_CAPTION ATT_PATH KEYWORD 

%type<sval> book book_att book_cnt dedication dedication_cnt preface preface_cnt part part_att part_cnt toc toc_cnt lof lof_cnt lot lot_cnt item item_att item_cnt chapter chapter_att chapter_cnt section section_att section_cnt figure figure_att figure_cnt table table_att table_cnt row row_cnt cell cell_cnt authornotes authornotes_cnt note note_cnt 
     
%%

book 	: BOOK_OPEN book_att END_TAG	  {$$ = "{\"tag\":\"book\"," + $2 + "}";}
		| BOOK_OPEN book_att CLOSE_TAG book_cnt BOOK_CLOSE {$$ = "{\"tag\":\"book\"," + $2 + $4 +"}";}
		;

book_att	: ATT_EDITION STRING	{$$ = "\"@edition\":\"" + $2 + "\"";}
			|
			;

book_cnt	: dedication preface part authornotes	{$$ = $1 + $2 + $3 + $4;}
			| dedication preface part {$$ = $1 + $2 + $3;}
			| preface part authornotes {$$ = $1 + $2 + $3;}
			| preface part {$$ = $1 + $2;}
		;

dedication	: DEDICATION_OPEN END_TAG {$$ = "{\"tag\":\"dedication\"}";}
			| DEDICATION_OPEN CLOSE_TAG dedication_cnt DEDICATION_CLOSE	{$$ = "{\"tag\":\"dedication\"," + $3 + "}";}
			|
			;

dedication_cnt	: TEXT {$$ = "\"content\": [\"" + $1 + "\"]";}
		|
		;

preface		: PREFACE_OPEN END_TAG {$$ = "{\"tag\":\"preface\"}";}
		| PREFACE_OPEN CLOSE_TAG preface_cnt PREFACE_CLOSE {$$ = "{\"tag\":\"preface\"," + $3 + "}";}
		;

preface_cnt	: TEXT	{$$ = "\"content\": [\"" + $1 + "\"]";}
		|
		;
		
part	: PART_OPEN part_att END_TAG  {$$ = "{\"tag\":\"part\"" + $2 + "}";}
		| PART_OPEN part_att CLOSE_TAG part_cnt PART_CLOSE {$$ = "{\"tag\":\"part\","+ $2 + $4 + "}";}
		| part part	{$$ = $1 + $2;}
		;

part_att	: ATT_ID STRING	{$$ = "\"@id\":\"" + $2 + "\",";}
			| ATT_ID STRING ATT_TITLE STRING {$$ = "\"@id\":\"" + $2 + "\",\"@title\":\"" + $4 + "\",";}
			;

part_cnt	: toc chapter lof lot	{$$ = $1 + $2 + $3 + $4;}
			| toc chapter lof {$$ = $1 + $2 + $3;}
			| toc chapter lot {$$ = $1 + $2 + $3;}
			| toc chapter {$$ = $1 + $2;}
		;


toc		: TOC_OPEN CLOSE_TAG toc_cnt TOC_CLOSE {$$ = "{\"tag\":\"toc\"," + $3 + "}";}
		;

toc_cnt	: item	{$$=$1;}
		;

lof		: LOF_OPEN CLOSE_TAG lof_cnt LOF_CLOSE {$$ = "{\"tag\":\"lof\"," + $3 + "}";}
		;

lof_cnt		: item {$$=$1;}
		;

lot		: LOT_OPEN CLOSE_TAG lot_cnt LOT_CLOSE {$$ = "{\"tag\":\"lot\"," + $3 + "}";}
		;

lot_cnt		: item {$$=$1;}
		;

item	: ITEM_OPEN item_att END_TAG  {$$ = "{\"tag\":\"item\"" + $2 + "}";}
		| ITEM_OPEN item_att CLOSE_TAG item_cnt ITEM_CLOSE {$$ = "{\"tag\":\"item\"" + $2 + $4 + "}";}
		| item item {$$ = $1 + $2;}
		;

item_att	: ATT_ID STRING {$$ = "\"@id\":\"" + $2 + "\",";}
			;

item_cnt	: TEXT {$$ = "\"content\": [\n\"" + $1 + "\"],";}
		|
		;

chapter	: CHAPTER_OPEN chapter_att CLOSE_TAG chapter_cnt CHAPTER_CLOSE {$$ = "{\"tag\":\"chapter\"" + $2 + $4 +"}";}
		| chapter chapter {$$ = $1 + $2;}
		;
		
chapter_att	: ATT_ID STRING {$$ = "\"@id\":\"" + $2 + "\",";}
		| ATT_ID STRING ATT_TITLE STRING {$$ = "\"@id\":\"" + $2 + "\",\"@title\":\"" + $4 + "\",";}
		;

chapter_cnt	: section {$$=$1;}
		;

section		: SECTION_OPEN section_att END_TAG {$$ = "{\"tag\":\"section\"" + $2 + "}";}
			| SECTION_OPEN section_att CLOSE_TAG section_cnt SECTION_CLOSE {$$ = "{\"tag\":\"section\"" + $2 + $4 +"}";}
			| section section {$$ = $1 + $2;}
			;

section_att	: ATT_ID STRING {$$ = "\"@id\":\"" + $2 + "\",";}
		| ATT_ID STRING ATT_TITLE STRNIG {$$ = "\"@id\":\"" + $2 + "\",\"@title\":\"" + $4 + "\",";}
		;

section_cnt	: TEXT {$$ = "\"content\": [\n\"" + $1 + "\"],";}
		| section {$$=$1;}
		| figure {$$=$1;}
		| table {$$=$1;}
		| section_cnt section_cnt {$$= $1 + $2;}
		;

figure	: FIGURE_OPEN figure_att END_TAG {$$ = "{\"tag\":\"figure\"" + $2 + "}";}
		;

figure_att	: ATT_ID STRING ATT_CAPTION STRING {$$ = "\"@id\":\"" + $2 + "\",\"@caption\":\"" + $4 + "\"";}
		| ATT_ID STRING ATT_CAPTION STRING ATT_PATH STRING {$$ = "\"@id\":\"" + $2 + "\",\"@caption\":\"" + $4 + "\",\"@caption\":\"" + $6 "\"";}
		;

table	: TABLE_OPEN table_att CLOSE_TAG table_cnt TABLE_CLOSE {$$ = "{\"tag\":\"table\"" + $2 + $4 +"}";}
		;

table_att	: ATT_ID STRING ATT_CAPTION STRING {$$ = "\"@id\":\"" + $2 + "\",\"@caption\":\"" + $4 + "\"";}
		;

table_cnt	: row	{$$=$1;} 
			| table_cnt table_cnt {$$=$1 + $2;}
		;

row		: ROW_OPEN CLOSE_TAG row_cnt ROW_CLOSE {$$ = "{\"tag\":\"row\"," + $3 + "}";}
		;

row_cnt	: cell	{$$=$1;}
		| row_cnt row_cnt {$$ = $1 + $2;}
		;

cell	: CELL_OPEN END_TAG {$$ = "{\"tag\":\"cell\"}";}
		| CELL_OPEN CLOSE_TAG cell_cnt CELL_CLOSE  {$$ = "{\"tag\":\"cell\"," + $3 + "}";}
		;

cell_cnt	: TEXT {$$ = "\"content\": [\n\"" + $1 + "\"]";}
		|
		;

authornotes	: AUTHORNOTES_OPEN END_TAG {$$ = "{\"tag\":\"authornotes\"}";}
		| AUTHORNOTES_OPEN CLOSE_TAG authornotes_cnt AUTHORNOTES_CLOSE {$$ = "{\"tag\":\"authornotes\"," + $3 + "}";}
		|
		;

authornotes_cnt : note cell	{$$=$1;}
		| authornotes_cnt authornotes_cnt {$$ = $1 + $2;}
		;

note	: NOTE_OPEN END_TAG {$$ = "{\"tag\":\"note\"}";}
		| NOTE_OPEN CLOSE_TAG note_cnt NOTE_CLOSE {$$ = "{\"tag\":\"note\"," + $3 + "}";}
		;

note_cnt	: TEXT {$$ = "\"content\": [\n\"" + $1 + "\"]";}
		|
		;
%%
 

 private Yylex lexer;


  private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.err.println ("Error: line %d: %s\n" + error + yychar);
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }

  public static void main(String args[]) throws IOException {
    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
      yyparser.yyparse();
    }
    else {
      System.out.println("ERROR: Provide an input file as Parser argument");
    }
  }














