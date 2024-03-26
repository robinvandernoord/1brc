package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"slices"
	"strconv"
	"strings"
)

type Measurement struct {
	min float64
	max float64
	sum float64
	cnt float64
}

func NewMeasurement() Measurement {
	return Measurement{
		min: math.Inf(1),
		max: math.Inf(-1),
		sum: 0.0,
		cnt: 0.0,
	}
}

func (m Measurement) Avg() float64 {
	return m.sum / m.cnt
}

func (m Measurement) Format() string {
	return fmt.Sprintf("%.1f/%.1f/%.1f", m.min, m.Avg(), m.max)
}

func asFloat(valueAsString string) float64 {
	valueAsFloat, err := strconv.ParseFloat(valueAsString, 64)
	if err != nil {
		return 0.0
	}
	return valueAsFloat
}

func printResults(readings map[string]Measurement) {
	cities := make([]string, 0, len(readings))
	for city := range readings {
		cities = append(cities, city)
	}

	slices.Sort(cities)

	fmt.Print("{")
	for _, city := range cities {
		fmt.Printf("%s=%s, ", city, readings[city].Format())
	}
	fmt.Print("\b\b} \n")
}

func main() {

	file, err := os.Open("measurements.txt")
	if err != nil {
		panic(err)
	}
	defer file.Close()
	scanner := bufio.NewScanner(file)

	readings := make(map[string]Measurement)

	for scanner.Scan() {
		line := scanner.Text()

		location, valueAsString := split(line, ";")
		valueAsFloat := asFloat(valueAsString)

		reading, exists := readings[location]
		if !exists {
			reading = NewMeasurement()
		}

		if valueAsFloat > reading.max {
			reading.max = valueAsFloat
		}

		if valueAsFloat < reading.min {
			reading.min = valueAsFloat
		}

		reading.sum += valueAsFloat
		reading.cnt++

		readings[location] = reading
	}

	printResults(readings)
}

func split(value, sep string) (string, string) {
	parts := strings.Split(value, sep)
	return parts[0], parts[1]
}
