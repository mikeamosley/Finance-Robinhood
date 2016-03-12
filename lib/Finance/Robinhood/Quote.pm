package Finance::Robinhood::Quote;
use 5.008001;
use Carp;
our $VERSION = "0.01";
use Moo;
use strictures 2;
use namespace::clean;
use DateTime;
#
has $_ => (is => 'ro', required => 1)
    for (qw[adjusted_previous_close
         ask_price ask_size bid_price bid_size last_extended_hours_trade_price
         last_trade_price previous_close trading_halted symbol]
    );
has $_ => (
    is       => 'ro',
    required => 1,
    coerce   => sub {
        $_[0]
            =~ m[(\d{4})-(\d\d)-(\d\d)(?:T(\d\d):(\d\d):(\d\d)(?:\.(\d+))?(.+))?];

        # "2016-03-11T17:59:48.026546Z",
        #warn 'Y:' . $1;
        #warn 'M:' . $2;
        #warn 'D:' . $3;
        #warn 'h:' . $4;
        #warn 'm:' . $5;
        #warn 's:' . $6;
        #warn 'n:' . $7;
        #warn 'z:' . $8;
        DateTime->new(year  => $1,
                      month => $2,
                      day   => $3,
                      (defined $7 ? (hour       => $4) : ()),
                      (defined $7 ? (minute     => $5) : ()),
                      (defined $7 ? (second     => $6) : ()),
                      (defined $7 ? (nanosecond => $7) : ()),
                      (defined $7 ? (time_zone  => $8) : ())
        );
    }
) for (qw[updated_at previous_close_date]);

sub refresh {
    return $_[0] = Finance::Robinhood::quote($_[0]->symbol());
}
1;

=encoding utf-8

=head1 NAME

Finance::Robinhood::Quote - Securities quote data

=head1 SYNOPSIS

    use Finance::Robinhood::Quote;

    # ... $rh creation, login, etc...
    my $quote = $rh->quote('MSFT');
    warn 'Current asking price for  ' .  $quote->symbol() . ' is ' . $quote->ask_price();

=head1 DESCRIPTION

This class contains data related to a security's price and other trade data.
They are gathered with the C<quote(...)> function of Finance::Robinhood.

=head1 METHODS

This class has several getters and a few methods as follows...

=head2 C<adjusted_previous_close( )>

A stock's closing price amended to include any distributions and corporate
actions that occurred at any time prior to the next day's open.

=head2 C<ask_price( )>


=head2 C<ask_size( )>


=head2 C<bid_price( )>


=head2 C<bid_size( )>


=head2 C<last_extended_hours_trade_price( )>


=head2 C<last_trade_price( )>


=head2 C<previous_close( )>

=head2 C<previous_close_date( )>

=head2 C<trading_halted( )>

=head2 C<updated_at( )>

=head2 C<refresh( )>

Reloads the object with current quote data.

=head1 LEGAL

This is a simple wrapper around the API used in the official apps. The author
provides no investment, legal, or tax advice and is not responsible for any
damages incured while using this software. Neither this software nor its
author are affiliated with Robinhood Financial LLC in any way.

For Robinhood's terms and disclosures, please see their website at http://robinhood.com/

=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

Other copyrights, terms, and conditions may apply to data transmitted through
this module. Please refer to the L<LEGAL> section.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=cut