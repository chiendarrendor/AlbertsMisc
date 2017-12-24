

enum Suit
  {
    CLUBS=0,
    DIAMONDS=1,
    HEARTS=2,
    SPADES=3
  };

typedef int Rank;

class Card
{
public:
  Card(Rank r,Suit s);
  Suit GetSuit() const;
  Rank GetRank() const;
private:
  Rank m_r;
  Suit m_s;
};

    
