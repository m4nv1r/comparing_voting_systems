# comparing_voting_systems
Model for comparing different voting systems

The 'voting_simulations.m' file can be used to compare three different voting systems: first-past-the-post, run-off and mixed-member-proportional voting. The 'comparing_voting_systems.m' gives an example of how the 'voting_simulations.m' function file can be used.

## Voting Systems
### First-past-the-post
First-past-the-post (FPTP) is the most commonly known system in North America. It is the system in which everybody gets a single vote for their preferred candidate. The candidate that wins the seat is the one with the most votes. The party with the most seats is considered the winner of the election and gets added benefits, like deciding who gets to be part of the Cabinet of Canada.

Benefits of this system are clear. The voting systems is intuitive. Everybody only gets one vote, meaning the voter has to be concise on who they want to win the riding. Also, counting the votes is incredibly simple. Each riding needs only to get a group of people to count the votes.

The system is far from perfect, however. In the case of a riding with lots of parties, it is possible that the winner of the riding need not get a majority of the total votes. For example, imagine a riding with 6 parties for which the fraction of votes looks like this 2/7, 1/7, 1/7, 1/7, 1/7, 1/7. The winner is the party with only 28% of the vote. That means 72% of the riding is not being represented and could be unhappy with the outcome. Another common criticism is that the system does not encourage honesty. Some people vote against their favourite party simply because they know there are other parties more favoured to win. Thus, they cast their vote for their favourite part from a list consisting of the most popular few. Also, this system is susceptible to gerrymandering and the spoiler effect.

### Instant Runoff
There are two talked about versions of instant runoff with vast similarities. We will work with the following version. Instant runoff voting requires voters vote as they would in FPTP and votes are counted as they would be in FPTP. If the 50% threshold for votes has been reached, that candidate is a winner. If no candidate hits the mark, the two with the largest votes are put up for a second vote against one another. The winner of that will most definitely have over 50% of the populations vote and so, we'd have a pseudo Condorcet winner.

This system does a wonderful job of encouraging honesty as there is no reason to vote against your conscience in the first election, given even if your party loses you still have sway over who wins the seat. Even the spoiler effect gets nullified by this system and the effects of gerrymandering is decreased.

Criticisms of this system usually come down to misrepresentation and how tiresome the double election is. Since the same votes have to be retaken during the elimination phase, deciding the winner of a riding is a cumbersome task. Not to mention, it is possible some people may not go vote twice. Furthermore, this system favours the already popular parties meaning misrepresentation is still a major issue.

### Mixed-member-proportional
An election under Mixed-member-proportional (MMP) is a rather interesting affair as two votes occur and the number of seats is doubled, one seat for the riding (a riding representative seat) and one correctional seat (the winner of which is not a riding representative). The first vote works just like that of FPTP where the winner of the riding is the one with the most votes. The second vote is an honest correctional vote. People are encouraged to vote their favourite party and the percentage of votes pi is calculated for each party _i_. First we look at the biggest winner of seats and give them a correctional seat until the percentage of seats _s<sub>i</sub>_ > _p<sub>i</sub>_. We continue this process and stop when no more correctional seats remain.

Counting votes under MMP is not that difficult. It also allows ridings to have their own representatives (something lots of people want) while ensuring the Federal government resembles the populations honest vote. It appears to be the perfect way to both have your cake and eat it too.

It appears however, that all this comes at a cost. Honesty and fair representation for the price of either doubling the number of politicians in office, or halving the number of ridings. Both are highly unpopular political decisions.

## The Model
Given how messy the conversation is, we thought that a statistical analysis of each electoral system with respects to misrepresentation was a necessity. In this section, we go over all the assumptions made, the metric used for voting misrepresentation and the model for determining which system is best.

### Assumptions
1. We assume that all voters have an opinion on each candidate and that the approval of each candidate can be put on a scale from 0 to 9.
2. We assume that there need not be a correlation between opinions on a candidate and where a voter stands on the political spectrum (i.e being right wing does not mean that you will like every right wing candidate more than any left wing candidate). Thus, the opinion of a given voter is random in nature.
3. We assume that the ridings people live in, are random and that like minded people congregating in a riding is an event of chance.
4. We assume ridings are all of random size, determined by a distribution. This fits historically with Canada's ridings following a Kumaraswamy curve.
5. We assume that the system in question has two favoured parties, not three or four. (historically accurate)
6. We assume that voters under FPTP can vote strategically and the other systems are relatively infallible in this regard (MMP has a round of FPTP before correctional votes are counted).
7. We assume strategic voting is based off a tolerance scale and that everyone has the same tolerance. We create the model so that tolerance is a parameter, however a more proper estimation would require access to a distribution of how often people vote strategically. If such research study were to be conducted, the model could be changed to implement this information.
8. We assume that the Saint Lague index is the best index for determining how bad an election has misrepresented a country.
9. We assume that every possible voter votes.
10. We assume voting fraud is not a widespread problem and so plays little to no affect on an election.

### Defining variables
We let _I_ be the set of all voters with cardinality _n_. We let _P_ be the set of all candidates. For all _i_ ![equation](https://latex.codecogs.com/gif.latex?%5Cin) _I_, we define _f<sub>i</sub>_ : _P_ ![equation](https://latex.codecogs.com/gif.latex?%5Crightarrow) {0..9} as a voting rule. We define the vote cast by voter _i_ as _v<sub>i</sub>_ : _P_ ![equation](https://latex.codecogs.com/gif.latex?%5Crightarrow) {0,1}. The restriction on _v<sub>i</sub>_ is ![equation](https://latex.codecogs.com/gif.latex?%5Cexists%21)_p_ ![equation](https://latex.codecogs.com/gif.latex?%5Cin) _P_ such that _v<sub>i</sub>_(_p_) = 1 i.e a person only truly gets one vote. 

We define a "genuine" vote as _v'<sub>i</sub>_: _P_ ![equation](https://latex.codecogs.com/gif.latex?%5Crightarrow) {0,1}. The restriction on _v'<sub>i</sub>_ is that _v'<sub>i</sub>_(_c_) = 1 if and only if _f<sub>i</sub>_(_c_) = max<sub>_p![equation](https://latex.codecogs.com/gif.latex?%5Cin)P_</sub> _f<sub>i</sub>_(_p_). This means that the genuine vote is what the voter should cast given they could be honest. Moreover, if a voter likes a cluster of parties equally, then the voters true preference is decided randomly so that only one party gets assigned the value 1.

We denote the percentage of seats received by a party as _s_ : _P_ ![equation](https://latex.codecogs.com/gif.latex?%5Crightarrow) [0,1] with the condition that ![equation](https://latex.codecogs.com/gif.latex?%5Csum_%7Bp%5Cin%20p%7Ds%28p%29%20%3D%201).

### Saint Lague Index

The Saint Lague index determines how misrepresented a political party has been in a given election. The formulation, per party _p_ is the following

![equation](https://latex.codecogs.com/gif.latex?R_o%28p%29%20%3D%20%5Cfrac%7B%28%5Cfrac%7B1%7D%7Bn%7D%5Csum_%7Bi%5Cin%20I%7D%20v_i%20-s%28p%29%29%5E2%7D%7B%5Cfrac%7B1%7D%7Bn%7D%5Csum_%7Bi%5Cin%20I%7D%20v_i%7D)

We define the misrepresentation of an electoral system as the grand total sum of misrepresentation for each party.

![equation](https://latex.codecogs.com/gif.latex?R_o%28p%29%20%3D%20%5Csum_%7Bp%20%5Cin%20P%7D%20R_o%28p%29)

We define _R<sub>g</sub>_ in the same manner as _R<sub>o</sub>_ except with _v'<sub>i</sub>_ instead of _v<sub>i</sub>_.

It is of course, important to examine what happens to _R<sub>o</sub>_ and _R<sub>g</sub>_ when a party _p_ gets no votes ![equation](https://latex.codecogs.com/gif.latex?%5Cleft%28%20%5Cfrac%7B1%7D%7Bn%7D%5Csum_%7Bi%20%5Cin%20I%7D%20v_i%20%28p%29%20%5Crightarrow%200%20%5Cright%20%29). To solve this problem, one must note that there is a certain threshold of votes, that if not met, a party is guaranteed to get zero seats. In other words, ![equation](https://latex.codecogs.com/gif.latex?s%28p%29%20%3C%3C%20%5Cfrac%7B1%7D%7Bn%7D%20%5Csum_%7Bi%20%5Cin%20I%7D%20v_i%20%28p%29) near 0. For simplicity, let ![equation](https://latex.codecogs.com/gif.latex?y%20%3D%20%5Cfrac%7B1%7D%7Bn%7D%5Csum_%7Bi%20%5Cin%20I%7D%20v_i%20%28p%29). So, 

![equation](https://latex.codecogs.com/gif.latex?%5Clim_%7By%5Crightarrow%200%7D%20%5Cfrac%7B%28y-s%28p%29%29%5E2%7D%7By%7D%20%3D%20%5Clim_%7By%5Crightarrow%200%7D%20O%5Cleft%20%28%20%5Cfrac%7By%5E2%7D%7By%7D%20%5Cright%20%29%20%3D%200)

Thus, we set the Saint Lague index to 0 when a party receives no votes.

### Implementing the model
Let _X_ be a random variable using a pseudo-random number generator for MATLAB (we can use any distribution), with range {0..9}. For all  and ![equation](https://latex.codecogs.com/gif.latex?i%20%5Cin%20I) and ![equation](https://latex.codecogs.com/gif.latex?p%20%5Cin%20P), we define _f<sub>i</sub>(p)_ = _X_<sup>*</sup>, some random number created by _X_. We also randomly assign a voting rule to a riding using a random number generator of a chosen distribution. The number of ridings is a parameter that we predetermine. Once ridings are determined, we keep them the same, so that the ridings will stay constant after a series of voting simulations (this saves time). The number of simulations, number of parties and number of ridings are parameters. We even have a way to assign different weights to different parties. That is to say, we can make a party more popular so that they will receive a greater amount of large number scores comparatively to other less popular parties. We define the following rules for each election type.

__First-past-the-post__: We first take a poll and see which parties are the top two. Then, rather than vote their conscience, a subset of people vote for one of the two most popular. Assume the popular parties are _a_ and _b_. If _f<sub>i</sub>(a)_ > _f<sub>i(b)</sub>_ then, we consider a vote for party a in that riding. It works vice versa if _f<sub>i</sub>(a)_ < _f<sub>i(b)</sub>_, if _f<sub>i</sub>(a)_ = _f<sub>i(b)</sub>_ then the choice is decided via coin flip. Of course, first the difference in preference must be less than our tolerance _T_.

![equation](https://latex.codecogs.com/gif.latex?min%5Cleft%20%5C%7B%20%5Cleft%20%7Cf_i%20%28a%29-max_%7Bp%5Cin%20P%7Df_i%28p%29%20%5Cright%20%7C%2C%20%5Cleft%20%7Cf_i%20%28b%29-max_%7Bp%5Cin%20P%7Df_i%28p%29%20%5Cright%20%7C%20%5Cright%20%5C%7D%5Cleq%20T)

Once the election is complete, we examine how the seats are assigned based off the vote and measure the Saint Lague index.

__Instant runoff__: First the voters vote for their favourite party _p_. If a party has a majority of the votes, that party wins. If that is not the case, another election is run with the top two parties. The voter votes for their favourite of the two and in the case that they like the two parties equally, the decision is made via coin flip. The vote counted in _R<sub>s</sub>_ and _R<sub>g</sub>_ are the same.

__Mixed-member-proportional__: Each voter cast two votes. The first vote is decided strategically, while the second vote is for their favourite party. The first vote is governed as it was with first past the post and seats are assigned accordingly. The total number of seats is then doubled. The percentage of seats that a party has is compared to the percentage of votes that it received. Starting from the most popular party to the least, additional seats will be assigned in order to ensure percentage of seats >= percentage of votes for each party until all additional seats have been assigned.

## Code
The parameter of 'voting_simulations.m' are nvoters, nridings, nparties, TOL, N. nvoters is the number of voters. nridings is the number of ridings. nparties is number of political parties. TOL is the tolerance (_T_) and N refers to the number of simulations. The output of the function file is a vector of misrepresentaion ratios of first-past-the-post (with strategic voting), instant runoff (with strategic voting), mixed-member-roportional (with strategic voting), rst-past-the-post (with no strategic voting), instant runoff (with no strategic voting), and mixed-member-roportional (with no strategic voting.)

'comparing_voting_systems.m' gives an example of how to call 'voting_simulations.m'. 

