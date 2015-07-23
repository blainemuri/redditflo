import json, time
from fetcher import Fetcher

def submission_is_valid(submission):
    actual_keys = submission.keys()
    target_keys = [
        'author',
        'body',
        'created',
        'title',
        'thumbnail'
    ]
    missing_keys = list(filter(lambda k: k not in actual_keys, target_keys))
    return len(missing_keys) is 0


def main():
    fetcher = Fetcher()
    with open('example_user.json', 'r') as fp:
        profile = json.load(fp)
    for redditer in profile['following']:
        submissions = fetcher.fetch_submissions(redditer)
        valid = list(map(submission_is_valid, submissions))
        assert(sum(valid) is len(submissions))
        time.sleep(2.0)

if __name__ == '__main__':
    main()
