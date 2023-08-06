package permit.generated.conditionset

import future.keywords.in

import data.permit.generated.abac.utils.attributes

default userset__5f_5fautogen_5fbenefits_5fpg_5frole = false

userset__5f_5fautogen_5fbenefits_5fpg_5frole {
	"benefits_pg_role" in attributes.user.roles
}
