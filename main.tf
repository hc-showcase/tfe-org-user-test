provider "tfe" {
  hostname="tfe.msk.pub"
  token="abc"
}

#####################
# User1 was invited via UI, logged in, but has not accepted the invitation.
#####################

data "tfe_organization_membership" "user1" {
  organization  = "org1"
  email = "user1@msk.pub"
}

output "user1" {
  value = data.tfe_organization_membership.user1
}

#####################
# User2 was invited via UI, has not logged in, and has not accepted the invitation. User 2 get added to team 1. Team 1 to already existed.
#####################

data "tfe_organization_membership" "user2" {
  organization  = "org1"
  email = "user2@msk.pub"
}

data "tfe_team" "team1-test1" {
  name         = "team1"
  organization = "org1"
}

resource "tfe_team_organization_member" "user2" {
  team_id = data.tfe_team.team1-test1.id
  organization_membership_id = data.tfe_organization_membership.user2.id
}

output "user2" {
  value = tfe_team_organization_member.user2
}

######################
# User3 is being added by terraform, has not logged in and has not accepted the invitation. Team 1 already existed.
######################

resource "tfe_organization_membership" "user3" {
  organization  = "org1"
  email = "user3@msk.pub"
}

data "tfe_team" "team1-test2" {
  name         = "team1"
  organization = "org1"
}

resource "tfe_team_organization_member" "user3" {
  team_id = data.tfe_team.team1-test2.id
  organization_membership_id = tfe_organization_membership.user3.id
}

output "user3" {
  value = tfe_organization_membership.user3
}

########################
# User4 is being added by terraform, has not logged in and has not accepted the invitation. Team 3 gets created as well.
########################

resource "tfe_organization_membership" "user4" {
  organization  = "org1"
  email = "user4@msk.pub"
}

resource "tfe_team" "team3" {
  name         = "team3"
  organization = "org1"
}

resource "tfe_team_organization_member" "user4" {
  team_id = tfe_team.team3.id
  organization_membership_id = tfe_organization_membership.user4.id
}

output "user4" {
  value = tfe_organization_membership.user4
}

