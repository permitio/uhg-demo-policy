package permit.custom

import future.keywords.if
import data.permit.policies
import data.permit.utils.abac
import data.permit.rebac

default allow := false

# Ignore the date check if there is no ReBac
allow {
	not rebac in policies.__allow_sources
} else {
	count(filter_resource) == 0
} else {
	some filtered_resource in filter_resource
	enforce_boundries(filtered_resource)
}

parse_time(time_str) := parsed_time {
	parsed_time := time.date(time.parse_rfc3339_ns(time_str))
}

filter_resource[derived_resource] {
	some allowing_role in rebac.rebac_roles_debugger.allowing_roles
	some source in allowing_role.sources
	derived_resource := exctract_resouce(source, allowing_role.role, allowing_role.resource)
}

exctract_resouce(source, role, resource) := returned_resource {
	source.type == "role_assignment"
	endswith(source.role, "#caregiver")
	returned_resource := resource
} else {
	source.type == "role_derivation"
	endswith(source.role, "#owner")
	returned_resource := source.resource
}

enforce_boundries(resource) {
	parse_time(abac.attributes.user.caregiver_bounds[resource].start_date) >= parse_time(time.now_ns())
	parse_time(abac.attributes.user.caregiver_bounds[resource].end_date) <= parse_time(time.now_ns())
}
