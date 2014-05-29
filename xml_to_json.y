book            = "<book" book_att* ( "/>" | ">" book_cnt "</book>" )
book_att        = "edition" "=" STRING
book_cnt        = dedication? preface part+ authornotes?

dedication      = "<dedication" ( "/>" | ">" dedication_cnt
                  "</dedication>" )
dedication_cnt  = TEXT*

preface         = "<preface" ( "/>" | ">" preface_cnt "</preface>" )
preface_cnt     = TEXT*

part            = "<part" part_att* ( "/>" | ">" part_cnt "</part>" )
part_att        = "id" "=" STRING
                | "title" "=" STRING
part_cnt        = toc chapter+ lof? lot?

toc             = "<toc" ( "/>" | ">" toc_cnt "</toc>" )
toc_cnt         = item+

lof             = "<lof" ( "/>" | ">" lof_cnt "</lof>" )
lof_cnt         = item+

lot             = "<lot" ( "/>" | ">" lot_cnt "</lot>" )
lot_cnt         = item+

item            = "<item" item_att* ( "/>" | ">" item_cnt "</item>" )
item_att        = "id" "=" STRING
item_cnt        = TEXT*

chapter         = "<chapter" chapter_att* ( "/>" | ">" chapter_cnt
                  "</chapter>" )
chapter_att     = "id" "=" STRING
                | "title" "=" STRING
chapter_cnt     = section+

section         = "<section" section_att* ( "/>" | ">" section_cnt
                  "</section>" )
section_att     = "id" "=" STRING
                | "title" "=" STRING
section_cnt     = ( TEXT* | section | figure | table )*

figure          = "<figure" figure_att* ( "/>" | ">" figure_cnt
                  "</figure>" )
figure_att      = "id" "=" STRING
                | "caption" "=" STRING
                | "path" "=" STRING
figure_cnt      = ;empty

table           = "<table" table_att* ( "/>" | ">" table_cnt "</table>"
                  )
table_att       = "id" "=" STRING
                | "caption" "=" STRING
table_cnt       = row+

row             = "<row" ( "/>" | ">" row_cnt "</row>" )
row_cnt         = cell+

cell            = "<cell" ( "/>" | ">" cell_cnt "</cell>" )
cell_cnt        = TEXT*

authornotes     = "<authornotes" ( "/>" | ">" authornotes_cnt
                  "</authornotes>" )
authornotes_cnt = note+

note            = "<note" ( "/>" | ">" note_cnt "</note>" )
note_cnt        = TEXT*

STRING          = "'" TEXT* "'" | '"' TEXT* '"'
TEXT            = (any legal XML character)
