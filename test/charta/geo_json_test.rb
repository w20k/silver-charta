require 'test_helper'

module Charta
  class GeoJSONTest < Charta::Test
    def test_all_forms_of_GeoJSON
      samples = []
      samples << {
        'type' => 'Feature',
        'geometry' => {
          'type' => 'Point',
          'coordinates' => [125.6, 10.1]
        },
        'properties' => {
          'name' => 'Dinagat Islands'
        }
      }

      samples << {
        'type' => 'Point',
        'coordinates' => [125.6, 10.1]
      }

      samples << {
        'type' => 'Feature',
        'geometry' => {
          'type' => 'Point',
          'coordinates' => [125.6, 10.1]
        },
        'properties' => {
          'name' => 'Dinagat Islands'
        }
      }

      samples << {
        'type' => 'LineString',
        'coordinates' => [
          [102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]
        ]
      }

      samples << {
        'type' => 'FeatureCollection',
        'features' => []
      }

      # http://geojson.org/geojson-spec.html#examples
      samples << '{ "type": "FeatureCollection",
    "features": [
      { "type": "Feature",
        "geometry": {"type": "Point", "coordinates": [102.0, 0.5]},
        "properties": {"prop0": "value0"}
      },
      { "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]
            ]
          },
        "properties": {
          "prop0": "value0",
          "prop1": 0.0
          }
      },
      { "type": "Feature",
         "geometry": {
           "type": "Polygon",
           "coordinates": [
             [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0],
               [100.0, 1.0], [100.0, 0.0] ]
             ]
         },
         "properties": {
           "prop0": "value0",
           "prop1": {"this": "that"}
           }
      }
       ]
     }'

      samples.each do |sample|
        geojson = Charta::GeoJSON.new(sample)
        assert geojson.valid?
        assert_equal 4326, geojson.srid
      end
    end

    def test_flattening
      topo = {
        'type' => 'LineString',
        'coordinates' => [
          [102.0, 0.0, 5], [103.0, 1.0, 6], [104.0, 0.0, 7], [105.0, 1.0, 8]
        ]
      }
      flat = {
        'type' => 'LineString',
        'coordinates' => [
          [102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]
        ]
      }
      assert_equal Charta::GeoJSON.new(flat).to_hash, Charta::GeoJSON.flatten(topo)
    end

    def test_geojson_normalize
      geojson = '{"type":"MultiPolygon","coordinates":[[[[-0.80186516046524,45.8255303173402],[-0.80225944519043,45.8260181465222],[-0.798313915729523,45.8273675980814],[-0.798448026180267,45.826827447575],[-0.798413157463074,45.826648019257405],[-0.798273682594299,45.8265265310056],[-0.798083245754242,45.8264592450906],[-0.798193216323853,45.82624991061251],[-0.798179805278778,45.8260106702451],[-0.798863768577576,45.8257957268507],[-0.799925923347473,45.8253677066629],[-0.80037921667099,45.8252368701409],[-0.801052451133728,45.8252088337034],[-0.801709592342377,45.8251228552068],[-0.80186516046524,45.8255303173402]]],[[[-0.7983541488647461,45.8268218404488],[-0.7982119917869571,45.8273993714774],[-0.796734094619751,45.8278871842802],[-0.796465873718262,45.8271171483253],[-0.797152519226074,45.8269339828649],[-0.797573626041412,45.8267975428955],[-0.797871351242065,45.8266629716393],[-0.798051059246063,45.8265171857445],[-0.798220038414001,45.8265863406396],[-0.798332691192627,45.8266984835302],[-0.7983541488647461,45.8268218404488]]]]}'
      reference = 'SRID=4326;MultiPolygon (((-0.80186516046524 45.8255303173402, -0.80225944519043 45.8260181465222, -0.798313915729523 45.8273675980814, -0.798448026180267 45.826827447575, -0.798413157463074 45.8266480192574, -0.798273682594299 45.8265265310056, -0.798083245754242 45.8264592450906, -0.798193216323853 45.8262499106125, -0.798179805278778 45.8260106702451, -0.798863768577576 45.8257957268507, -0.799925923347473 45.8253677066629, -0.80037921667099 45.8252368701409, -0.801052451133728 45.8252088337034, -0.801709592342377 45.8251228552068, -0.80186516046524 45.8255303173402)), ((-0.798354148864746 45.8268218404488, -0.798211991786957 45.8273993714774, -0.796734094619751 45.8278871842802, -0.796465873718262 45.8271171483253, -0.797152519226074 45.8269339828649, -0.797573626041412 45.8267975428955, -0.797871351242065 45.8266629716393, -0.798051059246063 45.8265171857445, -0.798220038414001 45.8265863406396, -0.798332691192627 45.8266984835302, -0.798354148864746 45.8268218404488)))'

      assert_equal Charta.new_geometry(reference).transform(:WGS84), Charta.new_geometry(geojson)
    end
  end
end
