
%%

%byaccj

%{
	private Parser yyparser;
	
	public Yylex(java.io.Reader r, Parser yyparser) {
	this(r);
	this.yyparser = yyparser;
	}

%}

%x OPENING_TAG CLOSING_TAG

NL  = [\s\r\n\t]+

VERSION		= "<?xml version=\'1.0\' encoding=\'UTF-8\'?>"
DOCTYPE		= "<\!DOCTYPE book SYSTEM \"book.dtd\">"
STRING		= (\"[a-zA-Z0-9\-_ .]+\")
TEXT	 	= [a-zA-Z0-9\-_,.;: \r\n\t\a\b]+
START_TAG	= [<]
END_TAG		= "/>"
CLOSE_TAG	= [>]
OPEN_CLOSE	= "</"
ATT_ID		= (" id=")
ATT_TITLE	= (" title=")
ATT_CAPTION	= (" caption=")
ATT_PATH	= (" path=")
ATT_EDITION	= (" edition=")
%%

<YYINITIAL,OPENING_TAG,CLOSING_TAG>{NL}    {} 
{VERSION}	{System.out.println("Debug: version");
			return Parser.VERSION;}
{DOCTYPE}	{return Parser.DOCTYPE;}

{START_TAG}			{					System.out.println("Debug: <");
					yybegin(OPENING_TAG);
				 return Parser.START_TAG;}

{TEXT}				{
										System.out.println("Debug: text");
					yyparser.yylval = new ParserVal(yytext());
				 return Parser.TEXT;}

{OPEN_CLOSE}			{					System.out.println("Debug: </");
					yybegin(CLOSING_TAG);
				 return Parser.OPEN_CLOSE;}


<OPENING_TAG>{
		
		"book"		{
					System.out.println("Debug: book");
					return Parser.BOOK;}
		"dedication"	{System.out.println("Debug: dedication");
						return Parser.DEDICATION;}
		"preface"	{					System.out.println("Debug: preface");
					return Parser.PREFACE;}
		"part"		{					System.out.println("Debug: part");
					return Parser.PART;}
		"toc"		{					System.out.println("Debug: toc");
					return Parser.TOC;}
		"lof"		{System.out.println("Debug: lof");
					return Parser.LOF;}
		"lot"		{System.out.println("Debug: lot");
					return Parser.LOT;}
		"item"		{System.out.println("Debug: item");
					return Parser.ITEM;}
		"chapter"	{System.out.println("Debug: chapter");
					return Parser.CHAPTER;}
		"section"	{System.out.println("Debug: section");
					return Parser.SECTION;}
		"figure"	{System.out.println("Debug: figure");
					return Parser.FIGURE;}
		"table"		{System.out.println("Debug: table");
					return Parser.TABLE;}
		"row"		{System.out.println("Debug: row");
					return Parser.ROW;}
		"cell"		{System.out.println("Debug: cell");
					return Parser.CELL;}
		"authornotes"	{System.out.println("Debug: authornotes");
					return Parser.AUTHORNOTES;}
		"note"		{System.out.println("Debug: note");
					return Parser.NOTE;}

		{END_TAG}	{					System.out.println("Debug: />");
					yybegin(YYINITIAL);
				 return Parser.END_TAG;}
		{CLOSE_TAG}	{					System.out.println("Debug: >");
					yybegin(YYINITIAL);
				 return Parser.CLOSE_TAG;}
	
		{ATT_EDITION}	{return Parser.ATT_EDITION;}
		{ATT_ID}	{return Parser.ATT_ID;}
		{ATT_TITLE}	{return Parser.ATT_TITLE;}
		{ATT_CAPTION}	{return Parser.ATT_CAPTION;}
		{ATT_PATH}	{return Parser.ATT_PATH;}

		{STRING}	{System.out.println("Debug: string");
					yyparser.yylval = new ParserVal(yytext());
				 return Parser.STRING;}	

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

		{CLOSE_TAG}	{yybegin(YYINITIAL);
				 return Parser.CLOSE_TAG;}
	}


/* whitespace */
[ \t]+ { }

/* error fallback */
[^]    { System.out.println("Error: unexpected character '"+yytext()+"'"); return -1; }

