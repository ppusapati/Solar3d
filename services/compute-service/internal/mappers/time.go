package mappers

import "time"

func unixSeconds(v int64) time.Time {
	if v <= 0 {
		return time.Unix(0, 0).UTC()
	}
	return time.Unix(v, 0).UTC()
}

