from pymongo import MongoClient
from textblob import TextBlob
import matplotlib.pyplot as plt


client = MongoClient(port=27017)
db=client.illumina


fivestarcount = db.twitter.find({'id': 1111681971682459650}).count()
print(fivestarcount)

platform="novaseq"

fullx=list(db.twitter.find({ }, {'_id':0, 'full_text':1}))
i=0
flist=[]
for tweet in fullx:
        b=TextBlob(tweet['full_text'])
#        print(b.detect_language())
        i=i+1
        if b.detect_language()!='en':
#            print(b.translate(to='en'))
            c=b.translate(to='en')
#            print(c.sentiment.polarity)
            flist.append(c.sentiment.polarity)
        else:
#            print(b)
#            print(b.sentiment.polarity)
            flist.append(b.sentiment.polarity)

print(flist)
x=list(db.twitter.find({"full_text": {"$regex": platform,"$options":"$i"}},{'_id':0, 'full_text':1}))
i=0
alist=[]
for tweet in x:
        b=TextBlob(tweet['full_text'])
#        print(b.detect_language())
        i=i+1
        if b.detect_language()!='en':
#            print(b.translate(to='en'))
            c=b.translate(to='en')
#            print(c.sentiment.polarity)
            alist.append(c.sentiment.polarity)
        else:
#            print(b)
#            print(b.sentiment.polarity)
            alist.append(b.sentiment.polarity)


            
plt.hist(flist)
plt.title("Sentiment polarity all products")
plt.xlabel("Value")
plt.ylabel("Frequency")
plt.show()


plt.hist(alist)
plt.title("Sentiment polarity " + platform )
plt.xlabel("Value")
plt.ylabel("Frequency")
plt.show()