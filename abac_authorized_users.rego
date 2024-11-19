package permit.abac_authorized_users

import data.permit.abac
import data.permit.generated.abac.utils
import data.permit.generated.conditionset
import future.keywords.if
import future.keywords.in

get_condition_set_key(key_input) := result {
    some key, value in data.condition_sets
    value.key == key_input
    result := key
}

get_condition_set_value(key_input) := result {
    result := data.condition_sets[key_input].key
}

get_resource_set_keys(resource_set_value) = {result |
    some re_key, _ in resource_set_value
    result := get_condition_set_key(re_key)
}



get_condition_set_keys[user_set_key] := value {
        some key , resource_set_value in data.condition_set_rules
			some resource_set_key, resource_set_data in resource_set_value
			actions := data.condition_set_rules[key][resource_set_key][input.resource.type]
            input.action in actions
            user_set_key := get_condition_set_key(key)
            value := get_resource_set_keys(resource_set_value)
}

matching_users_and_resources_set := {
    {"user": op_us, "resource": op_rs} |
    some key, value in get_condition_set_keys
        conditionset[key] == true
        op_us := get_condition_set_value(key)
        some r_key, r_value in value
                conditionset[r_key] == true
                op_rs := get_condition_set_value(r_key)
}




abac_authorized_users[user] := roles if {
    some user, user_data in data.users

    customize_input := {
        "action": input.action,
        "user" :  {"key": user},
        "resource" : input.resource,
    }

        user_resource_pairs := matching_users_and_resources_set with input as customize_input
        roles := { { "user": user, "role":user_resource_pair.user, "resource" : user_resource_pair.resource , "tenant" : input.resource.tenant} |
            some user_resource_pair in user_resource_pairs }
        count(roles) > 0
}
