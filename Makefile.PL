# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name 'Moose-Tiny';
all_from 'lib/Moose/Tiny.pm';

# Specific dependencies
requires 'Moose'                    => '0';

build_requires 'Test::More' => '0.42';

no_index 'directory' => 'ex';

auto_install;
WriteAll;
