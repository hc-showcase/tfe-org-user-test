provider "tfe" {
  hostname="tfe.msk.pub"
  token="abc"
}

#####################

data "tfe_organization_membership" "user1" {
  organization  = "org1"
  email = "user1@msk.pub"
}

data "tfe_organization_membership" "user2" {
  organization  = "org1"
  email = "user2@msk.pub"
}

# User1 was invited via UI, logged in, but has not accepted the invitation.
output "user1" {
  value = data.tfe_organization_membership.user1
}

# User2 was invited via UI, has not logged in, and has not accepted the invitation.
output "user2" {
  value = data.tfe_organization_membership.user2
}

######################

# User3 is being added by terraform, has not logged in and has not accepted the invitation
resource "tfe_organization_membership" "user3" {
  organization  = "org1"
  email = "user3@msk.pub"
}

data "tfe_organization_membership" "user3" {
  organization  = "org1"
  email = "user3@msk.pub"
  depends_on = [tfe_organization_membership.user3]
}

data "tfe_team" "team1" {
  name         = "team1"
  organization = "org1"
}

resource "tfe_team_organization_member" "user3" {
  team_id = data.tfe_team.team1.id
  organization_membership_id = tfe_organization_membership.user3.id
}

output "user3" {
  value = tfe_organization_membership.user3
}

########################

# User4 has never been added. The execution fails.
#data "tfe_organization_membership" "user4" {
#  organization  = "org1"
#  email = "user4@msk.pub"
#}

#output "user4" {
#  value = tfe_organization_membership.user4
#}

