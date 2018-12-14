package xbox

import (
	"sync"
)

const (
	GameIDUrl = "https://www.xbox.com/en-US/games/xbox-one/js/xcat-bi-urls.json"
	ProductIDListFile = "/data/xbox/id/bigids"
	ProductDir = "/data/xbox/products/"
)

type Market string
type Lang string
var (
	availMarkets = map[Market][]Lang{
		//// AMERICA
		// "AR": {"es-ar"},
		// "BR": {"pt-br"},
		// "CA": {"en-ca"},
		// "CL": {"zh-cn"},
		// "MX": {"zh-cn"},
		// "US": {"zh-cn"},
		
		//// EUROPE

		//// ASIA PACIFIC
		// "CN": {"zh-cn"},
		"HK": {"zh-cn"},
		"TW": {"zh-cn"},
		// "JP": {"ja-jp"},

		//// MIDDLEEAST AFRICA
	}

	wgCrawl sync.WaitGroup
)
