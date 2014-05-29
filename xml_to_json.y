%{
  import java.io.*;
%}
      
%token NL ATT_EDITION ATT_ID ATT_TITLE ATT_CAPTION ATT_PATH CLOSE_TAG END_TAG         /* newline , in realtà questo non so se serve */

%token<sval> OPEN_CLOSE AUTHORNOTES CLOSE_TAG START_TAG AUTHORNOTES OPEN_CLOSE BOOK CLOSE_TAG START_TAG BOOK OPEN_CLOSE CELL CLOSE_TAG START_TAG CELL OPEN_CLOSE CHAPTER CLOSE_TAG START_TAG CHAPTER OPEN_CLOSE DEDICATION CLOSE_TAG START_TAG DEDICATION OPEN_CLOSE FIGURE CLOSE_TAG START_TAG FIGURE OPEN_CLOSE ITEM CLOSE_TAG START_TAG ITEM OPEN_CLOSE LOF CLOSE_TAG START_TAG LOF OPEN_CLOSE LOT CLOSE_TAG START_TAG LOT OPEN_CLOSE NOTE CLOSE_TAG START_TAG NOTE OPEN_CLOSE PART CLOSE_TAG START_TAG PART OPEN_CLOSE PREFACE CLOSE_TAG START_TAG PREFACE OPEN_CLOSE ROW CLOSE_TAG START_TAG ROW OPEN_CLOSE SECTION CLOSE_TAG START_TAG SECTION STRING OPEN_CLOSE TABLE CLOSE_TAG START_TAG TABLE TEXT OPEN_CLOSE TOC CLOSE_TAG START_TAG TOC KEYWORD

%type<sval> book book_att book_cnt dedication dedication_cnt preface preface_cnt part part_att part_cnt toc toc_cnt lof lof_cnt lot lot_cnt item item_att item_cnt chapter chapter_att chapter_cnt section section_att section_cnt figure figure_att figure_cnt table table_att table_cnt row row_cnt cell cell_cnt authornotes authornotes_cnt note note_cnt
     
%%

book 		: START_TAG BOOK book_att END_TAG
		| START_TAG BOOK book_att CLOSE_TAG book_cnt OPEN_CLOSE BOOK CLOSE_TAG
		;

book_att	: ATT_EDITION STRING
		|
		;

book_cnt	: dedication preface part authornotes
		;

dedication	: START_TAG DEDICATION END_TAG
		| START_TAG DEDICATION CLOSE_TAG dedication_cnt OPEN_CLOSE DEDICATION CLOSE_TAG
		|
		;

dedication_cnt	: TEXT
		|
		;

preface		: START_TAG PREFACE END_TAG
		| START_TAG PREFACE CLOSE_TAG preface_cnt OPEN_CLOSE PREFACE CLOSE_TAG
		;

preface_cnt	: TEXT
		|
		;

part		: START_TAG PART part_att END_TAG
		| START_TAG PART CLOSE_TAG part_cnt OPEN_CLOSE PART CLOSE_TAG
		| part part
		;

part_att	: ATT_ID STRING
		| ATT_TITLE STRING
		|
		;

part_cnt	: toc chapter lof lot
		;


toc		: START_TAG TOC END_TAG
		| START_TAG TOC CLOSE_TAG toc_cnt OPEN_CLOSE TOC CLOSE_TAG
		;

toc_cnt		: item
		;

lof		: START_TAG LOF END_TAG
		| START_TAG LOF CLOSE_TAG lof_cnt OPEN_CLOSE LOF CLOSE_TAG
		;

lof_cnt		: item
		;

lot		: START_TAG LOT END_TAG
		| START_TAG LOT CLOSE_TAG lot_cnt OPEN_CLOSE LOT CLOSE_TAG

lot_cnt		: item
		;

item		: START_TAG ITEM item_att END_TAG
		| START_TAG ITEM item_att CLOSE_TAG item_cnt OPEN_CLOSE ITEM CLOSE_TAG
		| item item
		;

item_att	: ATT_ID STRING
		|
		;

item_cnt	: TEXT
		|
		;

chapter		: START_TAG CHAPTER chapter_att END_TAG
		| START_TAG CHAPTER chapter_att CLOSE_TAG chapter_cnt OPEN_CLOSE CHAPTER CLOSE_TAG
		| chapter chapter
		;
		
chapter_att	: ATT_ID STRING
		| ATT_TITLE STRING
		|
		;

chapter_cnt	: section
		;

section		: START_TAG SECTION section_att END_TAG
		| START_TAG SECTION section_att CLOSE_TAG section_cnt OPEN_CLOSE SECTION CLOSE_TAG
		| section section
		;

section_att	: ATT_ID STRING
		| ATT_TITLE STRING
		|
		;

section_cnt	: TEXT
		| section
		| figure
		| table
		|
		;

figure		: START_TAG FIGURE figure_att END_TAG
		| START_TAG FIGURE figure_att CLOSE_TAG OPEN_CLOSE FIGURE CLOSE_TAG
		;

figure_att	: ATT_ID STRING
		| ATT_CAPTION STRING
		| ATT_PATH STRING
		|
		;

table		: START_TAG TABLE table_att END_TAG
		| START_TAG TABLE table_att CLOSE_TAG table_cnt OPEN_CLOSE TABLE CLOSE_TAG
		;

table_att	: ATT_ID STRING
		| ATT_CAPTION STRING
		|
		;

table_cnt	: row
		;

row		: START_TAG ROW END_TAG
		| START_TAG ROW CLOSE_TAG row_cnt OPEN_CLOSE ROW CLOSE_TAG
		| row row
		;

row_cnt		: cell
		;

cell		: START_TAG CELL END_TAG
		| START_TAG CELL CLOSE_TAG cell_cnt OPEN_CLOSE CELL CLOSE_TAG
		| cell cell
		;

cell_cnt	: TEXT
		|
		;

authornotes	: START_TAG AUTHORNOTES END_TAG
		| START_TAG AUTHORNOTES CLOSE_TAG authornotes_cnt OPEN_CLOSE AUTHORNOTES CLOSE_TAG
		|
		;

authornotes_cnt : note
		;

note		: START_TAG NOTE END_TAG
		| START_TAG NOTE CLOSE_TAG note_cnt OPEN_CLOSE NOTE CLOSE_TAG
		| note note
		;

note_cnt	: TEXT
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
    System.err.println ("Error: " + error + yychar);
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














