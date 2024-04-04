#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <iomanip>   // For std::setprecision
#include <unordered_map>
#include <vector>
#include <algorithm> // For std::sort

struct Measurement {
    float min;
    float max;
    float sum;
    int cnt;

    std::string format() const {
        std::stringstream ss;
        ss << std::fixed << std::setprecision(1);  // 12.1 format
        float avg = this->sum / this->cnt;
        ss << this->min << "/" << avg << "/" << this->max;
        return ss.str();
    }
};

// template <typename T>
// void print(T value) {
//     std::cout << value << "\n";
// }

typedef std::unordered_map<std::string, Measurement> MeasurementMap;

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
            // it seems splitting and parsing in different ways is much slower lol

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
        Measurement& measurement = map[location];
        measurement.min = std::min(measurement.min, value);
        measurement.max = std::max(measurement.max, value);
        measurement.sum += value;
        measurement.cnt++;
    }
}

void naive() {
    std::ios_base::sync_with_stdio(false);  // Disable synchronization with C I/O
    MeasurementMap mp;
    parse_file("measurements.txt", mp);

    // Step 1: Copy to std::vector
    std::vector<std::pair<std::string, Measurement>> sortedMeasurements(mp.begin(), mp.end());

    // Step 2: Sort the std::vector
    std::sort(sortedMeasurements.begin(), sortedMeasurements.end(),
        [](const std::pair<std::string, Measurement>& a, const std::pair<std::string, Measurement>& b) {
            return a.first < b.first; // Sort by location name
        }
    );

    // Step 3: Print the Sorted Results
    std::cout << "{";
    for (const auto& entry : sortedMeasurements) {
        std::cout << entry.first << "=" << entry.second.format() << ", ";
    }
    // Remove the last ", " from the output
    if (!sortedMeasurements.empty()) {
        std::cout << "\b\b";
    }
    std::cout << "} \n";
}

int main() {
    naive();
    return 0;
}
