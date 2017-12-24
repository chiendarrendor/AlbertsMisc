
#include "THEDealer.hpp"
#include <iostream>
#include <map>
#include <sstream>


struct AceHighDescending
{
  // returns true if left precedes right
  bool operator()(const Card *i_left,const Card *i_right)
  {
    Rank lrank = i_left->GetRank();
    Rank rrank = i_right->GetRank();
    Suit lsuit = i_left->GetSuit();
    Suit rsuit = i_right->GetSuit();

    if (lrank != 1 && rrank != 1)
    {
      if (lrank != rrank) return lrank > rrank;
      return lsuit > rsuit;
    }
    else if (lrank == 1 && rrank == 1)
    {
      return lsuit > rsuit;
    }
    else if (lrank == 1)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
};

struct AceLowDescending
{
  // returns true if left precedes right
  bool operator()(const Card *i_left,const Card *i_right)
  {
    Rank lrank = i_left->GetRank();
    Rank rrank = i_right->GetRank();
    Suit lsuit = i_left->GetSuit();
    Suit rsuit = i_right->GetSuit();

    if (lrank != rrank) return lrank > rrank;
    return lsuit > rsuit;
  }
};

const int HIGHCARD=0;
const int PAIR=1;
const int TWOPAIRS=2;
const int THREEOFAKIND=3;
const int STRAIGHT=4;
const int FLUSH=5;
const int FULLHOUSE=6;
const int FOUROFAKIND=7;
const int STRAIGHTFLUSH=8;

// equal returns 0, return 1 if right is better, otherwise return -1
int IsValBetter(const std::vector<int> &i_left,const std::vector<int> &i_right)
{
  if (i_right[0] > i_left[0]) return 1;
  if (i_right[0] < i_left[0]) return -1;

  if (i_right.size() != i_left.size())
  {
    std::cout << "They should be the same size!" << std::endl;
    exit(1);
  }

  size_t i;
  for (i = 1 ; i < i_left.size() ; ++i)
  {
    if (i_right[i] == i_left[i]) continue;
    if (i_right[i] == 1) return 1;
    if (i_left[i] == 1) return -1;
    if (i_right[i] > i_left[i]) return 1;
    return -1;
  }
  return 0;
}


THEDealer::THEDealer():
  m_PlayerHands(10),
  m_TableHand(),
  m_deck()
{
  size_t i,j;
  
  for (j = 0 ; j < 2 ; ++j)
  {
    for (i = 0 ; i < 10 ; ++i)
    {
      m_PlayerHands[i].push_back(&(m_deck.Draw()));
    }
  }

  m_deck.Draw();
  m_TableHand.push_back(&(m_deck.Draw()));
  m_TableHand.push_back(&(m_deck.Draw()));
  m_TableHand.push_back(&(m_deck.Draw()));
  m_deck.Draw();
  m_TableHand.push_back(&(m_deck.Draw()));
  m_deck.Draw();
  m_TableHand.push_back(&(m_deck.Draw()));

  std::vector<int> bestVal;

  for (i = 0 ; i < 10 ; ++i)
  {
    Hand bigHand = m_PlayerHands[i];
    bigHand.insert(bigHand.end(),m_TableHand.begin(),m_TableHand.end());
    std::vector<int> val = ValuateHand(bigHand);

    if (i == 0)
    {
      bestVal = val;
      m_bestidx.push_back(i);
    }
    else
    {
      int v = IsValBetter(bestVal,val);
      if (v == 0)
      {
        m_bestidx.push_back(i);
      }
      else if (v > 0)
      {
        bestVal = val;
        m_bestidx.clear();
        m_bestidx.push_back(i);
      }
    }
  }
}



void SortHand(Hand &i_hand,bool i_IsHigh)
{
  if (i_IsHigh)
  {
    std::sort(i_hand.begin(),i_hand.end(),AceHighDescending());
  }
  else
  {
    std::sort(i_hand.begin(),i_hand.end(),AceLowDescending());
  }
}

bool AdjacentRank(Card *i_left,Card *i_right)
{
  if (i_left->GetRank() == 1 && i_right->GetRank() == 13) return true;
  if (i_left->GetRank() - 1 == i_right->GetRank()) return true;
  return false;
}

Rank SingleStraightDetector(Hand &i_hand,bool i_AceHigh)
{
  SortHand(i_hand,i_AceHigh);

  size_t i;
  Rank result = -1;
  int adjcount = 0;

  for (i = 0 ; i < i_hand.size() - 1; ++i)
  {
    // cases to deal with:
    // next card is the same as this card.
    if (i_hand[i]->GetRank() == i_hand[i+1]->GetRank())
    {
      continue;
    }
    // next card is different and not adjacent.
    if (AdjacentRank(i_hand[i],i_hand[i+1]))
    {
      if (adjcount == 0)
      {
        result = i_hand[i]->GetRank();
      }
      adjcount++;
      if (adjcount == 4) return result;
    }
    // next card is different and adjacent.
    else
    {
      result = -1;
      adjcount = 0;
    }
  }
  return -1;
}

Rank StraightDetector(Hand &i_hand)
{
  Rank r = SingleStraightDetector(i_hand,true);
  if (r != -1) return r;
  r = SingleStraightDetector(i_hand,false);
  return r;
}




// this method will find, assuming the hand is sorted by value
// the highest-value bunch of bunchsize in i_input and copy it to
// i_bunch.  all cards that do not make up that bunch are copied to i_remainder.
void BunchFinder(Hand &i_input,size_t bunchsize,Hand &i_bunch,Hand &i_remainder)
{
  i_bunch.clear();
  i_remainder.clear();

  size_t i;
  for (i = 0 ; i < i_input.size() ; ++i)
  {
    if (i_bunch.size() == 0)
    {
      i_bunch.push_back(i_input[i]);
    }
    else if (i_bunch.size() == bunchsize)
    {
      i_remainder.push_back(i_input[i]);
    }
    else if (i_bunch[0]->GetRank() == i_input[i]->GetRank())
    {
      i_bunch.push_back(i_input[i]);
    }
    else
    {
      // this is the case where we don't have a bunch of the 
      // appropriate size in i_bunch, but we find that we
      // aren't going to get any more.
      i_remainder.insert(i_remainder.end(),i_bunch.begin(),i_bunch.end());
      i_bunch.clear();
      i_bunch.push_back(i_input[i]);
    }
  }

  if (i_bunch.size() != bunchsize)
  {
    i_remainder.insert(i_remainder.end(),i_bunch.begin(),i_bunch.end());
    i_bunch.clear();
  }
}



// this method does the following things:
// assuming i_hand is sorted grouping cards of the same rank together
// will return true if there is a bunch (a group of cards of the same
// rank) of both b1size and b2size using different cards, or of just
// a single bunch if b2size is zero.
// furthermore, bresults will contain the following:
// the first entry will be the rank of the bunch of b1size
// the second entry will be the rank of the bunch of b2size (if nonzero)
// there will additionally be entries in bresults of 'count'
// 5 - b1size - b2size, and will contain the ranks of the
// highest 'count' cards that are not parts of the two (or one)
// bunch(es)


bool BunchDetector(Hand &i_hand,size_t b1size,size_t b2size,std::vector<int> &bresults)
{
  bresults.clear();

  Hand firstbunch;
  Hand firstremainder;
  BunchFinder(i_hand,b1size,firstbunch,firstremainder);
  if (firstbunch.size() != b1size) return false;

  Hand secondbunch;
  Hand secondremainder;

  if (b2size != 0)
  {
    BunchFinder(firstremainder,b2size,secondbunch,secondremainder);
    if (secondbunch.size() != b2size) return false;
  }
  else
  {
    secondremainder = firstremainder;
  }

  bresults.push_back(firstbunch[0]->GetRank());
  if (b2size != 0)
  {
    bresults.push_back(secondbunch[0]->GetRank());
  }

  size_t i;
  for (i = 0 ; i < (5 - b1size - b2size) ; ++i)
  {
    bresults.push_back(secondremainder[i]->GetRank());
  }

  return true;
}


std::vector<int> THEDealer::ValuateHand(Hand &i_hand)
{
  std::map<Suit,Hand> suits;
  size_t i;

  std::map<Suit,Hand>::iterator suitit;
  std::vector<int> result;

  for (i = 0 ; i < i_hand.size() ; ++i)
  {
    Card &c = *(i_hand[i]);
    suits[c.GetSuit()].push_back(&c);
  }

  // straight flush
  for (suitit = suits.begin() ; suitit != suits.end() ; ++suitit)
  {
    if (suitit->second.size() < 5) continue;
    Rank r = StraightDetector(suitit->second);
    if (r != -1)
    {
      result.push_back(STRAIGHTFLUSH);
      result.push_back(r);
      return result;
    }
  }

  std::vector<int> bunchcatcher;
  
  // 4 of a kind
  SortHand(i_hand,true);
  if (BunchDetector(i_hand,4,0,bunchcatcher))
  {
    result.push_back(FOUROFAKIND);
    result.insert(result.end(),bunchcatcher.begin(),bunchcatcher.end());
    return result;
  }

  // full house
  if (BunchDetector(i_hand,3,2,bunchcatcher))
  {
    result.push_back(FULLHOUSE);
    result.insert(result.end(),bunchcatcher.begin(),bunchcatcher.end());
    return result;
  }
  
  // flush
  for (suitit = suits.begin() ; suitit != suits.end() ; ++suitit)
  {
    if (suitit->second.size() < 5) continue;

    SortHand(suitit->second,true);
    result.push_back(FLUSH);
    for (i = 0 ; i < 5 ; ++i)
    {
      result.push_back(suitit->second[i]->GetRank());
    }
    return result;
  }

  // straight
  Rank r = StraightDetector(i_hand);
  if (r != -1)
  {
    result.push_back(STRAIGHT);
    result.push_back(r);
    return result;
  }
  
  // 3 of a kind
  SortHand(i_hand,true);
  if (BunchDetector(i_hand,3,0,bunchcatcher))
  {
    result.push_back(THREEOFAKIND);
    result.insert(result.end(),bunchcatcher.begin(),bunchcatcher.end());
    return result;
  }

  // 2 pairs
  if (BunchDetector(i_hand,2,2,bunchcatcher))
  {
    result.push_back(TWOPAIRS);
    result.insert(result.end(),bunchcatcher.begin(),bunchcatcher.end());
    return result;
  }
  // pair
  if (BunchDetector(i_hand,2,0,bunchcatcher))
  {
    result.push_back(PAIR);
    result.insert(result.end(),bunchcatcher.begin(),bunchcatcher.end());
    return result;
  }
  // high card
  result.push_back(HIGHCARD);
  for (i = 0 ; i < 5 ; ++i)
  {
    result.push_back(i_hand[i]->GetRank());
  }
  return result;
}

