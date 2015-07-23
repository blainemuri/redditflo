from functools import reduce

def object_contains_keys(obj, keys):
    has_key = map(lambda k: k in obj, keys)
    return all(has_key)
