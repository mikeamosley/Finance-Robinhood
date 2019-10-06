package Finance::Robinhood::User::AdditionalInfo;

=encoding utf-8

=for stopwords watchlist watchlists untradable urls

=head1 NAME

Finance::Robinhood::User::AdditionalInfo - Access Additional Data About the
Current User

=head1 SYNOPSIS

    use Finance::Robinhood;
    my $rh = Finance::Robinhood->new;
    
    my $user = $rh->user;
    my $info = $user->additional_info;

    CORE::say $user->first_name . ' has ' . $info->stock_loan_consent_status . ' to lending shares';

=cut

our $VERSION = '0.92_003';

sub _test__init {
    my $rh   = t::Utility::rh_instance(1);
    my $user = $rh->user;
    isa_ok($user, 'Finance::Robinhood::User');
    t::Utility::stash('USER', $user);            #  Store it for later
    my $add_info = $user->additional_info();
    isa_ok($add_info, __PACKAGE__);
    t::Utility::stash('USER_ADD_INFO', $add_info);
}
use Mojo::Base-base, -signatures;
use Mojo::URL;
#
use Time::Moment;
#
has _rh => undef => weak => 1;

=head1 METHODS

=head2 C<agreed_to_rhs( )>

Returns true if the user has accepted the Robinhood Securities agreement and
the account has been converted away from Apex.

=head2 C<agreed_to_rhs_margin( )>

Returns true if the user has accepted the Robinhood Securities margin agreement
and the Instant or Gold account has been converted away from Apex.

=head2 C<control_person( )>

Returns true if they user has a designated control person who can take control
of the account.

=head2 C<control_person_security_symbol( )>

Private data required to release the account to the control person.

=head2 C<object_to_disclosure( )>

Returns true if the user objected to the Robinhood user data disclosure
agreement.

=head2 C<security_affiliated_address( )>

Returns the address if the user is a direct employee of a securities related
company.

=head2 C<security_affiliated_employee( )>

Returns true if the user is a direct employee of a securities related company.

=head2 C<security_affiliated_firm_name( )>

Returns the name of the firm the user is employed by.

=head2 C<security_affiliated_firm_relationship( )>

Returns the type of relationship the user has to the securities related firm.

=head2 C<security_affiliated_person_name( )>

Returns the name of the person directly related to a securities related
company.

=head2 C<stock_loan_consent_status( )>

If the user has consented to lending shares they own out, this contains the
string C<consented>.

=head2 C<sweep_consent( )>

Returns true if the user has agreed to allow funds to be moved back and forth
from Robinhood Financial and Robinhood Crypto with sweep.

=cut

has ['agreed_to_rhs',
     'agreed_to_rhs_margin',
     'control_person',
     'control_person_security_symbol',
     'object_to_disclosure',
     'security_affiliated_address',
     'security_affiliated_employee',
     'security_affiliated_firm_name',
     'security_affiliated_firm_relationship',
     'security_affiliated_person_name',
     'stock_loan_consent_status',
     'sweep_consent'
];

=head2 C<updated_at( )>

    $user->updated_at();

Returns a Time::Moment object.

=cut

sub updated_at ($s) {
    Time::Moment->from_string($s->{updated_at});
}

sub _test_updated_at {
    t::Utility::stash('USER_ADD_INFO') // skip_all();
    isa_ok(t::Utility::stash('USER_ADD_INFO')->updated_at(), 'Time::Moment');
}

=head2 C<user( )>

    $order->user();

Reloads the data for this order from the API server.

Use this if you think the status or some other info might have changed.

=cut

sub user($s) {
    my $res = $s->_rh->_get($s->{user});
    $_[0]
        = $res->is_success
        ? Finance::Robinhood::User->new(_rh => $s->_rh, %{$res->json})
        : Finance::Robinhood::Error->new(
             $res->is_server_error ? (details => $res->message) : $res->json);
}

sub _test_user {
    t::Utility::stash('USER_ADD_INFO')
        // skip_all('No additional user data object in stash');
    isa_ok(t::Utility::stash('USER_ADD_INFO')->user(),
           'Finance::Robinhood::User');
}

=head1 LEGAL

This is a simple wrapper around the API used in the official apps. The author
provides no investment, legal, or tax advice and is not responsible for any
damages incurred while using this software. This software is not affiliated
with Robinhood Financial LLC in any way.

For Robinhood's terms and disclosures, please see their website at
https://robinhood.com/legal/

=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the terms found in the Artistic License 2. Other copyrights, terms, and
conditions may apply to data transmitted through this module. Please refer to
the L<LEGAL> section.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=cut

1;
