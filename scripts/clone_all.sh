#!/bin/bash
set -u
set -e

APPDIR=$1

cd $APPDIR

#### Marine Planner Modules

# visualize
git clone https://github.com/Ecotrust/mp-visualize.git

# drawing
git clone https://github.com/Ecotrust/mp-drawing.git

# data-manager
git clone https://github.com/Ecotrust/mp-data-manager.git

# accounts
git clone https://github.com/Ecotrust/mp-accounts.git

# proxy
git clone https://github.com/Ecotrust/mp-proxy.git

# explore
git clone https://github.com/Ecotrust/mp-explore.git

# clipping
git clone https://github.com/Ecotrust/mp-clipping.git

#### Madrona Modules

# features
git clone https://github.com/Ecotrust/madrona-features.git

# manipulators
git clone https://github.com/Ecotrust/madrona-manipulators.git

# scenarios
git clone https://github.com/Ecotrust/madrona-scenarios.git

# forms
git clone https://github.com/Ecotrust/madrona-forms.git

# analysis tools
git clone https://github.com/Ecotrust/madrona-analysistools.git

#### Miscellaneous Helpers

# django-recaptcha-develop  (add recaptcha to login)
git clone https://github.com/Ecotrust/django-recaptcha-develop.git

# tessellator (printable map server)
git clone https://github.com/Ecotrust/tessellator.git

# django-libsass (A django-compressor filter to compile Sass files using libsass.)
git clone https://github.com/Ecotrust/django-libsass.git

# p97settings
git clone https://github.com/Ecotrust/p97settings.git

# p97-nursery
git clone https://github.com/Ecotrust/p97-nursery.git

#### MARCO Carry over (TODO: remove these when able)

# marco-map-groups
git clone https://github.com/Ecotrust/marco-map_groups.git
