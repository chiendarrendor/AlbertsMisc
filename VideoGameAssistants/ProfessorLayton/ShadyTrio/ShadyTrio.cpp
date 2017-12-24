// in binary:
//       aabbccddeeffgghhii
// bit:  765432109876543210 
//       111111110000000000
// 
//
// nibble:
// 00 white
// 01 red
// 10 green
// 11 n/a
//
// meaning:
// aa: 1 hat
// bb: 1 coat
// cc: 1 pant
// dd: 2 hat
// ee: 2 coat
// ff: 2 pant
// gg: 3 hat
// hh: 3 coat
// ii: 3 pant
//

#include <iostream>
#include <iomanip>

enum Color
{
  WHITE = 0,
  RED = 1,
  GREEN = 2,
  INVALID = 3
};

char *cs[4] = { "white","  red","green","  bad" };



enum Clothing
{
  PANTS=0,
  COAT=1,
  HAT=2
};

// person 3 low order bits, person 1 is high
// person pidx offset
// 1      2    12
// 2      1    6
// 3      0    0
Color GetColorOf(int raw,int person,Clothing item)
{
  int pidx = 3-person;
  int offset = pidx * 6 + item*2;
  
  return (Color) ((raw>>offset)&0x3);
}

bool IsOutfitSame(int raw,int p1,int p2)
{
  return 
    GetColorOf(raw,p1,HAT) == GetColorOf(raw,p2,HAT) &&
    GetColorOf(raw,p1,COAT) == GetColorOf(raw,p2,COAT) &&
    GetColorOf(raw,p1,PANTS) == GetColorOf(raw,p2,PANTS);
}

// true only if all three pieces are different colors
bool IsClashing(int raw,int player)
{
  if (GetColorOf(raw,player,HAT) == GetColorOf(raw,player,COAT)) return false;
  if (GetColorOf(raw,player,HAT) == GetColorOf(raw,player,PANTS)) return false;
  if (GetColorOf(raw,player,PANTS) == GetColorOf(raw,player,COAT)) return false;
  return true;
}
  
    

int main(int argc,char **argv)
{
  int i;
  int goodcount = 0;

  for (i = 0 ; i < 1<<18 ; ++i)
  {
    // restrictions:
    // * no nibble is n/a
    if (GetColorOf(i,1,HAT) == INVALID ||
        GetColorOf(i,1,COAT) == INVALID ||
        GetColorOf(i,1,PANTS) == INVALID ||
        GetColorOf(i,2,HAT) == INVALID ||
        GetColorOf(i,2,COAT) == INVALID ||
        GetColorOf(i,2,PANTS) == INVALID ||
        GetColorOf(i,3,HAT) == INVALID ||
        GetColorOf(i,3,COAT) == INVALID ||
        GetColorOf(i,3,PANTS) == INVALID) continue;

    // * 1's hat = white
    if (GetColorOf(i,i,HAT) != WHITE) continue;

    // * 3's coat = green
    if (GetColorOf(i,3,COAT) != GREEN) continue;

    // * 1's coat = 2's coat
    if (GetColorOf(i,1,COAT) != GetColorOf(i,2,COAT)) continue;

    // * exactly two pants are white (at least two?)
    int pcount = 0;
    for (int j = 1 ; j <= 3; ++j)
    {
      if (GetColorOf(i,j,PANTS) == WHITE) ++pcount;
    }
    if (pcount != 2) continue;

    // * no two outfits are the same (i.e. hat-hat,coat-coat,pant-pant)
    if (IsOutfitSame(i,1,2) ||
        IsOutfitSame(i,2,3) ||
        IsOutfitSame(i,1,3)) continue;

    // * each person was wearing red, white and green
    // * i.e. no two pieces of each outfit were the same color
    if (!IsClashing(i,1) ||
        !IsClashing(i,2) ||
        !IsClashing(i,3)) continue;




    std::cout << "Person 1: ";
    std::cout << "Hat: " << cs[GetColorOf(i,1,HAT)] << " ";
    std::cout << "Coat: " << cs[GetColorOf(i,1,COAT)] << " ";
    std::cout << "Pants: " << cs[GetColorOf(i,1,PANTS)] << " ";
    std::cout << "Person 2: ";
    std::cout << "Hat: " << cs[GetColorOf(i,2,HAT)] << " ";
    std::cout << "Coat: " << cs[GetColorOf(i,2,COAT)] << " ";
    std::cout << "Pants: " << cs[GetColorOf(i,2,PANTS)] << " ";
    std::cout << "Person 3: ";
    std::cout << "Hat: " << cs[GetColorOf(i,3,HAT)] << " ";
    std::cout << "Coat: " << cs[GetColorOf(i,3,COAT)] << " ";
    std::cout << "Pants: " << cs[GetColorOf(i,3,PANTS)] << " ";
    std::cout << std::endl;
    ++goodcount;
  }
  std::cout << "Count: " << goodcount << std::endl;
}

