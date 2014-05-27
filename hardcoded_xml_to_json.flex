
%%

%byaccj

%{
	private Parser yyparser;
	
	public Yylex(java.io.Reader r, Parser yyparser) {
	this(r);
	this.yyparser = yyparser;
	}

%}

%x IN_TAG

NL = \r\n|\r|\n

STRING		= "'" TEXT* "'" | '"' TEXT* '"'
TEXT		= (any legal XML character)

START_TAG	= "<"
END_TAG		= ">"
CLOSE_TAG	= "/>"

%%

<IN_TAG, YYINITIAL>{NL}		{return Parser.NL;}

"<book"				{yybegin(IN_TAG)
				 return BOOK_OPEN;}

"<dedication"			{yybegin(IN_TAG)
				 return DEDICATION_OPEN;}

"<preface"			{yybegin(IN_TAG)
				 return PREFACE_OPEN;}

"<part"				{yybegin(IN_TAG)
				 return PART_OPEN;}

"<toc"				{yybegin(IN_TAG)
				 return TOC_OPEN;}

"<lof"				{yybegin(IN_TAG)
				 return LOF_OPEN;}

"<lot"				{yybegin(IN_TAG)
				 return LOT_OPEN;}

"<item"				{yybegin(IN_TAG)
				 return ITEM_OPEN;}

"<chapter"			{yybegin(IN_TAG)
				 return CHAPTER_OPEN;}

"<section"			{yybegin(IN_TAG)
				 return SECTION_OPEN;}

"<figure"			{yybegin(IN_TAG)
				 return FIGURE_OPEN;}

"<table"			{yybegin(IN_TAG)
				 return TABLE_OPEN;}

"<row"				{yybegin(IN_TAG)
				 return ROW_OPEN;}

"<cell"				{yybegin(IN_TAG)
				 return CELL_OPEN;}

"<authornotes"			{yybegin(IN_TAG)
				 return AUTHORNOTES_OPEN;}

"<note" 			{yybegin(IN_TAG)
				 return NOTE_OPEN;}

"</book>"			{yybegin(YYINITIAL)
				 return BOOK_CLOSE;}

"</dedication>"			{yybegin(IYYINITIAL)
				 return DEDICATION_CLOSE;}

"</preface>"			{yybegin(YYINITIAL)
				 return PREFACE_CLOSE;}

"</part>"			{yybegin(YYINITIAL)
				 return PART_CLOSE;}

"</toc>"			{yybegin(YYINITIAL)
				 return TOC_CLOSE;}

"</lof>"			{yybegin(YYINITIAL)
				 return LOF_CLOSE;}

"</lot>"			{yybegin(YYINITIAL)
				 return LOT_CLOSE;}

"</item>"			{yybegin(YYINITIAL)
				 return ITEM_CLOSE;}

"</chapter>"			{yybegin(YYINITIAL)
				 return CHAPTER_CLOSE;}

"</section>"			{yybegin(YYINITIAL)
				 return SECTION_CLOSE;}

"</figure>"			{yybegin(YYINITIAL)
				 return FIGURE_CLOSE;}

"</table>"			{yybegin(YYINITIAL)
				 return TABLE_CLOSE;}

"</row>"			{yybegin(YYINITIAL)
				 return ROW_CLOSE;}

"</cell>"			{yybegin(YYINITIAL)
				 return CELL_CLOSE;}

"</authornotes>"		{yybegin(YYINITIAL)
				 return AUTHORNOTES_CLOSE;}

"</note>" 			{yybegin(YYINITIAL)
				 return NOTE_CLOSE;}

/* whitespace */
[ \t]+ { }

\b     { System.err.println("Sorry, backspace doesn't work"); }

/* error fallback */
[^]    { System.err.println("Error: unexpected character '"+yytext()+"'"); return -1; }

