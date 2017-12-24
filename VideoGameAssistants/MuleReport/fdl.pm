####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package fdl;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;



sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			'NAME' => 1,
			'IF' => 6,
			'SKIPBYTES' => 3,
			'BITS' => 2
		},
		GOTOS => {
			'directivelist' => 5,
			'file' => 4,
			'directive' => 8,
			'metadirective' => 7
		}
	},
	{#State 1
		ACTIONS => {
			":" => 9
		}
	},
	{#State 2
		ACTIONS => {
			"{" => 10
		}
	},
	{#State 3
		ACTIONS => {
			"(" => 11
		}
	},
	{#State 4
		ACTIONS => {
			'' => 12
		}
	},
	{#State 5
		ACTIONS => {
			'NAME' => 1,
			'IF' => 6,
			'SKIPBYTES' => 3,
			'BITS' => 2
		},
		DEFAULT => -1,
		GOTOS => {
			'metadirective' => 13,
			'directive' => 8
		}
	},
	{#State 6
		ACTIONS => {
			'PERLEXP' => 14
		}
	},
	{#State 7
		ACTIONS => {
			";" => 15
		}
	},
	{#State 8
		DEFAULT => -5
	},
	{#State 9
		ACTIONS => {
			'BYTE' => 16,
			'SHORT' => 18,
			'SUB' => 17,
			'INT' => 19,
			'BYTES' => 22,
			'DEFINE' => 20,
			'STRING' => 21
		}
	},
	{#State 10
		ACTIONS => {
			'NAME' => 23
		},
		GOTOS => {
			'bit' => 24,
			'bitlist' => 25
		}
	},
	{#State 11
		ACTIONS => {
			'NUM' => 26
		}
	},
	{#State 12
		DEFAULT => 0
	},
	{#State 13
		ACTIONS => {
			";" => 27
		}
	},
	{#State 14
		ACTIONS => {
			'NAME' => 1,
			'SKIPBYTES' => 3,
			'BITS' => 2
		},
		GOTOS => {
			'directive' => 28
		}
	},
	{#State 15
		DEFAULT => -2
	},
	{#State 16
		ACTIONS => {
			"(" => 29
		},
		DEFAULT => -13
	},
	{#State 17
		ACTIONS => {
			'NAME' => 30,
			"{" => 31
		},
		GOTOS => {
			'block' => 32
		}
	},
	{#State 18
		ACTIONS => {
			"(" => 33
		},
		DEFAULT => -16
	},
	{#State 19
		ACTIONS => {
			"(" => 34
		},
		DEFAULT => -11
	},
	{#State 20
		ACTIONS => {
			"{" => 31
		},
		GOTOS => {
			'block' => 35
		}
	},
	{#State 21
		ACTIONS => {
			"(" => 36
		}
	},
	{#State 22
		ACTIONS => {
			"(" => 37
		}
	},
	{#State 23
		ACTIONS => {
			":" => 38
		}
	},
	{#State 24
		DEFAULT => -6
	},
	{#State 25
		ACTIONS => {
			"}" => 39,
			'NAME' => 23
		},
		GOTOS => {
			'bit' => 40
		}
	},
	{#State 26
		ACTIONS => {
			")" => 41
		}
	},
	{#State 27
		DEFAULT => -3
	},
	{#State 28
		DEFAULT => -4
	},
	{#State 29
		ACTIONS => {
			'NAME' => 42
		}
	},
	{#State 30
		ACTIONS => {
			"(" => 43
		},
		DEFAULT => -24
	},
	{#State 31
		ACTIONS => {
			'NAME' => 1,
			'IF' => 6,
			'SKIPBYTES' => 3,
			'BITS' => 2
		},
		GOTOS => {
			'directivelist' => 44,
			'metadirective' => 7,
			'directive' => 8
		}
	},
	{#State 32
		ACTIONS => {
			"(" => 45
		},
		DEFAULT => -22
	},
	{#State 33
		ACTIONS => {
			'NAME' => 46
		}
	},
	{#State 34
		ACTIONS => {
			'NAME' => 47
		}
	},
	{#State 35
		DEFAULT => -20
	},
	{#State 36
		ACTIONS => {
			'NUM' => 48
		}
	},
	{#State 37
		ACTIONS => {
			'NUM' => 49
		}
	},
	{#State 38
		ACTIONS => {
			'BITNUM' => 50
		}
	},
	{#State 39
		DEFAULT => -21
	},
	{#State 40
		DEFAULT => -7
	},
	{#State 41
		DEFAULT => -19
	},
	{#State 42
		ACTIONS => {
			")" => 51
		}
	},
	{#State 43
		ACTIONS => {
			'NAME' => 52
		}
	},
	{#State 44
		ACTIONS => {
			"}" => 53,
			'NAME' => 1,
			'IF' => 6,
			'SKIPBYTES' => 3,
			'BITS' => 2
		},
		GOTOS => {
			'metadirective' => 13,
			'directive' => 8
		}
	},
	{#State 45
		ACTIONS => {
			'NAME' => 54
		}
	},
	{#State 46
		ACTIONS => {
			")" => 55
		}
	},
	{#State 47
		ACTIONS => {
			")" => 56
		}
	},
	{#State 48
		ACTIONS => {
			")" => 57
		}
	},
	{#State 49
		ACTIONS => {
			")" => 58
		}
	},
	{#State 50
		ACTIONS => {
			"(" => 60,
			";" => 59
		}
	},
	{#State 51
		DEFAULT => -14
	},
	{#State 52
		ACTIONS => {
			")" => 61
		}
	},
	{#State 53
		DEFAULT => -10
	},
	{#State 54
		ACTIONS => {
			")" => 62
		}
	},
	{#State 55
		DEFAULT => -17
	},
	{#State 56
		DEFAULT => -12
	},
	{#State 57
		DEFAULT => -18
	},
	{#State 58
		DEFAULT => -15
	},
	{#State 59
		DEFAULT => -8
	},
	{#State 60
		ACTIONS => {
			'NAME' => 63
		}
	},
	{#State 61
		DEFAULT => -25
	},
	{#State 62
		DEFAULT => -23
	},
	{#State 63
		ACTIONS => {
			")" => 64
		}
	},
	{#State 64
		ACTIONS => {
			";" => 65
		}
	},
	{#State 65
		DEFAULT => -9
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'file', 1,
sub
#line 4 "fdl.bnf"
{ $_[1] }
	],
	[#Rule 2
		 'directivelist', 2,
sub
#line 8 "fdl.bnf"
{ return [ $_[1] ]; }
	],
	[#Rule 3
		 'directivelist', 3,
sub
#line 9 "fdl.bnf"
{ [ @{$_[1]} , $_[2] ] }
	],
	[#Rule 4
		 'metadirective', 3,
sub
#line 13 "fdl.bnf"
{ $_[1]->{BOOLEAN} = $_[2]; $_[1]; }
	],
	[#Rule 5
		 'metadirective', 1,
sub
#line 14 "fdl.bnf"
{ $_[1] }
	],
	[#Rule 6
		 'bitlist', 1,
sub
#line 18 "fdl.bnf"
{ [ $_[1] ] }
	],
	[#Rule 7
		 'bitlist', 2,
sub
#line 19 "fdl.bnf"
{ [ @{$_[1]},$_[2] ] }
	],
	[#Rule 8
		 'bit', 4,
sub
#line 23 "fdl.bnf"
{ { NAME=>$_[1],NUM=>$_[3] } }
	],
	[#Rule 9
		 'bit', 7,
sub
#line 24 "fdl.bnf"
{ { NAME=>$_[1],NUM=>$_[3],DECODE=>$_[5] } }
	],
	[#Rule 10
		 'block', 3,
sub
#line 28 "fdl.bnf"
{ $_[2] }
	],
	[#Rule 11
		 'directive', 3,
sub
#line 32 "fdl.bnf"
{ { TYPE=>'Int',NAME=>$_[1] } }
	],
	[#Rule 12
		 'directive', 6,
sub
#line 33 "fdl.bnf"
{ { TYPE=>'Int',NAME=>$_[1],DECODE=>$_[5] } }
	],
	[#Rule 13
		 'directive', 3,
sub
#line 34 "fdl.bnf"
{ { TYPE=>'Byte',NAME=>$_[1] } }
	],
	[#Rule 14
		 'directive', 6,
sub
#line 35 "fdl.bnf"
{ { TYPE=>'Byte',NAME=>$_[1],DECODE=>$_[5] } }
	],
	[#Rule 15
		 'directive', 6,
sub
#line 36 "fdl.bnf"
{ { TYPE=>'Bytes',NAME=>$_[1],LENGTH=>$_[5] } }
	],
	[#Rule 16
		 'directive', 3,
sub
#line 37 "fdl.bnf"
{ { TYPE=>'Short',NAME=>$_[1] } }
	],
	[#Rule 17
		 'directive', 6,
sub
#line 38 "fdl.bnf"
{ { TYPE=>'Short',NAME=>$_[1],DECODE=>$_[5] } }
	],
	[#Rule 18
		 'directive', 6,
sub
#line 39 "fdl.bnf"
{ { TYPE=>'String',LENGTH=>$_[5],NAME=>$_[1] } }
	],
	[#Rule 19
		 'directive', 4,
sub
#line 40 "fdl.bnf"
{ { TYPE=>'SkipBytes',LENGTH=>$_[3] } }
	],
	[#Rule 20
		 'directive', 4,
sub
#line 41 "fdl.bnf"
{ { TYPE=>'Define',BODY=>$_[4],NAME=>$_[1] } }
	],
	[#Rule 21
		 'directive', 4,
sub
#line 42 "fdl.bnf"
{ { TYPE=>'Bits',BITS=>$_[3] } }
	],
	[#Rule 22
		 'directive', 4,
sub
#line 43 "fdl.bnf"
{ { NAME=>$_[1],TYPE=>'Sub',BODY=>$_[4] } }
	],
	[#Rule 23
		 'directive', 7,
sub
#line 44 "fdl.bnf"
{ { NAME=>$_[1],TYPE=>'Sub',BODY=>$_[4],DECODE=>$_[6] } }
	],
	[#Rule 24
		 'directive', 4,
sub
#line 45 "fdl.bnf"
{ { NAME=>$_[1],TYPE=>'Sub',BODYNAME=>$_[4] } }
	],
	[#Rule 25
		 'directive', 7,
sub
#line 46 "fdl.bnf"
{ { NAME=>$_[1],TYPE=>'Sub',BODYNAME=>$_[4],DECODE=>$_[6] } }
	]
],
                                  @_);
    bless($self,$class);
}

#line 49 "fdl.bnf"


1;
