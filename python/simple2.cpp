#include <vector>
#include <boost/python.hpp>

using namespace std;

int calc_test(boost::python::list list)
{
  int r;
  r = (int)list[0];
  return r;
}

BOOST_PYTHON_MODULE(simple2)
{
  using namespace boost::python;

  def("calc_test", &calc_test);
}
