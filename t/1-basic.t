use FindBin;
use lib $FindBin::Bin;
use Test::More 'no_plan';
use lib::overlay 'Bar';
use Foo;

is(Foo->foo, 2);
