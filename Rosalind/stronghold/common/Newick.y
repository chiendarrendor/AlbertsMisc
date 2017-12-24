
%token number
%token string

%%

Tree: 
     Branch ';'
     ;

Internal:
     '(' BranchSet ')' Name
     ;


Branch:
     Subtree Length
     ;

Length:
     /* empty */ |
     ':' number
     ;

Subtree:
     Leaf |
     Internal
     ;

Leaf:
     Name
     ;

Name:
     /* empty */ |
     string
     ;

BranchSet:
    Branch |
    BranchSet ',' Branch
    ;


     
