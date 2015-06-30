package Project::Manager::UI::Mojo::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $self = shift;

  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

1;
