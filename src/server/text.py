import nltk

LEMMATIZER = nltk.WordNetLemmatizer()
STOP_WORDS = set(nltk.corpus.stopwords.words('english'))

def preprocess(text):
    text = text.lower().replace('\'', '')
    tokens = nltk.tokenize.word_tokenize(text)
    tokens = filter(lambda s: s not in stop_words, tokens)
    tokens = map(lambda s: lemmatizer.lemmatize(s), tokens)
    return ' '.join(tokens)

def remove_empty(iter):
    return filter(lambda s: s != '', iter)
