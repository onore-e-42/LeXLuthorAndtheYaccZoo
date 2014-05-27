%{
  import java.io.*;
%}
      
%token NL          /* newline , in realtà questo non so se serve */

%token<sval> ATT_EDITION ATT_ID ATT_TITLE AUTHORNOTES_CLOSE AUTHORNOTES_OPEN BOOK_CLOSE BOOK_OPEN CELL_CLOSE CELL_OPEN CHAPTER_CLOSE CHAPTER_OPEN CLOSE_TAG DEDICATION_CLOSE DEDICATION_OPEN END_TAG FIGURE_CLOSE FIGURE_OPEN ITEM_CLOSE ITEM_OPEN LOF_CLOSE LOF_OPEN LOT_CLOSE LOT_OPEN NOTE_CLOSE NOTE_OPEN PART_CLOSE PART_OPEN PREFACE_CLOSE PREFACE_OPEN ROW_CLOSE ROW_OPEN SECTION_CLOSE SECTION_OPEN STRING TABLE_CLOSE TABLE_OPEN TEXT TOC_CLOSE TOC_OPEN ATT_CAPTION ATT_PATH KEYWORD

%type<sval> book book_att book_cnt dedication dedication_cnt preface preface_cnt part part_att part_cnt toc toc_cnt lof lof_cnt lot lot_cnt item item_att item_cnt chapter chapter_att chapter_cnt section section_att section_cnt figure figure_att figure_cnt table table_att table_cnt row row_cnt cell cell_cnt authornotes authornotes_cnt note note_cnt
     
%%

book 		: BOOK_OPEN book_att END_TAG
		| BOOK_OPEN book_att CLOSE_TAG book_cnt BOOK_CLOSE
		;

book_att	: ATT_EDITION STRING
		|
		;

book_cnt	: dedication preface part authornotes
		;

dedication	: DEDICATION_OPEN END_TAG
		| DEDICATION_OPEN CLOSE_TAG dedication_cnt DEDICATION_CLOSE
		|
		;

dedication_cnt	: TEXT
		|
		;

preface		: PREFACE_OPEN END_TAG
		| PREFACE_OPEN CLOSE_TAG preface_cnt PREFACE_CLOSE
		;

preface_cnt	: TEXT
		|
		;

part		: PART_OPEN part_att END_TAG
		| PART_OPEN CLOSE_TAG part_cnt PART_CLOSE
		| part part
		;

part_att	: ATT_ID STRING
		| ATT_TITLE STRING
		|
		;

part_cnt	: toc chapter lof lot
		;


toc		: TOC_OPEN END_TAG
		| TOC_OPEN CLOSE_TAG toc_cnt TOC_CLOSE
		;

toc_cnt		: item
		;

lof		: LOF_OPEN END_TAG
		| LOF_OPEN CLOSE_TAG lof_cnt LOF_CLOSE
		;

lof_cnt		: item
		;

lot		: LOT_OPEN END_TAG
		| LOT_OPEN CLOSE_TAG lot_cnt LOT_CLOSE

lot_cnt		: item
		;

item		: ITEM_OPEN item_att END_TAG
		| ITEM_OPEN item_att CLOSE_TAG item_cnt ITEM_CLOSE
		| item item
		;

item_att	: ATT_ID STRING
		|
		;

item_cnt	: TEXT
		|
		;

chapter		: CHAPTER_OPEN chapter_att END_TAG
		| CHAPTER_OPEN chapter_att CLOSE_TAG chapter_cnt CHAPTER_CLOSE
		| chapter chapter
		;
		
chapter_att	: ATT_ID STRING
		| ATT_TITLE STRING
		|
		;

chapter_cnt	: section
		;

section		: SECTION_OPEN section_att END_TAG
		| SECTION_OPEN section_att CLOSE_TAG section_cnt SECTION_CLOSE
		| section section
		;

section_att	: ATT_ID
		| ATT_TITLE
		|
		;

section_cnt	: TEXT
		| section
		| figure
		| table
		|
		;

figure		: FIGURE_OPEN figure_att END_TAG
		| FIGURE_OPEN figure_att CLOSE_TAG figure_cnt FIGURE_CLOSE
		;

figure_att	: ATT_ID STRING
		| ATT_CAPTION STRING
		| ATT_PATH STRING
		|
		;

figure_cnt	:;

table		: TABLE_OPEN table_att END_TAG
		| TABLE_OPEN table_att CLOSE_TAG table_cnt TABLE_CLOSE
		;

table_att	: ATT_ID STRING
		| ATT_CAPTION STRING
		|
		;

table_cnt	: row
		;

row		: ROW_OPEN END_TAG
		| ROW_OPEN CLOSE_TAG row_cnt ROW_CLOSE
		| row row
		;

row_cnt		: cell
		;

cell		: CELL_OPEN END_TAG
		| CELL_OPEN CLOSE_TAG cell_cnt CELL_CLOSE
		| cell cell
		;

cell_cnt	: TEXT
		|
		;

authornotes	: AUTHORNOTES_OPEN END_TAG
		| AUTHORNOTES_OPEN CLOSE_TAG authornotes_cnt AUTHORNOTES_CLOSE
		|
		;

authornotes_cnt : note
		;

note		: NOTE_OPEN END_TAG
		| NOTE_OPEN CLOSE_TAG note_cnt NOTE_CLOSE
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














