#include "Deck.hpp"
#include "MyRand.hpp"
#include <iostream>
#include <boost/lexical_cast.hpp>

Deck::Deck()
{
  Rank r;
  Suit s;

  for (r = 1 ; r <= 13 ; ++r)
  {
    s = CLUBS;
    Card *pC = new Card(r,s);
    m_Cards.push_back(pC);
    m_Deck.push_back(pC);

    s = HEARTS;
    pC = new Card(r,s);
    m_Cards.push_back(pC);
    m_Deck.push_back(pC);

    s = DIAMONDS;
    pC = new Card(r,s);
    m_Cards.push_back(pC);
    m_Deck.push_back(pC);

    s = SPADES;
    pC = new Card(r,s);
    m_Cards.push_back(pC);
    m_Deck.push_back(pC);

  }
}

Deck::~Deck()
{
  size_t i;
  for (i = 0 ; i < m_Cards.size() ; ++i)
  {
    delete m_Cards[i];
  }
  m_Deck.clear();
  m_Cards.clear();
}

bool Deck::IsEmpty()
{
  return m_Deck.size() == 0;
}

Card &Deck::Draw()
{
  if (IsEmpty())
  {
    std::cout << "Draw from empty deck!" << std::endl;
    exit(1);
  }

  size_t idx = RandRange(0,m_Deck.size()-1);

  Card *pC = m_Deck[idx];

  m_Deck.erase(m_Deck.begin() + idx);

  return *pC;
}

std::ostream &operator<<(std::ostream &o,const Hand &h)
{
  size_t i;
  for (i = 0 ; i < h.size() ; ++i)
  {
    if (i != 0) o << ",";
    o << *(h[i]);
  }
  return o;
}

std::ostream &operator<<(std::ostream &o,const Card &c)
{
  o << GetRankString(c.GetRank()) << GetSuitString(c.GetSuit());
  return o;
}

std::string GetRankString(const Rank &r)
{
  switch(r)
  {
  case 1:
    return boost::lexical_cast<std::string>('A');
    break;
  case 2:
  case 3:
  case 4:
  case 5:
  case 6:
  case 7:
  case 8:
  case 9:
  case 10:
    return boost::lexical_cast<std::string>(r);
    break;
  case 11:
    return boost::lexical_cast<std::string>('J');
    break;
  case 12:
    return boost::lexical_cast<std::string>('Q');
    break;
  case 13:
    return boost::lexical_cast<std::string>('K');
    break;
  default:
    std::cout << "Illegal Rank " << r << std::endl;
    exit(1);
  }
}

std::string GetSuitString(const Suit &s)
{
  std::ostringstream o;
  switch(s)
  {
  case CLUBS:
    return boost::lexical_cast<std::string>('C');
    break;
  case DIAMONDS:
    return boost::lexical_cast<std::string>('D');
    break;
  case HEARTS:
    return boost::lexical_cast<std::string>('H');
    break;
  case SPADES:
    return boost::lexical_cast<std::string>('S');
    break;
  default:
    std::cout << "Illegal Suit " << s << std::endl;
    exit(1);
  }
}

