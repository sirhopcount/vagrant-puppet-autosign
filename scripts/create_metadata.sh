## Create custom fact file (metadata.yaml)

# Check if facts.d is present
if [ -d  /opt/puppetlabs/facter/facts.d ]; then
  cat <<EOF > /opt/puppetlabs/facter/facts.d/metadata.yaml
---
role: $1
EOF
else
  echo "facts.d directory does not exist, skipping"
fi
