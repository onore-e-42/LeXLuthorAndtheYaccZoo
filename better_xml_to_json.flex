
%%

%byaccj

%{
	private Parser yyparser;
	
	public Yylex(java.io.Reader r, Parser yyparser) {
	this(r);
	this.yyparser = yyparser;
	}

%}

%x IN_TAG IN_MARKUP

NL 		= \r\n|\r|\n

STRING		= ("'"[a-zA-Z0-9\-_]*"'" | '"'[a-zA-Z0-9\-_]*'"')
TEXT		= ([a-zA-Z0-9\-_]*)

START_TAG	= ("<")
END_TAG		= (">")
CLOSE_TAG	= ("/>")
OPEN_CLOSE	= ("</")
KEYWORD		= ("book" | "dedication" | "preface" | "part" | "toc" | "lof" | "lot" | "item" | "chapter" | "section" | "figure" | "table" | "row" | "cell" | "authornotes" | "note")

ATT_EDITION	= ("edition =")
ATT_ID		= ("id =")
ATT_TITLE	= ("title =")
ATT_CAPTION	= ("caption =")
ATT_PATH	= ("path = ")

%%

<IN_TAG, IN_MARKUP, YYINITIAL>{
		{NL}		{return Parser.NL;}
			}

{START_TAG}{KEYWORD}		{yyparser.yylval = new ParserVal(yytext());
				 yybegin(IN_TAG);
				 return Parser.KEYWORD;}




<IN_TAG>{
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
		
		{OPEN_CLOSE}{KEYWORD}{END_TAG}	{yyparser.yylval = new ParserVal(yytext());
						 yybegin(YYINITIAL);
						 return Parser.KEYWORD;}

		{TEXT}				{yyparser.yylval = new ParserVal(yytext());
						 return Parser.TEXT;}
   } 
