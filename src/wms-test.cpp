#define BOOST_TEST_MODULE WMSTest
#define BOOST_TEST_IGNORE_NON_ZERO_CHILD_CODE
#include <boost/test/included/unit_test.hpp>
#include <iostream>
#include <sstream>
#include <utils.hpp>
#include <strutils.hpp>
#include <xml.hpp>

BOOST_AUTO_TEST_SUITE(WMS_Tests)

BOOST_AUTO_TEST_CASE(Simple_Execute)
{
  std::stringstream oss,ess;
  unixutils::mysystem2("/bin/tcsh -c \"unsetenv QUERY_STRING; unsetenv CONTENT_LENGTH; /glade/scratch/rdadata/build-vm-web-test/wms-app\"",oss,ess);
  auto response_lines=strutils::split(oss.str(),"\n");
  BOOST_CHECK_EQUAL(response_lines.front(),"Content-type: application/xml");
  response_lines.pop_front();
  BOOST_CHECK_EQUAL(response_lines.front(),"");
  response_lines.pop_front();
  BOOST_CHECK_EQUAL(response_lines.front(),"<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
  response_lines.pop_front();
  std::string xml_s;
  for (const auto& line : response_lines) {
    xml_s+=line;
  }
  XMLSnippet xml_snippet(xml_s);
  BOOST_CHECK(static_cast<bool>(xml_snippet));
  auto e=xml_snippet.element("ServiceExceptionReport/ServiceException");
  BOOST_CHECK_EQUAL(e.content(),"Missing query");
}

BOOST_AUTO_TEST_SUITE_END()
