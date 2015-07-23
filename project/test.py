import json, time
from store import Store
import util

def test_submission_fetching(store):
    following = store.profile['following']
    n_submissions = 0
    limit = 25
    # Fetch testing
    print('Fetching...')
    for redditer in following:
        store.refresh_submissions_from_redditor(redditer, limit)
        submissions = store.submissions
        assert(len(submissions) is n_submissions + limit)
        n_submissions += limit
        time.sleep(2.0)
    # Sorted testing
    print('Ordering submissions...')
    created_times = list(map(lambda s: s['created'], store.submissions))
    assert(created_times == sorted(created_times))

def test_refresh(store):
    following  = store.profile['following']
    redditer = following[0]
    limit = 25
    for i in range(2):
        store.refresh_submissions_from_redditor(redditer, limit)
    assert(len(store.submissions) is 2 * limit)

def main():
    store = Store()
    with open('example_user.json', 'r') as fp:
        profile = json.load(fp)

    store.reset()
    store.set_profile(profile)
    test_submission_fetching(store)

    store.reset()
    store.set_profile(profile)
    test_refresh(store)

    return 0

if __name__ == '__main__':
    main()

def submission_is_valid(submission):
    keys = [
        'author',
        'body',
        'created',
        'title',
        'thumbnail'
    ]
    return util.object_contains_keys(submission, keys)
