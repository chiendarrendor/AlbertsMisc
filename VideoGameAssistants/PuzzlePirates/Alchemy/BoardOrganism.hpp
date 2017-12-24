#include <boost/array.hpp>

class Board;

class BoardOrganism
{
public:
  static void Initialize(const Board &i_b);

  int GetAllele(int i_x,int i_y) const;
  
  // this class must fulfill the interface defined by GA.hpp
  BoardOrganism(); // generates a random individual
  BoardOrganism(const BoardOrganism &i_right); // copy constructor
  virtual ~BoardOrganism();
  
  void Crossover(const BoardOrganism &i_right); // random crossover of this and right into this
  void Mutate(); // random small mutation
  double GetFitness() const; // a number >= 0

  const std::string &GetFitnessDescriptor() const;
  const std::string GetMetaState() const;

  int m_UID;

private:
  static const Board *s_pBoard;
  static bool s_Initialized;

  mutable double m_mFitness;
  mutable std::string m_mFitnessDescriptor;

  boost::array<boost::array<int,12>,11> m_dna; // a rotation value for each NORMAL cell
  double m_metamutationprobability;
  int m_mutationcount;
  double m_normalmutationprobability;
  void FixMetaBounds();


  int GetPipeId(int i_i,int i_j,int i_dir) const;
  static int GetXInDir(int i_i,int i_j,int i_dir);
  static int GetYInDir(int i_i,int i_j,int i_dir);

  static int s_UID;
};
