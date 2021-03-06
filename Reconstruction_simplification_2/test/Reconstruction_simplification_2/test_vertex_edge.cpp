// test_vertex_edge.cpp

//----------------------------------------------------------
// Test the cgal environment for Reconstruction_simplification_2
//----------------------------------------------------------

#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
#include <CGAL/Reconstruction_simplification_2.h>
#include <CGAL/RS_2/Reconstruction_triangulation_2.h>

#include "testing_tools.h"

#include <fstream>
#include <cassert>
#include <iostream>
#include <string>
#include <vector>
#include <utility>      // std::pair

#include <CGAL/property_map.h>

typedef CGAL::Exact_predicates_inexact_constructions_kernel K;
typedef K::Point_2                                          Point;
typedef K::FT                                               FT;

typedef std::pair<Point, FT> PointMassPair;
typedef std::vector<PointMassPair> PointMassList;

typedef CGAL::First_of_pair_property_map <PointMassPair> Point_property_map;
typedef CGAL::Second_of_pair_property_map <PointMassPair> Mass_property_map;

typedef CGAL::RS_2::Reconstruction_triangulation_2<K> Rt_2;
typedef Rt_2::Finite_edges_iterator Finite_edges_iterator;

typedef Rt_2::Edge Edge;
typedef Rt_2::Rec_edge_2 R_edge_2;

void simple_point_set(PointMassList &points);
void test_num_of_vertices_in_triangulation();
void test_edge_collapse();

int main ()
{
  test_num_of_vertices_in_triangulation();
  test_edge_collapse();
}

void print_edge(R_edge_2 pedge)
{
  Edge edge = pedge.edge();

  int i = edge.second;
  Point a = edge.first->vertex((i+1)%3)->point();
  Point b = edge.first->vertex((i+2)%3)->point();
  std::cout << a << " , " << b << " : " << pedge.priority() << std::endl;
}

void test_edge_collapse() 
{
  std::cerr << "test_edge_collapse" << std::endl;

  PointMassList points;
  //use the stair example for testing
  load_xy_file<PointMassList, Point>("data/stair-noise00.xy", points);

  Point_property_map point_pmap;
  Mass_property_map  mass_pmap;

  CGAL::Reconstruction_simplification_2<K, Point_property_map, Mass_property_map>
    rs2(points, point_pmap, mass_pmap);

  Rt_2 rt2;
  rs2.extract_tds_output(rt2);

  FT min_priority = 1000;
  R_edge_2 contract_edge;
  for (Finite_edges_iterator ei = rt2.finite_edges_begin();
       ei != rt2.finite_edges_end(); ++ei) 
  {
    R_edge_2 cur_r_edge;
    if(!rs2.create_pedge(*ei, cur_r_edge))
      continue;

    print_edge(cur_r_edge);

    if (cur_r_edge.priority() < min_priority && cur_r_edge.priority() > 0) 
    {
      min_priority = cur_r_edge.priority();
      contract_edge = cur_r_edge;
    }
  }

  R_edge_2 pedge;
  rs2.pick_edge(0, pedge);

  std::cout << "--------" << std::endl;
  print_edge(contract_edge);

  print_edge(pedge);

  std::cout << "--------" << std::endl;

  //test that the right edge was picked for collapsing
  // N.B.: it can be two different edges if several edges have the same
  // priority value.
  assert(CGAL::abs(pedge.priority() - contract_edge.priority())
         < pedge.priority()*1e-13);
  rs2.do_collapse(contract_edge.edge());

  bool found = false;
  for (Finite_edges_iterator ei = rt2.finite_edges_begin();
       ei != rt2.finite_edges_end(); ++ei) 
  {
    if (*ei == contract_edge.edge()) 
    {
      found = true;
      break;
    }
  }

  //test that the edge was collapsed
  assert(!found);
  CGAL_USE(found);
}

void test_num_of_vertices_in_triangulation()
{
  std::cerr << "test_num_of_vertices_in_triangulation" << std::endl;

  PointMassList points;
  simple_point_set(points);

  CGAL::Reconstruction_simplification_2<K, Point_property_map, Mass_property_map> rs2;
  int nb = 0;
  for (PointMassList::iterator it = points.begin(); it != points.end(); it++)
  {
    PointMassPair pmp = *it;
    Point point = pmp.first;
    rs2.insert_point(point, false, nb++);
  }

  Rt_2 rt2;
  rs2.extract_tds_output(rt2);

  //test if vertices are indeed added to the Reconstruction_triangulation_2
  assert(points.size() == rt2.number_of_vertices());
}

void simple_point_set(PointMassList &points)
{
  points.push_back(std::make_pair(Point(0.1,0.1), 1));
  points.push_back(std::make_pair(Point(0.4,0.1), 1));
  points.push_back(std::make_pair(Point(0.6,0.1), 1));
  points.push_back(std::make_pair(Point(0.9,0.1), 1));
  points.push_back(std::make_pair(Point(0.9,0.4), 1));
  points.push_back(std::make_pair(Point(0.9,0.6), 1));
  points.push_back(std::make_pair(Point(0.9,0.9), 1));
  points.push_back(std::make_pair(Point(0.6,0.9), 1));
  points.push_back(std::make_pair(Point(0.4,0.9), 1));
  points.push_back(std::make_pair(Point(0.1,0.9), 1));
  points.push_back(std::make_pair(Point(0.1,0.6), 1));
  points.push_back(std::make_pair(Point(0.1,0.4), 1));
}
