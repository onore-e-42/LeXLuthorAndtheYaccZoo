
%%

%byaccj

%{
	private Parser yyparser;
	
	public Yylex(java.io.Reader r, Parser yyparser) {
	this(r);
	this.yyparser = yyparser;
	}

	public String open(String keyword) {
		keyword = keyword.toUpperCase;
		return keyword.append(_OPEN);
	}

	public String close(String keyword) {
		keyword = keyword.toUpperCase;
		return keyword.append(_CLOSE);
	}
%}

%x IN_TAG

NL = \r\n|\r|\n

STRING		= ("'"[a-zA-Z0-9\-_]*"'" | '"'[a-zA-Z0-9\-_]*'"')
TEXT		= [a-zA-Z0-9\-_]*

START_TAG	= "<"
END_TAG		= ">"
CLOSE_TAG	= "/>"
OPEN_CLOSE	= "</"
KEYWORD		= ("book" | "dedication" | "preface" | "part" | "toc" | "lof" | "lot" | "item" | "chapter" | "section" | "figure" | "table" | "row" | "cell" | "authornotes" | "note")

%%

<IN_TAG, YYINITIAL>{NL}		{return Parser.NL;}

{START_TAG}{KEYWORD}		{yybegin(IN_TAG)
				 return open(Parser.KEYWORD);}

{OPEN_CLOSE}{KEYWORD}{END_TAG}	{return close(Parser.KEYWORD);}

{TEXT}				{return TEXT;}


<IN_TAG>{
		END_TAG		{yybegin(YYINITIAL)
				 return Parser.END_TAG;}
		CLOSE_TAG	{yybegin(YYINITIAL)
				 return Parser.CLOSE_TAG;}
	
		"edition ="	{return ATT_EDITION;}
		"id ="		{return ATT_ID;}
		"title ="	{return ATT_TITLE;}
		"caption ="	{return ATT_CAPTION;}
		"path ="	{return ATT_PATH;}

		{STRING}	{return STRING;}	
	}		
		
