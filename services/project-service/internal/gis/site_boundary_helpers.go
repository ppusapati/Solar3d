package gis

import (
	"io"
	"strconv"
)

func ioReadAll(reader io.Reader) ([]byte, error) {
	return io.ReadAll(reader)
}

func strconvParseFloat(value string, bitSize int) (float64, error) {
	return strconv.ParseFloat(value, bitSize)
}

