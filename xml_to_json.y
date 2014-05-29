%{
  import java.io.*;
%}
      
%token NL ATT_EDITION ATT_ID ATT_TITLE AUTHORNOTES BOOK CELL CHAPTER DEDICATION END_TAG FIGURE ITEM LOF LOT NOTE PART PREFACE ROW SECTION  TABLE TOC ATT_CAPTION ATT_PATH           /* newline , in realtà questo non so se serve */

%token<sval> TEXT STRING

%type<sval> book book_att book_cnt dedication dedication_cnt preface preface_cnt part part_att part_cnt toc toc_cnt lof lof_cnt lot lot_cnt item item_att item_cnt chapter chapter_att chapter_cnt section section_att section_cnt figure figure_att figure_cnt table table_att table_cnt row row_cnt cell cell_cnt authornotes authornotes_cnt note note_cnt 
     
%%

book 	: START_TAG BOOK book_att END_TAG	  {$$ = "{\"tag\":\"book\"," + $3 + "}";}
		| START_TAG BOOK book_att CLOSE_TAG book_cnt OPEN_CLOSE BOOK CLOSE_TAG {$$ = "{\"tag\":\"book\"," + $3 + $5 +"}";}
		;

book_att	: ATT_EDITION STRING	{$$ = "\"@edition\":\"" + $2 + "\"";}
			|
			;

book_cnt	: dedication preface part authornotes	{$$ = $1 + $2 + $3 + $4;}
			| dedication preface part {$$ = $1 + $2 + $3;}
			| preface part authornotes {$$ = $1 + $2 + $3;}
			| preface part {$$ = $1 + $2;}
		;

dedication	: START_TAG DEDICATION END_TAG {$$ = "{\"tag\":\"dedication\"}";}
			| START_TAG DEDICATION CLOSE_TAG dedication_cnt OPEN_CLOSE DEDICATION CLOSE_TAG	{$$ = "{\"tag\":\"dedication\"," + $4 + "}";}
			|
			;

dedication_cnt	: TEXT {$$ = "\"content\": [\"" + $1 + "\"]";}
		|
		;

preface		: START_TAG PREFACE END_TAG {$$ = "{\"tag\":\"preface\"}";}
		| START_TAG PREFACE CLOSE_TAG preface_cnt OPEN_CLOSE PREFACE CLOSE_TAG {$$ = "{\"tag\":\"preface\"," + $4 + "}";}
		;

preface_cnt	: TEXT	{$$ = "\"content\": [\"" + $1 + "\"]";}
		|
		;
		
part	: START_TAG PART part_att END_TAG  {$$ = "{\"tag\":\"part\"" + $3 + "}";}
		| START_TAG PART part_att CLOSE_TAG part_cnt OPEN_CLOSE PART CLOSE_TAG {$$ = "{\"tag\":\"part\","+ $3 + $5 + "}";}
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


toc		: START_TAG TOC CLOSE_TAG toc_cnt OPEN_CLOSE TOC CLOSE_TAG {$$ = "{\"tag\":\"toc\"," + $4 + "}";}
		;

toc_cnt	: item	{$$=$1;}
		;

lof		: START_TAG LOF CLOSE_TAG lof_cnt OPEN_CLOSE LOF CLOSE_TAG {$$ = "{\"tag\":\"lof\"," + $4 + "}";}
		;

lof_cnt		: item {$$=$1;}
		;

lot		: START_TAG LOT CLOSE_TAG lot_cnt OPEN_CLOSE LOT CLOSE_TAG {$$ = "{\"tag\":\"lot\"," + $4 + "}";}
		;

lot_cnt		: item {$$=$1;}
		;

item	: START_TAG ITEM item_att END_TAG  {$$ = "{\"tag\":\"item\"" + $3 + "}";}
		| START_TAG ITEM item_att CLOSE_TAG item_cnt OPEN_CLOSE ITEM CLOSE_TAG {$$ = "{\"tag\":\"item\"" + $3 + $5 + "}";}
		| item item {$$ = $1 + $2;}
		;

item_att	: ATT_ID STRING {$$ = "\"@id\":\"" + $2 + "\",";}
			;

item_cnt	: TEXT {$$ = "\"content\": [\n\"" + $1 + "\"],";}
		|
		;

chapter	: START_TAG CHAPTER chapter_att CLOSE_TAG chapter_cnt OPEN_CLOSE CHAPTER CLOSE_TAG {$$ = "{\"tag\":\"chapter\"" + $3 + $5 +"}";}
		| chapter chapter {$$ = $1 + $2;}
		;
		
chapter_att	: ATT_ID STRING {$$ = "\"@id\":\"" + $2 + "\",";}
		| ATT_ID STRING ATT_TITLE STRING {$$ = "\"@id\":\"" + $2 + "\",\"@title\":\"" + $4 + "\",";}
		;

chapter_cnt	: section {$$=$1;}
		;

section		: START_TAG SECTION section_att END_TAG {$$ = "{\"tag\":\"section\"" + $3 + "}";}
			| START_TAG SECTION section_att CLOSE_TAG section_cnt OPEN_CLOSE SECTION CLOSE_TAG {$$ = "{\"tag\":\"section\"" + $3 + $5 +"}";}
			| section section {$$ = $1 + $2;}
			;

section_att	: ATT_ID STRING {$$ = "\"@id\":\"" + $2 + "\",";}
		| ATT_ID STRING ATT_TITLE STRInG {$$ = "\"@id\":\"" + $2 + "\",\"@title\":\"" + $4 + "\",";}
		;

section_cnt	: TEXT {$$ = "\"content\": [\n\"" + $1 + "\"],";}
		| section {$$=$1;}
		| figure {$$=$1;}
		| table {$$=$1;}
		| section_cnt section_cnt {$$= $1 + $2;}
		;

figure	: START_TAG FIGURE figure_att END_TAG {$$ = "{\"tag\":\"figure\"" + $3 + "}";}
		;

figure_att	: ATT_ID STRING ATT_CAPTION STRING {$$ = "\"@id\":\"" + $2 + "\",\"@caption\":\"" + $4 + "\"";}
		| ATT_ID STRING ATT_CAPTION STRING ATT_PATH STRING {$$ = "\"@id\":\"" + $2 + "\",\"@caption\":\"" + $4 + "\",\"@caption\":\"" + $6 "\"";}
		;

table	: START_TAG TABLE table_att CLOSE_TAG table_cnt OPEN_CLOSE TABLE CLOSE_TAG $$ = "{\"tag\":\"table\"" + $3 + $5 +"}";}
		;

table_att	: ATT_ID STRING ATT_CAPTION STRING {$$ = "\"@id\":\"" + $2 + "\",\"@caption\":\"" + $4 + "\"";}
		;

table_cnt	: row	{$$=$1;} 
			| table_cnt table_cnt {$$=$1 + $2;}
		;

row		: START_TAG ROW CLOSE_TAG row_cnt OPEN_CLOSE ROW CLOSE_TAG {$$ = "{\"tag\":\"row\"," + $4 + "}";}
		;

row_cnt	: cell	{$$=$1;}
		| row_cnt row_cnt {$$ = $1 + $2;}
		;

cell	: START_TAG CELL END_TAG {$$ = "{\"tag\":\"cell\"}";}
		| START_TAG CELL CLOSE_TAG cell_cnt OPEN_CLOSE CELL CLOSE_TAG  {$$ = "{\"tag\":\"cell\"," + $4 + "}";}
		;

cell_cnt	: TEXT {$$ = "\"content\": [\n\"" + $1 + "\"]";}
		|
		;

authornotes	: START_TAG AUTHORNOTES END_TAG {$$ = "{\"tag\":\"authornotes\"}";}
		| START_TAG AUTHORNOTES CLOSE_TAG authornotes_cnt OPEN_CLOSE AUTHORNOTES CLOSE_TAG {$$ = "{\"tag\":\"authornotes\"," + $4 + "}";}
		|
		;

authornotes_cnt : note cell	{$$=$1;}
		| authornotes_cnt authornotes_cnt {$$ = $1 + $2;}
		;

note	: START_TAG NOTE END_TAG {$$ = "{\"tag\":\"note\"}";}
		| START_TAG NOTE CLOSE_TAG note_cnt OPEN_CLOSE NOTE CLOSE_TAG {$$ = "{\"tag\":\"note\"," + $4 + "}";}
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


