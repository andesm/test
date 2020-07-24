#include <vector>
#include <new>
#include <algorithm>
#include <boost/python.hpp>
#include <boost/foreach.hpp>
#include <boost/range/value_type.hpp>

typedef std::vector<double> double_vector;

void calc_test(double_vector const& data, double_vector const& st_sma, double_vector const& mt_sma) {

  for (int short_period = 2; short_period < 98; short_period += 5) {
    for (int medium_period = short_period + 1; medium_period < 100; medium_period += 5) {
      double total = 100000;
      double posi = 0;
      int trade = 0;
    
      for(int d = 1; d < data.size(); d++) { 
	if (st_sma[d - 1] < mt_sma[d - 1] && mt_sma[d] < st_sma[d]) {
	  if (posi != 0) {
	    double now = data[d];
	    total = total - ((total / posi) - (total / now)) * now;
	    posi = data[d];
	    trade += 1;
	  } else if (mt_sma[d - 1] < st_sma[d - 1] && st_sma[d] < mt_sma[d]) {
	    double now = data[d];
	    if (posi != 0) {
	      total = total + ((total / posi) - (total / now)) * now;
	      posi = data[d];
	      trade += 1;
	    }
	  }
	}
      }
      printf("%d %d %f\n", short_period, medium_period, total, trade);
    }
  }
}

template<typename T_>
class pylist_to_vector_converter {
public:
    typedef T_ native_type;

    static void* convertible(PyObject* pyo) {
        if (!PySequence_Check(pyo))
            return 0;

        return pyo;
    }

    static void construct(PyObject* pyo, boost::python::converter::rvalue_from_python_stage1_data* data)
    {
        namespace py = boost::python;
        native_type* storage = new(reinterpret_cast<py::converter::rvalue_from_python_storage<native_type>*>(data)->storage.bytes) native_type();
        for (py::ssize_t i = 0, l = PySequence_Size(pyo); i < l; ++i) {
            storage->push_back(
                py::extract<typename boost::range_value<native_type>::type>(
                    PySequence_GetItem(pyo, i)));
        }
        data->convertible = storage;
    }
};

BOOST_PYTHON_MODULE(simple3)
{
    using namespace boost::python;

    def("calc_test", &calc_test);
    converter::registry::push_back(
	&pylist_to_vector_converter<double_vector>::convertible,
        &pylist_to_vector_converter<double_vector>::construct,
        boost::python::type_id<double_vector>());
}
