### Social Proof Stars

What role does social proof play in what people choose to buy, endorse, contribute to? We study the question on the largest developer platform, Github. We randomly buy 'stars' for some Github repositories and estimate their impact on engagement---number of users watching, favoriting the repository, usage---number of forks and downloads, and user contributions---number of PRs, etc. In particular, we select Github repositories of Python Packages, we then filter to Github repositories with less than 10 stars that were made public in the last XX days, and then use online vendors to buy 'stars' for a random sample of these repositories and track the consequences. We find that the average impact of XX stars is XX additional stars over the next month, YY more watchers, and KK more downloads.


#### Background

A long line of research has shown that social proof plays a large role in people's choices around what to buy, contribute to, etc. (Cialdini, XXXX, Salganik and Watts 20XX). The research has also shown that reliance on such heuristics can cause small initial imbalances in how many people are thought to like a song to dramatically affect their popularity (Salganik and Watts 20XX), shedding light on the unpredictability and manipulability of choices when it comes to some leisure goods. We add to this research by studying a real world scenario with more friction---software.  

### Data 

We assume that the effect of additional 'favorite' is the largest when the repository has zero favorites. More generally, we expect the effect of additional social proof to decline and assymptote close to zero as the cummulated social proof increases. 

Tradeoffs:

1. Github metrics are slow moving so options = Not use the metrics, go big, go long.
2. Cheap or expensive stars: cheap stars will be rescinded by integrity teams so best for measuring short term impact.
3. New or old repos?: Quality is least certain with new so presumably a more important heuristic. 
4. Popular or unpopular repos.: the marginal impact of XX stars is likely the greatest where the n_stars is low. 

### Data

* https://star-history.com/

### Relevant Literature

* https://dagster.io/blog/fake-stars
* Benefit of stars: https://www.infracost.io/blog/github-stars-matter-here-is-why/
* https://www.tandfonline.com/doi/full/10.1080/10810730.2018.1455770
* https://www.princeton.edu/~mjs3/salganik_dodds_watts06_full.pdf
* https://en.wikipedia.org/wiki/Social_proof

### Github Star Vendors

* https://www.appsally.com/products/github-stars/
* https://baddhi.shop/product/buy-github-followers/
* https://likesmagic.com/product/buy-github-stars-forks-watchers-and-followers/

### Authors

Lucas Shen and Gaurav Sood
