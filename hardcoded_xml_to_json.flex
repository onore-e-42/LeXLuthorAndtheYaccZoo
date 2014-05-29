
%%

%byaccj

%{
	private Parser yyparser;
	
	public Yylex(java.io.Reader r, Parser yyparser) {
	this(r);
	this.yyparser = yyparser;
	}

%}

%x IN_TAG IN_MARKUP CLOSING_TAG

STRING		= ("'"[a-zA-Z0-9\-_]*"'" | '"'[a-zA-Z0-9\-_]*'"')
TEXT		= ([a-zA-Z0-9\-_]*)

START_TAG	= ("<")
END_TAG		= ("/>")
CLOSE_TAG	= (">")
OPEN_CLOSE	= ("</")
ATT_ID		= ("id =")
ATT_TITLE	= ("title =")
ATT_CAPTION	= ("caption =")
ATT_PATH	= ("path =")
ATT_EDITION	= ("edition =")
%%

<IN_TAG, IN_MARKUP, CLOSING_TAG, YYINITIAL>{
		{NL}		{return Parser.NL;}
	}

{START_TAG}			{yybegin(IN_TAG);
				 return Parser.START_TAG;}

<IN_TAG>{

		"book"		{return Parser.BOOK;}
		"dedication"	{return Parser.DEDICATION;}
		"preface"	{return Parser.PREFACE;}
		"part"		{return Parser.PART;}
		"toc"		{return Parser.TOC;}
		"lof"		{return Parser.LOF;}
		"lot"		{return Parser.LOT;}
		"item"		{return Parser.ITEM;}
		"chapter"	{return Parser.CHAPTER;}
		"section"	{return Parser.SECTION;}
		"figure"	{return Parser.FIGURE;}
		"table"		{return Parser.TABLE;}
		"row"		{return Parser.ROW;}
		"cell"		{return Parser.CELL;}
		"authornotes"	{return Parser.AUTHORNOTES;}
		"note"		{return Parser.NOTE;}

		{END_TAG}	{yybegin(IN_MARKUP);
				 return Parser.END_TAG;}
		{CLOSE_TAG}	{yybegin(YYINITIAL);
				 return Parser.CLOSE_TAG;}
	
		{ATT_EDITION}	{return Parser.ATT_EDITION;}
		{ATT_ID}	{return Parser.ATT_ID;}
		{ATT_TITLE}	{return Parser.ATT_TITLE;}
		{ATT_CAPTION}	{return Parser.ATT_CAPTION;}
		{ATT_PATH}	{return Parser.ATT_PATH;}

		{STRING}	{yyparser.yylval = new ParserVal(yytext());
				 return Parser.STRING;}	

	}		

<IN_MARKUP>{
		
		{OPEN_CLOSE}	{yybegin(CLOSING_TAG);
				 return Parser.OPEN_CLOSE;}

		{TEXT}		{yyparser.yylval = new ParserVal(yytext());
				 return Parser.TEXT;}
   	} 

<CLOSING_TAG>{
		"book"		{return Parser.BOOK;}
		"dedication"	{return Parser.DEDICATION;}
		"preface"	{return Parser.PREFACE;}
		"part"		{return Parser.PART;}
		"toc"		{return Parser.TOC;}
		"lof"		{return Parser.LOF;}
		"lot"		{return Parser.LOT;}
		"item"		{return Parser.ITEM;}
		"chapter"	{return Parser.CHAPTER;}
		"section"	{return Parser.SECTION;}
		"figure"	{return Parser.FIGURE;}
		"table"		{return Parser.TABLE;}
		"row"		{return Parser.ROW;}
		"cell"		{return Parser.CELL;}
		"authornotes"	{return Parser.AUTHORNOTES;}
		"note"		{return Parser.NOTE;}

		{END_TAG}	{yybegin(YYINITIAL);
				 return Parser.END_TAG;}
	}
