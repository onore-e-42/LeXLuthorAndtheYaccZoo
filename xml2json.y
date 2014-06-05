%{
  import java.io.*;
%}
      
%token ATT_EDITION ATT_ID ATT_TITLE AUTHORNOTES BOOK CELL CHAPTER DEDICATION END_TAG FIGURE ITEM LOF LOT NOTE PART PREFACE ROW SECTION TABLE TOC ATT_CAPTION ATT_PATH START_TAG OPEN_CLOSE CLOSE_TAG VERSION DOCTYPE
    /* new, in realtà questo non so se serve */

%token<sval> TEXT STRING

%type<sval> book book_att book_cnt dedication dedication_cnt preface preface_cnt part part_att part_cnt toc toc_cnt lof lof_cnt lot lot_cnt item item_att item_cnt chapter chapter_att chapter_cnt section section_att section_cnt figure figure_att table table_att table_cnt row row_cnt cell cell_cnt authornotes authornotes_cnt note note_cnt parts notes chapters sections items
     
%%

output	 	: VERSION DOCTYPE book {System.out.print($3);}
		| book {System.out.print($1);}
		;


book 		: START_TAG BOOK book_att END_TAG  {$$ = "{\n\t\"tag\":\"book\"" + $3 + "\n}";}
		| START_TAG BOOK book_att CLOSE_TAG  book_cnt  OPEN_CLOSE BOOK CLOSE_TAG {$$ = "{\n\t\"tag\":\"book\"" + $3 + $5 +"\n}";}
		;

book_att	: ATT_EDITION STRING	{$$ = ",\n\t\"@edition\":" + $2 ;}
		|			{$$ ="";}
		;

book_cnt	: dedication preface parts authornotes	{$$ = $1 + ", " + $2 + ", " + $3 + ", " + $4;}
		| preface parts authornotes {$$ = $1 + ", " + $2 +", "+ $3;}
		;

dedication	: START_TAG DEDICATION END_TAG {$$ = "\n\t{\n\t\t\"tag\":\"dedication\"\n\t}";}
		| START_TAG DEDICATION CLOSE_TAG dedication_cnt OPEN_CLOSE DEDICATION CLOSE_TAG	{$$ = "\n\t{\n\t\t\"tag\":\"dedication\"" + $4 + "\n\t}";}
		;

dedication_cnt	: TEXT {$$ = ",\n\t\t\"content\": [\n\t\t\t\"" + $1.trim() + "\"\n\t\t]";}
		| {$$ = "";}
		;

preface		: START_TAG PREFACE END_TAG {$$ = "\n\t{\n\t\t\"tag\":\"preface\"\n\t}";}
		| START_TAG PREFACE CLOSE_TAG preface_cnt OPEN_CLOSE PREFACE CLOSE_TAG {$$ = "\n\t{\n\t\t\"tag\":\"preface\"" + $4 + "\n\t}";}
		;

preface_cnt	: TEXT {$$ = ",\n\t\t\"content\": [\n\t\t\t\"" + $1.trim() + "\"\n\t\t]";}
		| {$$ = "";}
		;

parts		: part {$$ = $1;}
		| parts part {$$ = $1 + $2;}
		;

part		: START_TAG PART part_att END_TAG  {$$ = "\n\t{\n\t\t\"tag\":\"part\"" + $3 + "\n\t}";}
		| START_TAG PART part_att CLOSE_TAG part_cnt OPEN_CLOSE PART CLOSE_TAG {$$ = "\n\t{\n\t\t\"tag\":\"part\""+ $3 + $5 + "\n\t}";}
		;

part_att	: ATT_ID STRING	{$$ = ",\n\t\t\"@id\":" + $2 + ",";}
		| ATT_ID STRING ATT_TITLE STRING {$$ = ",\n\t\t\"@id\":" + $2 + ",\n\t\t\"@title\":" + $4 + ",";}
		;

part_cnt 	: toc chapters lof lot	{$$ = $1 + $2 + $3 + $4;}
		| toc chapters lot {$$ = $1 + $2 + $3;}
		| toc chapters lof {$$ = $1 + $2 + $3;}
		| toc chapters {$$ = $1 + $2;}
		;


toc		: START_TAG TOC CLOSE_TAG toc_cnt OPEN_CLOSE TOC CLOSE_TAG {$$ = "\n\t\t{\n\t\t\t\"tag\":\"toc\"," + $4 + "\n\t\t}";}
		;

toc_cnt		: items	{$$=$1;}
		;

lof		: START_TAG LOF CLOSE_TAG lof_cnt OPEN_CLOSE LOF CLOSE_TAG {$$ = "\n\t\t{\n\t\t\t\"tag\":\"lof\"," + $4 + "\n\t\t}";}
		;

lof_cnt		: items {$$=$1;}
		;

lot		: START_TAG LOT CLOSE_TAG lot_cnt OPEN_CLOSE LOT CLOSE_TAG {$$ = "\n\t\t{\n\t\t\t\"tag\":\"lot\"," + $4 + "\n\t\t}";}
		;

lot_cnt		: items {$$=$1;}
		;

items		: item {$$ = $1;}
		| items item {$$ = $1;}

item		: START_TAG ITEM item_att END_TAG  {$$ = "\n\t\t\t{\n\t\t\t\t\"tag\":\"item\"" + $3 + "\n\t\t\t}";}
		| START_TAG ITEM item_att CLOSE_TAG item_cnt OPEN_CLOSE ITEM CLOSE_TAG {$$ = "\n\t\t\t{\n\t\t\t\t\"tag\":\"item\"" + $3 + $5 + "\n\t\t\t}";}
		;

item_att	: ATT_ID STRING {$$ = ",\n\t\t\t\t\"@id\":" + $2;}
		;

item_cnt	:  TEXT {$$ = ",\n\t\t\t\t\"content\": [\n\t\t\t\t\t\"" + $1.trim() + "\"\n\t\t\t\t]";}
		|	{$$="";}
		;

chapters	: chapter {$$ = $1; }
		| chapters chapter {$$ = $1 + $2; }
		;

chapter		: START_TAG CHAPTER chapter_att CLOSE_TAG chapter_cnt OPEN_CLOSE CHAPTER CLOSE_TAG { $$ = "\n\t\t{\n\t\t\t\"tag\":\"chapter\"" + $3 + $5 +"\n\t\t}";}
		;

chapter_att	: ATT_ID STRING {$$ = ",\n\t\t\t\"@id\":" + $2 + ",";}
		| ATT_ID STRING ATT_TITLE STRING {$$ = ",\n\t\t\t\"@id\":" + $2 + ",\n\t\t\t\"@title\":" + $4 + ",";}
		;

chapter_cnt	: sections {$$=$1;}
		;

sections	: section {$$ = $1;}
		| sections section {$$ = $1 + $2;}

section		: START_TAG SECTION section_att END_TAG {$$ = "\n\t\t\t{\n\t\t\t\t\"tag\":\"section\"" + $3 + "\n\t\t\t}";}
		| START_TAG SECTION section_att CLOSE_TAG section_cnt OPEN_CLOSE SECTION CLOSE_TAG {$$ = "\n\t\t\t{\n\t\t\t\t\"tag\":\"section\"" + $3 + $5 +"\n\t\t\t}";}
		;

section_att	: ATT_ID STRING {$$ = ",\n\t\t\t\t\"@id\":" + $2;}
		| ATT_ID STRING ATT_TITLE STRING {$$ = ",\n\t\t\t\t\"@id\":" + $2 + ",\n\t\t\t\t\"@title\":" + $4;}
		;

section_cnt	: TEXT {$$ = ",\n\t\t\t\t\"content\": [\n\t\t\t\t\t\"" + $1.trim() + "\"\n\t\t\t\t]";}
		| sections {$$=$1;}
		| figure {$$=$1;}
		| table {$$=$1;}
		| section_cnt section_cnt {$$= $1 + $2;}
		;

figure		: START_TAG FIGURE figure_att END_TAG {$$ = "\n\t\t\t\t{,\n\t\t\t\t\t\"tag\":\"figure\"" + $3 + "\n\t\t\t\t\t}";}
		;

figure_att	: ATT_ID STRING ATT_CAPTION STRING {$$ = ",\n\t\t\t\t\t\"@id\":" + $2 + ",\n\t\t\t\t\t\"@caption\":" + $4;}
		| ATT_ID STRING ATT_CAPTION STRING ATT_PATH STRING {$$ = ",\n\t\t\t\t\t\"@id\":" + $2 + ",\n\t\t\t\t\t\"@caption\":\"" + $4 + ",\"@path\":" + $6 ;}
		;

table		: START_TAG TABLE table_att CLOSE_TAG table_cnt OPEN_CLOSE TABLE CLOSE_TAG {$$ = "\n\t\t\t\t{\n\t\t\t\t\t\"tag\":\"table\"" + $3 + $5 +"\n\t\t\t\t}";}
		;

table_att	: ATT_ID STRING ATT_CAPTION STRING {$$ = ",\n\t\t\t\t\t\"@id\":" + $2 + ",\n\t\t\t\t\t\"@caption\":" + $4 + "";}
		;

table_cnt	: row	{$$=$1;} 
		| table_cnt table_cnt {$$=$1 + $2;}
		;

row		: START_TAG ROW CLOSE_TAG row_cnt OPEN_CLOSE ROW CLOSE_TAG {$$ = "\n\t\t\t\t\t{\n\t\t\t\t\t\t\"tag\":\"row\"" + $4 + "\n\t\t\t\t\t}";}
		;

row_cnt		: cell	{$$=$1;}
		| row_cnt row_cnt {$$ = $1 + $2;}
		;

cell		: START_TAG CELL END_TAG {$$ = "\n\t\t\t\t\t\t{\n\t\t\t\t\t\t\t\"tag\":\"cell\"\n\t\t\t\t\t\t}";}
		| START_TAG CELL CLOSE_TAG cell_cnt OPEN_CLOSE CELL CLOSE_TAG  {$$ = "\n\t\t\t\t\t\t{\n\t\t\t\t\t\t\t\"tag\":\"cell\"" + $4 + "\n\t\t\t\t\t\t}";}
		;

cell_cnt	: TEXT {$$ = ",\n\t\t\t\t\t\t\t\"content\": [\n\t\t\t\t\t\t\t\t\"" + $1.trim() + "\"\n\t\t\t\t\t\t\t]";}
		| 	{$$="";}
		;

authornotes	: START_TAG AUTHORNOTES END_TAG {$$ = "\n\t{\n\t\t\"tag\":\"authornotes\"\n\t}";}
		| START_TAG AUTHORNOTES CLOSE_TAG authornotes_cnt OPEN_CLOSE AUTHORNOTES CLOSE_TAG {$$ = "\n\t{\n\t\t\"tag\":\"authornotes\"" + $4 + "\n\t}";}
		| {$$ = "";}
		;

authornotes_cnt : notes	{$$=$1;}
		| authornotes_cnt authornotes_cnt {$$ = $1 + $2;}
		;

notes		: note {$$ = $1;}
		| notes note {$$ = $1 + $2;}
		;

note		: START_TAG NOTE END_TAG {$$ = "\n\t\t{\n\t\t\t\"tag\":\"note\"\n\t\t}";}
		| START_TAG NOTE CLOSE_TAG note_cnt OPEN_CLOSE NOTE CLOSE_TAG {$$ = "\n\t\t{\n\t\t\t\"tag\":\"note\"" + $4 + "\n\t\t}";}
		;

note_cnt	: TEXT {$$ = ",\n\t\t\t\"content\": [\n\t\t\t\t\"" + $1.trim() + "\"\n\t\t\t]";}
		|	{$$="";}
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
    System.err.println ("Error: " + error);
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