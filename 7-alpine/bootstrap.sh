#!/bin/sh

set -e

VERSION=1.0.3
BASE_DIR=/opt/env

toEnvString () {
  # Quotify (VAR=value -> VAR="value")
  ENV_VARS=$(echo "$1" | perl -pe 's|([^=]*)="?([^"]*?)"?$|\1="\2"|g')
  # Transform to args
  ENV_VARS=$(echo "$ENV_VARS" | tr '\n' '\0' | perl -pe 's|\\n|\n|g' | xargs -0)
  echo "$ENV_VARS"
}

ENV=${ENV:-local}

# Check for mandatory env files
# REQUIRED_ENVS="production staging"
# for REQUIRED_ENV in $REQUIRED_ENVS
# do
#   if test ! -f $BASE_DIR/env.$REQUIRED_ENV.secure
#   then
#     (>&2 echo "Fatal: Missing required env file: env.$REQUIRED_ENV.secure")
#     exit 1
#   fi
# done

WHITELIST="PATH|APP_.*|OPCACHE_.*|SESSION_SAVE_.*"
ENV_VARS_WHITELISTED=$(env | grep -E "^($WHITELIST)")
ENV_VARS_WHITELISTED=$(toEnvString "$ENV_VARS_WHITELISTED")

ENV_VARS_OVERRIDE=$(env | grep -E "^OVERRIDE_" | cut -d_ -f2-)
ENV_VARS_OVERRIDE=$(toEnvString "$ENV_VARS_OVERRIDE")

# Check for env file
if test ! -f $BASE_DIR/env.$ENV.secure
then
  (>&2 echo "Warning: Missing env file: env.$ENV.secure")
  # exit 1
  ENV_CMD="exec env -i $ENV_VARS_WHITELISTED $ENV_VARS_OVERRIDE /entrypoint.sh $@"
  eval "$ENV_CMD"
fi

# Decrypt and read env file
ENV_VARS=$(set -e; openssl des3 -base64 -d -in $BASE_DIR/env.$ENV.secure -pass pass:$SECRET_KEY -md md5)

# unset SECRET_KEY
unset SECRET_KEY

# Exclude blank lines
ENV_VARS=$(echo "$ENV_VARS" | grep -v '^\s*$')
# Exclude comment lines
ENV_VARS=$(echo "$ENV_VARS" | grep -v '^#')

# Check for reserved env var
# if test ! -z $(echo "$ENV_VARS" | grep -E "^($WHITELIST)")
# then
#   (>&2 echo "Fatal: Environment variables with reserved name detected !")
#   exit 1
# fi

# Argify
ENV_VARS=$(toEnvString "$ENV_VARS")

# Create command line
ENV_CMD="exec env -i $ENV_VARS_WHITELISTED $ENV_VARS $ENV_VARS_OVERRIDE /entrypoint.sh $@"

echo "Bootstrap script version $VERSION"

if test ! -z "$ENV_VARS_OVERRIDE"
then
  echo ""
  echo "Warning: the following environment variables are overriden !"
  echo "============================================================"
  for ENV_VAR_OVERRIDE in $ENV_VARS_OVERRIDE
  do
    echo ${ENV_VAR_OVERRIDE%%=*}
  done
  echo "============================================================"
  echo ""
fi

# Eval generated command line
eval "$ENV_CMD"
