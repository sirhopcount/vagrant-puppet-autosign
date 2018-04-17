## Set challenge password in csr_attributes.yaml file

cat <<EOF >> /etc/puppetlabs/puppet/csr_attributes.yaml
---
custom_attributes:
  challengePassword: "$1"
EOF
