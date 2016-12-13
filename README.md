# sprout-iad

Recipes to install and configure things just the way the IAD team likes it.

## Making Changes

### Testing locally

You can update the Cheffile to point to the local sprout-iad repo for testing changes.

    # sprout-wrap/Cheffile
    
    cookbook 'sprout-iad',
      :path => '../sprout-iad'
      
You can run a single recipe to test it out by using this command:

    $ rbenv exec bundle exec soloist run_recipe sprout-iad::<recipe>
    
in the sprout-wrap directory

### Publishing Changes

When you add to the recipes, you'll need to update the version in the metadata.rb file
so that sprout-wrap knows to bring in your new changes.

To update the version of sprout-iad used by sprout-wrap, run the following from the sprout-wrap directory:

    $ librarian-chef update sprout-iad --verbose

#### Compatibility with Sprout

Since you will be in the sprout-wrap directory when running the command above, and that directory uses `system` ruby, you will not be able to install nor run librarian-chef unless you change your ruby version. Here is a relatively easy way to work around this with rbenv:

    $ RBENV_VERSION=2.3.1 gem install librarian-chef
    $ RBENV_VERSION=2.3.1 librarian-chef update sprout-iad --verbose
