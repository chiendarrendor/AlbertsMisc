#include <vector>


enum Suit
  {
    CLUBS=0,
    DIAMONDS=1,
    HEARTS=2,
    SPADES=3
  };

// use numbers 1 through 13, where
// 1 == ACE .. 11 == JACK, 12 == QUEEN, 13=KING
typedef int Rank;

class Card
{
public:
  Card(Rank r,Suit s) : m_r(r),m_s(s) {}
  Suit GetSuit() const { return m_s; }
  Rank GetRank() const { return m_r; }
private:
  Rank m_r;
  Suit m_s;
};

typedef std::vector<Card *> Hand;


class Deck
{
public:
  Deck();
  virtual ~Deck();
  Card &Draw();
  bool IsEmpty();


private:

  // this shows what cards are left to draw.
  Hand m_Deck;
  // this is the actual owner
  Hand m_Cards;
};

std::ostream &operator<<(std::ostream &o,const Hand &h);
std::ostream &operator<<(std::ostream &o,const Card &c);
std::string GetRankString(const Rank &r);
std::string GetSuitString(const Suit &s);

