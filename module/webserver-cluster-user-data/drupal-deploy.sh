# Install Composer dependencies
composer install \
    --no-interaction \
    --no-progress \
    --no-scripts \
    --optimize-autoloader \
    --prefer-dist

# Install npm dependencies
# Assuming Drupal web app directory is in your home directory "home/ubuntu"
# Path to file location "package.json" in docroot/themes/custom/your-app/resources/
cd ~/your-app-drupal/docroot/themes/custom/your-app/resources/
npm ci \
    --ignore-scripts \
    --no-audit
cd ~/your-app-drupal/

# Build assets
npm run build:prod

# Rebuild cache
vendor/bin/drush \
    --no-interaction \
    --yes \
    cache:rebuild

# Apply any database updates required
vendor/bin/drush \
    --no-interaction \
    --yes \
    updatedb

# Import config
vendor/bin/drush \
    --no-interaction \
    --yes \
    config:import
