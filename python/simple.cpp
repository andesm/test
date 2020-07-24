#include <boost/python.hpp>
 
char const* hello()
{
  return "hello, world";
}

int add(int lhs, int rhs)
{
  return lhs + rhs;
}

double add2(dobule lhs, dobule rhs)
{
  return lhs + rhs;
}

BOOST_PYTHON_MODULE(simple)
{
  using namespace boost::python;
  def("hello", hello);
  def("add", add);
  def("add2", add2);
}
