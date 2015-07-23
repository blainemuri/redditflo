from fetcher import Fetcher
from itertools import chain
import util

__all__ = 'Store'

class Store:
    def __init__(self):
        self.fetcher = Fetcher()
        self.reset()

    def reset(self):
        self.profile = default_profile()
        self.submissions = []

    def set_profile(self, profile):
        assert(profile_is_valid(profile))
        self.profile = profile

    def refresh_submissions_from_redditor(self, redditor, limit=25):
        cached_submissions = filter(
            lambda x: x['author'] is not redditor,
            self.submissions
        )
        new_submissions = self.fetcher.fetch_submissions(redditor, limit)
        submissions = chain(cached_submissions, new_submissions)
        self.submissions = sorted(submissions, key=lambda s: s['created'])


PROFILE_KEYS = [
    'following',
    'name',
    'nickname'
]

def default_profile():
    return dict(zip(PROFILE_KEYS, [None] * len(PROFILE_KEYS)))

def profile_is_valid(profile):
    return util.object_contains_keys(profile, PROFILE_KEYS)
