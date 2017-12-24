package DNA;

sub ReverseComplement
{
    my ($is) = @_;
    $is =~ tr/ACTG/TGAC/;
    return reverse $is;
}

sub Transcribe
{
    my ($is) = @_;
    $is =~ tr/T/U/;
    return $is;
}

1;
