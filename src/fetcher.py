import praw

__all__ = ['Fetcher']

class Fetcher:
    def __init__(self):
        self.reddit = praw.Reddit(user_agent='Python praw')

    def fetch_submissions(self, redditor, limit=25):
        redditor = self.reddit.get_redditor(redditor)
        submissions = redditor.get_submitted(limit=limit)
        submissions = map(submissionToDict, submissions)
        return list(submissions)

def submissionToDict(s):
    return {
        'author': s.author,
        'body': s.selftext,
        'created': s.created_utc,
        'title': s.title,
        'thumbnail': s.thumbnail,
    }
