from pymongo import MongoClient
from textblob import TextBlob
import matplotlib.pyplot as plt

#Establish connection to database
client = MongoClient(port=27017)
db=client.illumina

#Ignore - simple query to test the DB connection
#fivestarcount = db.twitter.find({'id': 1111681971682459650}).count()
#print(fivestarcount)


#Load tweets related to NovaSeq
platform="novaseq"
#limit information to the specified platform and only pull text of the tweet
x=list(db.twitter.find({"full_text": {"$regex": platform,"$options":"$i"}},{'_id':0, 'full_text':1}))
i=0
alist=[]
for tweet in x:
        b=TextBlob(tweet['full_text'])
        i=i+1
        if b.detect_language()!='en':  #detect language, if not English, translate to English
            c=b.translate(to='en')
            alist.append(c.sentiment.polarity)  #if not English, calculate polarity of the translation
        else:
            alist.append(b.sentiment.polarity)  #if English, calculate polarity


novaseqlist=alist

platform="miseq"
x=list(db.twitter.find({"full_text": {"$regex": platform,"$options":"$i"}},{'_id':0, 'full_text':1}))
i=0
alist=[]
for tweet in x:
        b=TextBlob(tweet['full_text'])
        i=i+1
        if b.detect_language()!='en':
            c=b.translate(to='en')
            alist.append(c.sentiment.polarity)
        else:
            alist.append(b.sentiment.polarity)

miseqlist=alist

#Plot stacked histogram

plt.hist([miseqlist, novaseqlist])
plt.title("Sentiment polarity" )
plt.xlabel("Value")
plt.ylabel("Frequency")
plt.legend({"MiSeq", "NovaSeq"}) 
plt.show()