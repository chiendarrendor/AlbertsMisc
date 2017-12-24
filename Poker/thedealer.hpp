#include "Deck.hpp"

class THEDealer
{
public:
  THEDealer();

  std::vector<Hand> m_PlayerHands;
  Hand m_TableHand;
  std::vector<int> m_bestidx;

private:
  std::vector<int> ValuateHand(Hand &i_hand);

  Deck m_deck;
};
