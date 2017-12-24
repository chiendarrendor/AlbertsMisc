%token  NUM
%left   '+' '-'
%%

exprs:    expr
        {
          return "$_[0]";
        } /* py */
        | expr exprs
        {
          return "@_";;
        } /* py */
expr:     NUM
        {
          return $_[0];
        } /* py */
        | expr '+' expr
        {
          return ($_[0] + $_[2]);
        } /* py */
        | expr '-' expr
        {
          return ($_[0] - $_[2]);
        } /* py */
        | '(' expr ')'
        {
          return ($_[1]);
        } /* py */
        ;

%%
