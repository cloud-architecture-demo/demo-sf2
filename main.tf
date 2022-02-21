
/*
resource "random_id" "id" {
  byte_length   = 4
  prefix        = "${var.project_name}-"
}
*/

resource "google_project" "project" {
  name              = var.project_name
  //project_id        = random_id.id.hex
  project_id        = var.project_name
  billing_account   = var.billing_account
}