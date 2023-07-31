package permit.generated.conditionset

import future.keywords.in

import data.permit.generated.abac.utils.attributes

default userset__5f_5fautogen_5fmanager = false

userset__5f_5fautogen_5fmanager {
	"manager" in attributes.user.roles
}
