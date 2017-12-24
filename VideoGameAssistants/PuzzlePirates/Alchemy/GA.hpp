#include <vector>
#include <iostream>
#include "MyRand.hpp"

// T_Individual must have:
// a copy constructor
// a default constructor which will generate a random individual
// a method void Crossover(const T_Individual &i_right) which
//   will randomly do a crossover between this individual and i_right
//   into this individual
// a method void Mutate() which will make one small random mutation
//   to this individual
// a method double GetFitness() const which returns the fitness
// of this individual. Must be >= 0


template<typename T_Individual>
class GA
{
public:
  GA(int i_PopulationSize) :
    m_FitnessSummed(false)
  {
    int i;
    for (i = 0 ; i < i_PopulationSize ; ++i)
    {
      m_Population.push_back(new T_Individual());
    }
  }

  // this should work if your individuals can't have a default constructor.
  GA() :
    m_FitnessSummed(false)
  {
  }


  void InsertIndividual(T_Individual &i_indiv)
  {
    m_FitnessSummed = false;
    m_Population.push_back(&i_indiv);
  }

  virtual ~GA()
  {
    size_t i;
    for (i = 0 ; i < m_Population.size() ; ++i)
    {
      delete m_Population[i];
    }
  }

  const std::vector<T_Individual *> &GetCurrentPopulation() const
  {
    return m_Population;
  }

  // random fitness-weighted individual
  // returns the pointer to a random individual in the
  // current population, where the probability
  // of that individual's choosing is equal to
  // that individual's fitness / by the population's sum fitness
  T_Individual *RFWI()
  {
    size_t i;
    if (!m_FitnessSummed)
    {
      m_SumFitness = 0;
      m_CumulativeFitness.clear();

      for (i = 0 ; i < m_Population.size() ; ++i)
      {
        double fit = m_Population[i]->GetFitness();
        if (fit < 0)
        {
          std::cout << "sub-zero fitness!" << std::endl;
          exit(1);
        }

        if (fit == 0) continue;

        m_SumFitness += fit;
        m_CumulativeFitness[m_SumFitness] = m_Population[i];
      }

      if (m_CumulativeFitness.size() == 0)
      {
        std::cout << "stillborn generation!" << std::endl;
        exit(1);
      }

      m_FitnessSummed = true;
    }

    double selection = RandRange(0.0,m_SumFitness);

    return m_CumulativeFitness.lower_bound(selection)->second;
  }

  void Generate(int i_Repeat = 1)
  {
    std::vector<T_Individual *> nextPopulation;
    
    while(i_Repeat-- > 0)
    {
      size_t i;
      for (i = 0 ; i < m_Population.size() ; ++i)
      {
        T_Individual *newIndividual = new T_Individual(*(this->RFWI()));
        T_Individual *mate = this->RFWI();
        newIndividual->Crossover(*mate);
        newIndividual->Mutate();
        nextPopulation.push_back(newIndividual);
      }

      for (i = 0 ; i < m_Population.size() ; ++i)
      {
        delete (m_Population[i]);
      }
      m_Population.clear();
      m_Population.swap(nextPopulation);

      m_FitnessSummed = false;
    }
  }

private:
  std::vector<T_Individual *> m_Population;
  bool m_FitnessSummed;
  std::map<double,T_Individual *> m_CumulativeFitness;
  double m_SumFitness;
};

