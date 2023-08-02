package permit.custom

import future.keywords.in
import data.permit.policies
import data.permit.utils.abac
import data.permit.rebac
import data.permit.debug

default allow := false

# Ignore the date check if there is no ReBac
allow {
	not "rebac" in policies.__allow_sources
	print("No ReBac")
} else {
	count(filter_resource) == 0
	print("No filtered resource")
} else {
	print("Filtered resource")
	some filtered_resource in filter_resource
	debug.custom.filtered = filtered_resource
	enforce_boundries(filtered_resource)
}

filter_resource[derived_resource] {
	print("Derived resource")
	some allowing_role in rebac.rebac_roles_debugger
	print("Allowing role: ", allowing_role.role)
	some source in allowing_role.sources
	derived_resource := exctract_resouce(allowing_role, source)
	print("Derived resource: ", derived_resource)
}

exctract_resouce(allowing_role, source) := returned_resource {
	source.type == "role_assignment"
	print("Role assignment - role: ", allowing_role.role)
	endswith(allowing_role.role, "#caregiver")
	not startswith(allowing_role.role, "profile")
	print("Role assignment - Caregiver role after endswith")
	returned_resource := allowing_role.resource
	print("Role assignment - returned resource: ", returned_resource)
} else {
	source.type == "role_derivation"
	print("Role derivation - role: ", source.role)
	endswith(source.role, "#caregiver")
	not startswith(allowing_role.role, "profile")
	print("Role derivation - Caregiver role after endswith")
	returned_resource := source.resource
	print("Role derivation - returned resource: ", returned_resource)
}

enforce_boundries(resource) {
	time.parse_rfc3339_ns(abac.attributes.user.caregiver_bounds[resource].start_date) >= time.now_ns()
	time.parse_rfc3339_ns(abac.attributes.user.caregiver_bounds[resource].end_date) <= time.now_ns()
}
