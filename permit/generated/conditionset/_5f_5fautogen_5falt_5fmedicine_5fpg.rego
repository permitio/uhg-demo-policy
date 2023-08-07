package permit.generated.conditionset

import future.keywords.in

import data.permit.generated.abac.utils.attributes

default userset__5f_5fautogen_5falt_5fmedicine_5fpg = false

userset__5f_5fautogen_5falt_5fmedicine_5fpg {
	"alt_medicine_pg" in attributes.user.roles
}
