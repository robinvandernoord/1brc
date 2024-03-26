#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>

struct Measurement {
    float min;
    float max;
    float sum;
    int cnt;

    std::string format() const {
        std::stringstream ss;
        ss << std::fixed;  // prevent scientific notation
        ss.precision(1);   // 12.1

        float avg = this->sum / this->cnt;
        ss << this->min << "/" << avg << "/" << this->max;
        return ss.str();
    }

   private:
    friend std::ostream& operator<<(std::ostream& os, const Measurement& m) {
        os << "Measurement(min=" << m.min << ", max=" << m.max << ", sum=" << m.sum << ", cnt=" << m.cnt << ")";
        return os;
    }
};

template <typename T>
void print(T value) {
    std::cout << value << "\n";
}

Measurement new_row_by_value() {
    Measurement row = {
        0.0,
        0.0,
        0.0,
        0};

    return row;
}

Measurement* new_row() {
    Measurement* row = new Measurement{0.0, 0.0, 0.0, 0};
    return row;
}

typedef std::map<std::string, Measurement> MeasurementMap;

void parse_file(std::string filename, MeasurementMap& map) {
    // std::ifstream input("measurements.txt");
    auto input = std::ifstream(filename);

    std::string location;
    for (std::string line; std::getline(input, line);) {
        // START PARSE
        location = "";  // reset

        bool found_semicolon = false;
        bool negative = false;

        float value = 0;

        for (auto& ch : line) {
            if (ch == ';') {
                found_semicolon = true;
            } else if (found_semicolon) {
                if (ch == '-') {
                    // only after 'found_semicolon' because location can also have '-' and '.' !!!
                    negative = true;
                } else if (ch == '.') {
                    // skip
                    continue;
                } else {
                    //                                ascii 48 = 0
                    value = (value * 10) + (ch - 48);
                }

            } else {
                location.push_back(ch);
            }
        }

        // finalize measurement:
        if (negative) {
            value = -(value / 10);
        } else {
            value /= 10;
        }

        // START DICT UPDATE

        auto measurement = map[location];

        // auto row = new_row();
        // auto row = new_row_by_value();

        measurement.min = std::min(measurement.min, value);
        measurement.max = std::max(measurement.max, value);
        measurement.sum += value;
        measurement.cnt++;

        map[location] = measurement;
    }
}

void naive() {
    MeasurementMap mp;
    parse_file("measurements.txt", mp);

    std::cout << "{";
    for (MeasurementMap::iterator i = mp.begin(); i != mp.end(); i++) {
        std::cout << i->first << "=";
        std::cout << i->second.format();
        std::cout << ", ";
    }

    std::cout << "\b\b} \n";
}

int main() {
    naive();

    // print("done!");
    // std::string done;
    // std::cin >> done;

    return 0;
}
