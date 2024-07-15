#!/bin/bash

function setup_kube_alias {
    local aws_profile=$1

    # Path to the YAML file
    local config_file="$HOME/.kube/config"

    # Find User Name based on AWS Profile
    local user_name=$(yq e ".users[] | select(.user.exec.env[]?.value == \"$aws_profile\") | .name" "$config_file")
    if [ -z "$user_name" ]; then
        return 1
    fi

    # Find Context Name based on User Name
    local context_name=$(yq e ".contexts[] | select(.context?.user == \"$user_name\") | .name" "$config_file")

    if [ -z "$context_name" ]; then
        return 1
    fi

    local contextrole=$(echo $context_name | sed 's/-eks//g')
    local alias_command="alias igo$contextrole='assume $aws_profile && kubectx $context_name'"

    # Check if the alias already exists in .zshrc
    if ! grep -Fxq "$alias_command" $HOME/.zshrc; then
        echo "$alias_command" >> $HOME/.zshrc
        echo "new alias igo$contextrole added to .zshrc"
    else
        echo "alias igo$contextrole already exists in .zshrc"
    fi
}

# Function to update kubeconfig for a specific profile
update_kubeconfig_for_profile() {
    local profile=$1
    local cluster=$2
    local region=$3

    echo "Updating kubeconfig for profile $profile, cluster $cluster"
    role=$(echo $profile | grep -oP '(?<=/)[^-/]*-[^-/]*' | awk -F'-' '{print $2}')
    aws eks update-kubeconfig --name $cluster --region $region --profile $profile --user-alias $cluster-$role
}

KUBECONFIG="$HOME/.kube/config"
AWS_CONFIG_FILE="$HOME/.aws/config"

# Create directories if they do not exist
mkdir -p "$(dirname "$AWS_CONFIG_FILE")"
mkdir -p "$(dirname "$KUBECONFIG")"

# Remove existing files if they exist, then create new empty files
rm -f "$AWS_CONFIG_FILE"
touch "$AWS_CONFIG_FILE"
rm -f "$KUBECONFIG"
touch "$KUBECONFIG"
sed -i '/^alias igo/d' ~/.zshrc

TODO: CHANGE THIS
# Run granted sso populate
granted sso populate --sso-region eu-west-1 #url

TODO: CHANGE THIS
# Define the default region you want to set
DEFAULT_REGION="il-central-1"

# Temporary file for storing modified content
TEMP_FILE=$(mktemp)


# Read the config file line by line
while IFS= read -r line
do
    echo "$line" >> "$TEMP_FILE"
    if [[ $line == \[profile* ]] && ! grep -q "region = " <<< "$line"; then
        echo "region = $DEFAULT_REGION" >> "$TEMP_FILE"
    fi
done < "$AWS_CONFIG_FILE"

# Replace the original file with the modified content
mv "$TEMP_FILE" "$AWS_CONFIG_FILE"


# Get all profiles from AWS config
profiles=$(grep '\[profile' $AWS_CONFIG_FILE | sed 's/\[profile \(.*\)\]/\1/')

for profile in $profiles
do
    echo "Processing profile: $profile"
    assume $profile
    clusters=$(aws eks list-clusters --output text --query "clusters[*]" --profile $profile)

    for cluster in $clusters
    do
        # Get cluster region
        region="il-central-1"
        
        # Update kubeconfig for this cluster
        update_kubeconfig_for_profile $profile $cluster $region
    done
done

echo "Kubeconfig updated for all"

while IFS= read -r line; do
    if [[ $line =~ \[profile\ (.*)\] ]]; then
        profile_name="${BASH_REMATCH[1]}"
        profile_name="${profile_name%"${profile_name##*[![:space:]]}"}"  # Remove trailing spaces
        setup_kube_alias "$profile_name"
    fi
done < "$AWS_CONFIG_FILE"
echo "done, the new aliases are in your .zshrc file"